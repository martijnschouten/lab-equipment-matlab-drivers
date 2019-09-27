function [appBuffer,driverBuffer,streamingGroupObj,maxADCCount,actualSampleInterval] = PS5443B_usb_stream_init(ps5000aDeviceObj,ranges, couplings, offsets,desiredInterval, bufferSize, downSampleRatio)
%written by Martijn Schouten for questions email:
%m.schouten-1@alumnus.utwente.nl or contact me via github


%inputs
%Ranges
%   ranges is a vector containting ps5000aEnuminfo.enPS5000ARange components.
%   It is used to set the maximum voltage that can be measured.
%   possible values are:
%   PS5000A_10MV, PS5000A_20MV, PS5000A_50MV, PS5000A_100MV, PS5000A_100MV
%   PS5000A_100MV, PS5000A_200MV, PS5000A_500MV, PS5000A_1V, PS5000A_2V,
%   PS5000A_5V, PS5000A_10V, PS5000A_50V and PS5000A_MAX_RANGES

%Couplings
%   ranges is a vector containting ps5000aEnuminfo.enPS5000ACoupling components.
%   It is used to set the coupling of the oscilloscope input.
%   possible values are:
%   ps5000aEnuminfo.enPS5000ACoupling.PS5000A_AC,
%   ps5000aEnuminfo.enPS5000ACoupling.PS5000A_DC

%offsets
%   offsets is a vector containting doubles.
%   It is used to set the analog offset voltage of the oscilloscope input.

%number of channels that are enabled depend on the length of the vectors.
%If 1 channels is enabled, channel A is used, if 2 are enable and B are
%used, enz.

%before running this function you must run:
%PS5000aConfig;

channels = length(ranges);
if channels > 4
    error("The scope has only 4 channels, so requesting more as 4 channels doesn't make any sense")
end

%% Load configuration information
PS5000aConfig;
%% Parameter definitions
% Define any parameters that might be required throughout the script.

channelA = ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_A;
channelB = ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_B;
channelC = ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_C;
channelD = ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_D;
channelList = {channelA, channelB, channelC, channelD};


%% Channel setup
% All channels are enabled by default - if the device is a 4-channel scope,
% switch off channels C and D so device can be set to 15-bit resolution.

for i1 = 1:channels
    channelSettings(i1).enabled = PicoConstants.TRUE;
    channelSettings(i1).coupling = couplings(i1);
    channelSettings(i1).range = ranges(i1);
    channelSettings(i1).analogueOffset = offsets(i1);
end

for i1 = channels+1:4
    channelSettings(i1).enabled = PicoConstants.FALSE;
    channelSettings(i1).coupling = ps5000aEnuminfo.enPS5000ACoupling.PS5000A_DC;
    channelSettings(i1).range = ps5000aEnuminfo.enPS5000ARange.PS5000A_2V;
    channelSettings(i1).analogueOffset = 0.0;
end

[status.currentPowerSource] = invoke(ps5000aDeviceObj, 'ps5000aCurrentPowerSource');
% Check if the power supply is connected - channels C and D will not be
% enabled on a 4-channel oscilloscope if it is only USB powered.
if (status.currentPowerSource == PicoStatus.PICO_POWER_SUPPLY_NOT_CONNECTED)&&(channels>2)
    error("you need to use the external power supply when you are using more than 2 channels")
end

%set channel configuration
for i1 = 1:4
    status.setChannelStatus(i1) = invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ...
        (i1 - 1), channelSettings(i1).enabled, ...
        channelSettings(i1).coupling, channelSettings(i1).range, ...
        channelSettings(i1).analogueOffset);
end



%% Change resolution
% The maximum resolution will depend on the number of channels enabled.

% Set resolution to 15 bits as 2 channels will be enabled.
if channels == 1
    [status.setResolution, resolution] = invoke(ps5000aDeviceObj, 'ps5000aSetDeviceResolution', 16);
elseif channels == 2
    [status.setResolution, resolution] = invoke(ps5000aDeviceObj, 'ps5000aSetDeviceResolution', 15);
else  
    [status.setResolution, resolution] = invoke(ps5000aDeviceObj, 'ps5000aSetDeviceResolution', 14);
end

% Obtain the maximum Analog Digital Converter (ADC) count value from the
% driver - this is used for scaling values returned from the driver when
% data is collected. This value may change depending on the resolution
% selected.
maxADCCount = get(ps5000aDeviceObj, 'maxADCValue');

%% Set simple trigger
% Set a trigger on channel A, with an auto timeout - the default value for
% delay is used. The device will wait for a rising edge through
% the specified threshold unless the timeout occurs first.

% Trigger properties and functions are located in the Instrument
% Driver's Trigger group.

%triggerGroupObj = get(ps5000aDeviceObj, 'Trigger');
%triggerGroupObj = triggerGroupObj(1);

% Set the |autoTriggerMs| property in order to automatically trigger the
% oscilloscope after 1 second if a trigger event has not occurred. Set to 0
% to wait indefinitely for a trigger event.

%set(triggerGroupObj, 'autoTriggerMs', 1000);

% Channel     : 0 (ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_A)
% Threshold   : 500 mV
% Direction   : 2 (ps5000aEnuminfo.enPS5000AThresholdDirection.PS5000A_RISING)

%[status.setSimpleTrigger] = invoke(triggerGroupObj, 'setSimpleTrigger', 0, 500, 2);

%% Set data buffers
% Data buffers for channels A and B - buffers should be set with the driver,
% and these *MUST* be passed with application buffers to the wrapper driver.
% This will ensure that data is correctly copied from the driver buffers
% for later processing.

segmentIndex        = 0;   
ratioMode           = ps5000aEnuminfo.enPS5000ARatioMode.PS5000A_RATIO_MODE_AVERAGE;

% Buffers to be passed to the driver
for i1 = 1:channels
    driverBuffer{i1} = libpointer('int16Ptr', zeros(bufferSize, 1, 'int16'));
    invoke(ps5000aDeviceObj, 'ps5000aSetDataBuffer', ...
    channelList{i1}, driverBuffer{i1}, bufferSize, segmentIndex, ratioMode);
end

% Application Buffers - these are for copying from the driver into.
for i1 = 1:channels
    appBuffer{i1} = libpointer('int16Ptr', zeros(bufferSize, 1, 'int16'));
end

% Streaming properties and functions are located in the Instrument Driver's
% Streaming group.

streamingGroupObj = get(ps5000aDeviceObj, 'Streaming');
streamingGroupObj = streamingGroupObj(1);

%appDriverBuffers = {status.setAppDriverBuffersA,status.setAppDriverBuffersB,status.setAppDriverBuffersC,status.setAppDriverBuffersD};

for i1 = 1:channels
   appDriverBufferStatus{i1} = invoke(streamingGroupObj, 'setAppAndDriverBuffers', channelList{i1}, ...
        appBuffer{i1}, driverBuffer{i1}, bufferSize);
end


%% Start streaming and collect data
% Use default value for streaming interval which is 1e-6 for 1 MS/s.
% Collect data for 5 seconds with auto stop - maximum array size will depend
% on the PC's resources - type <matlab:doc('memory') |memory|> at the
% MATLAB command prompt for further information.
%
% To change the sample interval set the |streamingInterval| property of the
% Streaming group object. The call to the |ps5000aRunStreaming()| function
% will output the actual sampling interval used by the driver.

% To change the sample interval e.g 5 us for 200 kS/s
set(streamingGroupObj, 'streamingInterval', desiredInterval);

%%
% Set the number of pre- and post-trigger samples.
% If no trigger is set the library will still store
% |numPreTriggerSamples| + |numPostTriggerSamples|.
%set(ps5000aDeviceObj, 'numPreTriggerSamples', 0);
%set(ps5000aDeviceObj, 'numPostTriggerSamples', 100000000);

%%
% The |autoStop| parameter can be set to false (0) to allow for continuous
% data collection.
set(streamingGroupObj, 'autoStop', PicoConstants.FALSE);

% Set other streaming parameters
downSampleRatioMode = ps5000aEnuminfo.enPS5000ARatioMode.PS5000A_RATIO_MODE_AVERAGE;

%%
% Defined buffers to store data collected from the channels. If capturing
% data without using the autoStop flag, or if using a trigger with the
% autoStop flag, allocate sufficient space (1.5 times the sum of the number
% of pre-trigger and post-trigger samples is shown below) to allow for
% additional pre-trigger data. Pre-allocating the array is more efficient
% than using <matlab:doc('vertcat') |vertcat|> to combine data.

%maxSamples = get(ps5000aDeviceObj, 'numPreTriggerSamples') + ...
%    get(ps5000aDeviceObj, 'numPostTriggerSamples');

% Start streaming data collection.
[status.runStreaming, tempSampleInterval, sampleIntervalTimeUnitsStr] = ...
    invoke(streamingGroupObj, 'ps5000aRunStreaming', downSampleRatio, ...
    downSampleRatioMode, bufferSize);



if strcmp(sampleIntervalTimeUnitsStr,'ns')
    actualSampleInterval = double(tempSampleInterval)*1e-9;
elseif strcmp(sampleIntervalTimeUnitsStr,'us')
    actualSampleInterval = double(tempSampleInterval)*1e-6;
elseif strcmp(sampleIntervalTimeUnitsStr,'ms')
    actualSampleInterval = double(tempSampleInterval)*1e-3;
elseif strcmp(sampleIntervalTimeUnitsStr,'s')
    actualSampleInterval = double(tempSampleInterval);
else
    error('unkown sample interval time unit string')
end
disp('Streaming data...');

% Variables to be used when collecting the data:



status.getStreamingLatestValuesStatus = PicoStatus.PICO_OK; % OK

% Plot Properties - these are for displaying data as it is collected.
end

