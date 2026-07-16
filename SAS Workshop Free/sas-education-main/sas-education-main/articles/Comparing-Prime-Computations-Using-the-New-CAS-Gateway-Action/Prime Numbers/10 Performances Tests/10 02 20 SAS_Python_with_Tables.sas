filename mac filesrvc folderpath="/Public/Prime Numbers/00 Macros" filename="Timers.sas";
filename SPPN filesrvc folderpath="/Public/Prime Numbers/02 With input and output tables" filename="02 20 SAS_Python_Prime_Numbers.sas";

%include mac;

/* %timer_init(Performances); */

%macro Python_with_Tables(loop=5);
	%do i=1 %to &loop;
		%let start=0;

		%let end=10000;
		%include SPPN;
		
		%let end=100000;
		%include SPPN;
		
		%let end=1000000;
		%include SPPN;
		
		%let end=10000000;
		%include SPPN;
	%end;
%mend;

/* %Python_with_Tables(loop=1); */