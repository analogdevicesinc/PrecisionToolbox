function hB = plugin_board(BoardName)
% Use Plugin API to create board plugin object

%   Copyright 2015 The MathWorks, Inc.

hB = hdlcoder.Board;

% Target Board Information
hB.BoardName    = sprintf('AnalogDevices CN0585 GPIO Control');

% FPGA Device
hB.FPGAVendor   = 'Xilinx';
hB.FPGAFamily   = 'Zynq';

% Determine the device based on the board

hB.FPGADevice   = sprintf('xc7%s', 'z020');
hB.FPGAPackage  = 'clg484';
hB.FPGASpeed    = '-1';
hB.FPGAFamily   = 'Zynq';

% Tool Info
hB.SupportedTool = {'Xilinx Vivado'};

% FPGA JTAG chain position
hB.JTAGChainPosition = 2;

%% Add interfaces
% Standard "External Port" interface
