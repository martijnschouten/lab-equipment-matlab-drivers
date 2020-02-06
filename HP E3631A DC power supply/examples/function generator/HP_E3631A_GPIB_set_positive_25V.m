function  HP_E3631A_GPIB_set_positive_25V(powerSupply,voltage,current)
    %Initialise the connection to the HP34401A multimeter using GPIB
    %this program is written by Martijn Schouten
    %for questions email: m.schouten-1@alumnus.utwente.nl
    %The program is written for use with the GPIB-USB-B converter 
    %and the E3631A power supply
    %Before using this program install the NI488-2 driver.
    %written using Matlab R2017a
    %to find the primary adress of the device run tmtool
    %scan for GPIB cards and scan for GPIB devices. 
    %fprintf(powerSupply,'INST P25V' );
    fprintf(powerSupply,['APPL P25V, ', num2str(voltage,'%.2f'),', ', num2str(current,'%.1f')]);
    
    