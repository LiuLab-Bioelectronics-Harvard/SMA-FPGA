/******************************************************************************

matrix malloc:
    ---------------------------------------------------------------
    |   start  |    end   |  content  | layout |  length in bytes |
    ---------------------------------------------------------------
    |  0x0000  |  0x00ff  |     w     |  4x16  |      0x0100      |
    ---------------------------------------------------------------
    |  0x0100  |  0x01ff  |     z     |  4x16  |      0x0100      |
    ---------------------------------------------------------------
    |  0x0200  |  0x023f  |     m     |  4x4   |      0x0040      |
    ---------------------------------------------------------------
    |  0x0240  |  0x027f  |     t     |  4x4   |      0x0040      |
    ---------------------------------------------------------------
    |  0x0280  |  0x02bf  |     x     |  16x1  |      0x0040      |
    ---------------------------------------------------------------
    |  0x02c0  |  0x02cf  |     y     |  4x1   |      0x0010      |
    ---------------------------------------------------------------
    |  0x02d0  |  0x02d3  |    step   |  1x1   |      0x0004      |
    ---------------------------------------------------------------
    |  0x02d4  |  0x02d7  |   1-step  |  1x1   |      0x0004      |
    ---------------------------------------------------------------
    |  0x02d8  |  0x02db  |    -1     |  1x1   |      0x0004      |
    ---------------------------------------------------------------

******************************************************************************/


`timescale 1 ns / 1ps

module calc(
    clock,
    reset_n,
    write,
    address,
    din,
    dout,
    trigger,
    done
);

parameter integer                       rom_depth = 1024;

input  logic                            clock;
input  logic                            reset_n;
input  logic                            write;
input  logic [31:0]                     address;
input  logic [31:0]                     din;
output logic [31:0]                     dout;
input  logic                            trigger;
output logic                            done;

// ----------------------------------------------------------------------------

logic [31:0]                            ram_araddr;
logic [1:0]                             ram_arburst;
logic [3:0]                             ram_arcache;
logic [4:0]                             ram_arid;
logic [7:0]                             ram_arlen;
logic [0:0]                             ram_arlock;
logic [2:0]                             ram_arprot;
logic [3:0]                             ram_arqos;
logic                                   ram_arready;
logic [2:0]                             ram_arsize;
logic                                   ram_arvalid;
logic [31:0]                            ram_rdata;
logic [4:0]                             ram_rid;
logic                                   ram_rlast;
logic                                   ram_rready;
logic [1:0]                             ram_rresp;
logic                                   ram_rvalid;
logic [31:0]                            ram_awaddr;
logic [1:0]                             ram_awburst;
logic [3:0]                             ram_awcache;
logic [4:0]                             ram_awid;
logic [7:0]                             ram_awlen;
logic [0:0]                             ram_awlock;
logic [2:0]                             ram_awprot;
logic [3:0]                             ram_awqos;
logic                                   ram_awready;
logic [2:0]                             ram_awsize;
logic                                   ram_awvalid;
logic [31:0]                            ram_wdata;
logic                                   ram_wlast;
logic                                   ram_wready;
logic [3:0]                             ram_wstrb;
logic                                   ram_wvalid;
logic [4:0]                             ram_bid;
logic                                   ram_bready;
logic [1:0]                             ram_bresp;
logic                                   ram_bvalid;

mpram
#(

)
ram(
    .clock                              (clock),
    .reset_n                            (reset_n),

    .exp_addr                           (address),
    .exp_clk                            (clock),
    .exp_din                            (din),
    .exp_dout                           (dout),
    .exp_rst                            (~reset_n),
    .exp_we                             ({(4){write}}),
    
    .s_0_araddr                         (ram_araddr),
    .s_0_arburst                        (ram_arburst),
    .s_0_arcache                        (ram_arcache),
    .s_0_arid                           (ram_arid),
    .s_0_arlen                          (ram_arlen),
    .s_0_arlock                         (ram_arlock),
    .s_0_arprot                         (ram_arprot),
    .s_0_arqos                          (ram_arqos),
    .s_0_arready                        (ram_arready),
    .s_0_arsize                         (ram_arsize),
    .s_0_arvalid                        (ram_arvalid),
    .s_0_rdata                          (ram_rdata),
    .s_0_rid                            (ram_rid),
    .s_0_rlast                          (ram_rlast),
    .s_0_rready                         (ram_rready),
    .s_0_rresp                          (ram_rresp),
    .s_0_rvalid                         (ram_rvalid),

    .s_1_awaddr                         (ram_awaddr),
    .s_1_awburst                        (ram_awburst),
    .s_1_awcache                        (ram_awcache),
    .s_1_awid                           (ram_awid),
    .s_1_awlen                          (ram_awlen),
    .s_1_awlock                         (ram_awlock),
    .s_1_awprot                         (ram_awprot),
    .s_1_awqos                          (ram_awqos),
    .s_1_awready                        (ram_awready),
    .s_1_awsize                         (ram_awsize),
    .s_1_awvalid                        (ram_awvalid),
    .s_1_wdata                          (ram_wdata),
    .s_1_wlast                          (ram_wlast),
    .s_1_wready                         (ram_wready),
    .s_1_wstrb                          (ram_wstrb),
    .s_1_wvalid                         (ram_wvalid),
    .s_1_bid                            (ram_bid),
    .s_1_bready                         (ram_bready),
    .s_1_bresp                          (ram_bresp),
    .s_1_bvalid                         (ram_bvalid)
);

logic [$clog2(rom_depth)-1:0]           rom_address;
logic [31:0]                            rom_dout;
xpm_memory_sprom #(
    .ADDR_WIDTH_A                       ($clog2(rom_depth)), // DECIMAL
    .AUTO_SLEEP_TIME                    (0), // DECIMAL
    .CASCADE_HEIGHT                     (2), // DECIMAL
    .ECC_MODE                           ("no_ecc"), // String
    .MEMORY_INIT_FILE                   ("rom_init.mem"), // String
    .MEMORY_INIT_PARAM                  ("0"), // String
    .MEMORY_OPTIMIZATION                ("true"), // String
    .MEMORY_PRIMITIVE                   ("auto"), // String
    .MEMORY_SIZE                        (rom_depth*32), // DECIMAL
    .MESSAGE_CONTROL                    (0), // DECIMAL
    .READ_DATA_WIDTH_A                  (32), // DECIMAL
    .READ_LATENCY_A                     (2), // DECIMAL
    .READ_RESET_VALUE_A                 ("0"), // String
    .RST_MODE_A                         ("SYNC"), // String
    .SIM_ASSERT_CHK                     (0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    .USE_MEM_INIT                       (1), // DECIMAL
    .WAKEUP_TIME                        ("disable_sleep") // String
)
rom(
    .dbiterra                           (), // 1-bit output: Leave open.
    .douta                              (rom_dout), // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
    .sbiterra                           (), // 1-bit output: Leave open.
    .addra                              (rom_address), // ADDR_WIDTH_A-bit input: Address for port A read operations.
    .clka                               (clock), // 1-bit input: Clock signal for port A.
    .ena                                (1'b1), // 1-bit input: Memory enable signal for port A. Must be high on clock cycles when read operations are initiated. Pipelined internally.
    .injectdbiterra                     (), // 1-bit input: Do not change from the provided value.
    .injectsbiterra                     (), // 1-bit input: Do not change from the provided value.
    .regcea                             (1'b1), // 1-bit input: Do not change from the provided value.
    .rsta                               (~reset_n), // 1-bit input: Reset signal for the final port A output register stage.Synchronously resets output port douta to the value specified by parameter READ_RESET_VALUE_A.
    .sleep                              (1'b0) // 1-bit input: sleep signal to enable the dynamic power saving feature.
);

logic                                   alu_wready;
logic                                   alu_wvalid;
logic [4:0]                             alu_woperate;
logic [31:0]                            alu_wdata;
logic                                   alu_wlast;
logic                                   alu_rready;
logic                                   alu_rvalid;
logic [31:0]                            alu_rdata;
logic                                   alu_rlast;

loader
#(
    .rom_depth                          (rom_depth)
)
loader(
    .clock                              (clock),
    .reset_n                            (reset_n),

    .trigger                            (trigger),
    .done                               (done),
    .rom_address                        (rom_address),
    .rom_dout                           (rom_dout),

    .ram_araddr                         (ram_araddr),
    .ram_arburst                        (ram_arburst),
    .ram_arcache                        (ram_arcache),
    .ram_arid                           (ram_arid),
    .ram_arlen                          (ram_arlen),
    .ram_arlock                         (ram_arlock),
    .ram_arprot                         (ram_arprot),
    .ram_arqos                          (ram_arqos),
    .ram_arready                        (ram_arready),
    .ram_arsize                         (ram_arsize),
    .ram_arvalid                        (ram_arvalid),
    .ram_rdata                          (ram_rdata),
    .ram_rid                            (ram_rid),
    .ram_rlast                          (ram_rlast),
    .ram_rready                         (ram_rready),
    .ram_rresp                          (ram_rresp),
    .ram_rvalid                         (ram_rvalid),
    .ram_awaddr                         (ram_awaddr),
    .ram_awburst                        (ram_awburst),
    .ram_awcache                        (ram_awcache),
    .ram_awid                           (ram_awid),
    .ram_awlen                          (ram_awlen),
    .ram_awlock                         (ram_awlock),
    .ram_awprot                         (ram_awprot),
    .ram_awqos                          (ram_awqos),
    .ram_awready                        (ram_awready),
    .ram_awsize                         (ram_awsize),
    .ram_awvalid                        (ram_awvalid),
    .ram_wdata                          (ram_wdata),
    .ram_wlast                          (ram_wlast),
    .ram_wready                         (ram_wready),
    .ram_wstrb                          (ram_wstrb),
    .ram_wvalid                         (ram_wvalid),
    .ram_bid                            (ram_bid),
    .ram_bready                         (ram_bready),
    .ram_bresp                          (ram_bresp),
    .ram_bvalid                         (ram_bvalid),

    .alu_wready                         (alu_wready),
    .alu_wvalid                         (alu_wvalid),
    .alu_woperate                       (alu_woperate),
    .alu_wdata                          (alu_wdata),
    .alu_wlast                          (alu_wlast),
    .alu_rready                         (alu_rready),
    .alu_rvalid                         (alu_rvalid),
    .alu_rdata                          (alu_rdata),
    .alu_rlast                          (alu_rlast)
);

alu
#(

)
alu(
    .clock                              (clock),
    .reset_n                            (reset_n),

    .alu_wready                         (alu_wready),
    .alu_wvalid                         (alu_wvalid),
    .alu_woperate                       (alu_woperate),
    .alu_wdata                          (alu_wdata),
    .alu_wlast                          (alu_wlast),
    .alu_rready                         (alu_rready),
    .alu_rvalid                         (alu_rvalid),
    .alu_rdata                          (alu_rdata),
    .alu_rlast                          (alu_rlast)
);

endmodule
