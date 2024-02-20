classdef Rx < adi.AD400x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD4001 Precision ADC Class
    % adi.AD4001.Rx Receives data from the AD4001 ADC
    %   The adi.AD4001.Rx System object is a signal source that can receive
    %   data from the AD4001.
    %
    %   rx = adi.AD4001.Rx;
    %   rx = adi.AD4001.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad4001-4005.pdf">AD4001 Datasheet</a>

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD400x.Base('ad4001', 'ad4001', 'int32', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end
    end
end
