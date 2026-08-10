function openSetupGui

global setupDefault  AppHdl;


if setupDefault.useShutter
    AppHdl.shutter=shutterSettingNew;
    %movegui(h2,[575,170]);
end

if setupDefault.useRefStim
    AppHdl.refstim = ReferenceStim;
end
