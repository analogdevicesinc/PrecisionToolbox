classdef Rx <adi.common.Rx & adi.common.RxTx & ...
        adi.AD463x.Base
    % ADAQ4224 Precision Data Acquisition (DAQ) Class
    %
    % adi.ADAQ4224.Rx Receives data from the ADAQ4224
    % The adi.ADAQ4224.Rx System object is a signal source that can receive
    % data from the ADAQ4224.
    %
    %   `rx = adi.ADAQ4224.Rx;`
    %   `rx = adi.ADAQ4224.Rx('uri','ip:192.168.2.1');`
    %
    % ADAQ4224 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/adaq4224.pdf>`_

    properties
        % Scale Channel Scale Value
        Scale =  0.001464843
    end

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
    end

    properties (Hidden)
        % Number of frames or buffers of data to capture
        FrameCount = 1
    end

    properties (Nontunable, Hidden)
        % Channels present with default register settings -
        channel_names = {'voltage0'}
    end

    properties (Hidden)
        Timeout = Inf
        kernelBuffersCount = 4
        dataTypeStr = 'int64'
        phyDevName = 'adaq4224'
        devName = 'adaq4224'
    end

    methods
        %%Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD463x.Base(varargin{:});
        end

        function set.Scale(obj, value)
		% Set channel scale value
            obj.Scale = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeRAW(id, 'scale', num2str(value), false);
            end
        end

        function value = get.Scale(obj)
		% Get channel scale value
            value = obj.Scale;
            if obj.ConnectedToDevice
                value = obj.getAttributeRAW('voltage0', 'scale', false);
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
            obj.setAttributeRAW('voltage0', 'scale', num2str(obj.Scale), false);
        end
    end

end