classdef Rx < adi.AD762x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD7960 Precision ADC Class
    % 
    % adi.AD7960.Rx Receives data from the AD7960 ADC
    % The adi.AD7960.Rx System object is a signal source that can receive
    % data from the AD7960.
    %
    %   `rx = adi.AD7960.Rx;`
    %   `rx = adi.AD7960.Rx('uri','192.168.2.1');`
    %
    % `AD7960 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7960.pdf>`_

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD762x.Base('ad7960', 'ad7960', 'int32', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end
    end
end
