data numbers;
	do number=&start to &end;
		output;
	end;
run;

%timer_start;

proc python ;
   submit ;
import pandas as pd;

def is_prime(n):
    if n <= 1:
        return False
    if n <= 3:
        return True
    if n % 2 == 0 or n % 3 == 0:
        return False
    i = 5
    while i * i <= n:
        if n % i == 0 or n % (i + 2) == 0:
            return False
        i += 6
    return True

def get_prime_numbers(df_in):
    df_in['is_prime'] = df_in['number'].apply(is_prime)
    # Filter the DataFrame to return only the prime numbers
    prime_df = df_in[df_in['is_prime']].reset_index(drop=True)
    return prime_df

sas_df_in = SAS.sd2df('WORK.Numbers')

df_out = pd.DataFrame(get_prime_numbers(sas_df_in), columns=['number'])

sas_ds_out= SAS.df2sd(df_out, 'WORK.Primes')

# Example usage
print('NOTE: Python found ' + str(len(df_out)) + ' prime numbers')
	endsubmit;
run;

%timer_stop(Performances,Python_Prime_Numbers_T, &end);
	