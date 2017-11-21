function data = HP4284A_single(RLCmeter,freq,voltage,bias,mode,integration_time,averages)
%this program is written by Martijn Schouten
%for questions email: m.schouten-1@alumnus.utwente.nl
%The program is written for use with the GPIB-USB-B converter 
%and the HP4284a RLC meter.
%Before using this program install the NI488-2 driver.
%written using Matlab R2017a

%to find the primary adress of the RLC meter run tmtool
%scan for GPIB cards and scan for GPIB devices. 


%input parameters
%freq: measurement signal frequency in Hz
%voltage: measurement signal size in V
%mode: measurement mode eq. CSRS, CPRP, ZTR
%integration_time: integration time eq. SHOR, MED, LONG

fprintf(RLCmeter, ['BIAS:STATE ON']);
fprintf(RLCmeter, ['BIAS:VOLT ', num2str(bias)])
fprintf(RLCmeter, ['FREQ ', num2str(freq)]);%set oscillator frequency to 100kHz
fprintf(RLCmeter, ['VOLT ', num2str(voltage)]);%set oscillator voltage to 1V
fprintf(RLCmeter, ['FUNC:IMP ', mode]);%set to Cs Rs mode
fprintf(RLCmeter, ['APER ', integration_time, ',', num2str(averages)]);%set intergration time
fprintf(RLCmeter, 'TRIG:SOUR BUS');

fprintf(RLCmeter, 'TRIG');
data = str2num(query(RLCmeter,'FETC:IMP?'));
