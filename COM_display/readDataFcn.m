function DisplaycbNew(src, ~)
    % src is the active tcpserver object automatically passed by MATLAB
    
    % Check if data is available (safety verification)
    if src.NumBytesAvailable > 0
        % Read the incoming ASCII data line
        dataReceived = readline(src);
        
        % Process the data (here, we print it to the Command Window)
        fprintf("Received from client: %s\n", dataReceived);
        
        % Optional: Send a response back to the client
        write(src, "Message Received", "string");
    end
end