clear all
close all

multimeter = keithley_2000_init(7);

%fwrite(multimeter, ':CONF:RES');

days = 1/24/3600*60;
tic
i1 = 1;
while(toc<days*3600*24)
    for i2 = 6:10
        time{i1,i2} = clock;
        data(i1,i2) = keithley_2000_get(multimeter,'RES',i2);
        pause(10)
    end
    i1 = i1 + 1
end
fclose(multimeter)

load counter
save(['data',mat2str(counter),'.mat'],'data','time')
counter = counter + 1;
save('counter.mat','counter');



