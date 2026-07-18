function update_isiname

%update filename for isi setup

global Mstate IsiComState

msg = 'F';

msg = sprintf('%s;%s;%s;%s',msg,Mstate.anim,Mstate.unit,Mstate.expt);

msg = [msg ';~'];  %add the "Terminator"

fwrite(IsiComState.serialPortHandle,msg);
%disp('Sending MainWindow values.');
