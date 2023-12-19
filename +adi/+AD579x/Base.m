classdef Base < adi.common.Tx & adi.common.RxTx & ...
         matlabshared.libiio.base & adi.common.Attribute & ...
         adi.common.RegisterReadWrite & adi.common.Channel
    % AD579x is a family of Voltage output DAC
    % AD5790 is single channel 20bit DAC
    % AD5791 is single channel 20bit DAC
    % AD5780 is single channel 18bit DAC
    % AD5781 is single channel 18bit DAC
    % AD5760 is single channel 16bit DAC

    properties(Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.        
         SamplesPerFrame = 400
    end

    properties
        % SampleRate Sample Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.        
        SampleRate = '80000'

        % PowerDown Power Down
        % Set to true/false to power-up/power-down the device channels
        PowerDown (1,1) logical = false

        % Raw Channel Raw Value
        Raw = '65000'

        % CodeSelect Code Select
        % Set to 2s_complement/offset_binary
        CodeSelect = '2s_complement'
    end

    % Channel names
    properties (Nontunable, Hidden)
        channel_names = {'voltage0'}
    end

    properties (Hidden, Nontunable, Access = protected)
        isOutput = true
    end

    properties (Nontunable, Hidden, Constant)
        Type = 'Tx'
    end

    properties (Nontunable, Hidden)
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr
        phyDevName
        devName
    end

    properties (Hidden, Constant)
        ComplexData = false
    end

    properties (Constant, Hidden)
        CodeSelectSet = matlab.system.StringSet([ ...
            "2s_complement", "binary_offset"]);
    end

    methods
        
        %% Constructor
        function obj = Base(phydev, dev, dtype, varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
            obj.phyDevName = phydev;
            obj.devName = dev;
            obj.dataTypeStr = dtype;
        end

        function set.SampleRate(obj, value)
            % Set device sampling rate
            obj.SampleRate = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sampling_frequency', num2str(value));
            end
        end

        function set.CodeSelect(obj, value)
            % Set code select option
            obj.CodeSelect = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setDeviceAttributeRAW(id, 'code_select', num2str(value), true)
            end
        end

        function set.PowerDown(obj, value)
            % Set channel power down value
            obj.PowerDown = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeRAW(id, 'powerdown', num2str(value), true)
            end
        end

        function set.Raw(obj, value)
             % Set channel raw value
            obj.Raw = value;
            if obj.ConnectedToDevice
                id = 'voltage0';
                obj.setAttributeRAW(id, 'raw', num2str(value), true)
            end
        end

        % Destructor
        function delete(obj)
            delete@adi.common.RxTx(obj);
        end
    end

    %% API Functions
    methods (Hidden, Access = protected)

        function setupInit(obj)
            % Write all attributes to device once connected through set
            % methods
            % Do writes directly to hardware without using set methods.
            % This is required since Simulink doesn't support
            % modification to nontunable variables at SetupImpl

            id = 'voltage0';

            obj.setDeviceAttributeRAW('sampling_frequency', num2str(obj.SampleRate));
            obj.setDeviceAttributeRAW('code_select', num2str(obj.CodeSelect));
            obj.setAttributeRAW(id, 'powerdown', num2str(obj.PowerDown), true);
            obj.setAttributeRAW(id, 'raw', num2str(obj.Raw), true);
        end

    end

    %% External Dependency Methods
    methods (Hidden, Static)

        function tf = isSupportedContext(bldCfg)
            tf = matlabshared.libiio.ExternalDependency.isSupportedContext(bldCfg);
        end

        function updateBuildInfo(buildInfo, bldCfg)
            % Call the matlabshared.libiio.method first
            matlabshared.libiio.ExternalDependency.updateBuildInfo(buildInfo, bldCfg);
        end

        function bName = getDescriptiveName(~)
            bName = 'AD579x DAC';
        end

    end
end