proc preprocess_bd {project carrier rxtx} {

    puts "Preprocessing $project $carrier $rxtx"

    switch $project {
        cn0585_fmcz {
            # Disconnect the ADC PACK pins
            delete_bd_objs [get_bd_nets axi_ltc2387_0_adc_data]
	        delete_bd_objs [get_bd_nets axi_ltc2387_1_adc_data]
	        delete_bd_objs [get_bd_nets axi_ltc2387_2_adc_data]
	        delete_bd_objs [get_bd_nets axi_ltc2387_3_adc_data]

            set sys_cstring "matlab $rxtx"
            sysid_gen_sys_init_file $sys_cstring

            # Disconnect adc_valid
            delete_bd_objs [get_bd_nets axi_ltc2387_0_adc_valid]
            # Reconnect the adc_valid in the system
            connect_bd_net [get_bd_pins axi_ltc2387_0/adc_valid] [get_bd_pins axi_ltc2387_dma/fifo_wr_en]

           if {$rxtx == "rx"} {
	         connect_bd_net [get_bd_pins axi_ltc2387_0/adc_data] [get_bd_pins axi_ad3552r_0/data_in_a]
             connect_bd_net [get_bd_pins axi_ltc2387_1/adc_data] [get_bd_pins axi_ad3552r_0/data_in_b]
             connect_bd_net [get_bd_pins axi_ltc2387_2/adc_data] [get_bd_pins axi_ad3552r_1/data_in_a]
             connect_bd_net [get_bd_pins axi_ltc2387_3/adc_data] [get_bd_pins axi_ad3552r_1/data_in_b]
           }

           if {$rxtx == "tx"} {
	         connect_bd_net [get_bd_pins axi_ltc2387_0/adc_data] [get_bd_pins util_ltc2387_adc_pack/fifo_wr_data_0]
             connect_bd_net [get_bd_pins axi_ltc2387_1/adc_data] [get_bd_pins util_ltc2387_adc_pack/fifo_wr_data_1]
             connect_bd_net [get_bd_pins axi_ltc2387_2/adc_data] [get_bd_pins util_ltc2387_adc_pack/fifo_wr_data_2]
             connect_bd_net [get_bd_pins axi_ltc2387_3/adc_data] [get_bd_pins util_ltc2387_adc_pack/fifo_wr_data_3]
             connect_bd_net [get_bd_pins axi_ltc2387_0/adc_valid] [get_bd_pins util_ltc2387_adc_pack/fifo_wr_en]
           }

	   if {$rxtx == "tx" || $rxtx == "rxtx"} {

            delete_bd_objs [get_bd_nets axi_ltc2387_0_adc_valid]
            delete_bd_objs [get_bd_nets axi_ltc2387_1_adc_valid]
            delete_bd_objs [get_bd_nets axi_ltc2387_2_adc_valid]
            delete_bd_objs [get_bd_nets axi_ltc2387_3_adc_valid]

            # Connect dac valids together
            connect_bd_net [get_bd_pins axi_ad3552r_0/valid_in_a] [get_bd_pins axi_ad3552r_0/valid_in_b]
            connect_bd_net [get_bd_pins axi_ad3552r_0/valid_in_a] [get_bd_pins axi_ad3552r_1/valid_in_a]
            connect_bd_net [get_bd_pins axi_ad3552r_0/valid_in_a] [get_bd_pins axi_ad3552r_1/valid_in_b]

            # Remove the gpio bd connections
            delete_bd_objs [get_bd_nets gpio_i_1]
            delete_bd_objs [get_bd_nets sys_ps7_GPIO_O]
            # Split the input gpios into 3 to separate the switches
            create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
            set_property -dict [list \
              CONFIG.DIN_FROM {63} \
              CONFIG.DIN_TO {19} \
              CONFIG.DIN_WIDTH {64} \
              CONFIG.DOUT_WIDTH {45} \
            ] [get_bd_cells xlslice_0]
            create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1
            set_property -dict [list \
              CONFIG.DIN_FROM {18} \
              CONFIG.DIN_TO {11} \
              CONFIG.DIN_WIDTH {64} \
              CONFIG.DOUT_WIDTH {8} \
            ] [get_bd_cells xlslice_1]
            create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2
            set_property -dict [list \
              CONFIG.DIN_FROM {10} \
              CONFIG.DIN_TO {0} \
              CONFIG.DIN_WIDTH {64} \
              CONFIG.DOUT_WIDTH {11} \
            ] [get_bd_cells xlslice_2]
            # Reconnect the input gpios
            connect_bd_net [get_bd_ports gpio_i] [get_bd_pins xlslice_0/Din]
            connect_bd_net [get_bd_ports gpio_i] [get_bd_pins xlslice_1/Din]
            connect_bd_net [get_bd_ports gpio_i] [get_bd_pins xlslice_2/Din]
            create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
	    set_property CONFIG.NUM_PORTS {3} [get_bd_cells xlconcat_0]
            set_property -dict [list CONFIG.IN2_WIDTH.VALUE_SRC USER CONFIG.IN1_WIDTH.VALUE_SRC USER CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells xlconcat_0]
            set_property -dict [list \
              CONFIG.IN0_WIDTH {45} \
              CONFIG.IN1_WIDTH {8} \
              CONFIG.IN2_WIDTH {11} \
            ] [get_bd_cells xlconcat_0]
            connect_bd_net [get_bd_pins xlslice_0/Dout] [get_bd_pins xlconcat_0/In0]
            connect_bd_net [get_bd_pins xlslice_2/Dout] [get_bd_pins xlconcat_0/In2]
            # Reconnect the input gpios to the ps7
            connect_bd_net [get_bd_pins sys_ps7/GPIO_I] [get_bd_pins xlconcat_0/dout]
            # Split the output gpios into 3 to separate the leds
            create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3
            set_property -dict [list \
              CONFIG.DIN_FROM {63} \
              CONFIG.DIN_TO {27} \
              CONFIG.DIN_WIDTH {64} \
              CONFIG.DOUT_WIDTH {37} \
            ] [get_bd_cells xlslice_3]
            create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4
            set_property -dict [list \
              CONFIG.DIN_FROM {26} \
              CONFIG.DIN_TO {19} \
              CONFIG.DIN_WIDTH {64} \
              CONFIG.DOUT_WIDTH {8} \
            ] [get_bd_cells xlslice_4]
            create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5
            set_property -dict [list \
              CONFIG.DIN_FROM {18} \
              CONFIG.DIN_TO {0} \
              CONFIG.DIN_WIDTH {64} \
              CONFIG.DOUT_WIDTH {19} \
            ] [get_bd_cells xlslice_5]
            # Reconnect the output gpios
            connect_bd_net [get_bd_pins sys_ps7/GPIO_O] [get_bd_pins xlslice_3/Din]
            connect_bd_net [get_bd_pins sys_ps7/GPIO_O] [get_bd_pins xlslice_4/Din]
            connect_bd_net [get_bd_pins sys_ps7/GPIO_O] [get_bd_pins xlslice_5/Din]
            create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1
	    set_property CONFIG.NUM_PORTS {3} [get_bd_cells xlconcat_1]
            set_property -dict [list CONFIG.IN2_WIDTH.VALUE_SRC USER CONFIG.IN1_WIDTH.VALUE_SRC USER CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells xlconcat_1]
            set_property -dict [list \
              CONFIG.IN0_WIDTH {37} \
              CONFIG.IN1_WIDTH {8} \
              CONFIG.IN2_WIDTH {19} \
            ] [get_bd_cells xlconcat_1]
            connect_bd_net [get_bd_pins xlslice_3/Dout] [get_bd_pins xlconcat_1/In0]
            connect_bd_net [get_bd_pins xlslice_5/Dout] [get_bd_pins xlconcat_1/In2]
            # Reconnect the output gpios to the output port
            connect_bd_net [get_bd_ports gpio_o] [get_bd_pins xlconcat_1/Dout]

           }
	    switch $carrier {
              zed {
                    set_property -dict [list CONFIG.NUM_MI {21}] [get_bd_cells axi_cpu_interconnect]
                    connect_bd_net [get_bd_pins axi_cpu_interconnect/M20_ACLK]    [get_bd_pins axi_clkgen/clk_0]
                    connect_bd_net [get_bd_pins axi_cpu_interconnect/M20_ARESETN] [get_bd_pins sampling_clk_rstgen/peripheral_aresetn]
                  }
             }
        }
    }
}
