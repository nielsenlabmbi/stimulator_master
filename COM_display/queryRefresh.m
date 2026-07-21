function queryRefresh

global DcomState StimCom


msg = 'F;1;~'; %we're adding the 1 just to make the parsing on the slave side easier to handle

%depending on how the communication between the machines is handled, using
%different commands (backwards compatibility)
if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end
disp('Getting refresh rate.');

