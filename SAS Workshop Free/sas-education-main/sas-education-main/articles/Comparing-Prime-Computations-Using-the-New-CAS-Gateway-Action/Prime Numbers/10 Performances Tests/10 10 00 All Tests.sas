filename SCO filesrvc folderpath="/Public/Prime Numbers/10 Performances Tests" filename="10 01 10 SAS_Computing_Only.sas";
filename PCO filesrvc folderpath="/Public/Prime Numbers/10 Performances Tests" filename="10 01 20 Python_Computing_Only.sas";
filename TPCO filesrvc folderpath="/Public/Prime Numbers/10 Performances Tests" filename="10 01 25 Threaded_Python_Computing_Only.sas";
filename CPCO filesrvc folderpath="/Public/Prime Numbers/10 Performances Tests" filename="10 01 30 CAS_Python_Computing_Only.sas";
filename SWT filesrvc folderpath="/Public/Prime Numbers/10 Performances Tests" filename="10 02 10 SAS_with_Tables.sas";
filename PWT filesrvc folderpath="/Public/Prime Numbers/10 Performances Tests" filename="10 02 20 SAS_Python_with_Tables.sas";
filename CPWT filesrvc folderpath="/Public/Prime Numbers/10 Performances Tests" filename="10 02 30 CAS_Python_with_Tables.sas";

%include SCO PCO TPCO CPCO SWT PWT CPWT;

%timer_init(Performances);

%SAS_Computing_Only(loop=1);
%Python_Computing_Only(loop=1);
/*%Threaded_Python_Computing_Only(loop=1);*/
%CAS_Python_Computing_Only(loop=1);
%SAS_with_Tables(loop=1);
%Python_with_Tables(loop=1);
%CAS_Python_with_Tables(loop=1);