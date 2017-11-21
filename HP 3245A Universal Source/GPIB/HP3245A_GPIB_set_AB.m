function HP3245A_GPIB_set_AB(source,frequencyA,amplitudeA,typeA,frequencyB,amplitudeB,typeB,phaseDifference)
%this program is written by Martijn Schouten
%for questions email: m.schouten-1@alumnus.utwente.nl
%The program is written for use with the GPIB-USB-B converter 
%and the agilent 54622D scope.
%Before using this program install the NI488-2 driver.
%written using Matlab R2017a

%to find the primary GPIB adress of the scope run tmtool
%scan for GPIB cards and scan for GPIB devices. 

%input parameters:
%source: the GPIB object generated by HP3245A_GPIB_init
%frequency: the frequency of the to be gerenated wavefrom in Hz
%amplitude: the amplitude of the to be gerenated waveform in V or A
%waveform: the type of waveform to be generated options are:
%               'ACV' or 'ACI': voltage or current sine wave
%               'SQV' or 'SQI': voltage or current square wave
%               'RPV' or 'RPI': voltage or current ramp
%phaseDifference: phase difference in between the signal on channel A and B
%                 in degrees

%to synchronise channels connect the trigger i/o of channel A and B with
%each other.

%known bugs:
%the phase in between the channels is sometimes 180 degrees out of phase

%channel A (master)
fprintf(source,'USE 0');
fprintf(source,'TRIGIN HIGH');
fprintf(source,'REFOUT EXT');
fprintf(source,'TRIGMODE ARMWF');
fprintf(source,'TRIGOUT EXT');
fprintf(source,'PANG 0');
fprintf(source,['FREQ ',num2str(frequencyA)]);
fprintf(source,['APPLY ',typeA,' ',num2str(amplitudeA)]);

%channel B (slave)
fprintf(source,'USE 100');
fprintf(source,'REFIN EXT');
fprintf(source,'TRIGMODE ARMWF');
fprintf(source,'TRIGIN EXT');
fprintf(source,['FREQ ',num2str(frequencyB)]);
fprintf(source,['PANG ',num2str(phaseDifference)]);
fprintf(source,['APPLY ',typeB,' ',num2str(amplitudeB)]);

fprintf(source,'USE 0');
fprintf(source,'TRIGIN LOW');
