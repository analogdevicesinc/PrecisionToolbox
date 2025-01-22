classdef Version
    % Version
    %   BSP Version information
    properties (Constant)
        Vivado = getenv('req_vivado_v')
        MATLAB = getenv('req_matlab_v') 
        Release = '21.2.1'
        AppName = 'Analog Devices, Inc. Precision Toolbox'
        ToolboxName = 'PrecisionToolbox'
        ToolboxNameShort = 'pcx'
        ExamplesDir = 'examples'
        HasHDL = false
    end

    methods
    end
end
