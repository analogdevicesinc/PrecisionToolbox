classdef Tx < adi.AD579x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD5791 Voltage output DAC Class
    % adi.AD5791.Tx Transmits data to the AD5791 DAC
    %   The adi.AD5791.Tx System object is a signal sink that can transmit
    %   data to the AD5791.
    %
    %   tx = adi.AD5791.Tx;
    %   tx = adi.AD5791.Tx('uri','ip:192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad5791.pdf">AD5791 Datasheet</a>

   methods

        %% Constructor
        function obj = Tx(varargin)
            obj = obj@adi.AD579x.Base('ad5791', 'ad5791', 'int32', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.uri = 'ip:analog.local';
            obj.DataSource = 'DMA';
        end

   end
end