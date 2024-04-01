classdef Tx < adi.AD579x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD5760 Voltage output DAC Class
    % 
    % adi.AD5760.Tx Transmits data to the AD5760 DAC
    % The adi.AD5760.Tx System object is a signal sink that can transmit
    % data to the AD5760.
    %
    %   `tx = adi.AD5760.Tx;`
    %   `tx = adi.AD5760.Tx('uri','ip:192.168.2.1');`
    %
    % `AD5760 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad5760.pdf>`_

   methods

        %% Constructor
        function obj = Tx(varargin)
            obj = obj@adi.AD579x.Base('ad5760', 'ad5760', 'int16', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.uri = 'ip:analog.local';
            obj.DataSource = 'DMA';
        end

   end
end