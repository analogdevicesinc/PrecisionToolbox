function out = hdlworkflow_cn0585_gpio_zed_tx(vivado)

if nargin < 1
	vivado = '2022.2';
end

%--------------------------------------------------------------------------
% HDL Workflow Script
% Generated with MATLAB 9.8 (R2020a) at 12:56:00 on 24/09/2020
% This script was generated using the following parameter values:
%     Filename  : '/tmp/hsx-add-boot-bin-test/test/hdlworkflow_daq2_zcu102_rx.m'
%     Overwrite : true
%     Comments  : true
%     Headers   : true
%     DUT       : 'testModel_Rx64Tx64/HDL_DUT'
% To view changes after modifying the workflow, run the following command:
% >> hWC.export('DUT','testModel_Rx64Tx64/HDL_DUT');
%--------------------------------------------------------------------------

%% Load the Model
load_system('testModel_Tx16and8');

%% Restore the Model to default HDL parameters
hdlrestoreparams('testModel_Tx16and8/HDL_DUT');

%% Model HDL Parameters
%% Set Model 'testModel_Rx64Tx64' HDL parameters
hdlset_param('testModel_Tx16and8', 'HDLSubsystem', 'testModel_Tx16and8/HDL_DUT');
hdlset_param('testModel_Tx16and8', 'ReferenceDesign', 'AnalogDevies CN0585 GPIO Control (TX)');
hdlset_param('testModel_Tx16and8', 'SynthesisTool', 'Xilinx Vivado');
hdlset_param('testModel_Tx16and8', 'SynthesisToolChipFamily', 'Zynq');
hdlset_param('testModel_Tx16and8', 'SynthesisToolDeviceName', 'xc7z020-clg484-1');
hdlset_param('testModel_Tx16and8', 'SynthesisToolPackageName', '');
hdlset_param('testModel_Tx16and8', 'SynthesisToolSpeedValue', '');
hdlset_param('testModel_Tx16and8', 'TargetDirectory', 'hdl_prj/hdlsrc');
hdlset_param('testModel_Tx16and8', 'TargetLanguage', 'Verilog');
hdlset_param('testModel_Tx16and8', 'TargetPlatform', 'AnalogDevices CN0585 GPIO Control');
hdlset_param('testModel_Tx16and8', 'Workflow', 'IP Core Generation');
