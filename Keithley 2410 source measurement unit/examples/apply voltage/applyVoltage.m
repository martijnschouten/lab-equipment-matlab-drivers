%written by Martijn Schouten
%written in Matlab 2016b for a Keitley 2410 SourceMeter
%note that in order for the script to work, the SourceMeter should be,
%set to RS232 mode. This can be done via menu->communication

% reset everything
clear all
close all
instrreset

voltage = 500;%the applied voltage
compliance = 100e-6;%the current limit

sourcemeter = keithley_2410_serial_init(7);
keithley_2410_serial_source_voltage(sourcemeter,voltage,compliance)

load counter
counter = counter + 1;
save('counter.mat','counter');

kb = HebiKeyboard();
tic
i1 = 1;
figure
subplot(2,1,1)
h1 = animatedline;
xlabel('time(s)')
ylabel('voltage(V)')
subplot(2,1,2)
xlabel('time(s)')
ylabel('current(I)')
h2 = animatedline;

disp('press x to stop measurement')

while(1)
    state = read(kb);
    if ~state.CTRL
        if all(state.keys('x'))
            break
        end
    end
    [voltage(i1),current(i1)] = keithley_2410_serial_read(sourcemeter);
    time(i1) = toc;
    fileID = fopen(['data' num2str(counter) '.txt'],'a');
    fprintf(fileID,'%9.15f %9.15f %9.15f \n',time(i1),voltage(i1), current(i1));
    fclose(fileID);
    
    
    addpoints(h1,time(i1),voltage(i1));
    addpoints(h2,time(i1),current(i1));
    drawnow
    i1 = i1 + 1;
end
fclose(sourcemeter)
