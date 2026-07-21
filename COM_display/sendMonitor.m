function sendMonitor

global Mstate DcomState StimCom

%This updates the gamma table and screen size at the display.

msg = ['MON;' Mstate.monitorID ';~'];

%depending on how the communication between the machines is handled, using
%different commands (backwards compatibility)
if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end