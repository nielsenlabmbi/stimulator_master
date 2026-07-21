function moveShutter(eye,pos)

global DcomState StimCom


msg=['S;' num2str(eye) ';' num2str(pos) ';~'];
disp(msg)

if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end
    