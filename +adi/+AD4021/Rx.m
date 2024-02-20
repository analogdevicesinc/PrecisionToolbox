classdef Rx < adi.AD400x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD4021 Precision ADC Class
    % adi.AD4021.Rx Receives data from the AD4021 ADC
    %   The adi.AD4021.Rx System object is a signal source that can receive
    %   data from the AD4021.
    %
    %   rx = adi.AD4021.Rx;
    %   rx = adi.AD4021.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad4020-4021-4022.pdf">AD4021 Datasheet</a>

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD400x.Base('ad4021', 'ad4021', 'int32', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end
    end
end
