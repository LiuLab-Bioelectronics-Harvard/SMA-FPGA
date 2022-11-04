vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/generic_baseblocks_v2_1_0
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_18
vlib modelsim_lib/msim/fifo_generator_v13_2_3
vlib modelsim_lib/msim/axi_data_fifo_v2_1_17
vlib modelsim_lib/msim/axi_crossbar_v2_1_19
vlib modelsim_lib/msim/blk_mem_gen_v8_3_6
vlib modelsim_lib/msim/axi_bram_ctrl_v4_1_0
vlib modelsim_lib/msim/blk_mem_gen_v8_4_2

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm
vmap generic_baseblocks_v2_1_0 modelsim_lib/msim/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_18 modelsim_lib/msim/axi_register_slice_v2_1_18
vmap fifo_generator_v13_2_3 modelsim_lib/msim/fifo_generator_v13_2_3
vmap axi_data_fifo_v2_1_17 modelsim_lib/msim/axi_data_fifo_v2_1_17
vmap axi_crossbar_v2_1_19 modelsim_lib/msim/axi_crossbar_v2_1_19
vmap blk_mem_gen_v8_3_6 modelsim_lib/msim/blk_mem_gen_v8_3_6
vmap axi_bram_ctrl_v4_1_0 modelsim_lib/msim/axi_bram_ctrl_v4_1_0
vmap blk_mem_gen_v8_4_2 modelsim_lib/msim/blk_mem_gen_v8_4_2

vlog -work xilinx_vip -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_4 -L axi_protocol_checker_v2_0_1 -L axi_vip_v1_1_1 -L processing_system7_vip_v1_0_3 -L xilinx_vip "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_4 -L axi_protocol_checker_v2_0_1 -L axi_vip_v1_1_1 -L processing_system7_vip_v1_0_3 -L xilinx_vip "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/Xilinx/vivado2018/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work generic_baseblocks_v2_1_0 -64 -incr "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../project_2.srcs/sources_1/bd/mpram/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0 -64 -incr "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_18 -64 -incr "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../project_2.srcs/sources_1/bd/mpram/ipshared/cc23/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_3 -64 -incr "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../project_2.srcs/sources_1/bd/mpram/ipshared/64f4/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_3 -64 -93 \
"../../../../project_2.srcs/sources_1/bd/mpram/ipshared/64f4/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_3 -64 -incr "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../project_2.srcs/sources_1/bd/mpram/ipshared/64f4/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_17 -64 -incr "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../project_2.srcs/sources_1/bd/mpram/ipshared/c4fd/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_19 -64 -incr "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../project_2.srcs/sources_1/bd/mpram/ipshared/6c9d/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/mpram/ip/mpram_xbar_0/sim/mpram_xbar_0.v" \

vlog -work blk_mem_gen_v8_3_6 -64 -incr "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../project_2.srcs/sources_1/bd/mpram/ipshared/2751/simulation/blk_mem_gen_v8_3.v" \

vcom -work axi_bram_ctrl_v4_1_0 -64 -93 \
"../../../../project_2.srcs/sources_1/bd/mpram/ipshared/27fe/hdl/axi_bram_ctrl_v4_1_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/mpram/ip/mpram_axi_warpper_0/sim/mpram_axi_warpper_0.vhd" \

vlog -work blk_mem_gen_v8_4_2 -64 -incr "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../project_2.srcs/sources_1/bd/mpram/ipshared/37c2/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../project_2.srcs/sources_1/bd/mpram/ipshared/ec67/hdl" "+incdir+D:/Xilinx/vivado2018/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/mpram/ip/mpram_block_ram_0/sim/mpram_block_ram_0.v" \
"../../../bd/mpram/ip/mpram_s00_data_fifo_0/sim/mpram_s00_data_fifo_0.v" \
"../../../bd/mpram/ip/mpram_s01_data_fifo_0/sim/mpram_s01_data_fifo_0.v" \
"../../../bd/mpram/sim/mpram.v" \

vlog -work xil_defaultlib \
"glbl.v"

