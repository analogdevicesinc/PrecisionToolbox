classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD719x.Base
    % AD7192 Precision ADC Class
    % adi.AD7192.Rx Receives data from the AD7192 ADC
    %   The adi.AD7192.Rx System object is a signal source that can receive
    %   data from the AD7192.
    %
    %   `rx = adi.AD7192.Rx;`
    %   `rx = adi.AD7192.Rx('serial:COM18,230400');`
    %
    % `AD7192 DataSheet<a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad7192.pdf">`_
    
    properties (Nontunable, Hidden)
        channel_names = {'voltage0', 'voltage1','voltage2','voltage3'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD719x.Base('ad7192','ad7192',varargin{:});
        end
    end
    
 end