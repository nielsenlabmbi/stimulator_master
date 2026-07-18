function setIsiDur

%send necessary parameters to isi setup

global  IsiComState

msg = 'D';

predelay = getParamVal('predelay');
stim_time = getParamVal('stim_time');

trialdur=predelay+stim_time;

msg = sprintf('%s;%.4f',msg,trialdur);

msg = [msg ';~'];  %add the "Terminator"

fwrite(IsiComState.serialPortHandle,msg);
%disp('Sending MainWindow values.');
