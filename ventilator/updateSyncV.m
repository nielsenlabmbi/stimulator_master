function updateSyncV(syncVflag)

global DcomState StimCom

msg = ['V;' num2str(syncVflag) ';~'];

if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end
