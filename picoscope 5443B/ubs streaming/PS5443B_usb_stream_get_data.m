function [Buffer,appBuffer] = PS5443B_usb_stream_get_data(streamingGroupObj, appBuffer,scopeRanges, maxADCCount)
channels = length(scopeRanges);

[newSamples, startIndex] = invoke(streamingGroupObj, 'availableData');

% Printing to console can slow down acquisition - use for
% demonstration.
%fprintf('Collected %d samples, startIndex: %d.\n', newSamples, startIndex, startIndex);

% Position indices of data in the buffer(s).
firstValuePosn = startIndex + 1;
lastValuePosn = startIndex + newSamples;

% Convert data values to millivolts from the application buffer(s).
for i1 = 1:channels
    channelRangeMV = PicoConstants.SCOPE_INPUT_RANGES(scopeRanges(i1) + 1);
    Buffer{i1} = adc2mv(appBuffer{i1}.Value(firstValuePosn:lastValuePosn),channelRangeMV , maxADCCount)/1000;
end



