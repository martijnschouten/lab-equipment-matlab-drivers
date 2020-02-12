function sourcemeter = keithley_2410_serial_init(port)

%When using this script make sure the 2410 is set to RS232 mode and the with the following settings:
%BAUD: 9600
%BITS: 8
%PARITY: NONE
%TERMINTATOR: <CR>
%FLOW CONTROL: NONE

%search if there is already a gpib-0-17 object
    sourcemeter = instrfind('Type', 'serial');

    % Create the GPIB object if it does not exist
    % otherwise use the object that was found.
    if isempty(sourcemeter)
        if (port == 0)
            object = instrhwinfo('serial');
            serialPort = object.AvailableSerialPorts{end};
            if serialPort == 1
                warning('error: no serial port found except port 1')
            end
        else
            serialPort = ['COM' num2str(port)];
        end
        sourcemeter = serial(serialPort);
    else
        fclose(sourcemeter);
        sourcemeter = sourcemeter(1);
    end
    
    %use the \H terminator
    sourcemeter.terminator = 13;
    %set the baud rate
    sourcemeter.baudrate = 9600;
    
    %open the connection with the sourcemeter
    fopen(sourcemeter);
    fprintf(sourcemeter,'*RST');
    fprintf(sourcemeter,':SYSTem:BEEPer:STATe OFF');
    
    
