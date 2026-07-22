function startIsiAcqTrial

%send necessary parameters to isi setup

global  IsiCom trialno



disp('Starting ISI camera')

msg = 'T';

msg = sprintf('%s;%d',msg,trialno);

msg = [msg ';~'];  %add the "Terminator"

write(IsiCom,msg);
