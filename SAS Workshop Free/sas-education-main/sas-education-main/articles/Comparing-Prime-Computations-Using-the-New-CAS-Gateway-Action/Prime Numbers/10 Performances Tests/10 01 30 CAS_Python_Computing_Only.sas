filename mac filesrvc folderpath="/Public/Prime Numbers/00 Macros" filename="Timers.sas";
filename CPN filesrvc folderpath="/Public/Prime Numbers/01 Computing Only" filename="01 30 CAS_Python_Prime_Numbers.sas";

%include mac;

/* %timer_init(Performances); */

%macro CAS_Python_Computing_Only(loop=5);
	%do i=1 %to &loop;
		%timer_start;
		%let start=0;
		%let workers=3;

		%let end=10000;
		%include CPN;
		
		%let end=100000;
		%include CPN;
		
		%let end=1000000;
		%include CPN;
		
		%let end=10000000;
		%include CPN;

		%let end=100000000;
		%include CPN;
	%end;
%mend;

/* %CAS_Python_Computing_Only(loop=1); */