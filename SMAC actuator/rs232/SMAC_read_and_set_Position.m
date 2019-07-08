function [position,force] = SMAC_read_and_set_Position(actuator,position)

if abs(position) <= 10000 
    fprintf(actuator, ['32 W 0x00607A ' num2str(int32(position),'%3.0d')]);%set position
else
    error('position is out of range')
end
fprintf(actuator, '32 R 0X006064');%read position
fprintf(actuator, '32 R 0X006077');%read force

position = strsplit(fgets(actuator),' ');
position = str2double(position(end));
force = strsplit(fgets(actuator), ' ');
force = str2double(force(end));
