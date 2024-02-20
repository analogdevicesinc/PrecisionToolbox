classdef Rx < adi.AD400x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD4010 Precision ADC Class
    % adi.AD4010.Rx Receives data from the AD4010 ADC
    %   The adi.AD4010.Rx System object is a signal source that can receive
    %   data from the AD4010.
    %
    %   rx = adi.AD4010.Rx;
    %   rx = adi.AD4010.Rx('uri','192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad4002-4006-4010.pdf">AD4010 Datasheet</a>

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD400x.Base('ad4010', 'ad4010', 'int32', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end
    end
end
