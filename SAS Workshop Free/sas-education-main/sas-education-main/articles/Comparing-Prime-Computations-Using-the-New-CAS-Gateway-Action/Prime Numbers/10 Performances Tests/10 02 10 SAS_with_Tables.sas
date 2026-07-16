filename mac filesrvc folderpath="/Public/Prime Numbers/00 Macros" filename="Timers.sas";
filename SPNT filesrvc folderpath="/Public/Prime Numbers/02 With input and output tables" filename="02 10 SAS_Prime_Numbers.sas";

%include mac;
%include SPNT;

/* %timer_init(Performances); */

%macro SAS_with_Tables(loop=5);

	%do i=1 %to &loop;
		%SAS_Prime_Numbers_T(start=0,end=10000);

		%SAS_Prime_Numbers_T(start=0,end=100000);

		%SAS_Prime_Numbers_T(start=0,end=1000000);

		%SAS_Prime_Numbers_T(start=0,end=10000000);
		%end;
%mend;

/* %SAS_with_Tables(loop=1); */