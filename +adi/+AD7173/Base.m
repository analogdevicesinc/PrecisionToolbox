classdef Base < adi.common.Rx & adi.common.RxTx & ...
         matlabshared.libiio.base & adi.common.Attribute & ...
         adi.common.RegisterReadWrite & adi.common.Channel
    % AD7193 Precision ADC Class
    % AD4111 is a 12 channel ADC with temperature/voltage/differential/current inputs

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate = '19200'

        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 400
    end

    % isOutput
    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int32'
        phyDevName
        devName
    end

    properties (Hidden, Constant)
        ComplexData = false
    end

    methods
    %% Constructor
        function obj = Base(phydev,dev,varargin)
            coder.allowpcode('plain');
            % Initialize the Rx object
            obj = obj@matlabshared.libiio.base(varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
            obj.phyDevName = phydev;
            obj.devName = dev;
            obj.uri = 'ip:analog.local';
        end

        function flush(obj)
            % Flush the buffer
            flushBuffers(obj);
        end

        function delete(obj)
            % Destructor
            delete@adi.common.RxTx(obj);
        end

        function set.SampleRate(obj, value)
            % Set device sampling rate
            obj.SampleRate = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sampling_frequency', value);
            end
        end

        %% Check Voltage Scale
        function rValue = get.VoltageScale(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('voltage0', 'scale', obj.isOutput);
            else
                rValue = NaN;
            end
        end

        %% Check Voltage Offset
        function rValue = get.VoltageOffset(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('voltage0', 'offset', obj.isOutput);
            else
                rValue = NaN;
            end
        end

        %% Check Current Scale
        function rValue = get.CurrentScale(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('current0', 'scale', obj.isOutput);
            else
                rValue = NaN;
            end
        end

        %% Check Current Offset
        function rValue = get.CurrentOffset(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('current0', 'offset', obj.isOutput);
            else
                rValue = NaN;
            end
        end

        %% Check Temperature Scale
        function rValue = get.TemperatureScale(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('temp', 'scale', obj.isOutput);
            else
                rValue = NaN;
            end
        end

        %% Check Temperature Offset
        function rValue = get.TemperatureOffset(obj)
            if obj.ConnectedToDevice
                rValue = obj.getAttributeDouble('temp', 'offset', obj.isOutput);
            else
                rValue = NaN;
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
            obj.setDeviceAttributeRAW('sampling_frequency',num2str(obj.SampleRate));
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
            bName = 'AD7193 ADC';
        end
    end

end
