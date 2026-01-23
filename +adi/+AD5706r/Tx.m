classdef Tx < adi.common.Tx & matlabshared.libiio.base & adi.common.Attribute
    % AD5706r Precision current output DAC Class
    % adi.AD5706r.Rx Transmits data to the AD5706r DAC
    %   The adi.AD5706r.Tx System object is a signal sink that can transmit
    %   data to the AD5706r.
    %
    %   `tx = adi.AD5706.Tx;`
    %   `tx = adi.AD5706.Tx('uri','ip:192.168.2.1');`
    %
    %  TODO: Add link to the data sheet  
    
    properties
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SampleRate
    end

    properties (Nontunable)
    % Samples per frame
        SamplesPerFrame
    end    

    properties (Nontunable, Hidden, Constant)     
        Type = 'Tx'
    end

    % Channel names
    properties (Nontunable, Hidden)
       channel_names = {'current0'}
    end

    properties (Hidden, Nontunable, Access = protected)
        isOutput = true
    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int16'
        phyDevName = 'ad5706r'
        devName = 'ad5706r'
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
        end
      
    end
end