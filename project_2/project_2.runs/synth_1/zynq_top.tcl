# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.cache/wt [current_project]
set_property parent.project_path E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_FIFO XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_mem E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/calc/src/rom_init.mem
read_verilog -library xil_defaultlib -sv {
  E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/calc/src/alu.sv
  E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/calc/src/calc.sv
  E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/calc/src/loader.sv
  E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/calc/src/router.sv
  E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/calc/src/sc_fifo.sv
}
read_verilog -library xil_defaultlib {
  E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/new/bram_zynq_calc.v
  E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
  E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/new/uart_rx.v
  E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/new/uart_top.v
  E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/new/uart_tx.v
  E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/new/zynq_top.v
}
add_files E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/mpram/mpram.bd
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/mpram/ip/mpram_xbar_0/mpram_xbar_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/mpram/ip/mpram_axi_warpper_0/mpram_axi_warpper_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/mpram/ip/mpram_block_ram_0/mpram_block_ram_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/mpram/ip/mpram_s00_data_fifo_0/mpram_s00_data_fifo_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/mpram/ip/mpram_s01_data_fifo_0/mpram_s01_data_fifo_0_ooc.xdc]
set_property used_in_implementation false [get_files -all E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/mpram/mpram_ooc.xdc]

add_files E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/design_1.bd
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_processing_system7_0_0/design_1_processing_system7_0_0.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_axi_bram_ctrl_0_0/design_1_axi_bram_ctrl_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_blk_mem_gen_0_0/design_1_blk_mem_gen_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_1/bd_afc3_psr_aclk_0_board.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_1/bd_afc3_psr_aclk_0.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_5/bd_afc3_s00a2s_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_6/bd_afc3_sarn_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_7/bd_afc3_srn_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_8/bd_afc3_sawn_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_9/bd_afc3_swn_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_10/bd_afc3_sbn_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_11/bd_afc3_m00s2a_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_rst_ps7_0_50M_0/design_1_rst_ps7_0_50M_0_board.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_rst_ps7_0_50M_0/design_1_rst_ps7_0_50M_0.xdc]
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/ip/design_1_rst_ps7_0_50M_0/design_1_rst_ps7_0_50M_0_ooc.xdc]
set_property used_in_implementation false [get_files -all E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/bd/design_1/design_1_ooc.xdc]

read_ip -quiet E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/ip/fp_divide/fp_divide.xci
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/ip/fp_divide/fp_divide_ooc.xdc]

read_ip -quiet E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/ip/fp_accumulator/fp_accumulator.xci
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/ip/fp_accumulator/fp_accumulator_ooc.xdc]

read_ip -quiet E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/ip/fp_multiply/fp_multiply.xci
set_property used_in_implementation false [get_files -all e:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/sources_1/ip/fp_multiply/fp_multiply_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/constrs_1/new/emio_xdc.xdc
set_property used_in_implementation false [get_files E:/Debug_V2.3/ZYNQ_CALC/project_2/project_2.srcs/constrs_1/new/emio_xdc.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top zynq_top -part xc7z010clg400-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef zynq_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file zynq_top_utilization_synth.rpt -pb zynq_top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]