function closeSpikeglxCom

global GcomState 

%disconnect SpikeGlx
if IsRunning(GcomState)
    GcomState=Close(GcomState);
end

disp('disconnected from SpikeGlx');