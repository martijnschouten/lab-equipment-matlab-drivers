function RLCmeter = HP4284A_init(gpibAdress)
%Initialise the connection to the HP4284A multimeter using GPIB
    %this program is written by Martijn Schouten
    %for questions email: m.schouten-1@alumnus.utwente.nl
    %The program is written for use with the GPIB-USB-B converter 
    %and the HP4284a RLC meter.
    %Before using this program install the NI488-2 driver.
    %written using Matlab R2017a
    %to find the primary adress of the RLC meter run tmtool
    %scan for GPIB cards and scan for GPIB devices. 

%search if there is already a gpib-0-17 object
RLCmeter = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', gpibAdress, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(RLCmeter)
    RLCmeter = gpib('NI', 0, gpibAdress);
else
    fclose(RLCmeter);
    RLCmeter = RLCmeter(1);
end

% Open the GPIB object
fopen(RLCmeter);