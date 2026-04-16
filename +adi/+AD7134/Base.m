classdef Base < adi.common.Rx & adi.common.RxTx & ...
         matlabshared.libiio.base & adi.common.Attribute & ...
         adi.common.RegisterReadWrite & adi.common.Channel
    % AD7134 Precision ADC Base Class
    % AD7134 is a 4-channel, 16-bit precision ADC
    % AD4134 is a 4-channel, 16-bit precision ADC

    properties (Nontunable)
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate = '500000'

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
        dataTypeStr = 'uint16'
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
    end

    %% API Functions
    methods (Hidden, Access = protected)
        function setupInit(obj)
            % Write all attributes to device once connected through set
            % methods
            % Do writes directly to hardware without using set methods.
            % This is required since Simulink support doesn't support
            % modification to nontunable variables at SetupImpl
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
            bName = 'AD7134 ADC';
        end
    end
    
end
