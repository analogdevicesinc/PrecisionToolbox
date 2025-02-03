classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD4170.Base
    % AD4170 Precision ADC Class
    % 
    % adi.AD4170.Rx Receives data from the AD4170 ADC
    % The adi.AD4170.Rx System object is a signal source that can receive
    % data from the AD4170.
    %
    %   `rx = adi.AD4170.Rx;`
    %   `rx = adi.AD4170.Rx('uri','ip:192.168.2.1');`
    %
    % `AD4170 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad4170-4.pdf>`_

    properties (Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2'...
            'voltage3'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD4170.Base('ad4170','ad4170',varargin{:});
        end
    end
    
 end
