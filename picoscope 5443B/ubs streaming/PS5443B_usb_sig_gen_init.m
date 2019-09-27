function sigGenGroupObj = PS5443B_usb_sig_gen_init(ps5000aDeviceObj)
%% Obtain Signalgenerator group object
% Signal Generator properties and functions are located in the Instrument
% Driver's Signalgenerator group.

sigGenGroupObj = get(ps5000aDeviceObj, 'Signalgenerator');
sigGenGroupObj = sigGenGroupObj(1);


    