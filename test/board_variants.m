function r = board_variants
% Board plugin registration file
% 1. Any registration file with this name on MATLAB path will be picked up
% 2. Registration file returns a cell array pointing to the location of
%    the board plugins
% 3. Board plugin must be a package folder accessible from MATLAB path,
%    and contains a board definition file

%   Copyright 2023 The MathWorks, Inc.

r = { ...
     'AnalogDevices.cn0585_fmcz.zed.plugin_rd_rx', ...
     'AnalogDevices.cn0585_fmcz.zed.plugin_rd_tx', ...
     'AnalogDevices.cn0585_fmcz.zed.plugin_rd_rxtx', ...
    };
end
% LocalWords:  Zynq ZC
