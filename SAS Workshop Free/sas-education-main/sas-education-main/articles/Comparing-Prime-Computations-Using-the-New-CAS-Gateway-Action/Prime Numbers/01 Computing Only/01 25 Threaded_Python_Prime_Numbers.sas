%timer_start;

proc python ;
submit ;
import pandas as pd;
import threading;
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
    # Print Primes found
    prime_count = len(prime_df)
    print(f"NOTE: Python found {prime_count} prime numbers in this thread")

# Generate a list of numbers from start to end
numbers = list(range(start, end + 1))

# Cut the list of numbers into two lists to run on two threads.
first_half = numbers[:len(numbers)//2]
first_quarter = first_half[:len(first_half)//2]
second_quarter = first_half[len(first_half)//2:]

last_half = numbers[len(numbers)//2:]
third_quarter = last_half[:len(last_half)//2]
fourth_quarter = last_half[len(last_half)//2:]

# Create two DataFrames for each list with one column called 'number'
sas_df_in_1 = pd.DataFrame(first_quarter, columns=['number'])
sas_df_in_2 = pd.DataFrame(second_quarter, columns=['number'])
sas_df_in_3 = pd.DataFrame(third_quarter, columns=['number'])
sas_df_in_4 = pd.DataFrame(fourth_quarter, columns=['number'])

# Calculate primes on two threads
if __name__ =="__main__":
    t1 = threading.Thread(target=get_prime_numbers, args=(sas_df_in_1,))
    t2 = threading.Thread(target=get_prime_numbers, args=(sas_df_in_2,))
    t3 = threading.Thread(target=get_prime_numbers, args=(sas_df_in_3,))
    t4 = threading.Thread(target=get_prime_numbers, args=(sas_df_in_4,))
		
    # Start each thread
    t1.start()
    t2.start()
    t3.start()
    t4.start()
	
    # Have threads wait for each other to finish
    t1.join()
    t2.join()
    t3.join()
    t4.join()

endsubmit;
run;

%timer_stop(Performances,Threaded_Python_Prime_Numbers, &end);