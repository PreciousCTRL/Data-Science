filename mac filesrvc folderpath="/Public/Prime Numbers/00 Macros" filename="Timers.sas";
filename PPN filesrvc folderpath="/Public/Prime Numbers/01 Computing Only" filename="01 20 Python_Prime_Numbers.sas";

%include mac;

/* %timer_init(Performances); */

%macro Python_Computing_Only(loop=5);
	%do i=1 %to &loop;
		%let start=0;

		%let end=10000;
		%include PPN;
		
		%let end=100000;
		%include PPN;
		
		%let end=1000000;
		%include PPN;
		
		%let end=10000000;
		%include PPN;
	%end;
%mend;

/* %Python_Computing_Only(loop=1); */