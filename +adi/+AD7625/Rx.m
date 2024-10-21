classdef Rx < adi.AD762x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD7625 Precision ADC Class
    % 
    % adi.AD7625.Rx Receives data from the AD7625 ADC
    % The adi.AD7625.Rx System object is a signal source that can receive
    % data from the AD7625.
    %
    %   `rx = adi.AD7625.Rx;`
    %   `rx = adi.AD7625.Rx('uri','192.168.2.1');`
    %
    % `AD7625 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/AD7625.pdf>`_

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD762x.Base('ad7625', 'ad7625', 'int16', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end
    end
end
