function [data1,data2,time] = agilent3024A_single(scope, tRange,Vrange1,Vrange2,samples)
%this program is written by Martijn Schouten
%for questions email: m.schouten-1@alumnus.utwente.nl
%The program is written for use with the GPIB-USB-B converter 
%and the agilent 54622D scope.
%Before using this program install the NI488-2 driver.
%written using Matlab R2017a

%to find the primary GPIB adress of the scope run tmtool
%scan for GPIB cards and scan for GPIB devices. 

%output parameters:
%data1: vector with 2048 measured voltages on input 1
%data2: vector with 2048 measured voltages on input 2
%time: vector with the time at which the measurements in data1 and data2 were taken

%input parameters:
%scope: matlab GPIB object made by using agilent54622D_init
%tRange: double with the total measurement time
%Vrange1: double with the gain of channel 1 in maximum voltage that can be measured
%Vrange1: double with the gain of channel 2 in maximum voltage that can be measured
%samples: number of samples taken during tRange


fprintf(scope, [':TIMEBASE:RANGE ', num2str(tRange)]);
actualTimeRange = str2num(query(scope, ':TIMEBASE:RANGE?'));
fprintf(scope, ':CHANNEL1:DISPLAY 1');
fprintf(scope, ':CHANNEL1:PROBE 1');
fprintf(scope, [':CHANNEL1:RANGE ' num2str(Vrange1)]);

fprintf(scope, ':CHANNEL2:DISPLAY 1');
fprintf(scope, ':CHANNEL2:PROBE 1');
fprintf(scope, [':CHANNEL2:RANGE ' num2str(Vrange2)]);

fprintf(scope, ':WAVEFORM:POINTS:MODE RAW');

fprintf(scope, [':WAVEFORM:POINTS ' num2str(samples)]);
fprintf(scope, ':DIGITIZE CHANNEL1, CHANNEL2')
actualSamples = str2num(query(scope, ':WAVEFORM:POINTS?'));

fprintf(scope, ':WAVEFORM:SOURCE CHANNEL1');
fprintf(scope, ':WAVEFORM:DATA?');
tempdata = fread(scope, actualSamples+11);
preamble1 = query(scope, ':WAVeform:PREamble?');
preamble1 = strread( preamble1, '%f', 'delimiter', ',' );

data1 = double(uint8(tempdata(11:end-1)))-preamble1(10);
data1 = data1*preamble1(8)-preamble1(9);

fprintf(scope, ':WAVEFORM:SOURCE CHANNEL2');
fprintf(scope, ':WAVEFORM:DATA?');
tempdata = fread(scope, actualSamples+11);
preamble2 = query(scope, ':WAVeform:PREamble?');
preamble2 = strread( preamble2, '%f', 'delimiter', ',' );

data2 = double(uint8(tempdata(11:end-1)))-preamble2(10);
data2 = data2*preamble2(8)-preamble2(9);

dt = actualTimeRange/(actualSamples-1);
time = 0:dt:actualTimeRange;