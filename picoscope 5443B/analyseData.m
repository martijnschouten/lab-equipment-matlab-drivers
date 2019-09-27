try PS5443B_usb_stream_stop(ps5000aDeviceObj);
end
clear all
close all
instrreset

load("data22.mat")

figure
dt = (t(end)-t(1))/length(t);
use = 1:round(10/fcs/dt);
for i1 = 1:4
    subplot(4,1,i1)
    plot(t(use),data(use,i1))
end

figure
use = round(1/10*length(time)):length(time);
subplot(2,1,1)
plot(time(use),X{1}(use))
subplot(2,1,2)
plot(time(use),Y{1}(use))

