classdef Tx < adi.AD579x.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD5781 Voltage output DAC Class
    % 
    % adi.AD5781.Tx Transmits data to the AD5781 DAC
    % The adi.AD5781.Tx System object is a signal sink that can transmit
    % data to the AD5781.
    %
    %   `tx = adi.AD5781.Tx;`
    %   `tx = adi.AD5781.Tx('uri','ip:192.168.2.1');`
    %
    % `AD5781 Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad5781.pdf>`_

      methods

        %% Constructor
        function obj = Tx(varargin)
            obj = obj@adi.AD579x.Base('ad5781', 'ad5781', 'int32', varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.uri = 'ip:analog.local';
            obj.DataSource = 'DMA';
        end

   end
end