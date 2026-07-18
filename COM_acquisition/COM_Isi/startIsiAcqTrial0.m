function startIsiAcqTrial0

%dummy first trial to avoid dropped frames

global  IsiComState 

msg = 'I';

msg = [msg ';~'];  %add the "Terminator"

fwrite(IsiComState.serialPortHandle,msg);
