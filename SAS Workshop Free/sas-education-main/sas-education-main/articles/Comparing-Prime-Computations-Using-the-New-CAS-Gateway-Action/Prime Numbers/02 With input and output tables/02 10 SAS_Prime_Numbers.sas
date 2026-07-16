%macro SAS_Prime_Numbers_T(start=,end=);

	data numbers;
		do number=&start to &end;
			output;
		end;
	run;

	%timer_start;
	
	/* data randomprimev2(drop=prime_flg j); */
	data prime_numbers(drop=prime_flg j);
		set numbers;
		if number >= 2 then do;
			prime_flg = 1;
			do j=2 to (int(number**0.5));
				if mod(number,j) eq 0 then do;
					prime_flg = 0;
					/* put i= j=;*/
					LEAVE;
				end;
			end; 
			if prime_flg then output;
		end;
	run;

	%timer_stop(Performances,SAS_Prime_Numbers_T, &end);
	
	%let nrows=0;
	data _NULL_;
		if 0 then set prime_numbers nobs=n;
		call symputx('nrows',n);
		stop;
	run;
	%put NOTE: SAS found &nrows prime numbers;

%mend;