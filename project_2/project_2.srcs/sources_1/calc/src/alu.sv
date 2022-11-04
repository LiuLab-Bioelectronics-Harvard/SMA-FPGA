

`timescale 1 ns / 1ps

module alu(
    clock,
    reset_n,

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

input  logic                            clock;
input  logic                            reset_n;

output logic                            alu_wready;
input  logic                            alu_wvalid;
input  logic [4:0]                      alu_woperate;
input  logic [31:0]                     alu_wdata;
input  logic                            alu_wlast;

input  logic                            alu_rready;
output logic                            alu_rvalid;
output logic [31:0]                     alu_rdata;
output logic                            alu_rlast;

// ----------------------------------------------------------------------------

logic                                   router_a_0_ready;
logic                                   router_a_0_valid;
logic [3:0]                             router_a_0_operate;
logic [31:0]                            router_a_0_data;
logic                                   router_a_0_last;

logic                                   router_a_1_ready;
logic                                   router_a_1_valid;
logic [3:0]                             router_a_1_operate;
logic [31:0]                            router_a_1_data;
logic                                   router_a_1_last;

router
#(
    .identity_width                     (4),
    .stream_width                       (32+1)
)
router_a(
    .clock                              (clock),
    .reset                              (~reset_n),

    .axi_s_ready                        (alu_wready),
    .axi_s_valid                        (alu_wvalid),
    .axi_s_identity                     (alu_woperate),
    .axi_s_stream                      ({alu_wdata,
                                         alu_wlast}),

    .axi_m_0_ready                      (router_a_0_ready),
    .axi_m_0_valid                      (router_a_0_valid),
    .axi_m_0_identity                   (router_a_0_operate),
    .axi_m_0_stream                    ({router_a_0_data,
                                         router_a_0_last}),

    .axi_m_1_ready                      (router_a_1_ready),
    .axi_m_1_valid                      (router_a_1_valid),
    .axi_m_1_identity                   (router_a_1_operate),
    .axi_m_1_stream                    ({router_a_1_data,
                                         router_a_1_last})
);

logic                                   router_b_0_ready;
logic                                   router_b_0_valid;
logic [2:0]                             router_b_0_operate;
logic [31:0]                            router_b_0_data;
logic                                   router_b_0_last;

logic                                   router_b_1_ready;
logic                                   router_b_1_valid;
logic [2:0]                             router_b_1_operate;
logic [31:0]                            router_b_1_data;
logic                                   router_b_1_last;

router
#(
    .identity_width                     (3),
    .stream_width                       (32+1)
)
router_b(
    .clock                              (clock),
    .reset                              (~reset_n),

    .axi_s_ready                        (router_a_1_ready),
    .axi_s_valid                        (router_a_1_valid),
    .axi_s_identity                     (router_a_1_operate),
    .axi_s_stream                      ({router_a_1_data,
                                         router_a_1_last}),

    .axi_m_0_ready                      (router_b_0_ready),
    .axi_m_0_valid                      (router_b_0_valid),
    .axi_m_0_identity                   (router_b_0_operate),
    .axi_m_0_stream                    ({router_b_0_data,
                                         router_b_0_last}),

    .axi_m_1_ready                      (router_b_1_ready),
    .axi_m_1_valid                      (router_b_1_valid),
    .axi_m_1_identity                   (router_b_1_operate),
    .axi_m_1_stream                    ({router_b_1_data,
                                         router_b_1_last})
);

// ----------------------------------------------------------------------------

logic                                   fifo_1_prog_full;
logic                                   fifo_1_write;
logic [2:0]                             fifo_1_din_operate;
logic [31:0]                            fifo_1_din_data;
logic                                   fifo_1_din_last;

logic                                   fifo_1_empty;
logic                                   fifo_1_read;
logic [2:0]                             fifo_1_dout_operate;
logic [31:0]                            fifo_1_dout_data;
logic                                   fifo_1_dout_last;

always_ff @(posedge clock) begin
    if(~reset_n) begin
        router_a_0_ready <= 'h0;
    end else begin
        router_a_0_ready <= (fifo_1_prog_full) ? 1'b0 : 1'b1;
    end
end

always_ff @(posedge clock) begin
    if(~reset_n) begin
        fifo_1_write <= 'h0;
    end else begin
        fifo_1_write <= &{router_a_0_ready,router_a_0_valid};
    end
end

always_ff @(posedge clock) begin
    fifo_1_din_operate <= router_a_0_operate[2:0];
    fifo_1_din_data <= {^{router_a_0_operate[3],router_a_0_data[31]}, router_a_0_data[30:0]}; // inverse
    fifo_1_din_last <= router_a_0_last;
end

sc_fifo
#(
    .write_depth                        (32),
    .write_width                        (3+32+1),
    .read_width                         (3+32+1),
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
fifo_1(
    .clock                              (clock),
    .reset                              (~reset_n),
    .almost_full                        (),
    .prog_full                          (fifo_1_prog_full),
    .full                               (),
    .write                              (fifo_1_write),
    .write_ack                          (),
    .din                               ({fifo_1_din_operate,
                                         fifo_1_din_data,
                                         fifo_1_din_last}),
    .din_count                          (),
    .overflow                           (),
    .almost_empty                       (),
    .prog_empty                         (),
    .empty                              (fifo_1_empty),
    .read                               (fifo_1_read),
    .dout_valid                         (),
    .dout                              ({fifo_1_dout_operate,
                                         fifo_1_dout_data,
                                         fifo_1_dout_last}),
    .dout_count                         (),
    .underflow                          ()
);

logic                                   fifo_2_prog_full;
logic                                   fifo_2_write;
logic [31:0]                            fifo_2_din_data;

logic                                   fifo_2_empty;
logic                                   fifo_2_read;
logic [31:0]                            fifo_2_dout_data;

always_ff @(posedge clock) begin
    if(~reset_n) begin
        router_b_0_ready <= 'h0;
    end else begin
        router_b_0_ready <= (fifo_2_prog_full) ? 1'b0 : 1'b1;
    end
end

always_ff @(posedge clock) begin
    if(~reset_n) begin
        fifo_2_write <= 'h0;
    end else begin
        fifo_2_write <= &{router_b_0_ready,router_b_0_valid};
    end
end

always_ff @(posedge clock) begin
    fifo_2_din_data <= router_b_0_data;
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
fifo_2(
    .clock                              (clock),
    .reset                              (~reset_n),
    .almost_full                        (),
    .prog_full                          (fifo_2_prog_full),
    .full                               (),
    .write                              (fifo_2_write),
    .write_ack                          (),
    .din                                (fifo_2_din_data),
    .din_count                          (),
    .overflow                           (),
    .almost_empty                       (),
    .prog_empty                         (),
    .empty                              (fifo_2_empty),
    .read                               (fifo_2_read),
    .dout_valid                         (),
    .dout                               (fifo_2_dout_data),
    .dout_count                         (),
    .underflow                          ()
);

logic                                   fifo_3_prog_full;
logic                                   fifo_3_write;
logic [31:0]                            fifo_3_din_data;

logic                                   fifo_3_empty;
logic                                   fifo_3_read;
logic [31:0]                            fifo_3_dout_data;

always_ff @(posedge clock) begin
    if(~reset_n) begin
        router_b_1_ready <= 'h0;
    end else begin
        router_b_1_ready <= (fifo_3_prog_full) ? 1'b0 : 1'b1;
    end
end

always_ff @(posedge clock) begin
    if(~reset_n) begin
        fifo_3_write <= 'h0;
    end else begin
        fifo_3_write <= &{router_b_1_ready,router_b_1_valid};
    end
end

always_ff @(posedge clock) begin
    fifo_3_din_data <= router_b_1_data;
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
fifo_3(
    .clock                              (clock),
    .reset                              (~reset_n),
    .almost_full                        (),
    .prog_full                          (fifo_3_prog_full),
    .full                               (),
    .write                              (fifo_3_write),
    .write_ack                          (),
    .din                                (fifo_3_din_data),
    .din_count                          (),
    .overflow                           (),
    .almost_empty                       (),
    .prog_empty                         (),
    .empty                              (fifo_3_empty),
    .read                               (fifo_3_read),
    .dout_valid                         (),
    .dout                               (fifo_3_dout_data),
    .dout_count                         (),
    .underflow                          ()
);

// ----------------------------------------------------------------------------

logic                                   multiply_a_ready;
logic                                   multiply_a_valid;
logic [31:0]                            multiply_a_data;
logic                                   multiply_a_last;
logic [2:0]                             multiply_a_operate;

logic                                   multiply_b_ready;
logic                                   multiply_b_valid;
logic [31:0]                            multiply_b_data;

logic                                   multiply_r_valid;
logic                                   multiply_r_ready;
logic [31:0]                            multiply_r_data;
logic                                   multiply_r_last;
logic [2:0]                             multiply_r_operate;

assign multiply_a_valid = (fifo_1_empty) ? 1'b0 : 1'b1;
assign fifo_1_read = (fifo_1_empty) ? 1'b0 : multiply_a_ready;
assign multiply_a_data = fifo_1_dout_data;
assign multiply_a_last = fifo_1_dout_last;
assign multiply_a_operate = fifo_1_dout_operate;

assign multiply_b_valid = (fifo_2_empty) ? 1'b0 : 1'b1;
assign fifo_2_read = (fifo_2_empty) ? 1'b0 : multiply_b_ready;
assign multiply_b_data = fifo_2_dout_data;

fp_multiply
#(

)
fp_multiply(
    .aclk                               (clock),
    .aresetn                            (reset_n),
    .s_axis_a_tvalid                    (multiply_a_valid),
    .s_axis_a_tready                    (multiply_a_ready),
    .s_axis_a_tdata                     (multiply_a_data),
    .s_axis_a_tlast                     (multiply_a_last),
    .s_axis_a_tuser                     (multiply_a_operate),
    .s_axis_b_tvalid                    (multiply_b_valid),
    .s_axis_b_tready                    (multiply_b_ready),
    .s_axis_b_tdata                     (multiply_b_data),
    .m_axis_result_tvalid               (multiply_r_valid),
    .m_axis_result_tready               (multiply_r_ready),
    .m_axis_result_tdata                (multiply_r_data),
    .m_axis_result_tlast                (multiply_r_last),
    .m_axis_result_tuser                (multiply_r_operate)
);

logic                                   router_c_0_ready;
logic                                   router_c_0_valid;
logic [1:0]                             router_c_0_operate;
logic [31:0]                            router_c_0_data;
logic                                   router_c_0_last;

logic                                   router_c_1_ready;
logic                                   router_c_1_valid;
logic [1:0]                             router_c_1_operate;
logic [31:0]                            router_c_1_data;
logic                                   router_c_1_last;

router
#(
    .identity_width                     (2),
    .stream_width                       (32+1)
)
router_c(
    .clock                              (clock),
    .reset                              (~reset_n),

    .axi_s_ready                        (multiply_r_ready),
    .axi_s_valid                        (multiply_r_valid),
    .axi_s_identity                     (multiply_r_operate),
    .axi_s_stream                      ({multiply_r_data,
                                         multiply_r_last}),

    .axi_m_0_ready                      (router_c_0_ready),
    .axi_m_0_valid                      (router_c_0_valid),
    .axi_m_0_identity                   (router_c_0_operate),
    .axi_m_0_stream                    ({router_c_0_data,
                                         router_c_0_last}),

    .axi_m_1_ready                      (router_c_1_ready),
    .axi_m_1_valid                      (router_c_1_valid),
    .axi_m_1_identity                   (router_c_1_operate),
    .axi_m_1_stream                    ({router_c_1_data,
                                         router_c_1_last})
);

logic                                   accumulator_r_valid;
logic                                   accumulator_r_ready;
logic [31:0]                            accumulator_r_data;
logic                                   accumulator_r_last;
logic                                   accumulator_r_operate;

fp_accumulator
#(

)
fp_accumulator(
    .aclk                               (clock),
    .aresetn                            (reset_n),
    .s_axis_a_tvalid                    (router_c_1_valid),
    .s_axis_a_tready                    (router_c_1_ready),
    .s_axis_a_tdata                     (router_c_1_data),
    .s_axis_a_tlast                   (&{router_c_1_operate[1],
                                         router_c_1_last}),
    .s_axis_a_tuser                     (router_c_1_operate[0]),
    .m_axis_result_tvalid               (accumulator_r_valid),
    .m_axis_result_tready               (accumulator_r_ready),
    .m_axis_result_tdata                (accumulator_r_data),
    .m_axis_result_tlast                (accumulator_r_last),
    .m_axis_result_tuser                (accumulator_r_operate)
);

logic                                   router_d_0_ready;
logic                                   router_d_0_valid;
logic                                   router_d_0_operate;
logic [31:0]                            router_d_0_data;

logic                                   router_d_1_ready;
logic                                   router_d_1_valid;
logic                                   router_d_1_operate;
logic [31:0]                            router_d_1_data;

router
#(
    .identity_width                     (1),
    .stream_width                       (32)
)
router_d(
    .clock                              (clock),
    .reset                              (~reset_n),

    .axi_s_ready                        (accumulator_r_ready),
    .axi_s_valid                      (&{accumulator_r_valid,
                                         accumulator_r_last}),
    .axi_s_identity                    ({accumulator_r_operate,1'b0}),
    .axi_s_stream                       (accumulator_r_data),

    .axi_m_0_ready                      (router_d_0_ready),
    .axi_m_0_valid                      (router_d_0_valid),
    .axi_m_0_identity                   (router_d_0_operate),
    .axi_m_0_stream                     (router_d_0_data),

    .axi_m_1_ready                      (router_d_1_ready),
    .axi_m_1_valid                      (router_d_1_valid),
    .axi_m_1_identity                   (router_d_1_operate),
    .axi_m_1_stream                     (router_d_1_data)
);

logic                                   divide_b_ready;
logic                                   divide_b_valid;
logic [31:0]                            divide_b_data;

logic                                   divide_r_ready;
logic                                   divide_r_valid;
logic [31:0]                            divide_r_data;

assign divide_b_valid = (fifo_3_empty) ? 1'b0 : 1'b1;
assign fifo_3_read = (fifo_3_empty) ? 1'b0 : divide_b_ready;
assign divide_b_data = fifo_3_dout_data;

fp_divide
#(

)
fp_divide(
    .aclk                               (clock),
    .aresetn                            (reset_n),
    .s_axis_a_tvalid                    (router_d_1_valid),
    .s_axis_a_tready                    (router_d_1_ready),
    .s_axis_a_tdata                     (router_d_1_data),
    .s_axis_b_tvalid                    (divide_b_valid),
    .s_axis_b_tready                    (divide_b_ready),
    .s_axis_b_tdata                     (divide_b_data),
    .m_axis_result_tvalid               (divide_r_valid),
    .m_axis_result_tready               (divide_r_ready),
    .m_axis_result_tdata                (divide_r_data)
);

assign router_c_0_ready = alu_rready;
assign router_d_0_ready = alu_rready;
assign divide_r_ready = alu_rready;

always_comb begin
    if(router_c_0_valid || router_d_0_valid || divide_r_valid) begin
        alu_rvalid <= 1'b1;
    end else begin
        alu_rvalid <= 1'b0;
    end
end

always_comb begin
    if(router_c_0_valid) begin
        alu_rdata <= router_c_0_data;
    end else if(router_d_0_valid) begin
        alu_rdata <= router_d_0_data;
    end else begin
        alu_rdata <= divide_r_data;
    end
end

always_comb begin
    if(router_c_0_valid) begin
        alu_rlast <= router_c_0_last;
    end else begin
        alu_rlast <= 1'b1;
    end
end

endmodule
