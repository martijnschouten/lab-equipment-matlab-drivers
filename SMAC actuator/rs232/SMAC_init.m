function actuator = SMAC_init(port)
%search if there is already a gpib-0-17 object
    actuator = instrfind('Type', 'serial');

    % Create the GPIB object if it does not exist
    % otherwise use the object that was found.
    if isempty(actuator)
        if (port == 0)
            object = instrhwinfo('serial');
            serialPort = object.AvailableSerialPorts{end};
            if serialPort == 1
                warning('error: no serial port found except port 1')
            end
        else
            serialPort = ['COM' num2str(port)];
        end
        actuator = serial(serialPort);
    else
        fclose(actuator);
        actuator = actuator(1);
    end
    
    %use the \H terminator
    actuator.terminator = 13;
    %set timeout
    actuator.Timeout = 1;
    %set the baud rate
    actuator.baudrate = 115200;
    
    fopen(actuator);
end