filename mac filesrvc folderpath="/Public/Prime Numbers/00 Macros" filename="Timers.sas";
filename CPNT filesrvc folderpath="/Public/Prime Numbers/02 With input and output tables" filename="02 30 CAS_Python_Prime_Numbers.sas";

%include mac;

/* %timer_init(Performances); */

%macro CAS_Python_with_Tables(loop=5);
	%do i=1 %to &loop;
		%let start=0;
		%let workers=3;

		%let end=10000;
		%include CPNT;
		
		%let end=100000;
		%include CPNT;
		
		%let end=1000000;
		%include CPNT;
		
		%let end=10000000;
		%include CPNT;

		%let end=100000000;
		%include CPNT;
	%end;
%mend;

/* %CAS_Python_with_Tables(loop=1); */