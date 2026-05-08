classdef Base < adi.common.Tx & adi.common.RxTx & ...
         matlabshared.libiio.base & adi.common.Attribute & ...
         adi.common.RegisterReadWrite & adi.common.Channel
    % AD552xr is a family of Voltage output DAC
    % AD5529r is 16-channel 16-bit DAC

    properties(Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
         SamplesPerFrame = 400
    end

    properties
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate = '1000000'
    end

    properties (Hidden, Nontunable, Access = protected)
        isOutput = true
    end

    properties (Nontunable, Hidden, Constant)
        Type = 'Tx'
    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'uint16'
        phyDevName
        devName
    end

    properties (Hidden, Constant)
        ComplexData = false
    end

    methods

        %% Constructor
        function obj = Base(phydev, dev, dtype, varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
            obj.phyDevName = phydev;
            obj.devName = dev;
            obj.dataTypeStr = dtype;
        end

        function set.SampleRate(obj, value)
            % Set device sampling rate
            obj.SampleRate = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sampling_frequency', num2str(value));
            end
        end

        % Destructor
        function delete(obj)
            delete@adi.common.RxTx(obj);
        end
    end

    %% API Functions
    methods (Hidden, Access = protected)

        function setupInit(obj)
            % Write all attributes to device once connected through set
            % methods
            % Do writes directly to hardware without using set methods.
            % This is required since Simulink doesn't support
            % modification to nontunable variables at SetupImpl

            obj.setDeviceAttributeRAW('sampling_frequency', num2str(obj.SampleRate));
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
            bName = 'AD552xr DAC';
        end

    end
end