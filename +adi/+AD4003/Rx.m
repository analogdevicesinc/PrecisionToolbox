classdef Rx < adi.AD400x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD4003 Precision ADC Class
    % adi.AD4003.Rx Receives data from the AD4003 ADC
    %   The adi.AD4003.Rx System object is a signal source that can receive
    %   data from the AD4003.
    %
    %   rx = adi.AD4003.Rx;
    %   rx = adi.AD4003.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad4003-4007-4011.pdf">AD4003 Datasheet</a>

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD400x.Base('ad4003', 'ad4003', 'int32', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end
    end
end
