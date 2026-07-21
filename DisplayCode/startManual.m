function startManual(modID)

global DcomState StimCom


msg = ['MM;' modID ';~'];

if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end

