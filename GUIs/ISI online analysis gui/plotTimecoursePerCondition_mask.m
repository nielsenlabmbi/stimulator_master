function plotTimecoursePerCondition_mask(maskPixelList,selectedCondition,plotDetail,trialDetail,imagingDetail,timeWindows,axis_tc)
    % currPixelTc = getPixTc(currentPixel,plotDetail.filterPx+1);
    currPixelTc = getMaskTc(maskPixelList,imagingDetail.imageSize);
    
    primCond = plotDetail.param1name;
    primCondIdx = find(~cellfun(@isempty,(strfind(trialDetail.domains,primCond))));
    
    domval = trialDetail.domval;
    selectedDomval = domval(selectedCondition);
    if plotDetail.param1_modulo
        domval(:,primCondIdx) = mod(domval(:,primCondIdx),plotDetail.param1_moduloVal);
        [~,~,uniqueDomVals] = unique(domval);
        selectedDomval = trialDetail.domval(uniqueDomVals == selectedCondition,primCondIdx);
    end
    
    pickTrials = {};
    for v=1:length(selectedDomval)
        pickTrials{v} = [];
        if ~trialDetail.isMultipleDomain
            domValIdx = find(trialDetail.domval(:,primCondIdx) == selectedDomval(v));
            for dvi=1:length(domValIdx)
                pickTrials{v} = [pickTrials{v};find(trialDetail.trials == domValIdx(dvi))];
            end
        elseif strcmp(plotDetail.param2mode,'mean')
            domValIdx = find(trialDetail.domval(:,primCondIdx) == selectedDomval(v));
            for dvi=1:length(domValIdx)
                pickTrials{v} = [pickTrials{v};find(trialDetail.trials == domValIdx(dvi))];
            end
        elseif strcmp(plotDetail.param2mode,'all')
            domValIdx = find(trialDetail.domval(:,primCondIdx) == selectedDomval(v));
            for dvi=1:length(domValIdx)
                pickTrials{v} = [pickTrials{v};find(trialDetail.trials == domValIdx(dvi))];
            end
        else
            secCondIdx = 3 - primCondIdx;
            domValIdx = find(trialDetail.domval(:,primCondIdx) == selectedDomval(v) & domval(:,secCondIdx) == plotDetail.param2val);
            for dvi=1:length(domValIdx)
                pickTrials{v} = [pickTrials{v};find(trialDetail.trials == domValIdx(dvi))]; % (:,primCondIdx)
            end
        end    
    end    
    
    hold(axis_tc,'on');
    
    tc = currPixelTc(cell2mat(pickTrials'));
    for ii=1:length(tc)
        t = linspace(0,(imagingDetail.tPerFrame*length(tc{ii})),length(tc{ii}))*1000 + timeWindows.baselineRange(1);
        plot(axis_tc,t,tc{ii},'k','linewidth',1);
    end
    
	hold(axis_tc,'off')
end

function tc1 = getMaskTc(maskPixelList,imageSize)
    global pixelTc;
    
	[X,Y] = ind2sub(imageSize,maskPixelList);
    for p=1:length(X)
        tc(:,p) = cellfun(@(x)squeeze(x(X(p),Y(p),:)),pixelTc,'uniformoutput',false);
    end
    
    for c=1:size(tc,1)
        tc1{c} = mean(cell2mat(tc(c,:)),2);
    end
end