classdef Base < adi.common.Rx & matlabshared.libiio.base & adi.common.Attribute
    % AD738X Family Precision ADC Class
    %

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second. Options are:
        %   '256000','128000','64000','32000','16000','8000','4000',
        %   '2000','1000'
        SampleRate = '4000000'
        SamplesPerFrame = 1024
    end

    properties (Hidden)
        % Number of frames or buffers of data to capture
        FrameCount = 1
    end

    % Channel names
    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
    end

    % isOutput
    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Constant, Hidden)
        SampleRateSet = matlab.system.StringSet({'4000000', '256000', '128000', '64000', ...
            '32000', '16000', '8000', '4000', '2000', '1000'})

    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        dataTypeStr = 'int16'
    end

    properties (Hidden, Constant)
        ComplexData = false
    end

    methods

        %% Constructor
        function obj = Base(varargin)
            obj = obj@matlabshared.libiio.base(varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
            obj.uri = 'ip:analog.local';
        end

        function flush(obj)
            flushBuffers(obj);
        end

        % Check SamplingRate
        function set.SampleRate(obj, value)
            obj.SampleRate = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sampling_frequency', value);
            end
        end

    end

    %% API Functions
    methods (Hidden, Access = protected)

        function setupInit(obj)
            % Write all attributes to device once connected through set
            % methods
            % Do writes directly to hardware without using set methods.
            % This is required since Simulink support doesn't support
            % modification to nontunable variables at SetupImpl

            % obj.setDeviceAttributeRAW('sampling_frequency',num2str(obj.SampleRate));

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

                    dataRAW = zeros([length(obj.EnabledChannels) obj.SamplesPerFrame * capCount]);
                    for count = 1:capCount
                        [data_i, valid] = getData(obj);
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
                        dataRAW(:, obj.SamplesPerFrame * (count - 1) + ...
                            1 : count * obj.SamplesPerFrame) = data_i;
                    end

                    data = dataRAW.';
                end
            end
        end

    end
end
