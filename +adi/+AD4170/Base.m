classdef Base < adi.common.Rx & adi.common.RxTx & ...
         matlabshared.libiio.base & adi.common.Attribute & ...
         adi.common.RegisterReadWrite & adi.common.Channel
    % AD4170/AD4190 Precision ADC Class
    % AD4190 is 8 channel ADC
    % AD4170 is a 8 channel ADC with additional filter configurations and other added features

    properties (Nontunable)
        % Fs for configuring the sampling rate of the device.
        % It supports a numeric value. Please refer to the DS
        % for more details on configuring FS.
        % Fs = 1 corresponds to 500ksps with the sinc5 filter
        Fs = 1

        % AdcMode ADC Mode
        % ADC Mode for data capture, represented as a string.
        % It supports the following: 'Continuous_Conversion',
        % 'Continuous_Conversion_FIR', 'Continuous_Conversion_IIR',
        % 'Standby', 'Power_Down', 'Idle'
        AdcMode = 'Continuous_Conversion'

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

        function set.AdcMode(obj, value)
            % Set device ADC Mode
            obj.AdcMode = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('adc_mode', value);
            end
        end

        function set.Fs(obj, value)
            % Set device Fs
            obj.Fs = value;
            if obj.ConnectedToDevice
                 for ch=1:length(obj.channel_names)
                    obj.setAttributeRAW(obj.channel_names{ch}, 'fs', value, false, obj.iioDev);
                 end
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
            obj.setDeviceAttributeRAW('adc_mode',num2str(obj.AdcMode));
            for ch=1:length(obj.channel_names)
                obj.setAttributeRAW(obj.channel_names{ch}, 'fs', num2str(obj.Fs), false, obj.iioDev, false);
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
            bName = 'AD4170 ADC';
        end
    end
    
end