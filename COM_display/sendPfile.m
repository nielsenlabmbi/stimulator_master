function sendPfile(modID)

global DcomState


msg = ['PF;' modID ';1;~']; %we're adding a dummy parameter for easier parsing on the slave side

fwrite(DcomState.serialPortHandle,msg);

