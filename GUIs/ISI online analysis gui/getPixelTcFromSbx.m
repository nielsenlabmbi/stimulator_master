function success  = getPixelTcFromAvi(maxBaselineFrames,maxPostFrames)
    global pixelTc imagingDetail exptDetail

    if ~exist('maxBaselineFrames','var');   maxBaselineFrames = 10; end
    if ~exist('maxPostFrames','var');       maxPostFrames = 20;     end
    
    aviPath = ['C:\ISIdata\' exptDetail.animal '\' exptDetail.animal '_' exptDetail.unit '_' exptDetail.expt ];
    analyzerPath = ['Z:\ISI\Analyzer\' exptDetail.animal '\' exptDetail.animal '_u' exptDetail.unit '_' exptDetail.expt '.analyzer'];
    
    if ~exist([aviPath '.mat'],'file')
        success = false;
        return;
    end

    v = VideoReader([fname,'.avi']);
    imagingDetail.imageSize = [v.Height v.Width];
    imagingDetail.tPerFrame = 1/v.FrameRate;
    imagingDetail.maxBaselineFrames = maxBaselineFrames;
    imagingDetail.maxPostFrames = maxPostFrames;
    imagingDetail.projectedStimFrames = 20;

    clearvars sampleFrame;
    
    load(analyzerPath,'-mat');
    load([aviPath '.mat']);

    trialDetail = getTrialDetail(Analyzer);

    pixelTc = cell(1,trialDetail.nTrial);
    
    stimOnOffIdx = find(info.event_id == 2);
    stimOnIdx = stimOnOffIdx(1:2:end);
    stimOffIdx = stimOnOffIdx(2:2:end);
    
    success = true;
    if length(stimOnIdx) == length(trialDetail.trials)
        hWaitbar = waitbar(0,'1','Name','Extracting pixel data from sbx file. This may take a while...',...
                'CreateCancelBtn',...
                'setappdata(gcbf,''canceling'',1)');
        setappdata(hWaitbar,'canceling',0);
        for t=1:length(stimOnIdx)
            if getappdata(hWaitbar,'canceling'); success = false; break; end
            waitbar(t/length(stimOnIdx),hWaitbar,['Trial number ' num2str(t)]);
            stimOnFrame = info.frame(stimOnIdx(t));
            stimOffFrame = info.frame(stimOffIdx(t));
            baselineFrameStart = stimOnFrame-imagingDetail.maxBaselineFrames;
            
            epochs = [1 imagingDetail.maxBaselineFrames...
                imagingDetail.maxBaselineFrames+(stimOffFrame-stimOnFrame)...
                imagingDetail.maxBaselineFrames+(stimOffFrame-stimOnFrame)+imagingDetail.maxPostFrames];
            
            % baseline
            framesRead = sbxread(aviPath,baselineFrameStart,imagingDetail.maxBaselineFrames);
            framesRead = double(squeeze(framesRead(1,:,:,:)));
            if ~isempty(alignStruct); framesRead = alignFrames(framesRead,alignStruct.T(baselineFrameStart:baselineFrameStart+imagingDetail.maxBaselineFrames-1,:)); end
            pixelTc{t}(:,:,epochs(1):epochs(2)) = framesRead;
            
            % stim
            framesRead = sbxread(aviPath,stimOnFrame,stimOffFrame-stimOnFrame);
            framesRead = double(squeeze(framesRead(1,:,:,:)));
            if ~isempty(alignStruct); framesRead = alignFrames(framesRead,alignStruct.T(stimOnFrame:stimOffFrame-1,:)); end
            pixelTc{t}(:,:,epochs(2)+1:epochs(3)) = framesRead;
            
            % post
            framesRead = sbxread(aviPath,stimOffFrame,imagingDetail.maxPostFrames);
            framesRead = double(squeeze(framesRead(1,:,:,:)));
            if ~isempty(alignStruct); framesRead = alignFrames(framesRead,alignStruct.T(stimOffFrame:stimOffFrame+imagingDetail.maxPostFrames-1,:)); end
            pixelTc{t}(:,:,epochs(3)+1:epochs(4)) = framesRead;     
        end
        delete(hWaitbar);
    else
        disp('Something went wrong. TTL pulses don''t match up with nTrials.')
        success = false;
    end
end

function alignedFrames = alignFrames(inputFrames,shift)
    alignedFrames = nan(size(inputFrames));
    for frameCount=1:size(inputFrames,3)
        alignedFrames(:,:,frameCount) = circshift(squeeze(inputFrames(:,:,frameCount)),shift(frameCount,:));
    end
end