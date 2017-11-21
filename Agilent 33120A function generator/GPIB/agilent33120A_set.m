function agilent33120A_set(generator, f,Vpp,offset)
%set the agilent33120A function generator to a sinewive using GPIB
    %this program is written by Martijn Schouten
    %for questions email: m.schouten-1@alumnus.utwente.nl
    %The program is written for use with the GPIB-USB-B converter 
    %and the agilent33120A function generator.
    %Before using this program install the NI488-2 driver.
    %written using Matlab R2017a
    %to find the primary adress of the RLC meter run tmtool
    %scan for GPIB cards and scan for GPIB devices. 
    
    fprintf(generator, ['APPL:SIN ' num2str(f) ', ' num2str(Vpp) ', ' num2str(offset)]);