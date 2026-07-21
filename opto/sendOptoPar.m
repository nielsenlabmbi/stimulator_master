function sendOptoPar

global DcomState StimCom optoInfo

optoPar=fieldnames(optoInfo);

msg='OP';

for i=1:length(optoPar)
    msg = sprintf('%s;%s=%d',msg,optoPar{i},optoInfo.(optoPar{i}));
end

msg = [msg ';~'];  %add the "Terminator"
disp(msg)

if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end
    