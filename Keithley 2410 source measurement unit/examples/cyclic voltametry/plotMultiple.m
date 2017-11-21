clear all
close all

use = [9];

figure
for i1 = 1:length(use)
    load(['data' num2str(use(i1)) '.mat']);
    plot(voltage,current)
    hold on
    charge{i1} = 0
    for i2 = 1:length(current)-1
        charge{i1}(i2+1) = charge{i1}(i2) + (current(i2+1)+current(i2))/2*(time(i2+1)-time(i2));
    end
end

figure
for i1 = 1:length(use)
    plot(voltage,charge{i1})
    hold on
end