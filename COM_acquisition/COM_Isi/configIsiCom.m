function configIsiCom

%configures communication with the stimulus slave

global IsiComState setupDefault

%isiIP='172.30.11.187';


% close all open udp port objects on the same port and remove
% the relevant object form the workspace
port = instrfindall('RemoteHost',setupDefault.isiID);
if length(port) > 0; 
    fclose(port); 
    delete(port);
    clear port;
end

% make udp object named 'stim'
IsiComState.serialPortHandle = udp(setupDefault.isiID,'RemotePort',8005,'LocalPort',9004);

set(IsiComState.serialPortHandle, 'OutputBufferSize', 1024)
set(IsiComState.serialPortHandle, 'InputBufferSize', 1024)
set(IsiComState.serialPortHandle, 'Datagramterminatemode', 'off')

%Establish serial port event callback criterion  
IsiComState.serialPortHandle.BytesAvailableFcnMode = 'Terminator';
IsiComState.serialPortHandle.Terminator = '~'; %Magic number to identify request from Stimulus ('c' as a string)
IsiComState.serialPortHandle.BytesAvailableFcn = @Isicb;  

% open and check status 
fopen(IsiComState.serialPortHandle);
stat=get(IsiComState.serialPortHandle, 'Status')
if ~strcmp(stat, 'open')
    disp([' Isi camera: trouble opening port; cannot proceed']);
    IsiComState.serialPortHandle=[];
    out=1;
    return;
end

IsiComState.serialPortHandleReceiver = IsiComState.serialPortHandle;

disp('ISI camera connected');