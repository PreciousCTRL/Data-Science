

import numpy as np
import pandas as pd
import warnings
from sklearn.model_selection import KFold
from sklearn.metrics import mean_squared_error
from catboost import CatBoostRegressor, Pool

train= pd.read_csv("../data/VFL_2026_TRAIN_SET.csv")
test_df  = pd.read_csv("../data/VFL_2026_TEST_SET.csv")
y = train["ADMIT_LOS"].astype(float).values

# ---------------------------------------------------------------- features
def strip_num(x): return pd.to_numeric(x.astype(str).str.strip(), errors="coerce")

numeric = ["ICU_DAYS","ORDER_TOTAL_CHARGES","PATIENT_AGE","OPERATION_COUNT","NUM_VISITS","ADMIT_MTH",
           "MS_DRG_CODE","ZIP","X","Y","DX_CODE","ICD9_TARGET","ORDER_SET_USED","DIAGNOSIS_ICD_CODE"]
numeric_text = ["NUM_CHRONIC_COND","DRG_APR_SEVERITY","PROCEDURE_SUBCAT_CODE"]
extra = ["MONITORING_HOURS","COMORBIDITY_INDEX","CARE_TEAM_SIZE"]
categorical = ["DOCTOR","DEPARTMENT","DISCHARGED_TO","STANDARD_ORDERS_USED","DISCH_NURSE_ID","GENDER",
               "STATECODE","REGION","RACE_CD","DIAGNOSIS_GROUP","DRG_APR_CODE","DIAGNOSIS_SUBCAT_CODE",
               "PROCEDURE_ICD_CODE","HOSPITAL"]

def build_features(df):
    X = pd.DataFrame(index=df.index)
    for c in numeric + numeric_text + extra:
        X[c] = pd.to_numeric(df[c], errors="coerce").fillna(-1)
    icu = pd.to_numeric(df["ICU_DAYS"], errors="coerce")
    ch  = pd.to_numeric(df["ORDER_TOTAL_CHARGES"], errors="coerce")
    op  = pd.to_numeric(df["OPERATION_COUNT"], errors="coerce")
    X["charge_per_icu"] = (ch / icu.replace(0, np.nan)).fillna(0)
    X["charge_per_op"]  = (ch / op.replace(0, np.nan)).fillna(0)
    X["icu_x_sev"]      = icu * strip_num(df["DRG_APR_SEVERITY"])
    X["mon_per_icu"]    = (pd.to_numeric(df["MONITORING_HOURS"], errors="coerce") / icu.replace(0, np.nan)).fillna(0)
    X["proc_desc_missing"]   = df["PROCEDURE_LONG_DESC"].isna().astype(int)
    X["proc_subcat_missing"] = df["PROCEDURE_SUBCAT_DESC"].isna().astype(int)
    for c in categorical:
        X[c] = df[c].astype(str).str.strip().fillna("NA")
    return X

X = build_features(train)
cat_idx = [X.columns.get_loc(c) for c in categorical]

MEMBERS = [
    {"name": "CatBoost d8 l2=3", "depth": 8, "l2": 3.0},
    {"name": "CatBoost d7 l2=3", "depth": 7, "l2": 3.0},
    {"name": "CatBoost d8 l2=5", "depth": 8, "l2": 5.0},
]
kf = KFold(n_splits=5, shuffle=True, random_state=42)

def rmse(a, p): return mean_squared_error(a, np.clip(p, 0, None)) ** 0.5

oof = {m["name"]: np.zeros(len(y)) for m in MEMBERS}
fold_blend_rmse = []

for fold, (tr_idx, va_idx) in enumerate(kf.split(X), 1):
    fold_preds = []
    for m in MEMBERS:
        model = CatBoostRegressor(iterations=1500, learning_rate=0.025, depth=m["depth"],
                                  l2_leaf_reg=m["l2"], random_seed=7, verbose=0,
                                  allow_writing_files=False)
        model.fit(Pool(X.iloc[tr_idx], y[tr_idx], cat_features=cat_idx))
        p = np.clip(model.predict(Pool(X.iloc[va_idx], cat_features=cat_idx)), 0, None)
        oof[m["name"]][va_idx] = p
        fold_preds.append(p)
    blend = np.clip(np.mean(fold_preds, axis=0), 0, None)      
    r = rmse(y[va_idx], blend)
    fold_blend_rmse.append(r)
    print(f"fold {fold}: blend RMSE = {r:.4f}")

print("\n=== Per-member out-of-fold RMSE (5-fold) ===")
for m in MEMBERS:
    print(f"  {m['name']:20s} {rmse(y, oof[m['name']]):.4f}")

blend_oof = np.clip(np.mean([oof[m['name']] for m in MEMBERS], axis=0), 0, None)
fb = np.array(fold_blend_rmse)
print("\n=== FINAL ENSEMBLE (3-way blend) ===")
print(f"  overall out-of-fold RMSE : {rmse(y, blend_oof):.4f}")
print(f"  per-fold mean +/- std    : {fb.mean():.4f} +/- {fb.std():.4f}")
print(f"  fold spread              : {fb.min():.4f} .. {fb.max():.4f}")
