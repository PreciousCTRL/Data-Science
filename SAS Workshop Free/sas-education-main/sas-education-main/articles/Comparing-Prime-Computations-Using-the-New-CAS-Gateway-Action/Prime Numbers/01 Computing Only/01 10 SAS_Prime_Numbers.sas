%macro SAS_Prime_Numbers(start=,end=);

	%timer_start;
	/* data randomprimev2(drop=prime_flg j); */
	data _null_(drop=prime_flg counter j);
		do number=&start to &end;
			if number >= 2 then do;
				prime_flg = 1;
				do j=2 to (int(number**0.5));
					if mod(number,j) eq 0 then do;
						prime_flg = 0;
						/* put i= j=;*/
						LEAVE;
					end;
				end; 
				if prime_flg then do;
					counter+1;
					output;
				end;
			end;
		end;
	run;
	%timer_stop(Performances,SAS_Prime_Numbers, &end);

%mend;