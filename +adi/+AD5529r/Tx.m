classdef Tx < adi.AD552xr.Base & matlabshared.libiio.base & adi.common.Attribute
    % AD5529r Precision voltage output DAC Class
    % adi.AD5529r.Tx Transmits data to the AD5529r DAC
    %   The adi.AD5529r.Tx System object is a signal sink that can transmit
    %   data to the AD5529r.
    %
    %   `tx = adi.AD5529r.Tx;`
    %   `tx = adi.AD5529r.Tx('uri','ip:192.168.2.1');`
    %
    %  `AD5529r Datasheet <https://www.analog.com/media/en/technical-documentation/data-sheets/ad5529r.pdf>`_

    % Channel names
    properties (Nontunable, Hidden)
        channel_names = {'voltage0', 'voltage1', 'voltage2', 'voltage3', ...
                         'voltage4', 'voltage5', 'voltage6', 'voltage7', ...
                         'voltage8', 'voltage9', 'voltage10', 'voltage11', ...
                         'voltage12', 'voltage13', 'voltage14', 'voltage15'}
    end

    methods

        %% Constructor
        function obj = Tx(varargin)
            obj = obj@adi.AD552xr.Base('ad5529r', 'ad5529r', 'uint16', varargin{:});
            obj.enableExplicitPolling = false;
            obj.uri = 'ip:analog.local';
            obj.DataSource = 'DMA';
        end

    end
end