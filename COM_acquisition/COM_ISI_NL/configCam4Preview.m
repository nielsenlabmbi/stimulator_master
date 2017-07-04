cam = videoinput('gige', 1);
src = getselectedsource(cam);
stop(cam);

% set camera trigger 
framesPerTrigger = 15000; % We're counting on a software stop
cam.FrameGrabInterval = 2;          % save every other frame
cam.FramesPerTrigger = framesPerTrigger / cam.FrameGrabInterval;
src.TriggerSelector = 'FrameBurstStart';
triggerconfig(cam,'hardware','DeviceSpecific','DeviceSpecific');
set(cam, 'TriggerFcn', @camTriggerOccurred);

% make sure Jumbo Frames are set to 9k in the GigE NIC adapter settings
src.PacketSize = 9000;

%set details of movie acquisition
fileInfo.Fps = 15;  % Hz
fileInfo.resizeScale = 0.25;  % 0.5;    reduce frame size