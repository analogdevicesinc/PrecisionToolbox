classdef DemoTests < matlab.uitest.TestCase
    
    properties
        root = '';
    end
    
    methods(TestClassSetup)
        function addpaths(testCase)
            here = mfilename('fullpath');
            here = strsplit(here,'/');
            here = fullfile('/',here{1:end-2});
            testCase.root = here;
            addpath(genpath(fullfile(here,'hdl')));
        end
        function setupVivado(~)
            v=ver('matlab'); Release = v.Release;
            switch Release
                case '(R2017a)'
                    vivado = '2016.2';
                case '(R2017b)'
                    vivado = '2017.4';
                case '(R2018b)'
                    vivado = '2017.4';
                case '(R2019a)'
                    vivado = '2018.2';
                case '(R2019b)'
                    vivado = '2018.2';
                case '(R2020a)'
                    vivado = '2018.2';
                case '(R2020b)'
                    vivado = '2018.2';
                case '(R2021a)'
                    vivado = '2018.2';
                case '(R2021b)'
                    vivado = '2021.1';
		case '(R2022a)'
                    vivado = '2022.2';
            end
            if ispc
                hdlsetuptoolpath('ToolName', 'Xilinx Vivado', ...
                    'ToolPath', ['C:\Xilinx\Vivado\',vivado,'\bin\vivado.bat']);
            elseif isunix
                hdlsetuptoolpath('ToolName', 'Xilinx Vivado', ...
                    'ToolPath', ['/opt/Xilinx/Vivado/',vivado,'/bin/vivado']);
            end
            
        end
    end
    
    methods(TestMethodTeardown)
        function cleanup_hdl_prj(testCase)
            dir = fullfile(testCase.root,'test','hdl_prj');
            if exist(dir, 'dir')
                rmdir(fullfile(testCase.root,'test','hdl_prj'), 's');
            end
        end
    end
    
end

