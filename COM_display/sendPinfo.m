function sendPinfo(mod)
%mod is the 2 letter code for the module

global Pstate DcomState StimCom

%mod = getmoduleID;

msg = ['P;' mod];

for i=1:length(Pstate.param)
    p = Pstate.param{i};
    switch p{2}
        case 'float'
            msg = sprintf('%s;%s=%.4f',msg,p{1},p{3});
        case 'int'
            msg = sprintf('%s;%s=%d',msg,p{1},round(double(p{3})));
        case 'string'
            msg = sprintf('%s;%s=%s',msg,p{1},p{3});
    end
end

msg = [msg ';~'];  %add the "Terminator"


%depending on how the communication between the machines is handled, using
%different commands (backwards compatibility)
if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end

disp('Sending param values.');
