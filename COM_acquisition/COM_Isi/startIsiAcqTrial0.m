function startIsiAcqTrial0

%dummy first trial to avoid dropped frames

global  IsiCom

msg = 'I';

msg = [msg ';~'];  %add the "Terminator"

write(IsiCom,msg);
