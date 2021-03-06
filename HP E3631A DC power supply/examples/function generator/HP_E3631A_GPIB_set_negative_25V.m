function  HP_E3631A_GPIB_set_negative_25V(powerSupply,voltage,current)
    %Initialise the connection to the HP34401A multimeter using GPIB
    %this program is written by Martijn Schouten
    %for questions email: m.schouten-1@alumnus.utwente.nl
    %The program is written for use with the GPIB-USB-B converter 
    %and the E3631A power supply
    %Before using this program install the NI488-2 driver.
    %written using Matlab R2017a
    %to find the primary adress of the device run tmtool
    %scan for GPIB cards and scan for GPIB devices. 
    
    command = ['APPL N25V, ', num2str(voltage,1),', ', num2str(current)]
    fprintf(powerSupply,command);
    
    