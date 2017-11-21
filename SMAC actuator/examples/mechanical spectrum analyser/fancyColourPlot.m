function fancyColourPlot(xdata,ydata,time,timeLabel)
    z = zeros(1,length(time));
    surface([xdata;xdata],[ydata;ydata],[z;z],[time;time],...
        'facecol','no',...
        'edgecol','interp');
    c = colorbar;
    c.Label.String = timeLabel;