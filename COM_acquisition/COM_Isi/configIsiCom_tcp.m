function configIsiCom_tcp

%configures communication with the isi computer

global IsiCom 

%isiIP='172.30.11.187';

IsiCom=tcpserver("0.0.0.0", 40000); 
configureTerminator(IsiCom, 126); %126 = ~
%configureCallback(IsiCom, "terminator", @Isicb); %no callback, will just
%probe for bytes available

disp('Opening TCP gateway. Start communication on ISI computer.');
% check status 
fprintf('Waiting for client connection...\n');
while IsiCom.Connected == 0
    pause(0.5); 
end


disp('ISI camera connected');