function startStimulus(modID)

global DcomState StimCom


msg = ['G;' modID ';~'];

if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end
