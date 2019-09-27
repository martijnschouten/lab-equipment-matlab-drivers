function PS5443B_usb_sig_gen_set(sigGenGroupObj,wavetype,frequency,offset,peakToPeakVoltage)
%can only be executed before PS5443B_usb_stream_init is exectuted.

%frequency: frequency of the wave
%offset: dc offset in volt
%peakToPeakVoltage: amplitude in volt
%waveType:  for sine use        ps5000aEnuminfo.enPS5000AWaveType.PS5000A_SINE
%           for block use       ps5000aEnuminfo.enPS5000AWaveType.PS5000A_BlOCK
%           for triangle use    ps5000aEnuminfo.enPS5000AWaveType.PS5000A_TRIANGLE
%           for more see ps5000aEnuminfo (workspace variable)


set(sigGenGroupObj, 'startFrequency', frequency);
set(sigGenGroupObj, 'stopFrequency', frequency);
set(sigGenGroupObj, 'offsetVoltage', offset*1000);
set(sigGenGroupObj, 'peakToPeakVoltage', peakToPeakVoltage*1000);

[status.setSigGenBuiltInSimple] = invoke(sigGenGroupObj, 'setSigGenBuiltInSimple', wavetype);