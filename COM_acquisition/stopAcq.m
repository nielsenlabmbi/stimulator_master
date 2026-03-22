function stopAcq

global setupDefault Mstate


if ~isempty(strfind(setupDefault.setupID,'2P')) && Mstate.acqConnect(Mstate.acqIdx2P)==1
    send_sbserver('S'); %stop microscope
end

if ~isempty(strfind(setupDefault.setupID,'EP')) && Mstate.acqConnect(Mstate.acqIdxEP)==1
    stopIntanAcq;
end

if ~isempty(strfind(setupDefault.setupID,'NP')) && Mstate.acqConnect(Mstate.acqIdxNP)==1
    stopSpikeglxAcq;
end

% if ~isempty(strfind(setupDefault.setupID,'ISI')) && Mstate.acqConnect(Mstate.acqIdxIsi)==1
%     stopIsiAcq;
% end

