classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD405x.Base

    % AD4060 Precision ADC Class
    % 
    % adi.AD4060.Rx Receive data from the AD4060 ADC
    % The adi.AD4060.Rx System object is a signal source that can receive
    % data from the AD4060.
    %
    %   `rx = adi.AD4060.Rx;`
    %   `rx = adi.AD4060.Rx('uri','serial:COM5,230400');`
    %
    % `AD4060 Datasheet <http://www.analog.com/media/en/technical-documentation/data-sheets/AD4060.pdf>`_

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
    end

    properties (Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int32'
        phyDevName = 'ad4060'
        devName = 'ad4060'
    end

    methods
        %% Constructor

        function obj = Rx(Args)
		    arguments
                    Args.uri
            end
            coder.allowpcode('plain');
            obj = obj@adi.AD405x.Base('devName', 'ad4060', 'phyDevName', 'ad4060', 'uri', Args.uri);
        end

    end
end