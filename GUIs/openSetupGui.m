function openSetupGui

global setupDefault


switch setupDefault.setupID
    
    case 'ISI' %intrinsic imaging rig
        h1 = IsiAnalysisGui;
        %movegui(hmm,[365,275]);
end

if setupDefault.useShutter
    h2=shutterSetting;
    %movegui(hmm,[365,275]);
end
    
