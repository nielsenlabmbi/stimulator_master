function startIsiAcqTrial

%send necessary parameters to isi setup

global  IsiComState trialno IsiState

%set Isi status to 0 (no data saved)
IsiState.doneData=0;

msg = 'T';

msg = sprintf('%s;%d',msg,trialno);

msg = [msg ';~'];  %add the "Terminator"

fwrite(IsiComState.serialPortHandle,msg);
