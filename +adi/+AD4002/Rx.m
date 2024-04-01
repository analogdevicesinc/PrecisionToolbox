classdef Rx < adi.AD400x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD4002 Precision ADC Class
    % 
    % adi.AD4002.Rx Receives data from the AD4002 ADC
    % The adi.AD4002.Rx System object is a signal source that can receive
    % data from the AD4002.
    %
    %   `rx = adi.AD4002.Rx;`
    %   `rx = adi.AD4002.Rx('uri','192.168.2.1');`
    %
    % `AD4002 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad4002-4006-4010.pdf>`_

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD400x.Base('ad4002', 'ad4002', 'int32', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end
    end
end
