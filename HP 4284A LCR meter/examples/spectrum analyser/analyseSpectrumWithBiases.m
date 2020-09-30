clear all
close all


sweeps = 5;%number of sweeps
frequencies = 100;
Vmin = -0.3;
Vmax = 0.3;
fs = 1/1.55;
secPerV = 100; %s/V
slope = 1/secPerV
dV = slope/fs;
bias = [0:dV:Vmax, Vmax:-dV:Vmin,Vmin:dV:0];
biases = length(bias);%number of frequencies
amplitude = 0.01;


GPIB_adress = 17;
RLCmeter = HP4284A_init(GPIB_adress);

tic
for i2 = 1:sweeps
    for i1 = 1:biases
        tempdata = HP4284A_single(RLCmeter,frequencies,amplitude,bias(i1),'CPRP','LONG',1);
        Rp(i1,i2) = tempdata(2);
        Cp(i1,i2) = tempdata(1);
        time(i1,i2) = toc;
        i2
        i1
    end
end

load counter
save(['CPRPdata',mat2str(counter),'.mat'],'Rp', 'frequencies','Cp','bias','time','amplitude')
counter = counter + 1;
save('counter.mat','counter');

fclose(RLCmeter)

dim = 2;
avgRp = mean(Rp,dim);
stdRp = std(Rp,0,dim);
avgCp = mean(Cp,dim);
stdCp = std(Cp,0,dim);

figure
subplot(2,1,1)
errorbar(bias,avgRp,stdRp)
xlabel('log(Frequency) (Hz)')
ylabel('Parallel resistance (Ohm)')
subplot(2,1,2)
errorbar(bias,avgCp,stdCp)
xlabel('log(Frequency) (Hz)')
ylabel('Parallel capacitance (Farad)')

figure
for i1 = 1:sweeps
    subplot(2,1,1);
    plot(bias,Rp(:,i1));
    xlabel('Frequency(Hz)')
    ylabel('Parallel resistance(Ohm)')
    hold on
    subplot(2,1,2)
    plot(bias,Cp(:,i1))
    xlabel('Frequency (Hz)')
    ylabel('Parallel capacitance (Farad)')
    hold on
end


