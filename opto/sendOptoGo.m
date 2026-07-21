function sendOptoGo(pulseType)

%pulseType: 1 - one pulse, 2 - pulse train

global DcomState StimCom

msg=['O;' num2str(pulseType) ';~'];
disp(msg)
if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end
    