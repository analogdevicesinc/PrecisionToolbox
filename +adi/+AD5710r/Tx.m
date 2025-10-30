classdef Tx < adi.common.Tx & matlabshared.libiio.base & adi.common.Attribute
    % AD5710r 16-bit Configurable IDAC/VDAC Class
    % adi.AD5710r.Rx Transmits data to the AD5710r DAC
    %   The adi.AD5710r.Tx System object is a signal sink that can transmit
    %   data to the AD5710r.
    %
    %   tx = adi.AD5710r.Tx;
    %   tx = adi.AD5710r.Tx('uri','ip:192.168.2.1');
    %
    %  <a href="https://www.analog.com/en/products/ad5710r.html"</a>  
    
    properties
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate = '50000'
    end

    properties
        % ChMode Channel Mode
        %   COnfigure the channel mode of the device channels. 
        %   Options are 'VMODE', 'IMODE'.
        ChMode = 'VMODE'
    end

    properties (Nontunable)
        SamplesPerFrame
    end    

    properties (Nontunable, Hidden, Constant)     
        Type = 'Tx'
    end

    properties (Constant, Hidden)
        ChModeSet = matlab.system.StringSet([ ...
            "V_MODE", "I_MODE"]);
    end

    % Channel names
    properties (Nontunable, Hidden)
       channel_names = {'voltage0', 'voltage1', 'voltage2', 'voltage3', ...
                         'voltage4', 'voltage5', 'voltage6', 'voltage7'}
    end

    properties (Hidden, Nontunable, Access = protected)
        isOutput = true
    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int16'
        phyDevName = 'ad5710r'
        devName = 'ad5710r'
    end

    properties (Hidden, Constant)
        ComplexData = false
    end

    methods

        %% Constructor
        function obj = Tx(varargin)
            obj = obj@matlabshared.libiio.base(varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.uri = 'ip:analog.local';
            obj.DataSource = 'DMA';
        end

        function set.SampleRate(obj, value)
            % Set device sampling rate
            obj.SampleRate = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sampling_frequency', num2str(value));
            end
        end

        function set.ChMode(obj, value)
            % Set channel mode
            obj.ChMode = value;
            if obj.ConnectedToDevice
                for i=1:length(obj.channel_names)
                    if (ismember(i, obj.EnabledChannels))
                        obj.setAttributeRAW(obj.channel_names{i}, 'ch_mode', num2str(value), true);
                    end
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
            obj.setDeviceAttributeRAW('sampling_frequency',num2str(obj.SampleRate))
            obj.setDeviceAttributeRAW('all_ch_operating_mode', 'normal_operation')
            for i=1:length(obj.channel_names)
                if (ismember(i, obj.EnabledChannels))
                    obj.setAttributeRAW(obj.channel_names{i}, 'ch_mode', num2str(obj.ChMode), true);
                end
            end
        end
      
    end
end