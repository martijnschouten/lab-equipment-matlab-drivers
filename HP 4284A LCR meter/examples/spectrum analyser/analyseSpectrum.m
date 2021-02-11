clear all
close all

frequs = 50;%number of frequencies 
sweeps = 10;%number of frequency sweeps
frequencies = logspace(1.4,6,frequs);
bias = 0;

GPIB_adress = 17;
RLCmeter = HP4284A_init(GPIB_adress);

tic
for i2 = 1:sweeps
    for i1 = 1:frequs
        tempdata = HP4284A_single(RLCmeter,frequencies(i1),0.5,bias,'ZTR','LONG',1);
        Zabs(i1,i2) = tempdata(1);
        phase(i1,i2) = tempdata(2);
        time(i1,i2) = toc;
        i2
        i1
    end
end

load counter
save(['Zdata',mat2str(counter),'.mat'],'Zabs', 'frequencies','phase','bias','time')
counter = counter + 1;
save('counter.mat','counter');

fclose(RLCmeter)

dim = 2;
avgImp = mean(Zabs,dim);
stdImp = std(Zabs,0,dim);
avgPhase = mean(phase,dim);
stdPhase = std(phase,0,dim);

figure
subplot(2,1,1)
min = log10(avgImp)-log10(avgImp-stdImp);
plus = log10(avgImp)-log10(avgImp+stdImp);
errorbar(log10(frequencies),log10(avgImp),min,plus)
xlabel('log(Frequency) (Hz)')
ylabel('log(Impedance) (Ohm)')
subplot(2,1,2)
errorbar(log10(frequencies),avgPhase,stdPhase)
xlabel('log(Frequency) (Hz)')
ylabel('Phase (rad)')

figure
for i1 = 1:sweeps
    subplot(2,1,1);
    loglog(frequencies,Zabs(:,i1));
    xlabel('Frequency(Hz)')
    ylabel('Impedance(Ohm)')
    hold on
    subplot(2,1,2)
    semilogx(frequencies,phase(:,i1))
    xlabel('Frequency (Hz)')
    ylabel('Phase (rad)')
    hold on
end
