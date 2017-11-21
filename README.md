# lab equipment matlab drivers

This github page contains a set of matlab functions that simplify the control of lab equipment, by implementing abstration layer to using SCPI commands.

General usage is:
device_object = device_init()
device_function(device_object,parameters)