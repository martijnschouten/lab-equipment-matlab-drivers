To control the SMAC actuator via matlab use the following procedure;

1. Power the SMAC actuator driver using a power supply with a sufficiently powerfull lab power supply at (24V,2A)
2. Start SMAC control centre (https://www.smac-mca.nl/Software.htm)
3. Connect to the SMAC actuator in SMAC control center
4. Run Macro number 0
5. Disconnect the SMAC actuator in SMAC control center
6. Connect to the SMAC actuator using the matlab function SMAC_init
7. To read out the current position and force of the actuator and set a new target force use SMAC_read_and_set_Force function
8. Disconnect the SMAC actuator using fclose