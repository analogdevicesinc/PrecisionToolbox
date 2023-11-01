classdef Rx < adi.common.Rx & matlabshared.libiio.base & ...
        adi.common.Attribute & adi.common.DeviceAttribute & adi.common.Channel
    % Generic Precision ADC Class
    % adi.Generic.Rx Receives data from the connected ADC
    %   The adi.Generic.Rx System object is a signal source that can receive
    %   data from any generic ADI precision ADC.
    %
    %   rx = adi.Generic.Rx('adxxxx', 'ip:analog.local');
    %

    properties
        % DeviceAttributeNames Device Attribute Names
        %   Array of device IIO attribute names as defined in the
        %   driver/firmware, and queried from the hardware
        %   at initialization time
        DeviceAttributeNames

        % ChannelAttributeNames Device Attribute Names
        %   Array of channel IIO attribute names as defined in the
        %   driver/firmware, and queried from the hardware
        %   at initialization time
        ChannelAttributeNames
    end

    properties (Nontunable)
        % SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer.
        SamplesPerFrame = 1024
    end

    properties (Nontunable, Hidden)
        channel_names = {'voltage0'}
        Timeout = Inf
        kernelBuffersCount = 1
        dataTypeStr = 'int32'
        phyDevName = 'adxxxx'
        devName = 'adxxxx'
    end

    properties (Nontunable, Hidden, Constant)
        Type = 'Rx'
        ComplexData = false
    end

    properties (Hidden, Nontunable, Access = protected)
        isOutput = false
    end

    properties(Hidden, Access = protected)
        cachedAttrWrites = {}
    end

    methods

        %% Constructor
        function obj = Rx(Args)
            arguments
                Args.devName
                Args.phyDevName
                Args.uri
            end
            
            obj = obj@matlabshared.libiio.base();
            obj.enableExplicitPolling = false;
            obj.EnabledChannels = 1;
            obj.BufferTypeConversionEnable = true;

            % Set device name, phyDevName, uri from input arguments
            try
                obj.devName = Args.devName;
                obj.phyDevName = Args.phyDevName;
                obj.uri = Args.uri;
            catch
                e = MException('MATLAB:notEnoughInputs',['Not enough input ' ...
                    'arguments. Specify devName, phyDevName and uri']);
                throw(e)
            end

            % Determine datatype using trial and error
            possibleDataTypeStr = {'int8', 'int16', 'int32', 'int64'};
            for k = 1:length(possibleDataTypeStr)
                try
                    obj.dataTypeStr = possibleDataTypeStr{k};
                    obj.setup();
                    break;
                catch
                end
            end
            assert(obj.ConnectedToDevice == 1, "Connection could not be established with the specified device")

            % Check is the platform is running ADI Kuiper Linux.
            % Presence of 'local,kernel' context attribute would
            % indicate usage of Linux platform
            isLinuxPLatform = false;
            try
                obj.iio_context_get_attr_value(obj.iioCtx, 'local,kernel');
                isLinuxPLatform = true;
            catch
            end            

            release(obj);

            % If platform is running ADI Kuiper Linux, kernelBuffersCount
            % can be increased
            if isLinuxPLatform
                obj.kernelBuffersCount = 4;
                disp("Detected ADI Kuiper Linux platform. Changing buffer count to 4..")
            end

        end

        function flush(obj)
            % Flush the buffer contents
            flushBuffers(obj);
        end

        function SetDeviceAttrValue(obj, attr, val)
            % Apply the device attribute value when device is
            % connected
            %   rx.SetDeviceAttrValue('sampling_frequency', '1000000')
            obj.cachedAttrWrites{end+1} = {attr, val};
        end

        
        function val = GetDeviceAttrValue(obj, attr)  
            % Fetch the device attribute value if device is
            % connected.
            %   rx.GetDeviceAttrValue('sampling_frequency')
            if obj.ConnectedToDevice
                val = obj.getDeviceAttributeRAW(attr, 128);
            end
        end

        function SetChannelAttrValue(obj, chnID, attr, val)
            % Apply the channel attribute value when device is
            % connected. To write to the first channel attribute use
            %   rx.SetChannelAttrValue('voltage0', 'scale', '2') or
            %   rx.SetChannelAttrValue(1, 'scale', '2')
            if isnumeric(chnID)
                chnID = obj.channel_names(chanID);
            end
            obj.cachedAttrWrites{end+1} = {chnID, attr, val};
        end

        function val = GetChannelAttrValue(obj, chnID, attr)
            % Fetch the channel attribute value if device is
            % connected. To get the first channel attribute value, use
            %   rx.GetChannelAttrValue('voltage0', 'scale') or
            %   rx.GetChannelAttrValue(1, 'scale')
            if obj.ConnectedToDevice
                if isnumeric(chnID)
                    chnID = obj.channel_names(chanID);
                end
                val = obj.getAttributeRAW(attr, chnID, obj.isOutput);
            end
        end

    end

    %% API Functions
    methods (Hidden, Access = protected)

        function setupInit(obj)
           
            % Write all attributes to device once connected through set
            % methods
            % Do writes directly to hardware without using set methods.
            % This is required since Simulink support doesn't support
            % modification to nontunable variables at SetupImpl

            %Fetch all the attributes and channel names
            if ~isempty(obj.channel_names)
                obj.fetch_channel_names();
            end
            
            if isempty(obj.DeviceAttributeNames)
                obj.fetch_device_attributes();
            end
            
            if isempty(obj.ChannelAttributeNames)
                obj.fetch_channel_attributes();
            end

            % Apply attribute settings in hardware
            if ~isempty(obj.cachedAttrWrites)
                for i = 1:length(obj.cachedAttrWrites)
                    if length(obj.cachedAttrWrites{i}) == 2
                        % Apply device attribute
                        attr = obj.cachedAttrWrites{i}{1};
                        val = obj.cachedAttrWrites{i}{2};
                        obj.setDeviceAttributeRAW(attr, val);
                    elseif length(obj.cachedAttrWrites{i}) == 3
                        % Apply channel attribute
                        chan = obj.cachedAttrWrites{i}{1};
                        attr = obj.cachedAttrWrites{i}{2};
                        val = obj.cachedAttrWrites{i}{3};
                        obj.setAttributeRAW(chan, attr, val, obj.isOutput);
                    end
                end
            end

            obj.cachedAttrWrites = {};

        end

        function fetch_channel_names(obj)
            % Update the channel names
            obj.channel_names = {};
            phydev = getDev(obj, obj.devName);
            chanCount = obj.iio_device_get_channels_count(phydev);
            for c = 1:chanCount
                chanPtr = obj.iio_device_get_channel(phydev, c - 1);
                obj.channel_names{end + 1} = obj.iio_channel_get_name(chanPtr);
            end
        end

        function fetch_device_attributes(obj)
            % Store the attribute names
            devPtr = obj.getDev(obj.phyDevName);
            devAttrCnt = obj.iio_device_get_attrs_count(devPtr);
            for i=1:devAttrCnt
                obj.DeviceAttributeNames{end+1} = obj.iio_device_get_attr(devPtr, i-1);
            end
        end

        function fetch_channel_attributes(obj)
            % Store channel attribute names, if there's channels present
            devPtr = obj.getDev(obj.phyDevName);         

            if ~isempty(obj.channel_names)
                % Fetch first channel
                chanPtr = calllib(obj.libName, 'iio_device_get_channel', devPtr, 0);

                % Fetch count of channel attributes
                chanAttrCnt = obj.iio_channel_get_attrs_count(chanPtr);
                
                % Fetch each attribute for the channel
                for j=1:chanAttrCnt
                    obj.ChannelAttributeNames{j} = obj.iio_channel_get_attr(chanPtr, j-1);
                end
            end

        end

      
    end
end
