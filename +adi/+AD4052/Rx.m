classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD405x.Base

    % AD4052 Precision ADC Class
    % 
    % adi.AD4052.Rx Receive data from the AD4052 ADC
    % The adi.AD4052.Rx System object is a signal source that can receive
    % data from the AD4052.
    %
    %   `rx = adi.AD4052.Rx;`
    %   `rx = adi.AD4052.Rx('uri','serial:COM5,230400');`
    %
    % `AD4052 Datasheet <http://www.analog.com/media/en/technical-documentation/data-sheets/AD4052.pdf>`_

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
    end

    properties (Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int32'
        phyDevName = 'ad4052'
        devName = 'ad4052'
    end

    methods
        %% Constructor

        function obj = Rx(Args)
		    arguments
                    Args.uri
            end
            coder.allowpcode('plain');
            obj = obj@adi.AD405x.Base('devName', 'ad4052', 'phyDevName', 'ad4052', 'uri', Args.uri);
        end

    end
end