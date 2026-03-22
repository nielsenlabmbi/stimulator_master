function startSpikeglxAcq

global GcomState

TriggerGT(GcomState,0,0)
SetRecordingEnable(GcomState, 1);