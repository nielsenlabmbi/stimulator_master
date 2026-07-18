function stopIsiAcqTrial

global IsiState


%keep checking for status of ISIstate
while IsiState.doneData~=1
    pause(1);
end