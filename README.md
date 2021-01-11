# Lab equipment Matlab drivers

This github page contains a set of matlab functions that simplify the control of lab equipment, by implementing a abstration layer for using SCPI commands.

General usage is:  
```matlab
device_object = device_init()  
device_function(device_object,parameters)  
```

If you have an script that you think should be added to this repository, let me know!

The GPIB-USB-B converters are not support by versions of NI488.2 newer as 17.6. So be sure to always install version 17.6!
For more information see: https://www.ni.com/nl-nl/support/documentation/supplemental/06/ni-488-2-supported-versions-for-gpib-devices-and-modules.html