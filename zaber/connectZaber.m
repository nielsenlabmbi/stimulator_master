function connectZaber(status)

%connect or disconnect function generator

global DcomState StimCom

msg=['ZS;' num2str(status) ';~'];

if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end

    