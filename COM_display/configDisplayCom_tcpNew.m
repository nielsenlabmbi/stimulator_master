function configDisplayCom_tcpNew

%configures communication with the stimulus slave - new tcp commands

global StimCom 

%with tcpserver, the ip entered here is that of the server; the port distinguishes connections
StimCom=tcpserver("0.0.0.0", 30000); 
configureTerminator(StimCom, 126); %126 = ~
configureCallback(StimCom, "terminator", @DisplaycbNew);


disp('Opening TCP gateway. Start Stimulator on the slave.');

% check status 
fprintf('Waiting for client connection...\n');
while StimCom.Connected == 0
    pause(0.5); 
end
fprintf('Client successfully connected!\n\n');





