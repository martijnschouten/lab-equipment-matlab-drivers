function  Generator = agilent33120A_init(generatorAdress)
%Initialise the connection to the HP34401A multimeter using GPIB
    %this program is written by Martijn Schouten
    %for questions email: m.schouten-1@alumnus.utwente.nl
    %The program is written for use with the GPIB-USB-B converter 
    %and the agilent33120A function generator.
    %Before using this program install the NI488-2 driver.
    %written using Matlab R2017a
    %to find the primary adress of the RLC meter run tmtool
    %scan for GPIB cards and scan for GPIB devices. 
    
    
    %search if there is already a gpib object
    Generator = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', generatorAdress, 'Tag', '');

    % Create the GPIB object if it does not exist
    % otherwise use the object that was found.
    if isempty(Generator)
        Generator = gpib('NI', 0, generatorAdress);
    else
        fclose(Generator);
        Generator = Generator(1);
    end

    fopen(Generator);