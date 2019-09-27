try PS5443B_usb_stream_stop(ps5000aDeviceObj);
end
clear all
close all
instrreset

%% Load configuration information
PS5000aConfig;
ranges = [ps5000aEnuminfo.enPS5000ARange.PS5000A_500MV,ps5000aEnuminfo.enPS5000ARange.PS5000A_500MV,ps5000aEnuminfo.enPS5000ARange.PS5000A_500MV,ps5000aEnuminfo.enPS5000ARange.PS5000A_10MV];
couplings = [ps5000aEnuminfo.enPS5000ACoupling.PS5000A_AC,ps5000aEnuminfo.enPS5000ACoupling.PS5000A_AC,ps5000aEnuminfo.enPS5000ACoupling.PS5000A_AC,ps5000aEnuminfo.enPS5000ACoupling.PS5000A_AC];
offsets = [0,0,0,0];
fcs = [33000];
plotFreq = 1;
timeconstant = 1e-2;
ptpAmplitude =  0.1;
fs = 5e6;
tplot = 3;

VtoI = ((12+10)/12/2.2e3);

hardwareDownSampleRatio = 20;

tend = 20;
bufferSize = 40000000;

fcoutput = 1/2/pi/timeconstant;
fdrift = 1;

frequs = length(fcs);
for i1 = 1:frequs
    ffilt1s(i1) = fcs(i1)-fcoutput;
    ffilt2s(i1) = fcs(i1)+fcoutput;
end

outputDownSampleRatio = round(fs/hardwareDownSampleRatio/fcoutput/10);
fsoutput = fs/hardwareDownSampleRatio/outputDownSampleRatio;

channels = length(ranges);
desiredInterval = 1/fs;
finalBufferSize = round(tend/desiredInterval*1.5/hardwareDownSampleRatio);
outputBufferSize = round(fsoutput*1.5);

%initialize picoscope
ps5000aDeviceObj = PS5443B_usb_init();

%configure function generator
sigGenGroupObj = PS5443B_usb_sig_gen_init(ps5000aDeviceObj);
awg_buffer_size = PS5443B_usb_buffer_size_get(sigGenGroupObj);
x = 0:(2*pi)/(awg_buffer_size - 1):2*pi;
fcmin = min(fcs);
y = zeros(1,awg_buffer_size);
for i1 = 1:frequs
    y = y + sin(fcs(i1)/fcmin*x);
end
y = y/max(y);


figure
plot(y)
ylabel('Normalised amplitude')
xlabel('sample number')

PS5443B_usb_awg_set(sigGenGroupObj,y, fcmin,0,ptpAmplitude)

%start streaming
[appBuffer,driverBuffer,streamingGroupObj,maxADCCount,actualSampleInterval] = PS5443B_usb_stream_init(ps5000aDeviceObj,ranges,couplings,offsets,desiredInterval,bufferSize,hardwareDownSampleRatio);

fsActual = 1/actualSampleInterval;
dto = actualSampleInterval*hardwareDownSampleRatio*outputDownSampleRatio;
for i1 = 1:frequs
    X{i1} = zeros(outputBufferSize,1);
    Y{i1} = zeros(outputBufferSize,1);
    state1{i1} = {[],[]};
    state2{i1} = {[],[],[],[],[]};
end

nM = 3;
M = zeros(outputBufferSize,nM);
time = zeros(outputBufferSize,1);
data = zeros(finalBufferSize,4);

i2 = 1;
i3 = 1;
i4 = 1;
rest = 1;


tic
figure
for i1 = 1:frequs
    ax1{i1} = subplot(frequs,2,1+(i1-1)*2);
    h1{i1} = animatedline;
    ylabel('X(V)')
    xlabel('time(t)')
    title(['X-' num2str(i1)])
    ax2{i1} = subplot(frequs,2,2+(i1-1)*2);
    h2{i1} = animatedline;
    ylabel('Y(V)')
    xlabel('time(t)')
    title(['Y-' num2str(i1)])
end


while toc < tend
    i2;
    PS5443B_usb_stream_get_ready(streamingGroupObj);
    [result, appBuffer] = PS5443B_usb_stream_get_data(streamingGroupObj, appBuffer,ranges,maxADCCount);
    n = length(result{1});
    signal = result{2}-result{1};
    carrier = result{3};
    for i1 = 1:channels
        data(i2:i2+n-1,i1) = result{i1};
    end
    use = rest+1:outputDownSampleRatio:n;
    n2 = length(use);
    rest = mod(n-rest,outputDownSampleRatio);
    time(i3:i3+n2-1) = (i3:i3+n2-1)*dto;
    for i5 = 1:frequs
        [signalFiltered,state1{i5}{1}] = realTimeFilter(signal,[ffilt1s(i5)/fsActual*hardwareDownSampleRatio*2, ffilt2s(i5)/fsActual*hardwareDownSampleRatio*2],2,'butter','bandpass',state1{i5}{1});
        [carrierFiltered,state1{i5}{2}] = realTimeFilter(carrier,[ffilt1s(i5)/fsActual*hardwareDownSampleRatio*2, ffilt2s(i5)/fsActual*hardwareDownSampleRatio*2],2,'butter','bandpass',state1{i5}{2});
        Xt = signalFiltered.*carrierFiltered;
        Yt = signalFiltered.*hilbert2(carrierFiltered,10);
        [Xt,state2{i5}{1}] = realTimeFilter(Xt,fcoutput/fsActual*hardwareDownSampleRatio*2,2,'butter','low',state2{i5}{1});
        [Xf,state2{i5}{4}] = realTimeFilter(Xt,fcoutput/fsActual*hardwareDownSampleRatio*2,2,'butter','low',state2{i5}{4});
        [Yt,state2{i5}{2}] = realTimeFilter(Yt,fcoutput/fsActual*hardwareDownSampleRatio*2,2,'butter','low',state2{i5}{2});
        [Yf,state2{i5}{5}] = realTimeFilter(Yt,fcoutput/fsActual*hardwareDownSampleRatio*2,2,'butter','low',state2{i5}{5});
%         [Xt,state2{i5}{1}] = realTimeFilter(Xt,[10/fsActual*hardwareDownSampleRatio*2, fcoutput/fsActual*hardwareDownSampleRatio*2],2,'butter','bandpass',state2{i5}{1});
%         [Xf,state2{i5}{4}] = realTimeFilter(Xt,[10/fsActual*hardwareDownSampleRatio*2, fcoutput/fsActual*hardwareDownSampleRatio*2],2,'butter','bandpass',state2{i5}{4});
%         [Yt,state2{i5}{2}] = realTimeFilter(Yt,[10/fsActual*hardwareDownSampleRatio*2, fcoutput/fsActual*hardwareDownSampleRatio*2],2,'butter','bandpass',state2{i5}{2});
%         [Yf,state2{i5}{5}] = realTimeFilter(Yt,[10/fsActual*hardwareDownSampleRatio*2, fcoutput/fsActual*hardwareDownSampleRatio*2],2,'butter','bandpass',state2{i5}{5});
        [Cms, state2{i5}{3}] = realTimeFilter(carrierFiltered.^2,fdrift/fsActual*hardwareDownSampleRatio*2,2,'butter','low',state2{i5}{3});
        
        X{i5}(i3:i3+n2-1) = Xf(use)./abs(sqrt(Cms(use)));
        Y{i5}(i3:i3+n2-1) = Yf(use)./abs(sqrt(Cms(use)));
        
        addpoints(h1{i5},time(i3:i3+n2-1),X{i5}(i3:i3+n2-1));
        addpoints(h2{i5},time(i3:i3+n2-1),Y{i5}(i3:i3+n2-1));
        
        
        if time(i3+n2-1) > tplot
            plotn = i3+n2-1-floor(tplot/dto):i3+n2-1;
            axis(ax1{i5}, [time(i3+n2-1)-tplot,time(i3+n2-1), min(X{i5}(plotn)),max(X{i5}(plotn))]);
        else
            plotn = 1:i3+n2-1;
            axis(ax1{i5}, [0,time(i3+n2-1), min(X{i5}(plotn)),max(X{i5}(plotn))]);
        end
        if time(i3+n2-1) > tplot
            plotn = i3+n2-1-floor(tplot/dto):i3+n2-1;
            axis(ax2{i5}, [time(i3+n2-1)-tplot,time(i3+n2-1), min(Y{i5}(plotn)),max(Y{i5}(plotn))]);
        else
            plotn = 1:i3+n2-1;
            axis(ax2{i5}, [0,time(i3+n2-1), min(Y{i5}(plotn)),max(Y{i5}(plotn))]);
        end
        
        
    end
    
    drawnow
    
    
    i2 = i2+n;
    i3 = i3+n2;
end

PS5443B_usb_stream_stop(ps5000aDeviceObj);

for i1 = 1:frequs
    X{i1} = X{i1}(1:i3-1);
    Y{i1} = Y{i1}(1:i3-1);
end
data = data(1:i2-1,:);

dt = actualSampleInterval*hardwareDownSampleRatio;
nt = i2-1;
t = 0:dt:(nt-1)*dt;

load counter
save(['data',mat2str(counter),'.mat'],'X', 'Y','t','data', 'time', 'fcs', 'timeconstant','couplings','ptpAmplitude','fs','hardwareDownSampleRatio', 'fdrift','-v7.3')
counter = counter + 1;
save('counter.mat','counter');

figure
nstart = round(3/fdrift*fsoutput);
for i1 = 1:frequs
    ax1{i1} = subplot(frequs,2,1+(i1-1)*2);
    plot(time(nstart:end),X{i1}(nstart:end))
    ylabel('X(V)')
    xlabel('time(t)')
    title(['X-' num2str(i1)])
    ax2{i1} = subplot(frequs,2,2+(i1-1)*2);
    plot(time(nstart:end),Y{i1}(nstart:end))
    ylabel('Y(V)')
    xlabel('time(t)')
    title(['Y-' num2str(i1)])
    
end


% 
% figure
% subplot(2,1,1)
% plot(time(nstart:end),X{1}(nstart:end),time(nstart:end),X{2}(nstart:end))
% ylabel('X(V)')
% xlabel('time(t)')
% legend({[num2str(fcs(1)) 'Hz'], [num2str(fcs(2)) 'Hz']})
% subplot(2,1,2)
% plot(time(nstart:end),abs(M(nstart:end,1)))
% ylabel('M(V)')
% xlabel('time(t)')
% 
% figure
% subplot(3,1,1)
% plot(time(nstart:end),abs(M(nstart:end,1)))
% ylabel('Re(Ohm)')
% xlabel('time(t)')
% subplot(3,1,2)
% plot(time(nstart:end),abs(M(nstart:end,2)))
% ylabel('Ri(Ohm)')
% xlabel('time(t)')
% subplot(3,1,3)
% plot(time(nstart:end),abs(M(nstart:end,3)))
% ylabel('Cm(F)')
% xlabel('time(t)')



% 
% figure
% plot(t(use),filteredData(use,1),t(use),hilbert2(filteredData(use,2),10))



% 
% fs = 1/dt;
% df = fs/(nt-1);
% f = 0:df:fs;
% Sig = fft(data(:,1));
% figure
% loglog(f,abs(Sig)/nt)
% 
% Sigf = fft(filteredData(:,1));
% figure
% loglog(f,abs(Sigf)/nt)
% 
% figure
% plot(time,filteredData)



