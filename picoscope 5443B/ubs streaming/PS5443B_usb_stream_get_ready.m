function status = PS5443B_usb_stream_get_ready(streamingGroupObj)
    ready = PicoConstants.FALSE;
    while (ready == PicoConstants.FALSE)

       status = invoke(streamingGroupObj, 'getStreamingLatestValues'); 
        
       ready = invoke(streamingGroupObj, 'isReady');
    end
end

