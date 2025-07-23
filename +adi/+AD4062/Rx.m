classdef Rx < adi.common.Rx & adi.common.RxTx ...
        & adi.AD405x.Base

    % AD4062 Precision ADC Class
    % 
    % adi.AD4062.Rx Receive data from the AD4062 ADC
    % The adi.AD4062.Rx System object is a signal source that can receive
    % data from the AD4062.
    %
    %   `rx = adi.AD4062.Rx;`
    %   `rx = adi.AD4062.Rx('uri','serial:COM5,230400');`
    %
    % `AD4062 Datasheet <http://www.analog.com/media/en/technical-documentation/data-sheets/AD4062.pdf>`_

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
    end

    properties (Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int32'
        phyDevName = 'ad4062'
        devName = 'ad4062'
    end

    methods
        %% Constructor

        function obj = Rx(Args)
		    arguments
                    Args.uri
            end
            coder.allowpcode('plain');
            obj = obj@adi.AD405x.Base('devName', 'ad4062', 'phyDevName', 'ad4062', 'uri', Args.uri);
        end

    end
end