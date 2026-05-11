classdef Tx < adi.AD353xr.Base & matlabshared.libiio.base & adi.common.Attribute
    /* AD3530r Precision voltage output DAC Class
     * adi.AD3530r.Tx Transmits data to the AD3530r DAC
     *   The adi.AD3530r.Tx System object is a signal sink that can transmit
     *   data to the AD3530r.
     *
     *   tx = adi.AD3530r.Tx;
     *   tx = adi.AD3530r.Tx('uri','ip:192.168.2.1');
     *
     * AD3530r Datasheet <https://www.analog.com/en/products/ad3530r.html>
     */

    methods

        %% Constructor
        function obj = Tx(varargin)
            channels = {'voltage0', 'voltage1', 'voltage2', 'voltage3', ...
                        'voltage4', 'voltage5', 'voltage6', 'voltage7'};
            obj = obj@adi.AD353xr.Base('ad3530r', 'ad3530r', 'int16', channels, varargin{:});
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.uri = 'ip:analog.local';
            obj.DataSource = 'DMA';
        end

    end
end
