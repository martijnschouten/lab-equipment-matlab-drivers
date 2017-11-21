function  keithley_2410_serial_source_voltage(sourcemeter,voltage,compliance)
    fprintf(sourcemeter,':SOURce:FUNCtion VOLT');
    fprintf(sourcemeter,[':SOURce:VOLTage ',num2str(voltage,'%4.8f')]);%set voltage to 1
    
    fprintf(sourcemeter,':SENS:FUNC "VOLT"');%set to voltage mode
    fprintf(sourcemeter,[':SENSe:CURRent:PROTection ',num2str(compliance,'%4.8f')]);
    
    fprintf(sourcemeter,':OUTPut:STATe ON');
end
