function update_isiname

%update filename for isi setup

global Mstate IsiCom

msg = 'F';

msg = sprintf('%s;%s;%s;%s',msg,Mstate.anim,Mstate.unit,Mstate.expt);

msg = [msg ';~'];  %add the "Terminator"

write(IsiCom,msg);
%disp('Sending MainWindow values.');
