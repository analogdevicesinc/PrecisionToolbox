classdef instr_m2k < handle
    
    properties
        DAC_available_sample_rates = [750, 7500, 75000, 750000, 7500000, 75000000];
        DAC_max_rate
        DAC_min_nr_of_points = 10;
        max_buffer_size = 500000;
        ADC_available_sample_rates = [1000, 10000, 100000, 1000000, 10000000, 100000000];
        ADC_max_rate
        ADC_min_nr_of_points = 10;
    end

    methods
        function [best_ratio, best_fract] = get_best_ratio(obj, ratio)
            max_it = obj.max_buffer_size / ratio;
            best_ratio = ratio;
            best_fract = 1;

            for i = 1 : fix(max_it)
                new_ratio = i * ratio;
                % (new_fract, integral) = math.modf(new_ratio)
                new_fract = mod(abs(new_ratio),1);
                % integral = fix(new_ratio);
                if new_fract < best_fract
                    best_fract = new_fract;
                    best_ratio = new_ratio;
                end
                if new_fract == 0
                    break
                end
            end
        end

        function size = get_samples_count(obj, rate, freq, mode)
            ratio = rate / freq;
            if mode == "DAC"
                min_nr_of_points = obj.DAC_min_nr_of_points;
                max_rate = obj.DAC_max_rate;
            elseif mode == "ADC"
                min_nr_of_points = obj.ADC_min_nr_of_points;
                max_rate = obj.ADC_max_rate;
            end
    
            if ratio < min_nr_of_points && rate < max_rate
                size = 0;
                return
            end
            if ratio < 2
                size = 0;
                return
            end
        
            [ratio, fract] = obj.get_best_ratio(ratio);
            % ratio = number of periods in buffer
            % fract = what is left over - error
        
            size = fix(ratio);
            while bitand(size, uint16(0x03))
                size = size * 2; % double instead of python <<
            end
            while size < 1024
                size = size * 2; % double instead of python <<
            end
        end

        function rate = get_optimal_sample_rate(obj, freq, mode)
            if mode == "DAC"
                available_sample_rates = obj.DAC_available_sample_rates;
            elseif mode == "ADC"
                available_sample_rates = obj.ADC_available_sample_rates;
            end
        
            for rate = available_sample_rates
                buf_size = obj.get_samples_count(rate, freq, mode);
                if buf_size
                    break
                end
            end
        end
    
        function [sample_rate, buf] = sine_buffer_generator(obj, freq, ampl, offset, phase)
            sample_rate = obj.get_optimal_sample_rate(freq, "DAC");
            nr_of_samples = obj.get_samples_count(sample_rate, freq, "DAC");
            samples_per_period = sample_rate / freq;
            phase_in_samples = (phase / 360) * samples_per_period;
        
            buf = zeros(1,nr_of_samples);

            for i = 1:nr_of_samples
                buf(i) = (...
                    offset ...
                    + ampl ...
                    * (sin(((i + phase_in_samples) / samples_per_period) * 2 * pi)) ...
                );
            end
        end
    end


    methods
        % Constructor
        function obj = instr_m2k()
            obj.DAC_max_rate = obj.DAC_available_sample_rates(end);  % last sample rate = max rate
            obj.ADC_max_rate = obj.ADC_available_sample_rates(end);  % last sample rate = max rate
        end

        function m2k = connect(obj, uri, calibrate)
            import clib.libm2k.libm2k.*
            m2k = context.m2kOpen(uri);
            if clibIsNull(m2k)
                clib.libm2k.libm2k.context.contextCloseAll(uri);
                m2k = context.m2kOpen();
            end
            if isempty(m2k)
                error('M2K device not found');
            end
            if calibrate
                m2k.calibrateDAC();
                m2k.calibrateADC();
            end
        end

        % function m2k = calibrate()
        % end

        function instr = create_instr(obj, ctx, instrument)
            % Method to create instrument object from ctx
            if instrument == "siggen"
                instr = ctx.getAnalogOut();
            elseif instrument == "specanalyzer" | instrument == "voltmeter"
                instr = ctx.getAnalogIn();
            elseif instrument == "powersupply"
                instr = ctx.getPowerSupply();
            end
        end       

        function retval = control(obj, instr, chan, control_param)
            % Generic control method for any instrument
            %   instr - instrument object
            %   chan - ADC or DAC channel, 0 or 1 only
            %   control_param - a list containing control parameters
            %       siggen - [tone_frequency,ampl,offset,phase]
            % TODO: implement other instruments
            % control_param should be treated as varargin

            if isa(instr, 'clib.libm2k.libm2k.analog.M2kAnalogOut') && length(control_param) == 4
                % Generates sinewave at chan
                % Known issue - signal generated at one channel appears at the other
                control_param = num2cell(control_param);
                [tone_frequency, ampl, offset, phase] = control_param{:};
                [samp, buf] = obj.sine_buffer_generator(tone_frequency, ampl, offset, phase);
                instr.enableChannel(chan, true);
                instr.setSampleRate(chan, samp);
                instr.push(chan, buf);
                retval = 1;
            end
        end

        function contextClose(obj)
            import clib.libm2k.libm2k.*
            clib.libm2k.libm2k.context.contextCloseAll();
        end

        function delete(obj, m2k)
            vars = who;
            for i = 1 : length(vars)
                if contains(class(eval(vars{i})),'clib.libm2k.libm2k.analog')
                    evalin('base', "clear " + string(vars{1})); 
                end
            end
        end

    end
end