classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD719x.Base
    % AD7195 Precision ADC Class
    % adi.AD7195.Rx Receives data from the AD7195 ADC
    %   The adi.AD7195.Rx System object is a signal source that can receive
    %   data from the AD7195.
    %
    %   `rx = adi.AD7195.Rx;`
    %   `rx = adi.AD7195.Rx('serial:COM18,230400');`
    %
    % `AD7195 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7195.pdf>`_

    properties (Nontunable, Hidden)
        channel_names = {'voltage0', 'voltage1','voltage2','voltage3'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD719x.Base('ad7195','ad7195',varargin{:});
        end
    end
    
 end