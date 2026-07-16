%timer_start;

proc python ;
   submit ;
import pandas as pd;
start = int(SAS.symget('start'))
end = int(SAS.symget('end'))

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

# Generate a list of numbers from start to end
numbers = list(range(start, end + 1))

# Create a DataFrame with one column called 'number'
sas_df_in = pd.DataFrame(numbers, columns=['number'])

# Example usage
print('NOTE: Python found ' + str(len(get_prime_numbers(sas_df_in))) + ' prime numbers')
	endsubmit;
run;

%timer_stop(Performances,Python_Prime_Numbers, &end);
	