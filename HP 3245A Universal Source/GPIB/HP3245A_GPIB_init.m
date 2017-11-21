function source = HP3245A_GPIB_init(adress)
%this program is written by Martijn Schouten
%for questions email: m.schouten-1@alumnus.utwente.nl
%The program is written for use with the GPIB-USB-B converter 
%and the agilent 54622D scope.
%Before using this program install the NI488-2 driver.
%written using Matlab R2017a

%to find the primary GPIB adress of the scope run tmtool
%scan for GPIB cards and scan for GPIB devices. 


%search if there is already a gpib-0-17 object
source = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', adress, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(source)
    source = gpib('NI', 0, adress);
else
    fclose(source);
    source = source(1);
end

fopen(source);
fprintf(source, 'RST');
fprintf(source, 'SCRATCH');