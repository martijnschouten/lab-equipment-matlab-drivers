function  data = keithley_2000_get(multimeter,mode,chan)
%Initialise the connection to the keithley 2000 muxed multimeter using GPIB
    %this program is written by Martijn Schouten
    %for questions email: m.schouten-1@alumnus.utwente.nl
    %The program is written for use with the GPIB-USB-B converter 
    %and the agilent33120A function generator.
    %Before using this program install the NI488-2 driver.
    %written using Matlab R2019b
    %to find the primary adress of the RLC meter run tmtool
    %scan for GPIB cards and scan for GPIB devices. 
    %usage:
    %mode: string containing value to be measured (i.e. 'VOLTAGE', 'CURRENT',
    %'RESistance')
    %ACDC: string select either AC or DC measurment mode (i.e. 'AC' or
    %'DC')
    %word = ['ROUTE:CLOSE ', num2str(chan), '']
    fwrite(multimeter, ['ROUTE:CLOSE (@', num2str(chan), ')']); 
    %data = str2num(query(multimeter,'read?'));
    data = str2num(query(multimeter,['MEASURE:', mode, '?']));
    