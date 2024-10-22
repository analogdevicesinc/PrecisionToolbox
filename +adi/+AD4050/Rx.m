classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD405x.Base

    % AD4050 Precision ADC Class
    %
    % adi.AD4050.Rx Receive data from the AD4050 ADC
    % The adi.AD4050.Rx System object is a signal source that can receive
    % data from the AD4050.
    %
    %   `rx = adi.AD4050.Rx;`
    %   `rx = adi.AD4050.Rx('uri','serial:COM28,230400');`
    %
    % `AD4050 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad4050-ad4056.pdf>`_

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
    end

    properties (Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int32'
        phyDevName = 'ad4050'
        devName = 'ad4050'
    end

    methods
        %% Constructor

        function obj = Rx(Args)
		    arguments
                    Args.uri
            end
            coder.allowpcode('plain');
            obj = obj@adi.AD405x.Base('devName', 'ad4050', 'phyDevName', 'ad4050', 'uri', Args.uri);
        end

    end
end