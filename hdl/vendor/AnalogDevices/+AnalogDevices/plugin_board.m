function hB = plugin_board(project, board)
% Use Plugin API to create board plugin object

if nargin < 2
    board = "";
end    
hB = hdlcoder.Board;

pname = project;

% Target Board Information
hB.BoardName    = sprintf('AnalogDevices %s', upper(pname));
if nargin > 1
    hB.BoardName    = sprintf('%s %s', hB.BoardName, upper(board));
end

% FPGA Device
hB.FPGAVendor   = 'Xilinx';

% Determine the device based on the board
switch lower(project)

    case {'cn0585'}
        switch(upper(board))
            case 'ZED'
                hB.FPGADevice   = sprintf('xc7%s', 'z020');
                hB.FPGAPackage  = 'clg484';
                hB.FPGASpeed    = '-1';
                hB.FPGAFamily   = 'Zynq';
        end

end

% Tool Info
hB.SupportedTool = {'Xilinx Vivado'};

% FPGA JTAG chain position
hB.JTAGChainPosition = 2;

%% Add interfaces
% Standard "External Port" interface

