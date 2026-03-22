function update_spikeglxname

global Mstate GcomState 


name = [Mstate.anim '_u' Mstate.unit '_' Mstate.expt];

SetRunName(GcomState, name);