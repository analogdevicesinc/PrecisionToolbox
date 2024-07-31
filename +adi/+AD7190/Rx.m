classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD719x.Base
    % AD7190 Precision ADC Class
    % adi.AD7190.Rx Receives data from the AD7190 ADC
    %   The adi.AD7190.Rx System object is a signal source that can receive
    %   data from the AD7190.
    %
    %   `rx = adi.AD7190.Rx;`
    %   `rx = adi.AD7190.Rx('serial:COM18,230400');`
    %
    %   `AD7190 DataSheet<a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad7190.pdf">`_

    properties (Nontunable, Hidden)
        channel_names = {'voltage0', 'voltage1','voltage2','voltage3'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD719x.Base('ad7190','ad7190',varargin{:});
        end
    end
    
 end