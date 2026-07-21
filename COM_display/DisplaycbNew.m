function DisplaycbNew(src, ~)

%callback from stimulus machine using new tcp commands

global AppHdl Mstate



% Check if data is available (safety verification)
if src.NumBytesAvailable > 0
    % Read the incoming ASCII data line
    inString = readline(src);
    inString=char(inString);
    fprintf('\t'); disp(['Message received from slave: ' inString]);
    
    %'nextT' is the string sent after stimulus is played
    %If it just played a stimulus, and scanimage is not acquiring, then run
    %next trial...
    if strcmp(inString,'nextT')

        %run any trial-dependent code for the acquisition
        if AppHdl.main.BStimDAQ.Value==1
            stopAcqTrial;
        end

        run2

    elseif inString(1)=='r'
        Mstate.refreshRate=str2num(inString(2:end));
        %disp(Mstate.refreshRate)

    end
end
end