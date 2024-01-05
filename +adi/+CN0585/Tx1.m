classdef Tx1 < adi.AD3552R.Tx & adi.CN0585.Base
    % adi.CN0585.Tx Transmit data from the AD3552R evaluation platform
    %
    %   tx1 = adi.CN0585.Tx1;
    %   tx1 = adi.CN0585.Tx1('uri','192.168.2.1');
    %
    %   <a href="https://wiki.analog.com/resources/eval/user-guides/circuits-from-the-lab/cn0585">User Guide</a>
    %
    %   See also adi.AD3552R.Tx1

    methods
        %% Constructor
        function obj = Tx1(varargin)
            % Returns the matlabshared.libiio.base object
            coder.allowpcode('plain');
            obj = obj@adi.AD3552R.Tx(varargin{:});
            obj.devName = 'axi-ad3552r-1';
            obj.phyDevName = 'axi-ad3552r-1';
        end
    end

end
