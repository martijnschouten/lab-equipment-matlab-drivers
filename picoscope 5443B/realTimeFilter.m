function [filteredData, state] = realTimeFilter(data,Wn,n,design,ftype,state)
    %data:      data to be filtered
    %Wn:        cuttof frequency divided by the nyquist frequency. Scalar for high and low,
    %           vector for bandapss and stop
    %n:         filter order
    %design:    filter design ('butter', 'cheby2', 'ellip')
    %ftype:     filter type ('high','low','bandpass', 'stop')

    [n1,n2] = size(data);
    if n2 > n1
        data = rot90(data);
    end
    n3 = length(data);
    
    if strcmp(design,'butter')
        [b,a] = butter(n,Wn,ftype);
    elseif strcmp(design,'cheby2')
        [b,a] = cheby2(n,100,Wn,ftype);
    elseif strcmp(design,'ellip')
        [b,a] = ellip(n,1,100,Wn,ftype);
    elseif strcmp(design,'fir1')
        b = fir1(n,Wn,ftype);
        a = [1 zeros(1,length(b)-1)];
    else
        error('unkown filter design. Options are "butter", "cheby2" and "ellip"');
    end
    
    [filteredData,state] = filter(b,a,data,state);
end