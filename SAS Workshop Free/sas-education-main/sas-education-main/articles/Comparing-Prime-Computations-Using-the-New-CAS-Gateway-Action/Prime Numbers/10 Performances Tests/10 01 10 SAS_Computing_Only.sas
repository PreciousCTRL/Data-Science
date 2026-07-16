filename mac filesrvc folderpath="/Public/Prime Numbers/00 Macros" filename="Timers.sas";
filename SPN filesrvc folderpath="/Public/Prime Numbers/01 Computing Only" filename="01 10 SAS_Prime_Numbers.sas";

%include mac;
%include SPN;

/* %timer_init(Performances); */

%macro SAS_Computing_Only(loop=5);

	%do i=1 %to &loop;
		%SAS_Prime_Numbers(start=0,end=10000);
		
		%SAS_Prime_Numbers(start=0,end=100000);
		
		%SAS_Prime_Numbers(start=0,end=1000000);
		
		%SAS_Prime_Numbers(start=0,end=10000000);
		%end;
	
%mend;

/* %SAS_Computing_Only(loop=1); */