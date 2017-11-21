function [voltage, current] = keithley_2410_serial_read(sourcemeter)
    answer = str2num(query(sourcemeter,'read?'));
    voltage = answer(1);
    current = answer(2);
