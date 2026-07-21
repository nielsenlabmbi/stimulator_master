function buildStimulusSample(cond,trial)

%Sends stimulus information for the current trial to the slave

global DcomState StimCom 

modId=getmoduleID;
msg = ['B;' modId ';-1;~'];

if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end