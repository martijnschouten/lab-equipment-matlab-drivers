function [frequencies, Eabs, phase,offset] = calculateYoungsModulus(fileName,higherOrders,area,thickness,interpolation,plot)
load(fileName)

bins = 5;

[~,n] = size(position);

Eabs = zeros(1,n);
phase = zeros(higherOrders,n);
sigmaZabs = zeros(higherOrders,n);
dteff = [];
for i1 = 1:n
    n2 = length(position{i1});
    dt = (time{i1}(end)-time{i1}(1))/length(time{i1});
    
    dtint = dt/interpolation;
    ttemp = time{i1}-time{i1}(1);
    tint = 0:dtint:ttemp(end);
    nint = length(tint);
    
    Fint = interp1(ttemp,force{i1},tint, 'linear');
    xint = interp1(ttemp,position{i1},tint, 'linear');
   
    %causality "beun" fix
%     tint = tint(1:end-interpolation);
%     Fint = Fint(1+interpolation:end);
%     xint = xint(1:end-interpolation);
    
    fend = 1/dtint;
    df = fend/(nint-1);
    f = 0:df:fend;
    
    Pfft = fft(Fint/area);
    Sfft = fft(xint/thickness);
    
    if ~isempty(plot)
        if ismember(i1,plot)
             figure
             [hAx,hLine1,hLine2] = plotyy(time{i1},force{i1},time{i1},position{i1});
             xlabel('Time (s)')
             ylabel(hAx(1),'Force (N)')
             ylabel(hAx(2),'Position (m)')
             ylim(hAx(1),[min(force{i1}),max(force{i1})])
             ylim(hAx(2),[min(position{i1}),max(position{i1})])
             figure
             [hAx,hLine1,hLine2] = plotyy(tint,Fint-mean(Fint),tint,xint-mean(xint))
             xlabel('Time (s)')
             ylabel(hAx(1),'Force (N)')
             ylabel(hAx(2),'Position (m)')
             figure
             loglog(f(1:end/2),abs(Pfft(1:end/2))/nint*2/df);
             ylabel('Pressure (Pa/Hz)')
             xlabel('Frequency (Hz)')
             xlim([min(f),max(f)])
             figure
             loglog(f(1:end/2),abs(Sfft(1:end/2))/nint*2/df);
             ylabel('Strain (m/Hz)');
             xlabel('Frequency (Hz)');
             xlim([min(f),max(f)])
             figure
             fancyColourPlot(force{i1},position{i1},ttemp,'Time(s)')
             %fancyColourPlot(Fint,xint,tint,'Time(s)')
             xlabel('Position(m)')
             ylabel('Force(N)')
        end
    end
    
    
    offset(i1) = Sfft(1)/length(Sfft);
    
    Ptotal = 0;
    Stotal = 0;
    for i2 = 1:higherOrders      
        nfe = round(i2*frequencies(i1)/df);
        frangePlus = nfe-bins:nfe+bins;
        frangeMin = nint-frangePlus+2;
        
        Ptotal = Ptotal + sum(abs(Pfft(frangePlus)));
        Stotal = Stotal + sum(abs(Sfft(frangePlus)));
        
        
        Ffft_filt = zeros(n2,1);
        Ffft_filt(frangePlus) = Pfft(frangePlus);
        Ffft_filt(frangeMin) = Pfft(frangeMin);
        
        Sfft_filt = zeros(n2,1);
        Sfft_filt(frangePlus) = Sfft(frangePlus);
        Sfft_filt(frangeMin) = Sfft(frangeMin);
        
        
        xcorrVI = ifft(Ffft_filt.*conj(Sfft_filt));

        
        nmaxmax = floor(1/frequencies(i1)/i2/dt);
        [~, nmax] = max(xcorrVI(1:nmaxmax));
        phase(i2,i1) = -nmax*dtint*frequencies(i1)*2*pi;
        
        if phase(i2,i1) > pi
            phase(i2,i1) = phase(i2,i1) - 2*pi;
        end 
    end
    Eabs(1,i1) = Ptotal/Stotal;
end

% figure
% histogram(dteff)


