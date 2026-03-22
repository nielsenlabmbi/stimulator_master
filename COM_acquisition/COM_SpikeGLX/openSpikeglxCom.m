function openSpikeglxCom

global GcomState setupDefault

%connect to SpikeGlx
rhost = setupDefault.SpikeGlxID;
hSGL = SpikeGL(rhost);
    
if IsRunning(hSGL)
    GcomState=hSGL;
    disp('connected to SpikeGlx');
else
    disp('failed to connect to SpikeGlx');
    GcomState=-1;
end