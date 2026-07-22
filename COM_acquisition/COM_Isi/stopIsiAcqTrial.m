function stopIsiAcqTrial

global IsiCom 

%send stop, just in case the camera didn't stop on its own
msg = 'S;~';  
write(IsiCom,msg);

