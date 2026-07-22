function closeIsiCom

%configures communication with the isi computer

global IsiCom 

% delete IsiCom so that we can reinitialize it again
delete(IsiCom)
disp('ISI camera disconnected');