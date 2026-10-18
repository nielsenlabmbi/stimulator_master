function setIsiDur

%send necessary parameters to isi setup

global  IsiCom 

msg = 'D';

predelay = getParamVal('predelay');
stim_time = getParamVal('stim_time');
postdelay = getParamVal('postdelay');

postacq=min(1,floor(postdelay/2));

trialdur=predelay+stim_time+postacq;

msg = sprintf('%s;%.4f',msg,trialdur);

msg = [msg ';~'];  %add the "Terminator"

write(IsiCom,msg);
%disp('Sending MainWindow values.');
