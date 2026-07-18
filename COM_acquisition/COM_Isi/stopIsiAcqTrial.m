function stopIsiAcqTrial

global IsiState IsiComState

%send stop, just in case the camera didn't stop on its own
msg = 'S;~';  
fwrite(IsiComState.serialPortHandle,msg);

%keep checking for status of ISIstate
%while IsiState.doneData~=1
%    pause(.1);
%end