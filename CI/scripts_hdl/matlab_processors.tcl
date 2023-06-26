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

            #Disconnect adc_valid
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
