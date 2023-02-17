classdef Base < adi.common.Rx & adi.common.RxTx & ...
         matlabshared.libiio.base & adi.common.Attribute & adi.common.RegisterReadWrite & adi.common.Channel
    % AD463x is a family of Precision ADC
    % AD4630-16 is dual channel 16bit SAR ADC with max sampling frequency
    % of 2MSPS
    % AD4630-24 is dual channel 24bit SAR ADC with max sampling frequency 2MSPS
    % AD4030-24 is single channel version of AD4630-24

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate = '1000000'
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 2^15

        % SampleAveragingLength
        %   Block length of samples to be averaged. Applied in the Averaging Mode register only when
        %   OUT_DATA_MD is set to 30-bit averaged differential mode
        SampleAveragingLength = '2'
    end

    properties (Abstract, Nontunable, Hidden)
        channel_names
    end

    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Abstract, Nontunable, Hidden)
        Timeout
        kernelBuffersCount
        dataTypeStr
        phyDevName
        devName
    end

    properties (Hidden, Constant, Abstract)
        Type
    end

    properties (Hidden, Constant)
        ComplexData = false
        SampleAveragingLengthSet = matlab.system.StringSet({ ...
                                                            '2', '4', '8', '16', '32', '64', '128', '256', '512', '1024', '2048', '4096', '8192', '16384', '32768', '65536'})
    end

    methods

        %% Constructor
        function obj = Base(varargin)
            obj = obj@matlabshared.libiio.base(varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;

            % Check if uri has been specified, else throw an error
            uriFound = 0;
            for i = 1:length(varargin)
                if isequal(varargin{i}, 'uri')
                    if i == length(varargin)
                        break
                    else
                        uriArgIndex = find(contains([varargin{:}], 'uri'));
                        obj.uri = varargin{uriArgIndex + 1};
                        uriFound = 1;
                    end
                end
            end
            if uriFound == 0
                error("Error. \nUri was not supplied. Supply it in the following manner \n    %s", "adi.ADXXXX.Rx('uri', <insert uri>)");
            end

            % Connects to device temporarily and fetches the channel names
            obj.setup();
            release(obj);
        end

        function set.SamplesPerFrame(obj, value)
            validateattributes(value, { 'double', 'single', 'uint32' }, ...
                               { 'real', 'positive', 'scalar', 'finite', 'nonnan', 'nonempty', 'integer', '>', 0, '<', 2^20 + 1}, ...
                               '', 'SamplesPerFrame');
            obj.SamplesPerFrame = value;
        end

        function set.SampleAveragingLength(obj, value)
            validateattributes(value, { 'char', 'string'}, ...
                               {}, ...
                               '', 'SampleAveragingLength');
            obj.SampleAveragingLength = value;

        end

        function flush(obj)
            flushBuffers(obj);
        end

        function delete(obj)
            delete@adi.common.RxTx(obj);
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
            % This is required sine Simulink support doesn't support
            % modification to nontunable variables at SetupImpl
            obj.setDeviceAttributeRAW('sampling_frequency', num2str(obj.SampleRate));
            if obj.getRegister('0x20')  == 67  % Check if the current out-data-mode is 30bit averaging
                obj.setDeviceAttributeRAW('sample_averaging', obj.SampleAveragingLength);
            end

            obj.set_channel_names();

        end

        function set_channel_names(obj)
            obj.channel_names = {};
            phydev = getDev(obj, obj.devName);
            chanCount = obj.iio_device_get_channels_count(phydev);
            for c = 1:chanCount
                chanPtr = obj.iio_device_get_channel(phydev, c - 1);
                obj.channel_names{end + 1} = obj.iio_channel_get_name(chanPtr);
            end
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
                        dataRAW(:, obj.SamplesPerFrame * (count - 1) + 1:count * obj.SamplesPerFrame) = data_i;
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
                        chanPtr = getChan(obj, obj.iioDev, obj.channel_names{obj.EnabledChannels(l + 1)}, false);
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
                    dataRAW = zeros([length(obj.EnabledChannels) obj.SamplesPerFrame * capCount]);
                    for count = 1:capCount
                        [data_i, valid] = getData(obj);
                        dataRAW(:, obj.SamplesPerFrame * (count - 1) + 1:count * obj.SamplesPerFrame) = data_i;
                    end
                    data = dataRAW.';
                end
            end
        end

    end

    %% External Dependency Methods
    methods (Hidden, Static)

        function tf = isSupportedContext(bldCfg)
            tf = matlabshared.libiio.ExternalDependency.isSupportedContext(bldCfg);
        end

        function updateBuildInfo(buildInfo, bldCfg)
            % Call the matlabshared.libiio.method first
            matlabshared.libiio.ExternalDependency.updateBuildInfo(buildInfo, bldCfg);
        end

        function bName = getDescriptiveName(~)
            bName = 'AD463x Precision ADC';
        end

    end
end
