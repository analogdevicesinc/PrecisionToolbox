function hRD = plugin_rd
% Reference design definition

%   Copyright 2014-2015 The MathWorks, Inc.

% Call the common reference design definition function
hRD = AnalogDevicesDemo.cn0585_led_sw_gpio_control_demo.common.plugin_rd('AnalogDevies CN0585 GPIO Control', 'Tx');
AnalogDevicesDemo.cn0585_led_sw_gpio_control_demo.zed.tx.add_tx_io(hRD);
