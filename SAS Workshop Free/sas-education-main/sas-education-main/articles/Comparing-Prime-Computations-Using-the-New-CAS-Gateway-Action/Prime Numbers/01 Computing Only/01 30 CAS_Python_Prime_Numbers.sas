cas mysess terminate;
cas mysess sessopts=(nworkers=&workers);

proc cas;
loadactionset 'gateway';
run;

/* print('thread_id '+str(gateway.thread_id))
   print('num_threads ' + str(gateway.num_threads))
   print('num_workers ' + str(gateway.num_workers))
   print('Thread Nmber: ' +str(gateway.thread_id) + ' from ' + str(lower) + ' to ' + str(upper))
 */

%timer_start;

proc cas;
externalsource pyprog8;

import pandas as pd;

if gateway.thread_id == 0:
	lower = gateway.args['start']
	upper= lower + ((gateway.args['end'] - gateway.args['start']) // gateway.num_threads) - 1
else:
	lower = gateway.args['start'] + ((gateway.args['end'] - gateway.args['start']) // gateway.num_threads) * gateway.thread_id
	upper = gateway.args['start'] + ((gateway.args['end'] - gateway.args['start']) // gateway.num_threads) * (gateway.thread_id + 1) - 1
if gateway.thread_id == (gateway.num_threads - 1):
	upper = gateway.args['end']

# print('Thread Number: ' +str(gateway.thread_id) + ' from ' + str(lower) + ' to ' + str(upper))

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
numbers = list(range(lower, upper + 1))

# Create a DataFrame with one column called 'number'
sas_df_in = pd.DataFrame(numbers, columns=['number'])

# gateway.return_result('all_primes', primes=results[:3])

# Example usage
print('NOTE: Python found ' + str(len(get_prime_numbers(sas_df_in))) + ' prime numbers')

endexternalsource;
action gateway.runLang / code= pyprog8,
args={start=&start,end=&end}
/* , &threads = 1 */
/* , log_level="DEBUG" */
/* , single=true */
timeout_millis=1000000;
;
run;
quit;

%timer_stop(Performances,CAS_Python_Prime_Numbers, &end);
	