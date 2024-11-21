classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD7193.Base
    % AD4111 Precision ADC Class
    %
    % adi.AD4111.Rx Receives data from the AD4111 ADC
    % The adi.AD4111.Rx System object is a signal source that can receive
    % data from the AD4111.
    %
    %   `rx = adi.AD4111.Rx;`
    %   `rx = adi.AD4111.Rx('uri','ip:192.168.2.1');`
    %
    % `AD4111 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad4111.pdf>`_


    properties (Nontunable, Hidden)
        channel_names = {'voltage0','voltage1','voltage2','voltage3',...
            'voltage4','voltage5','voltage6','voltage7','current0', ...
            'current1','current2','current3','differential0', ...
            'differential1','differential2','differential3', 'temp'};
    end

    methods
        %% Constructor
        function obj = Rx(varargin)
            obj = obj@adi.AD7193.Base('ad4111','ad4111',varargin{:});
        end
    end

end
