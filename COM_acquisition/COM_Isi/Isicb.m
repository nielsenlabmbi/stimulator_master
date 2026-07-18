function Isicb(obj,event)
%Callback function from ISI PC

global IsiComState IsiState

%disp('callback')

n=get(IsiComState.serialPortHandleReceiver,'BytesAvailable');
if n > 0
    inString = fread(IsiComState.serialPortHandleReceiver,n);
    inString = char(inString');
else
    return
end

inString = inString(1:end-1);  %Get rid of the terminator
disp(['Message received from camera: ' inString]);

%the following sets the status of the camera once it confirms that data
%saving is done
if strcmp(inString,'doneData')  
    IsiState.doneData=1;
end    
