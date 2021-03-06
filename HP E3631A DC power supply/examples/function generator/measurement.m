clear all
close all 

powersupply = HP_E3631A_GPIB_init(22);

tend = 100;

Vmin = 10;
Vmax = 20;

fext = 0.02;

compliance = 100e-3;

i1 = 1;
figure
subplot(2,1,1)
h1 = animatedline;
xlabel('time(s)')
ylabel('voltage(V)')

subplot(2,1,2)
h2 = animatedline;
xlabel('time(s)')
ylabel('current(I)')

voltage = [];
current = [];
time2 = [0];
tic
i1 = 1;
while time2(i1) < tend
    test =  HP_E3631A_GPIB_get_current(powersupply);
    current(i1) = test;
    voltage(i1) = (Vmax+Vmin)/2 + (Vmax-Vmin)/2*sin(2*pi*fext*time2(i1));
    HP_E3631A_GPIB_set_HV(powersupply,voltage(i1),compliance);
    
    
    time{i1} = datetime('now');
    
    addpoints(h1,time2(i1),voltage(i1));
    if i1 > 2
        axis([min(time2),max(time2),min(voltage)-1e-9,max(voltage)+1e-9]);
    end
    addpoints(h2,time2(i1),current(i1));
    drawnow
    if i1 > 2
        axis([min(time2),max(time2),min(current)-1e-9,max(current)+1e-9]);
    end
    time2(i1+1) = toc;
    i1 = i1 + 1;
end

HP_E3631A_GPIB_set_HV(powersupply,0,compliance);

load counter
save(['data',mat2str(counter),'.mat'],'voltage', 'current','time')
counter = counter + 1;
save('counter.mat','counter');

fclose(powersupply)