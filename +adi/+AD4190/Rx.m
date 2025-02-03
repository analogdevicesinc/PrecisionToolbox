classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD4170.Base
    % AD4190 Precision ADC Class
    % 
    % adi.AD4190.Rx Receives data from the AD4190 ADC
    % The adi.AD4190.Rx System object is a signal source that can receive
    % data from the AD4190.
    %
    %   `rx = adi.AD4190.Rx;`
    %   `rx = adi.AD4190.Rx('uri','ip:192.168.2.1');`
    %
    % `AD4190 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad4190-4.pdf>`_

    properties (Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2'...
            'voltage3'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD4170.Base('ad4190','ad4190',varargin{:});
        end
    end
    
 end
