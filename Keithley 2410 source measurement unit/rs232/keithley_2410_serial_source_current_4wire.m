function  keithley_2410_serial_source_current_4wire(sourcemeter,current,compliance)
    fprintf(sourcemeter,':SOURce:FUNCtion CURR');
    fprintf(sourcemeter,':SYST:RSEN ON');
    fprintf(sourcemeter,[':SOURce:CURR ',num2str(current,'%4.11f')]);
    
    fprintf(sourcemeter,':SENS:FUNC "VOLT"');%set to voltage mode
    fprintf(sourcemeter,[':SENSe:VOLTage:PROTection ',num2str(compliance,'%4.11f')]);
    
    fprintf(sourcemeter,':OUTPut:STATe ON');
end
