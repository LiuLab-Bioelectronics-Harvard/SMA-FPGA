//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Thu Jun  2 21:44:19 2022
//Host        : MS-20150520OJYQ running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target mpram_wrapper.bd
//Design      : mpram_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module mpram_wrapper
   (clock,
    exp_addr,
    exp_clk,
    exp_din,
    exp_dout,
    exp_rst,
    exp_we,
    reset_n,
    s_0_araddr,
    s_0_arburst,
    s_0_arcache,
    s_0_arid,
    s_0_arlen,
    s_0_arlock,
    s_0_arprot,
    s_0_arqos,
    s_0_arready,
    s_0_arregion,
    s_0_arsize,
    s_0_arvalid,
    s_0_rdata,
    s_0_rid,
    s_0_rlast,
    s_0_rready,
    s_0_rresp,
    s_0_rvalid,
    s_1_awaddr,
    s_1_awburst,
    s_1_awcache,
    s_1_awid,
    s_1_awlen,
    s_1_awlock,
    s_1_awprot,
    s_1_awqos,
    s_1_awready,
    s_1_awregion,
    s_1_awsize,
    s_1_awvalid,
    s_1_bid,
    s_1_bready,
    s_1_bresp,
    s_1_bvalid,
    s_1_wdata,
    s_1_wlast,
    s_1_wready,
    s_1_wstrb,
    s_1_wvalid);
  input clock;
  input [31:0]exp_addr;
  input exp_clk;
  input [31:0]exp_din;
  output [31:0]exp_dout;
  input exp_rst;
  input [3:0]exp_we;
  input reset_n;
  input [31:0]s_0_araddr;
  input [1:0]s_0_arburst;
  input [3:0]s_0_arcache;
  input [4:0]s_0_arid;
  input [7:0]s_0_arlen;
  input [0:0]s_0_arlock;
  input [2:0]s_0_arprot;
  input [3:0]s_0_arqos;
  output s_0_arready;
  input [3:0]s_0_arregion;
  input [2:0]s_0_arsize;
  input s_0_arvalid;
  output [31:0]s_0_rdata;
  output [4:0]s_0_rid;
  output s_0_rlast;
  input s_0_rready;
  output [1:0]s_0_rresp;
  output s_0_rvalid;
  input [31:0]s_1_awaddr;
  input [1:0]s_1_awburst;
  input [3:0]s_1_awcache;
  input [4:0]s_1_awid;
  input [7:0]s_1_awlen;
  input [0:0]s_1_awlock;
  input [2:0]s_1_awprot;
  input [3:0]s_1_awqos;
  output s_1_awready;
  input [3:0]s_1_awregion;
  input [2:0]s_1_awsize;
  input s_1_awvalid;
  output [4:0]s_1_bid;
  input s_1_bready;
  output [1:0]s_1_bresp;
  output s_1_bvalid;
  input [31:0]s_1_wdata;
  input s_1_wlast;
  output s_1_wready;
  input [3:0]s_1_wstrb;
  input s_1_wvalid;

  wire clock;
  wire [31:0]exp_addr;
  wire exp_clk;
  wire [31:0]exp_din;
  wire [31:0]exp_dout;
  wire exp_rst;
  wire [3:0]exp_we;
  wire reset_n;
  wire [31:0]s_0_araddr;
  wire [1:0]s_0_arburst;
  wire [3:0]s_0_arcache;
  wire [4:0]s_0_arid;
  wire [7:0]s_0_arlen;
  wire [0:0]s_0_arlock;
  wire [2:0]s_0_arprot;
  wire [3:0]s_0_arqos;
  wire s_0_arready;
  wire [3:0]s_0_arregion;
  wire [2:0]s_0_arsize;
  wire s_0_arvalid;
  wire [31:0]s_0_rdata;
  wire [4:0]s_0_rid;
  wire s_0_rlast;
  wire s_0_rready;
  wire [1:0]s_0_rresp;
  wire s_0_rvalid;
  wire [31:0]s_1_awaddr;
  wire [1:0]s_1_awburst;
  wire [3:0]s_1_awcache;
  wire [4:0]s_1_awid;
  wire [7:0]s_1_awlen;
  wire [0:0]s_1_awlock;
  wire [2:0]s_1_awprot;
  wire [3:0]s_1_awqos;
  wire s_1_awready;
  wire [3:0]s_1_awregion;
  wire [2:0]s_1_awsize;
  wire s_1_awvalid;
  wire [4:0]s_1_bid;
  wire s_1_bready;
  wire [1:0]s_1_bresp;
  wire s_1_bvalid;
  wire [31:0]s_1_wdata;
  wire s_1_wlast;
  wire s_1_wready;
  wire [3:0]s_1_wstrb;
  wire s_1_wvalid;

  mpram mpram_i
       (.clock(clock),
        .exp_addr(exp_addr),
        .exp_clk(exp_clk),
        .exp_din(exp_din),
        .exp_dout(exp_dout),
        .exp_rst(exp_rst),
        .exp_we(exp_we),
        .reset_n(reset_n),
        .s_0_araddr(s_0_araddr),
        .s_0_arburst(s_0_arburst),
        .s_0_arcache(s_0_arcache),
        .s_0_arid(s_0_arid),
        .s_0_arlen(s_0_arlen),
        .s_0_arlock(s_0_arlock),
        .s_0_arprot(s_0_arprot),
        .s_0_arqos(s_0_arqos),
        .s_0_arready(s_0_arready),
        .s_0_arregion(s_0_arregion),
        .s_0_arsize(s_0_arsize),
        .s_0_arvalid(s_0_arvalid),
        .s_0_rdata(s_0_rdata),
        .s_0_rid(s_0_rid),
        .s_0_rlast(s_0_rlast),
        .s_0_rready(s_0_rready),
        .s_0_rresp(s_0_rresp),
        .s_0_rvalid(s_0_rvalid),
        .s_1_awaddr(s_1_awaddr),
        .s_1_awburst(s_1_awburst),
        .s_1_awcache(s_1_awcache),
        .s_1_awid(s_1_awid),
        .s_1_awlen(s_1_awlen),
        .s_1_awlock(s_1_awlock),
        .s_1_awprot(s_1_awprot),
        .s_1_awqos(s_1_awqos),
        .s_1_awready(s_1_awready),
        .s_1_awregion(s_1_awregion),
        .s_1_awsize(s_1_awsize),
        .s_1_awvalid(s_1_awvalid),
        .s_1_bid(s_1_bid),
        .s_1_bready(s_1_bready),
        .s_1_bresp(s_1_bresp),
        .s_1_bvalid(s_1_bvalid),
        .s_1_wdata(s_1_wdata),
        .s_1_wlast(s_1_wlast),
        .s_1_wready(s_1_wready),
        .s_1_wstrb(s_1_wstrb),
        .s_1_wvalid(s_1_wvalid));
endmodule
