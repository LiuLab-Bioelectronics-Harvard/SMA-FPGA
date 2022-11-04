/******************************************************************************************
    
    ROM Data Format
    -------------------------------------------------------
    |    31:16   |   15   |   14:10  |    9:2   |   1:0   |
    -------------------------------------------------------
    |  Address   |  Burst |  Operate |  Length  |   Type  |
    -------------------------------------------------------

    Address:
        the address of RAM in Byte
    
    Burst:
        1'h0    wrapping
        1'h1    increasement

    Operate:
        See the ALU

    Length:
        a transfer packet length - 1

    Type:
        2'h0    done
        2'h1    wait for a signal to continue 
        2'h2    reading from RAM
        2'h3    writing to RAM

******************************************************************************************/


`timescale 1 ns / 1ps

module loader(
    clock,
    reset_n,

    trigger,
    done,

    rom_address,
    rom_dout,

    ram_araddr,
    ram_arburst,
    ram_arcache,
    ram_arid,
    ram_arlen,
    ram_arlock,
    ram_arprot,
    ram_arqos,
    ram_arready,
    ram_arsize,
    ram_arvalid,
    ram_rdata,
    ram_rid,
    ram_rlast,
    ram_rready,
    ram_rresp,
    ram_rvalid,
    ram_awaddr,
    ram_awburst,
    ram_awcache,
    ram_awid,
    ram_awlen,
    ram_awlock,
    ram_awprot,
    ram_awqos,
    ram_awready,
    ram_awsize,
    ram_awvalid,
    ram_wdata,
    ram_wlast,
    ram_wready,
    ram_wstrb,
    ram_wvalid,
    ram_bid,
    ram_bready,
    ram_bresp,
    ram_bvalid,

    alu_wready,
    alu_wvalid,
    alu_woperate,
    alu_wdata,
    alu_wlast,
    alu_rready,
    alu_rvalid,
    alu_rdata,
    alu_rlast
);

parameter integer                       rom_depth = 512;

input  logic                            clock;
input  logic                            reset_n;
input  logic                            trigger;
output logic                            done;
output logic [$clog2(rom_depth)-1:0]    rom_address;
input  logic [31:0]                     rom_dout;

output logic [31:0]                     ram_araddr;
output logic [1:0]                      ram_arburst;
output logic [3:0]                      ram_arcache;
output logic [4:0]                      ram_arid;
output logic [7:0]                      ram_arlen;
output logic [0:0]                      ram_arlock;
output logic [2:0]                      ram_arprot;
output logic [3:0]                      ram_arqos;
input  logic                            ram_arready;
output logic [2:0]                      ram_arsize;
output logic                            ram_arvalid;
input  logic [31:0]                     ram_rdata;
input  logic [4:0]                      ram_rid;
input  logic                            ram_rlast;
output logic                            ram_rready;
input  logic [1:0]                      ram_rresp;
input  logic                            ram_rvalid;
output logic [31:0]                     ram_awaddr;
output logic [1:0]                      ram_awburst;
output logic [3:0]                      ram_awcache;
output logic [4:0]                      ram_awid;
output logic [7:0]                      ram_awlen;
output logic [0:0]                      ram_awlock;
output logic [2:0]                      ram_awprot;
output logic [3:0]                      ram_awqos;
input  logic                            ram_awready;
output logic [2:0]                      ram_awsize;
output logic                            ram_awvalid;
output logic [31:0]                     ram_wdata;
output logic                            ram_wlast;
input  logic                            ram_wready;
output logic [3:0]                      ram_wstrb;
output logic                            ram_wvalid;
input  logic [4:0]                      ram_bid;
output logic                            ram_bready;
input  logic [1:0]                      ram_bresp;
input  logic                            ram_bvalid;

input  logic                            alu_wready;
output logic                            alu_wvalid;
output logic [4:0]                      alu_woperate;
output logic [31:0]                     alu_wdata;
output logic                            alu_wlast;

output logic                            alu_rready;
input  logic                            alu_rvalid;
input  logic [31:0]                     alu_rdata;
input  logic                            alu_rlast;

// ----------------------------------------------------------------------------

logic                                   fifo_reset;
logic                                   fifo_prog_full;
logic                                   fifo_write;
logic [31:0]                            fifo_din;
logic                                   fifo_empty;
logic                                   fifo_read;
logic [31:0]                            fifo_dout;

always_comb begin
    if(!reset_n) begin
        fifo_reset <= 1'b1;
    end else begin
        fifo_reset <= done;
    end
end

sc_fifo
#(
    .write_depth                        (32),
    .write_width                        (32),
    .read_width                         (32),
    .prog_full_thresh                   (24),
    .prog_empty_thresh                  (10),
    .memory_type                        ("distributed"),
    .read_mode                          ("fwft"),
    .has_write_ack                      (0),
    .has_almost_full                    (0),
    .has_din_count                      (0),
    .has_prog_full                      (1),
    .has_overflow                       (0),
    .has_dout_valid                     (0),
    .has_almost_empty                   (0),
    .has_dout_count                     (0),
    .has_prog_empty                     (0),
    .has_underflow                      (0)
)
inst_fifo(
    .clock                              (clock),
    .reset                              (fifo_reset),
    .almost_full                        (),
    .prog_full                          (fifo_prog_full),
    .full                               (),
    .write                              (fifo_write),
    .write_ack                          (),
    .din                                (fifo_din),
    .din_count                          (),
    .overflow                           (),
    .almost_empty                       (),
    .prog_empty                         (),
    .empty                              (fifo_empty),
    .read                               (fifo_read),
    .dout_valid                         (),
    .dout                               (fifo_dout),
    .dout_count                         (),
    .underflow                          ()
);

logic                                   fetch_state;
logic [2:0]                             fetch_valid;

always_ff @(posedge clock) begin
    if(!reset_n) begin
        fetch_state <= 1'b0;
    end else begin
        case(fetch_state)
            1'b0:
                fetch_state <= (trigger) ? 1'b1 : 1'b0;
            1'b1:
                fetch_state <= (done) ? 1'b0 : 1'b1;
        endcase
    end
end

always_ff @(posedge clock) begin
    case(fetch_state)
        1'b0:
            rom_address <= '1;
        1'b1:
            rom_address <= (fifo_prog_full) ? rom_address : (rom_address + 1'b1);
    endcase
end

always_ff @(posedge clock) begin
    if(fifo_reset) begin
        fetch_valid <= 'h0;
    end else begin
        case(fetch_state)
            1'b0:
                fetch_valid <= 'h0;
            1'b1:
                fetch_valid <= {fetch_valid[1:0], (fifo_prog_full) ? 1'b0 : 1'b1};
        endcase
    end
end

assign fifo_write = fetch_valid[2];
assign fifo_din = rom_dout;

// ----------------------------------------------------------------------------

logic                                   execute_reset;
logic [3:0]                             execute_state;
logic                                   execute_wait;
logic [15:0]                            execute_address;
logic                                   execute_burst;
logic [4:0]                             execute_operate;
logic [7:0]                             execute_length;
logic [1:0]                             execute_type;
logic [4:0]                             execute_signal;

assign {
    execute_address,
    execute_burst,
    execute_operate,
    execute_length,
    execute_type
} = fifo_dout;

always_ff @(posedge clock) begin
    if(!reset_n) begin
        done <= 1'b0;
    end else begin
        done <= (execute_state == 4'h4) ? 1'b1 : 1'b0;
    end
end

always_ff @(posedge clock) begin
    if(!reset_n) begin
        execute_reset <= 1'b0;
    end else begin
        case(execute_state)
            4'h8:
                execute_reset <= ~execute_reset;
            default:
                execute_reset <= 1'b0;
        endcase
    end
end

always_ff @(posedge clock) begin
    if(!reset_n) begin
        execute_state <= 4'h1;
    end else begin
        case(execute_state)
            4'h1: // check a new instruction
                execute_state <= ({fifo_empty,execute_type[1]}) ? execute_state : (execute_type[0] ? 4'h2 : 4'h4);
            4'h2: // wait for a signal
                if(execute_wait) begin
                    execute_state <= ((ram_bvalid == 1'b1) && (ram_bid == execute_signal)) ? 4'h1 : 4'h2;
                end else begin
                    execute_state <= ((ram_rready == 1'b1) && (ram_rvalid == 1'b1) && (ram_rid == execute_signal)) ? 4'h1 : 4'h2;
                end 
            4'h4: // generate the done signal
                execute_state <= 4'h8;
            default:
                execute_state <= (execute_reset) ? 4'h1 : 4'h8;
        endcase
    end
end

always_ff @(posedge clock) begin
    if(execute_state == 4'h1) begin
        execute_signal <= execute_operate;
        execute_wait <= execute_address[15];
    end
end

always_comb begin
    if(!reset_n) begin
        fifo_read <= 1'b0;
    end else begin
        case(execute_state)
            4'h1:
                if(fifo_empty) begin
                    fifo_read <= 1'b0;
                end else begin
                    case(execute_type)
                        2'h0:
                            fifo_read <= 1'b0;
                        2'h1:
                            fifo_read <= 1'b1;
                        2'h2:
                            fifo_read <= ram_arready;
                        2'h3:
                            fifo_read <= ram_awready;
                    endcase
                end
            default:
                fifo_read <= 1'b0;
        endcase
    end
end

assign ram_araddr = {16'h0,execute_address};
assign ram_arburst = {1'b0,execute_burst};
assign ram_arcache = 'h0;
assign ram_arid = execute_operate;
assign ram_arlen = execute_length;
assign ram_arlock = 'h0;
assign ram_arprot = 'h0;
assign ram_arqos = 'h0;
assign ram_arsize = 'h2;

always_comb begin
    if(!reset_n) begin
        ram_arvalid <= 1'b0;
    end else begin
        case(execute_state)
            4'h1:
                ram_arvalid <= ({fifo_empty,execute_type} == 3'b010) ? 1'b1 : 1'b0;
            default:
                ram_arvalid <= 1'b0;
        endcase
    end
end

assign ram_awaddr = {16'h0,execute_address};
assign ram_awburst = {1'b0,execute_burst};
assign ram_awcache = 'h0;
assign ram_awid = execute_operate;
assign ram_awlen = execute_length;
assign ram_awlock = 'h0;
assign ram_awprot = 'h0;
assign ram_awqos = 'h0;
assign ram_awsize = 'h2;

always_comb begin
    if(!reset_n) begin
        ram_awvalid <= 1'b0;
    end else begin
        case(execute_state)
            4'h1:
                ram_awvalid <= ({fifo_empty,execute_type} == 3'b011) ? 1'b1 : 1'b0;
            default:
                ram_awvalid <= 1'b0;
        endcase
    end
end

assign ram_rready = alu_wready;
assign alu_wvalid = ram_rvalid;
assign alu_woperate = ram_rid;
assign alu_wdata = ram_rdata;
assign alu_wlast = ram_rlast;
assign alu_rready = ram_wready;
assign ram_wvalid = alu_rvalid;
assign ram_wdata = alu_rdata;
assign ram_wlast = alu_rlast;
assign ram_wstrb = 'hf;
assign ram_bready = 'h1;

endmodule
