classdef Tx < adi.common.Tx & matlabshared.libiio.base & adi.common.Attribute
    % AD3530r Precision voltage output DAC Class
    % adi.AD3530r.Rx Transmits data to the AD3530r DAC
    %   The adi.AD3530r.Tx System object is a signal sink that can transmit
    %   data to the AD3530r.
    %
    %   tx = adi.AD3530r.Tx;
    %   tx = adi.AD3530r.Tx('uri','ip:192.168.2.1');
    %
    %  TODO: Add link to the data sheet  
    
    properties
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate
    end

    properties (Nontunable)
        SamplesPerFrame
    end    

    properties (Nontunable, Hidden, Constant)     
        Type = 'Tx'
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
        phyDevName = 'ad3530r'
        devName = 'ad3530r'
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
        end
      
    end
end