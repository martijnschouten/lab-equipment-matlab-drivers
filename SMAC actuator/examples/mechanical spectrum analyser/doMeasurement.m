%if you want to connect to the smac actuator in smac control center
%you should close the connnection in matlab:
%fclose(actuator)

clear all
close all

actuator = SMAC_init(9);

%script parameters
n1 = 10;%number of frequencies
n2 = 40;%number of periods in a measurement
fmin = 0.1;%minimum frequency
fmax = 2;%maximum frequency
Fbias = 4;%N
Fac = 3;%N
A = (1.75e-3/2)^2*pi;%section area
L = 20e-3; %length of the sample

%system parameters
fs = 40;%sample frequency
FperP = 0.0167;
mperP = 5e-2/10000;

%derived parameters
dt = 1/fs;
frequencies = logspace(log10(fmin),log10(fmax),n1);

ttotal = sum(1./frequencies*n2)/60/60

figure
subplot(2,1,1)
h1 = animatedline;
xlabel('time(s)')
ylabel('Position(m)')
subplot(2,1,2)
xlabel('time(s)')
ylabel('Force(N)')
h2 = animatedline;

tic
for i2 = 1:n1
    p = 1/frequencies(i2);
    n3 = round(p*n2/dt);
    tmax = toc + (n3-1)*dt;
    i1=1;
    while toc < tmax
        Fset = Fbias/FperP+Fac/FperP*sin(2*pi*toc*frequencies(i2));
        [position{i2}(i1), force{i2}(i1)] = SMAC_read_and_set_Force(actuator,Fset);
        position{i2}(i1) = mperP * position{i2}(i1);
        force{i2}(i1) = FperP * force{i2}(i1);
        time{i2}(i1) = toc;
        addpoints(h1,time{i2}(i1),position{i2}(i1));
        addpoints(h2,time{i2}(i1),force{i2}(i1));
        drawnow limitrate
        i1 = i1+1;
    end
end
toc

SMAC_read_and_set_Force(actuator,0)

load counter
save(['data',mat2str(counter),'.mat'],'force', 'position','time','frequencies')
counter = counter + 1;
save('counter.mat','counter');

fclose(actuator)

[frequencies, Eabs, phase,offset] = calculateCalculateYoungsModulus(['data',mat2str(counter-1),'.mat'],5,A,L,5,[]);

figure
subplot(2,1,1)
semilogx(frequencies(1:length(Eabs)),Eabs)
xlabel('Frequency(Hz)')
ylabel('Youngs modulus (Pa)')
subplot(2,1,2)
semilogx(frequencies(1:length(Eabs)),phase(1,:))
xlabel('Frequency(Hz)')
ylabel('Phase shift (rad)')