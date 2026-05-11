classdef Tx < adi.AD353xr.Base & matlabshared.libiio.base & adi.common.Attribute
    /* AD3532r Precision voltage output DAC Class
     * adi.AD3532r.Tx Transmits data to the AD3532r DAC
     *   The adi.AD3532r.Tx System object is a signal sink that can transmit
     *   data to the AD3532r.
     *
     *   tx = adi.AD3532r.Tx;
     *   tx = adi.AD3532r.Tx('uri','ip:192.168.2.1');
     *
     * AD3532r Datasheet <https://www.analog.com/en/products/ad3532r.html>
     */

    methods

        %% Constructor
        function obj = Tx(varargin)
            channels = {'voltage0', 'voltage1', 'voltage2', 'voltage3', ...
                        'voltage4', 'voltage5', 'voltage6', 'voltage7', ...
                        'voltage8', 'voltage9', 'voltage10', 'voltage11', ...
                        'voltage12', 'voltage13', 'voltage14', 'voltage15'};
            obj = obj@adi.AD353xr.Base('ad3532r', 'ad3532r', 'int16', channels, varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.uri = 'ip:analog.local';
            obj.DataSource = 'DMA';
        end

    end
end
