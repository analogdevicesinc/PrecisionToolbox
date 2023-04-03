classdef (Abstract) Base < matlabshared.libiio.base & adi.common.Attribute &...
        adi.common.DeviceAttribute & adi.common.Channel & adi.common.Rx
    %BASE Base class for all the converter classes
    %   Does common stuff like call matlabshared
    %   Has a default setup implementation... that can be overridden. 
    
    properties 
        kernelBuffersCount = 1 
        FrameCount = 1
    end

    properties (Abstract)
        channel_names
    end
    
    methods
        function obj = Base(varargin)
            obj = obj@matlabshared.libiio.base();
        end
        
    

        function fetch_channel_names(obj)
            obj.channel_names = {};
            phydev = getDev(obj, obj.devName);
            chanCount = obj.iio_device_get_channels_count(phydev);
            for c = 1:chanCount                
                chanPtr = obj.iio_device_get_channel(phydev, c);
                obj.channel_names{end + 1} = obj.iio_channel_get_id(chanPtr);
            end
        end
    end

    methods (Hidden, Access = protected)

        function setupInit(obj)        
            xmlString = calllib(obj.libName, 'iio_context_get_xml', obj.iioCtx);
            if ~contains(xmlString, "no-OS")
                % It is a Linux platform that MATLAB is talking to. 
                disp("Changed kernel buffer count to 4")
                obj.kernelBuffersCount = 4;
            end   

            obj.setupExtra();
        end

        

        function [data, valid] = stepImpl(obj)
            % [data,valid] = rx() returns data received from the radio
            % hardware associated with the receiver System object, rx.
            % The output 'valid' indicates whether the object has received
            % data from the radio hardware. The first valid data frame can
            % contain transient values, resulting in packets containing
            % undefined data.
            %
            % The output 'data' will be an [NxM] vector where N is
            % 'SamplesPerFrame' and M is the number of elements in
            % 'EnabledChannels'. 'data' will be complex if the devices
            % assumes complex data operations.

            % Get the data

            capCount = obj.FrameCount;

            if obj.ComplexData
                kd = 1;
                ce = length(obj.EnabledChannels);
                [dataRAW, valid] = getData(obj);
                data = complex(zeros(obj.SamplesPerFrame, ce));
                for k = 1:ce
                    data(:, k) = complex(dataRAW(kd, :), dataRAW(kd + 1, :)).';
                    kd = kd + 2;
                end
            else
                if obj.BufferTypeConversionEnable

                    dataRAW = zeros([length(obj.EnabledChannels) ...
                        obj.SamplesPerFrame * capCount]);
                    for count = 1:capCount
                        [data_i, valid] = getData(obj);
                        % dataRAW = cat(2, dataRAW, data_i);

                        dataRAW(:, obj.SamplesPerFrame * (count - 1) + ...
                            1:count * obj.SamplesPerFrame) = data_i;
                    end
                    disp("Finished grabbing data. Processing it now...");
                    % Channels must be in columns or pointer math fails
                    dataRAW = dataRAW.';
                    [D1, D2] = size(dataRAW);
                    data = coder.nullcopy(zeros(D1, D2, obj.dataTypeStr));
                    dataPtr = libpointer(obj.ptrTypeStr, data);
                    dataRAWPtr = libpointer(obj.ptrTypeStr, dataRAW);
                    % Convert hardware format to human format channel by
                    % channel
                    for l = 0:D2 - 1
                        chanPtr = getChan(obj, obj.iioDev, ...
                            obj.channel_names{obj.EnabledChannels(l + 1)}, false);
                        % Pull out column
                        tmpPtrSrc = dataRAWPtr + D1 * l;
                        tmpPtrDst = dataPtr + D1 * l;
                        setdatatype(tmpPtrSrc, obj.ptrTypeStr, D1, 1);
                        setdatatype(tmpPtrDst, obj.ptrTypeStr, D1, 1);
                        for k = 0:D1 - 1
                            iio_channel_convert(obj, chanPtr, tmpPtrDst + k, tmpPtrSrc + k);
                        end
                    end
                    data = dataPtr.Value;
                else
                    dataRAW = zeros([length(obj.EnabledChannels) ...
                        obj.SamplesPerFrame * capCount]);
                    for count = 1:capCount
                        [data_i, valid] = getData(obj);
                        % dataRAW = cat(2, dataRAW, data_i);

                        dataRAW(:, obj.SamplesPerFrame * (count - 1) + ...
                            1:count * obj.SamplesPerFrame) = data_i;
                    end

                    data = dataRAW.';
                end
            end
        end
    end

    methods(Abstract)
        setupExtra(obj)
        
    end

end

