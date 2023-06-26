classdef (Abstract) Base < ...
        adi.common.RxTx & ...
        matlabshared.libiio.base & ...
        adi.common.Attribute
    % adi.AD3552R.Tx Transmit data to the AD3552R high speed DAC
    %   The adi.AD3552R.Tx System object is a signal source that can send
    %   complex data from the AD3552R.
    %
    %   tx = adi.AD3552R.Tx;
    %   tx = adi.AD3552R.Tx('uri','192.168.2.1');
    %
    %   <a href="http://www.analog.com/media/en/technical-documentation/data-sheets/AD3552R.pdf">AD3552R Datasheet</a>
    %
    %   See also adi.CN0585.Tx
    
    properties (Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer from 2 to 16,777,216. Using values less than 3660 can
        %   yield poor performance.
        SamplesPerFrame = 2 ^ 15;
    end

    properties (Nontunable, Hidden)
        Timeout = Inf;
        kernelBuffersCount = 2;
        dataTypeStr = 'uint16';
    end

    properties (Abstract, Hidden, Constant)
        Type
    end

    properties (Hidden, Constant)
        ComplexData = false;
    end

    properties
        % InputSource
        %  Lists all the available input sources of the DAC.
        %  Options are: 'adc_input', 'dma_input', 'ramp_input'.
        %  Example: InputSource = 'dma_input';
        InputSource = 'dma_input';
    end

    properties
         % OutputRange
         %  Lists all the available voltage ranges of the output signal.
         %  Options are: '0/2.5V', '0/5V', '0/10V', '-5/+5V', '-10/+10V'.
         %  Example: OutputRange = '-10/+10V';
         OutputRange = '-10/+10V';
     end

    properties
        InputSourceSet = matlab.system.StringSet({...
						  'adc_input', 'dma_input', 'ramp_input'})
        OutputRangeSet = matlab.system.StringSet({...
						  '0/2.5V', '0/5V', '0/10V', '-5/+5V', '-10/+10V'})
    end

    methods
        %% Constructor
        function obj = Base(varargin)
            % Returns the matlabshared.libiio.base object
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
        end

        % Check SamplesPerFrame
        function set.SamplesPerFrame(obj, value)
            validateattributes(value, {'double', 'single'}, ...
                {'real', 'positive', 'scalar', 'finite', 'nonnan', 'nonempty', 'integer', '>', 0, '<', 2 ^ 20 + 1}, ...
                '', 'SamplesPerFrame');
            obj.SamplesPerFrame = value;
        end

        % Set/Get Input Source
        function result = get.InputSource(obj)
            result = obj.InputSource;
        end

        function set.InputSource(obj, value)
            obj.InputSource = value;
        end

        % Set/Get Output Range
        function result = get.OutputRange(obj)
            result = obj.OutputRange;
        end

        function set.OutputRange(obj, value)
            obj.OutputRange = value;
        end

    end

    %% API Functions
    methods (Hidden, Access = protected)

        function icon = getIconImpl(obj)
            icon = sprintf(['AD3552R', obj.Type]);
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
            bName = 'AD3552R';
        end

    end

end
