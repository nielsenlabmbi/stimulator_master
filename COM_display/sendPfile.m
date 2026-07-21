function sendPfile(modID)

global DcomState StimCom


msg = ['PF;' modID ';1;~']; %we're adding a dummy parameter for easier parsing on the slave side

%depending on how the communication between the machines is handled, using
%different commands (backwards compatibility)
if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end
disp('Sending param file');

