classdef Base < adi.common.Tx & adi.common.RxTx & ...
         matlabshared.libiio.base & adi.common.Attribute & ...
         adi.common.RegisterReadWrite & adi.common.Channel
    /* AD353xr is a family of precision voltage output DACs
     * AD3530r is 8-channel 16-bit DAC
     * AD3532r is 16-channel 16-bit DAC
     */

    properties(Nontunable)
        /* SamplesPerFrame Samples Per Frame
         *   Number of samples per frame, specified as an even positive
         *   integer.
         */
         SamplesPerFrame = 400
    end

    properties
        /* SamplingFrequency Sampling Frequency
         *   Baseband sampling rate in Hz, specified as a scalar
         *   in samples per second.
         */
        SamplingFrequency = '1000000'

        /* AllChOperatingMode All Channel Operating Mode
         * Set operating mode for all channels
         * Options: normal_operation, powerdown_1k, powerdown_100k, tristate
         */
        AllChOperatingMode = 'normal_operation'
    end

    /* Channel names */
    properties (Nontunable, Hidden)
        channel_names
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
        AllChOperatingModeSet = matlab.system.StringSet([ ...
            "normal_operation", "1kohm_to_gnd", "7.7kohm_to_gnd", "32kohm_to_gnd"]);
    end

    methods

        %% Constructor
        function obj = Base(phydev, dev, dtype, channels, varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
            obj.phyDevName = phydev;
            obj.devName = dev;
            obj.dataTypeStr = dtype;
            obj.channel_names = channels;
        end

        function set.SamplingFrequency(obj, value)
            /* Set device sampling frequency */
            obj.SamplingFrequency = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sampling_frequency', num2str(value));
            end
        end

        function set.AllChOperatingMode(obj, value)
            /* Set all channel operating mode */
            obj.AllChOperatingMode = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('all_ch_operating_mode', num2str(value));
            end
        end

        /* Destructor */
        function delete(obj)
            delete@adi.common.RxTx(obj);
        end
    end

    %% API Functions
    methods (Hidden, Access = protected)

        function setupInit(obj)
            /* Write all attributes to device once connected through set
             * methods
             * Do writes directly to hardware without using set methods.
             * This is required since Simulink doesn't support
             * modification to nontunable variables at SetupImpl
             */

            obj.setDeviceAttributeRAW('sampling_frequency', num2str(obj.SamplingFrequency));
            obj.setDeviceAttributeRAW('all_ch_operating_mode', num2str(obj.AllChOperatingMode));
        end

    end

    %% External Dependency Methods
    methods (Hidden, Static)

        function tf = isSupportedContext(bldCfg)
            tf = matlabshared.libiio.ExternalDependency.isSupportedContext(bldCfg);
        end

        function updateBuildInfo(buildInfo, bldCfg)
            /* Call the matlabshared.libiio.method first */
            matlabshared.libiio.ExternalDependency.updateBuildInfo(buildInfo, bldCfg);
        end

        function bName = getDescriptiveName(~)
            bName = 'AD353xr DAC';
        end

    end
end
