classdef Tx < adi.AD579x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD5780 Voltage output DAC Class
    % adi.AD5780.Tx Transmits data to the AD5780 DAC
    %   The adi.AD5780.Tx System object is a signal sink that can transmit
    %   data to the AD5780.
    %
    %   tx = adi.AD5780.Tx;
    %   tx = adi.AD5780.Tx('uri','ip:192.168.2.1');
    %
    %   <a href="https://www.analog.com/media/en/technical-documentation/data-sheets/ad5780.pdf">AD5780 Datasheet</a>

   methods

        %% Constructor
        function obj = Tx(varargin)
            obj = obj@adi.AD579x.Base('ad5780', 'ad5780', 'int32', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.uri = 'ip:analog.local';
            obj.DataSource = 'DMA';
        end

   end
end