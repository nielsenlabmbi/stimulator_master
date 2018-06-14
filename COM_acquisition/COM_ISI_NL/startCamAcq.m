function startCamAcq
global Mstate camInfo camMeta cam;

%%%%%%%%%%%% Set file name
title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];
%open file for movie acquisition
dd = [Mstate.dataRoot '\' Mstate.anim ...
    '\' sprintf('u%s',Mstate.unit) '_' Mstate.expt ...
    '\' title '.avi'];
fprintf('Video path and filename : %s\n\n', dd);

%%%%%%%%%%%% Make video file
camInfo.writerObj = VideoWriter(dd); 
camInfo.writerObj.FrameRate = camInfo.Fps;
open(camInfo.writerObj);

camMeta = {};

%%%%%%%%%%%% Set up camera

% set camera trigger for the experiment params (overwrite preview)
P = getParamStruct;
framesPerTrigger = ceil(P.predelay*camInfo.Fps); % only image during the pre delay and stim
cam.FrameGrabInterval = 1;          % save every frame
cam.FramesPerTrigger = framesPerTrigger / cam.FrameGrabInterval;
% cam.TriggerRepeat = 1;
cam.TriggerSelector = 'FrameBurstStart';
triggerconfig(cam,'hardware','DeviceSpecific','DeviceSpecific');
set(cam, 'TriggerFcn', @camTriggered);
% set(cam, 'TriggerMode', 'On');
