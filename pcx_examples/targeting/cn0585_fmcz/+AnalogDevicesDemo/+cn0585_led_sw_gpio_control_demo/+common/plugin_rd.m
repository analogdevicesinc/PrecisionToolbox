function hRD = plugin_rd(board, design)
% Reference design definition

%   Copyright 2014-2015 The MathWorks, Inc.

% pname = upper(project);
% ppath = project;
% if strcmpi(project, 'cn0585')
%     ppath = 'cn0585_fmcz';	
% end

board = 'zed';
design = 'Tx';

hRD = hdlcoder.ReferenceDesign('SynthesisTool', 'Xilinx Vivado');

% This is the base reference design that other RDs can build upon
hRD.ReferenceDesignName = sprintf('%s (%s)', upper(board), design);

% Determine the board name based on the design
hRD.BoardName = sprintf('AnalogDevices CN0585 GPIO Control');

% Tool information
hRD.SupportedToolVersion = {'2022.2'};

% Get the root directories
rootDirExample = fileparts(strtok(mfilename('fullpath'), '+'));
tmp = strsplit(rootDirExample,filesep);

if isunix
    rootDir = fullfile(filesep,tmp{1:end-3});
else
    rootDir = fullfile(tmp{1:end-3});
end
rootDirBSP = fullfile('hdl','vendor','AnalogDevices','vivado');

% Design files are shared
hRD.SharedRD = true;
hRD.SharedRDFolder = rootDir;

%% Set top level project pieces
hRD.addParameter( ...
    'ParameterID',   'project', ...
    'DisplayName',   'HDL Project Subfolder', ...
    'DefaultValue',  'cn0585_fmcz');

hRD.addParameter( ...
    'ParameterID',   'carrier', ...
    'DisplayName',   'HDL Project Carrier', ...
    'DefaultValue',  'zed');

%% Add custom design files
hRD.addCustomVivadoDesign( ...
    'CustomBlockDesignTcl', fullfile('pcx_examples', 'targeting', 'cn0585_fmcz', 'cn0585_hdl', 'system_project_rxtx.tcl'));

%% Standard reference design pieces
hRD.BlockDesignName = 'system';

% custom source files
hRD.CustomFiles = {...
    fullfile('projects')...,
    fullfile('library')...,
    fullfile('scripts')...,
    };
    
% custom source files
hRD.CustomFiles = {...
	fullfile(rootDirBSP, 'scripts')...,
	fullfile(rootDirBSP, 'library')...,
	fullfile(rootDirBSP, 'library','xilinx')...,
	fullfile(rootDirBSP, 'projects','common')...,
	fullfile(rootDirBSP, 'projects','scripts')...,
	fullfile(rootDirBSP, 'projects','cn0585_fmcz')...,
	fullfile(rootDirBSP, 'projects','cn0585_fmcz', 'common')...,
    fullfile(rootDirBSP, 'projects','cn0585_fmcz', 'zed')...,
    fullfile('pcx_examples', 'targeting', 'cn0585_fmcz', 'cn0585_hdl')...,
    };	    

hRD.addParameter( ...
    'ParameterID',   'ref_design', ...
    'DisplayName',   'Reference Type', ...
    'DefaultValue',  lower(strrep(design, ' & ','')));

hRD.addParameter( ...
    'ParameterID',   'fpga_board', ...
    'DisplayName',   'FPGA Boad', ...
    'DefaultValue',  upper(board));

hRD.addParameter( ...
    'ParameterID',   'preprocess', ...
    'DisplayName',   'Preprocess', ...
    'DefaultValue',  'on');
hRD.addParameter( ...
    'ParameterID',   'preprocess_script', ...
    'DisplayName',   'Preprocess Script', ...
    'DefaultValue',  fullfile('pcx_examples', 'targeting', 'cn0585_fmcz','cn0585_hdl','fh_preprocess.tcl'));

hRD.addParameter( ...
    'ParameterID',   'postprocess', ...
    'DisplayName',   'Postprocess', ...
    'DefaultValue',  'off');

%% Add IO
%AnalogDevices.add_io(hRD,'cn0585_led_sw_gpio_control_demo',board,design);

%% Add interfaces
% add clock interface
hRD.addClockInterface( ...
    'ClockConnection',   'axi_clkgen/clk_0', ...
    'ResetConnection',   'sampling_clk_rstgen/peripheral_aresetn');
