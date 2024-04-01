classdef Rx < adi.AD400x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD4007 Precision ADC Class
    % 
    % adi.AD4007.Rx Receives data from the AD4007 ADC
    % The adi.AD4007.Rx System object is a signal source that can receive
    % data from the AD4007.
    %
    %   `rx = adi.AD4007.Rx;`
    %   `rx = adi.AD4007.Rx('uri','192.168.2.1');`
    %
    % `AD4007 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad4003-4007-4011.pdf>`_

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD400x.Base('ad4007', 'ad4007', 'int32', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;
        end
    end
end
