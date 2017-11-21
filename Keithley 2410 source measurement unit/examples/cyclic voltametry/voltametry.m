clear all
close all

sourcemeter = keithley_2410_serial_init(7);

fs = 2; %Hz sample frequency of the sourcemeter (estimate)
secPerV = 5;%s/V speed at which the voltage is increased and decreased

Vmax = 20;%minimum frequency
Vmin = -Vmax;%maximum frequency
n = 6;%number of cycles

slope = 1/secPerV;%V/s 
tend = (Vmax-Vmin)*2*n*secPerV/60%time the measurement will take in minutes

dV = slope/fs;
V = [0:dV:Vmax,Vmax:-dV:Vmin,Vmin:dV:0];
n2 = length(V);

tic
i1 = 1;
figure
h1 = animatedline;
xlabel('voltage(V)')
ylabel('current(I)')

for i1 = 1:n
    for i2 = 1:n2
        i3 = (i1-1)*n2+i2;
        keithley_2410_serial_source_voltage(sourcemeter,V(i2),10e-3)
        [voltage(i3),current(i3)] = keithley_2410_serial_read(sourcemeter);
        time(i3) = toc;

        addpoints(h1,voltage(i3),current(i3));
        drawnow
        if i3 > 2
            axis([min(voltage),max(voltage),min(current),max(current)]);
        end
    end
end

load counter
save(['data',mat2str(counter),'.mat'],'voltage', 'current','time')
counter = counter + 1;
save('counter.mat','counter');

fclose(sourcemeter)