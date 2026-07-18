function startDummyTrial

%need to generate a TTL pulse to run a dummy trial for the ISI acquisition
%to avoid dropped frames later

global  DcomState

msg = 'TTL;;;~';  %this way it will be parsed correctly

fwrite(DcomState.serialPortHandle,msg);
disp('Sending TTL pulse');
