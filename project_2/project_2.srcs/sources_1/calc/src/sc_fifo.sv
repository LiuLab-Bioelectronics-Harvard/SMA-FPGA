module sc_fifo(
    clock,
    reset,

    almost_full,
    prog_full,
    full,
    write,
    write_ack,
    din,
    din_count,
    overflow,

    almost_empty,
    prog_empty,
    empty,
    read,
    dout_valid,
    dout,
    dout_count,
    underflow
);

parameter integer                           write_depth = 512;
parameter integer                           write_width = 512;
parameter integer                           read_width = 512;
parameter integer                           prog_full_thresh = 508;
parameter integer                           prog_empty_thresh = 10;
parameter                                   memory_type = "auto"; // allowed values: auto, block, distributed
parameter                                   read_mode = "fwft"; // allowed values: std, fwft
parameter                                   has_write_ack = 0;
parameter                                   has_almost_full = 0;
parameter                                   has_din_count = 0;
parameter                                   has_prog_full = 0;
parameter                                   has_overflow = 0;
parameter                                   has_dout_valid = 0;
parameter                                   has_almost_empty = 0;
parameter                                   has_dout_count = 0;
parameter                                   has_prog_empty = 0;
parameter                                   has_underflow = 0;

function [31:0] features_code;
integer features;
integer i;
begin
    features = (has_overflow) ? 1 : 0;
    features += (has_prog_full) ? 2 : 0;
    features += (has_din_count) ? 4 : 0;
    features += (has_almost_full) ? 8 : 0;
    features += (has_write_ack) ? 16 : 0;
    features += (has_underflow) ? 256 : 0;
    features += (has_prog_empty) ? 512 : 0;
    features += (has_dout_count) ? 1024 : 0;
    features += (has_almost_empty) ? 2048 : 0;
    features += (has_dout_valid) ? 4096 : 0;

    for(i=0; i<4; i=i+1)begin
        case(features & 4'hf)
            'h0:features_code = {8'h30, features_code[31:8]};
            'h1:features_code = {8'h31, features_code[31:8]};
            'h2:features_code = {8'h32, features_code[31:8]};
            'h3:features_code = {8'h33, features_code[31:8]};
            'h4:features_code = {8'h34, features_code[31:8]};
            'h5:features_code = {8'h35, features_code[31:8]};
            'h6:features_code = {8'h36, features_code[31:8]};
            'h7:features_code = {8'h37, features_code[31:8]};
            'h8:features_code = {8'h38, features_code[31:8]};
            'h9:features_code = {8'h39, features_code[31:8]};
            'ha:features_code = {8'h41, features_code[31:8]};
            'hb:features_code = {8'h42, features_code[31:8]};
            'hc:features_code = {8'h43, features_code[31:8]};
            'hd:features_code = {8'h44, features_code[31:8]};
            'he:features_code = {8'h45, features_code[31:8]};
            'hf:features_code = {8'h46, features_code[31:8]};
        endcase
        features=features>>4;
    end
end
endfunction

// ----------------------------------------------------------------------------

input  logic                                clock;
input  logic                                reset;

output logic                                almost_full;
output logic                                prog_full;
output logic                                full;
input  logic                                write;
output logic                                write_ack;
input  logic [write_width-1:0]              din;
output logic [$clog2(write_depth):0]        din_count;
output logic                                overflow;

output logic                                almost_empty;
output logic                                prog_empty;
output logic                                empty;
input  logic                                read;
output logic                                dout_valid;
output logic [read_width-1:0]               dout;
output logic [$clog2(write_depth*write_width/read_width):0] dout_count;
output logic                                underflow;

// ----------------------------------------------------------------------------

xpm_fifo_sync #(
    .DOUT_RESET_VALUE                       ("0"),
    .ECC_MODE                               ("no_ecc"),
    .FIFO_MEMORY_TYPE                       (memory_type), // allowed values: auto, block, distributed, ultra. Default value = auto.
    .FIFO_READ_LATENCY                      (1),
    .FIFO_WRITE_DEPTH                       (write_depth),
    .FULL_RESET_VALUE                       (0),
    .PROG_EMPTY_THRESH                      (prog_empty_thresh), // min_value = 3 + (2 * read_mode_value); max_value = write_depth - min_value, if read_mode = "std", then read_mode_value = 0, otherwise read_mode_value = 1
    .PROG_FULL_THRESH                       (prog_full_thresh), // min_value = 3 + (2 * read_mode_value) * write_depth / read_depth; max_value = write_depth - min_value
    .RD_DATA_COUNT_WIDTH                    ($clog2(write_depth*write_width/read_width)+1), // should be log2(read_depth)+1, read_depth = write_depth * write_depth / read_depth
    .READ_DATA_WIDTH                        (read_width),
    .READ_MODE                              (read_mode), // allowed values: std, fwft
//    .SIM_ASSERT_CHK                         (0),
    .USE_ADV_FEATURES                       (features_code()), // enables dout_valid, almost_empty, dout_count, prog_empty, underflow, 0, 0, 0, write_ack, almost_full, din_count, prog_full, overflow features.
    .WAKEUP_TIME                            (0),
    .WRITE_DATA_WIDTH                       (write_width),
    .WR_DATA_COUNT_WIDTH                    ($clog2(write_depth)+1) // should be log2(write_depth)+1.
)
xpm_fifo_sync (
    .almost_empty                           (almost_empty), // only one more read can be performed before the FIFO goes to empty
    .almost_full                            (almost_full), // only one more write can be performed before the FIFO is full
    .data_valid                             (dout_valid),
    .dbiterr                                (),
    .dout                                   (dout),
    .empty                                  (empty),
    .full                                   (full),
    .overflow                               (overflow),
    .prog_empty                             (prog_empty),
    .prog_full                              (prog_full),
    .rd_data_count                          (dout_count), // this bus indicates the number of words read from the FIFO.
    .rd_rst_busy                            (),
    .sbiterr                                (),
    .underflow                              (underflow),
    .wr_ack                                 (write_ack),
    .wr_data_count                          (din_count), // this bus indicates the number of words written into the FIFO.
    .wr_rst_busy                            (),
    .din                                    (din),
    .injectdbiterr                          (),
    .injectsbiterr                          (),
    .rd_en                                  (read),
    .rst                                    (reset), // must be synchronous to wr_clk.
    .sleep                                  (1'b0),
    .wr_clk                                 (clock),
    .wr_en                                  (write)
);

endmodule