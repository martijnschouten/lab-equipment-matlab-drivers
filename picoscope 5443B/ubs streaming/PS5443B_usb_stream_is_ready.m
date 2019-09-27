function ready = PS5443B_usb_stream_is_ready(streamingGroupObj)
    ready = invoke(streamingGroupObj, 'isReady');
end

