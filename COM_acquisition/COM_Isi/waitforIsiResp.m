function waitforIsiResp

global IsiCom 


%Wait...
n = 0;  %Need this, or it won't enter next loop
while n == 0
    n = IsiCom.NumBytesAvailable; %Wait for response
    pause(.1) %wait a bit before next read
end
msg=read(IsiCom, IsiCom.NumBytesAvailable, "string");
disp(['Message received from ISI camera: ' msg]);

