function PS5443B_usb_awg_set(sigGenGroupObj,y,frequency,offset,peakToPeakVoltage)
%can only be executed before PS5443B_usb_stream_init is exectuted.


%frequency: frequency of the wave
%offset: dc offset in volt
%peakToPeakVoltage: amplitude in volt
%waveType:  signal with signal in between 1 and 0

set(sigGenGroupObj, 'startFrequency', frequency);
set(sigGenGroupObj, 'stopFrequency', frequency);
set(sigGenGroupObj, 'offsetVoltage', offset*1000);
set(sigGenGroupObj, 'peakToPeakVoltage', peakToPeakVoltage*1000);

[status.setSigGenBuiltInSimple] = invoke(sigGenGroupObj, 'setSigGenArbitrarySimple', y);