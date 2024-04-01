classdef Rx < adi.AD400x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD4008 Precision ADC Class
    % 
    % adi.AD4008.Rx Receives data from the AD4008 ADC
    % The adi.AD4008.Rx System object is a signal source that can receive
    % data from the AD4008.
    %
    %   `rx = adi.AD4008.Rx;`
    %   `rx = adi.AD4008.Rx('uri','192.168.2.1');`
    %
    % `AD4008 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad4000-4004-4008.pdf>`_

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD400x.Base('ad4008', 'ad4008', 'int16', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end
    end
end
