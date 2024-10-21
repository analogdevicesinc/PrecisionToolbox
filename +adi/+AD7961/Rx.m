classdef Rx < adi.AD762x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD7961 Precision ADC Class
    % 
    % adi.AD7961.Rx Receives data from the AD7961 ADC
    % The adi.AD7961.Rx System object is a signal source that can receive
    % data from the AD7961.
    %
    %   `rx = adi.AD7961.Rx;`
    %   `rx = adi.AD7961.Rx('uri','192.168.2.1');`
    %
    % `AD7961 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad7961.pdf>`_

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD762x.Base('ad7961', 'ad7961', 'int16', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end
    end
end
