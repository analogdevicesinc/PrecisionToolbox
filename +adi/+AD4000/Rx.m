classdef Rx < adi.AD400x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD4000 Precision ADC Class
    % adi.AD4000.Rx Receives data from the AD4000 ADC
    %   The adi.AD4000.Rx System object is a signal source that can receive
    %   data from the AD4000.
    %
    %   rx = adi.AD4000.Rx;
    %   rx = adi.AD4000.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad4000-4004-4008.pdf">AD4000 Datasheet</a>

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD400x.Base('ad4000', 'ad4000', 'int16', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end
    end
end
