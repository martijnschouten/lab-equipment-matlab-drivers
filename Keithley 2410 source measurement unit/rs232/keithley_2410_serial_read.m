function [voltage, current] = keithley_2410_serial_read(sourcemeter)
%When using this script make sure the 2410 is set to RS232 mode and the with the following settings:
%BAUD: 9600
%BITS: 8
%PARITY: NONE
%TERMINTATOR: <CR>
%FLOW CONTROL: NONE

    answer = str2num(query(sourcemeter,'read?'));
    voltage = answer(1);
    current = answer(2);
