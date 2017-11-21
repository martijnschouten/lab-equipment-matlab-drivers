function  keithley_2410_serial_source_current(sourcemeter,current,compliance)
    fprintf(sourcemeter,':SOURce:FUNCtion CURR');
    fprintf(sourcemeter,[':SOURce:VOLTage ',num2str(current,'%4.8f')]);
    
    fprintf(sourcemeter,':SENS:FUNC "CURR"');%set to voltage mode
    fprintf(sourcemeter,[':SENSe:VOLTage:PROTection ',num2str(compliance,'%4.8f')]);
    
    fprintf(sourcemeter,':OUTPut:STATe ON');
end
