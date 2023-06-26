function add_clocks(hRD,project,design)

switch lower(project)
    case 'cn0585'
        switch(upper(design))
            case 'RX'
                hRD.addClockInterface( ...
                    'ClockConnection',   'axi_clkgen/clk_0', ...
                    'ResetConnection',   'sampling_clk_rstgen/peripheral_aresetn');

            case 'TX'
                hRD.addClockInterface( ...
                    'ClockConnection',   'axi_clkgen/clk_0', ...
                    'ResetConnection',   'sampling_clk_rstgen/peripheral_aresetn');
            case 'RX & TX'
                hRD.addClockInterface( ...
                    'ClockConnection',   'axi_clkgen/clk_0', ...
                    'ResetConnection',   'sampling_clk_rstgen/peripheral_aresetn');
            otherwise
                error('Unknown reference design');
        end
end
