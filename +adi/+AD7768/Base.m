classdef (Abstract, Hidden = true) Base < ...
        adi.common.RxTx & ...
        adi.common.Attribute & ...
        adi.common.DebugAttribute & ...
        matlabshared.libiio.base & ...
        adi.common.Rx

    properties (Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer from 2 to 16,777,216. Using values less than 3660 can
        %   yield poor performance.
        SamplesPerFrame = 2^15
    end

    properties (Abstract)
        % SamplingRate Sampling Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   from 65105 to 61.44e6 samples per second.
        SampleRate

    end

    properties (Abstract, Nontunable, Hidden)
        Timeout
        kernelBuffersCount
        dataTypeStr
        phyDevName
        devName
    end

    properties (Hidden, Constant)
        ComplexData = false
    end

    methods

        %% Constructor
        function obj = Base(varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
        end

        % Destructor
        function delete(obj)
            delete@adi.common.RxTx(obj);
        end

        % Check SamplesPerFrame
        function set.SamplesPerFrame(obj, value)
            validateattributes(value, { 'double', 'single', 'uint32'}, ...
                               { 'real', 'positive', 'scalar', 'finite', ...
                               'nonnan', 'nonempty', 'integer', '>', 0, '<=', 2^20}, ...
                               '', 'SamplesPerFrame');
            obj.SamplesPerFrame = value;
        end

    end

    %% API Functions
    methods (Hidden, Access = protected)

        function icon = getIconImpl(obj)
            icon = sprintf(['AD7768 ', obj.Type]);
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
            bName = 'AD7768';
        end

    end
end
