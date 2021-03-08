function [position,force] = SMAC_read_and_set_Force(actuator,force)
if abs(force) <= 1000
    if force ~= 0
        fprintf(actuator,['32 W 0x006071 ' num2str(int32(force),'%3.0d')])
    else
        fprintf(actuator,['32 W 0x006071 ' num2str(0)])
    end
else
    error('force is out of range')
end
fprintf(actuator, '32 R 0X006064');%read position
fprintf(actuator, '32 R 0X006077');%read force
position = strsplit(fgets(actuator),' ');
position = str2double(position(end));
force = strsplit(fgets(actuator), ' ');
force = str2double(force(end));
