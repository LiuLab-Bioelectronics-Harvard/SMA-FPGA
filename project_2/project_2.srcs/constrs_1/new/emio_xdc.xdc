

#set_property IOSTANDARD LVCMOS33 [get_ports {emio_gpio_tri_io[*]}]
#pl led
#set_property PACKAGE_PIN M14 [get_ports {emio_gpio_tri_io[0]}]
#pl key
#set_property PACKAGE_PIN N15 [get_ports {emio_gpio_tri_io[1]}]
#set_property PACKAGE_PIN N16 [get_ports {emio_gpio_tri_io[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports i_uart_rx]
set_property PACKAGE_PIN W16 [get_ports i_uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports o_uart_tx]
set_property PACKAGE_PIN T15 [get_ports o_uart_tx]

create_clock -period 20.000 [get_ports fpga_clk]
set_input_jitter [get_clocks -of_objects [get_ports fpga_clk]] 0.200
set_property PACKAGE_PIN U18 [get_ports fpga_clk]
set_property IOSTANDARD LVCMOS33 [get_ports fpga_clk]


connect_debug_port u_ila_0/probe0 [get_nets [list {u_bram_zynq_calc/de_bram_addr[0]} {u_bram_zynq_calc/de_bram_addr[1]} {u_bram_zynq_calc/de_bram_addr[2]} {u_bram_zynq_calc/de_bram_addr[3]} {u_bram_zynq_calc/de_bram_addr[4]} {u_bram_zynq_calc/de_bram_addr[5]} {u_bram_zynq_calc/de_bram_addr[6]} {u_bram_zynq_calc/de_bram_addr[7]} {u_bram_zynq_calc/de_bram_addr[8]} {u_bram_zynq_calc/de_bram_addr[9]} {u_bram_zynq_calc/de_bram_addr[10]} {u_bram_zynq_calc/de_bram_addr[11]} {u_bram_zynq_calc/de_bram_addr[12]} {u_bram_zynq_calc/de_bram_addr[13]} {u_bram_zynq_calc/de_bram_addr[14]} {u_bram_zynq_calc/de_bram_addr[15]} {u_bram_zynq_calc/de_bram_addr[16]} {u_bram_zynq_calc/de_bram_addr[17]} {u_bram_zynq_calc/de_bram_addr[18]} {u_bram_zynq_calc/de_bram_addr[19]} {u_bram_zynq_calc/de_bram_addr[20]} {u_bram_zynq_calc/de_bram_addr[21]} {u_bram_zynq_calc/de_bram_addr[22]} {u_bram_zynq_calc/de_bram_addr[23]} {u_bram_zynq_calc/de_bram_addr[24]} {u_bram_zynq_calc/de_bram_addr[25]} {u_bram_zynq_calc/de_bram_addr[26]} {u_bram_zynq_calc/de_bram_addr[27]} {u_bram_zynq_calc/de_bram_addr[28]} {u_bram_zynq_calc/de_bram_addr[29]} {u_bram_zynq_calc/de_bram_addr[30]} {u_bram_zynq_calc/de_bram_addr[31]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {u_bram_zynq_calc/de_bram_din[0]} {u_bram_zynq_calc/de_bram_din[1]} {u_bram_zynq_calc/de_bram_din[2]} {u_bram_zynq_calc/de_bram_din[3]} {u_bram_zynq_calc/de_bram_din[4]} {u_bram_zynq_calc/de_bram_din[5]} {u_bram_zynq_calc/de_bram_din[6]} {u_bram_zynq_calc/de_bram_din[7]} {u_bram_zynq_calc/de_bram_din[8]} {u_bram_zynq_calc/de_bram_din[9]} {u_bram_zynq_calc/de_bram_din[10]} {u_bram_zynq_calc/de_bram_din[11]} {u_bram_zynq_calc/de_bram_din[12]} {u_bram_zynq_calc/de_bram_din[13]} {u_bram_zynq_calc/de_bram_din[14]} {u_bram_zynq_calc/de_bram_din[15]} {u_bram_zynq_calc/de_bram_din[16]} {u_bram_zynq_calc/de_bram_din[17]} {u_bram_zynq_calc/de_bram_din[18]} {u_bram_zynq_calc/de_bram_din[19]} {u_bram_zynq_calc/de_bram_din[20]} {u_bram_zynq_calc/de_bram_din[21]} {u_bram_zynq_calc/de_bram_din[22]} {u_bram_zynq_calc/de_bram_din[23]} {u_bram_zynq_calc/de_bram_din[24]} {u_bram_zynq_calc/de_bram_din[25]} {u_bram_zynq_calc/de_bram_din[26]} {u_bram_zynq_calc/de_bram_din[27]} {u_bram_zynq_calc/de_bram_din[28]} {u_bram_zynq_calc/de_bram_din[29]} {u_bram_zynq_calc/de_bram_din[30]} {u_bram_zynq_calc/de_bram_din[31]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list u_bram_zynq_calc/de_bram_data_rdy]]
connect_debug_port u_ila_0/probe3 [get_nets [list u_bram_zynq_calc/de_bram_en]]
connect_debug_port u_ila_0/probe4 [get_nets [list u_bram_zynq_calc/de_flow_cnt]]




create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list fpga_clk_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {u3_bram_zynq_calc/de_state_data[0]} {u3_bram_zynq_calc/de_state_data[1]} {u3_bram_zynq_calc/de_state_data[2]} {u3_bram_zynq_calc/de_state_data[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {u3_bram_zynq_calc/de_bram_din[0]} {u3_bram_zynq_calc/de_bram_din[1]} {u3_bram_zynq_calc/de_bram_din[2]} {u3_bram_zynq_calc/de_bram_din[3]} {u3_bram_zynq_calc/de_bram_din[4]} {u3_bram_zynq_calc/de_bram_din[5]} {u3_bram_zynq_calc/de_bram_din[6]} {u3_bram_zynq_calc/de_bram_din[7]} {u3_bram_zynq_calc/de_bram_din[8]} {u3_bram_zynq_calc/de_bram_din[9]} {u3_bram_zynq_calc/de_bram_din[10]} {u3_bram_zynq_calc/de_bram_din[11]} {u3_bram_zynq_calc/de_bram_din[12]} {u3_bram_zynq_calc/de_bram_din[13]} {u3_bram_zynq_calc/de_bram_din[14]} {u3_bram_zynq_calc/de_bram_din[15]} {u3_bram_zynq_calc/de_bram_din[16]} {u3_bram_zynq_calc/de_bram_din[17]} {u3_bram_zynq_calc/de_bram_din[18]} {u3_bram_zynq_calc/de_bram_din[19]} {u3_bram_zynq_calc/de_bram_din[20]} {u3_bram_zynq_calc/de_bram_din[21]} {u3_bram_zynq_calc/de_bram_din[22]} {u3_bram_zynq_calc/de_bram_din[23]} {u3_bram_zynq_calc/de_bram_din[24]} {u3_bram_zynq_calc/de_bram_din[25]} {u3_bram_zynq_calc/de_bram_din[26]} {u3_bram_zynq_calc/de_bram_din[27]} {u3_bram_zynq_calc/de_bram_din[28]} {u3_bram_zynq_calc/de_bram_din[29]} {u3_bram_zynq_calc/de_bram_din[30]} {u3_bram_zynq_calc/de_bram_din[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {u3_bram_zynq_calc/de_bram_addr[0]} {u3_bram_zynq_calc/de_bram_addr[1]} {u3_bram_zynq_calc/de_bram_addr[2]} {u3_bram_zynq_calc/de_bram_addr[3]} {u3_bram_zynq_calc/de_bram_addr[4]} {u3_bram_zynq_calc/de_bram_addr[5]} {u3_bram_zynq_calc/de_bram_addr[6]} {u3_bram_zynq_calc/de_bram_addr[7]} {u3_bram_zynq_calc/de_bram_addr[8]} {u3_bram_zynq_calc/de_bram_addr[9]} {u3_bram_zynq_calc/de_bram_addr[10]} {u3_bram_zynq_calc/de_bram_addr[11]} {u3_bram_zynq_calc/de_bram_addr[12]} {u3_bram_zynq_calc/de_bram_addr[13]} {u3_bram_zynq_calc/de_bram_addr[14]} {u3_bram_zynq_calc/de_bram_addr[15]} {u3_bram_zynq_calc/de_bram_addr[16]} {u3_bram_zynq_calc/de_bram_addr[17]} {u3_bram_zynq_calc/de_bram_addr[18]} {u3_bram_zynq_calc/de_bram_addr[19]} {u3_bram_zynq_calc/de_bram_addr[20]} {u3_bram_zynq_calc/de_bram_addr[21]} {u3_bram_zynq_calc/de_bram_addr[22]} {u3_bram_zynq_calc/de_bram_addr[23]} {u3_bram_zynq_calc/de_bram_addr[24]} {u3_bram_zynq_calc/de_bram_addr[25]} {u3_bram_zynq_calc/de_bram_addr[26]} {u3_bram_zynq_calc/de_bram_addr[27]} {u3_bram_zynq_calc/de_bram_addr[28]} {u3_bram_zynq_calc/de_bram_addr[29]} {u3_bram_zynq_calc/de_bram_addr[30]} {u3_bram_zynq_calc/de_bram_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list u4_uart_top/calc_done_d0]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list u3_bram_zynq_calc/de_bram_data_rdy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list u3_bram_zynq_calc/de_bram_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list u3_bram_zynq_calc/de_o_calc_trigger]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets fpga_clk_IBUF_BUFG]
