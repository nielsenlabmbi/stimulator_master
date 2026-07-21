function sendMinfo

%Send the necessary information to display that is in Mstate

%Screen distance is the only thing that the display needs to know about
%before the beginning of 'run' or 'play'.  monitor info such as
%screen size are updated when the user enters a new monitor.

%... Stimulus also needs the anim_unit_expt to save the random ensemble
%info, such as with 'flash grater'.

global Mstate DcomState StimCom

msg = 'M';

msg = sprintf('%s;%s=%.4f',msg,'screenDist',Mstate.screenDist);
msg = sprintf('%s;%s=%s',msg,'anim',Mstate.anim);
msg = sprintf('%s;%s=%s',msg,'unit',Mstate.unit);
msg = sprintf('%s;%s=%s',msg,'expt',Mstate.expt);
msg = sprintf('%s;%s=%d',msg,'running',Mstate.running);

msg = [msg ';~'];  %add the "Terminator"

%depending on how the communication between the machines is handled, using
%different commands (backwards compatibility)
if ~isempty(DcomState) %old tcp protocol
    fwrite(DcomState.serialPortHandle,msg);
elseif ~isempty(StimCom)
    write(StimCom,msg);
end
disp('Sending MainWindow values.');
