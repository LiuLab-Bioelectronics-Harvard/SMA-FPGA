//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Thu May 19 22:26:05 2022
//Host        : MS-20150520OJYQ running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    bram_portb_addr,
    bram_portb_clk,
    bram_portb_din,
    bram_portb_dout,
    bram_portb_en,
    bram_portb_rst,
    bram_portb_we,
    package_receive,
    i_overtime_flag,
    i_zynq_reply_flag
    //emio_gpio_tri_io
    );
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input [31:0]bram_portb_addr;
  input bram_portb_clk;
  input [31:0]bram_portb_din;
  output [31:0]bram_portb_dout;
  input bram_portb_en;
  input bram_portb_rst;
  input [3:0]bram_portb_we;
  output package_receive;
  input  i_overtime_flag;
  input  i_zynq_reply_flag;
  //inout [2:0]emio_gpio_tri_io;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [31:0]bram_portb_addr;
  wire bram_portb_clk;
  wire [31:0]bram_portb_din;
  wire [31:0]bram_portb_dout;
  wire bram_portb_en;
  wire bram_portb_rst;
  wire [3:0]bram_portb_we;
  wire [0:0]emio_gpio_tri_i_0;
  wire [1:1]emio_gpio_tri_i_1;
  wire [2:2]emio_gpio_tri_i_2;
  wire [0:0]emio_gpio_tri_io_0;
  wire [1:1]emio_gpio_tri_io_1;
  wire [2:2]emio_gpio_tri_io_2;
  wire [0:0]emio_gpio_tri_o_0;
  wire [1:1]emio_gpio_tri_o_1;
  wire [2:2]emio_gpio_tri_o_2;
  wire [0:0]emio_gpio_tri_t_0;
  wire [1:1]emio_gpio_tri_t_1;
  wire [2:2]emio_gpio_tri_t_2;

  design_1 design_1_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .bram_portb_addr(bram_portb_addr),
        .bram_portb_clk(bram_portb_clk),
        .bram_portb_din(bram_portb_din),
        .bram_portb_dout(bram_portb_dout),
        .bram_portb_en(bram_portb_en),
        .bram_portb_rst(bram_portb_rst),
        .bram_portb_we(bram_portb_we),
        .emio_gpio_tri_i({i_overtime_flag,i_zynq_reply_flag,emio_gpio_tri_i_0}),
        .emio_gpio_tri_o({emio_gpio_tri_o_2,emio_gpio_tri_o_1,emio_gpio_tri_o_0}),
        .emio_gpio_tri_t({emio_gpio_tri_t_2,emio_gpio_tri_t_1,emio_gpio_tri_t_0}));
        /*
  IOBUF emio_gpio_tri_iobuf_0
       (.I(emio_gpio_tri_o_0),
        .IO(emio_gpio_tri_io[0]),
        .O(emio_gpio_tri_i_0),
        .T(emio_gpio_tri_t_0));
  IOBUF emio_gpio_tri_iobuf_1
       (.I(emio_gpio_tri_o_1),
        .IO(emio_gpio_tri_io[1]),
        .O(emio_gpio_tri_i_1),
        .T(emio_gpio_tri_t_1));
  IOBUF emio_gpio_tri_iobuf_2
       (.I(emio_gpio_tri_o_2),
        .IO(emio_gpio_tri_io[2]),
        .O(emio_gpio_tri_i_2),
        .T(emio_gpio_tri_t_2));
        */
        assign package_receive  =emio_gpio_tri_o_0;
endmodule
