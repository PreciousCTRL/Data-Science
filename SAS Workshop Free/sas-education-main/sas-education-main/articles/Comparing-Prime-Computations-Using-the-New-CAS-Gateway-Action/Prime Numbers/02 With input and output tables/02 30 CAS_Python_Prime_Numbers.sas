cas mysess terminate;
cas mysess sessopts=(nworkers=&workers);

data numbers;
	do number=&start to &end;
		output;
	end;
run;

proc casutil outcaslib="casuser" ;
   load data=work.numbers replace;                     /* 4 */ 
run;

proc cas;
loadactionset 'gateway';
run;

/* print('thread_id '+str(gateway.thread_id))
   print('num_threads ' + str(gateway.num_threads))
   print('num_workers ' + str(gateway.num_workers))
   print('Thread Nmber: ' +str(gateway.thread_id) + ' from ' + str(lower) + ' to ' + str(upper))
 */

proc cas;
	
   table.shuffle /
      table={caslib="casuser", name="numbers"},
      casout={caslib="casuser", name="numbers", 
              replace = true, threadBlockSize =  50000};

run;
quit;

%timer_start;

proc cas;
externalsource pyprog2;

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

sas_df_in = gateway.read_table({'caslib': 'casuser', 'name': 'numbers'})
# sp = sas_df_in.shape
df_out = pd.DataFrame(get_prime_numbers(sas_df_in), columns=['number'])
gateway.write_table(df_out, {'caslib': 'casuser', 'name': 'primes', 'replace':True})

print('NOTE: Python found ' + str(len(df_out)) + ' prime numbers')

endexternalsource;

action gateway.runLang / code= pyprog2
/* nthreads=4 */
timeout_millis=1000000;
run;
quit;

%timer_stop(Performances,CAS_Python_Prime_Numbers_T, &end);
	