filename mac filesrvc folderpath="/Public/Prime Numbers/00 Macros" filename="Timers.sas";
filename TPPN filesrvc folderpath="/Public/Prime Numbers/01 Computing Only" filename="01 25 Threaded_Python_Prime_Numbers.sas";

%include mac;

/* %timer_init(Performances); */

%macro Threaded_Python_Computing_Only(loop=5);
	%do i=1 %to &loop;
		%let start=0;

		%let end=10000;
		%include TPPN;
		
		%let end=100000;
		%include TPPN;
		
		%let end=1000000;
		%include TPPN;
		
		%let end=10000000;
		%include TPPN;
	%end;
%mend;

/* %Threaded_Python_Computing_Only(loop=1); */