clear all
close all

multimeter = keithley_2000_init(7);

%fwrite(multimeter, ':CONF:RES');

days = 10;
tic
i1 = 1;
while(toc<days*3600*24)
    for i2 = 2:5
        time{i1,i2} = clock;
        data(i1,i2) = keithley_2000_get(multimeter,'FRES',i2);
        pause(10)
    end
    i1 = i1 + 1
end
fclose(multimeter)

load counter
save(['data',mat2str(counter),'.mat'],'data','time')
counter = counter + 1;
save('counter.mat','counter');



