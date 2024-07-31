classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD719x.Base
    % AD7193 Precision ADC Class
    % adi.AD7193.Rx Receives data from the AD7193 ADC
    %   The adi.AD7193.Rx System object is a signal source that can receive
    %   data from the AD7193.
    %
    %   `rx = adi.AD7193.Rx;`
    %   `rx = adi.AD7193.Rx('serial:COM18,230400');`
    %
    % `AD7193 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7193.pdf>`_

    properties (Nontunable, Hidden)
        channel_names = {'voltage0', 'voltage1','voltage2','voltage3','voltage4','voltage5','voltage6','voltage7'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD719x.Base('ad7193','ad7193',varargin{:});
        end
    end
    
 end

  