function update_spikeglxname

global Mstate GcomState 

%get name
name = [Mstate.anim '_u' Mstate.unit '_' Mstate.expt];

%make directory using shared drive
datadir=fullfile('/mnt','windows_share',Mstate.anim,name);
s=mkdir(datadir);
if s==0
    disp('Error: Could not create data directory!')
end

%set filename (on windows machine)
SetRunName(GcomState, name);
SetNextFileName(GcomState,['D:\' Mstate.anim '\' name '\' name]);
%SetRunName(GcomState, name);