
module router(
    clock,
    reset,

    axi_s_ready,
    axi_s_valid,
    axi_s_identity,
    axi_s_stream,

    // axi_s_identity[msb] = 1'b0
    axi_m_0_ready,
    axi_m_0_valid,
    axi_m_0_identity,
    axi_m_0_stream,

    // axi_s_identity[msb] = 1'b1
    axi_m_1_ready,
    axi_m_1_valid,
    axi_m_1_identity,
    axi_m_1_stream
);

parameter integer                       identity_width = 2;
parameter integer                       stream_width = 32;

// ----------------------------------------------------------------------------

input  logic                            clock;
input  logic                            reset;

output logic                            axi_s_ready;
input  logic                            axi_s_valid;
input  logic [identity_width:0]         axi_s_identity;
input  logic [stream_width-1:0]         axi_s_stream;

input  logic                            axi_m_0_ready;
output logic                            axi_m_0_valid;
output logic [identity_width-1:0]       axi_m_0_identity;
output logic [stream_width-1:0]         axi_m_0_stream;

input  logic                            axi_m_1_ready;
output logic                            axi_m_1_valid;
output logic [identity_width-1:0]       axi_m_1_identity;
output logic [stream_width-1:0]         axi_m_1_stream;

// ----------------------------------------------------------------------------

logic [5:0]                             state;
logic [identity_width-1:0]              identity;
logic [stream_width-1:0]                stream;

always_ff @(posedge clock) begin
    case(state)
        6'h02:
            {identity,stream} <= {axi_s_identity[identity_width-1:0],axi_s_stream};
        default;
    endcase
end

always_ff @(posedge clock) begin
    case(state)
        6'h02:
            {axi_m_0_identity,axi_m_0_stream} <= ((axi_s_valid == 1'b1) && (axi_s_identity[identity_width] == 1'b0) && ({axi_m_0_ready,axi_m_0_valid} != 2'b01)) ? {axi_s_identity[identity_width-1:0],axi_s_stream} : {axi_m_0_identity,axi_m_0_stream};
        6'h04:
            {axi_m_0_identity,axi_m_0_stream} <= (axi_m_0_ready) ? {identity,stream} : {axi_m_0_identity,axi_m_0_stream};
        default;
    endcase
end

always_ff @(posedge clock) begin
    case(state)
        6'h02:
            {axi_m_1_identity,axi_m_1_stream} <= ((axi_s_valid == 1'b1) && (axi_s_identity[identity_width] == 1'b1) && ({axi_m_1_ready,axi_m_1_valid} != 2'b01)) ? {axi_s_identity[identity_width-1:0],axi_s_stream} : {axi_m_1_identity,axi_m_1_stream};
        6'h08:
            {axi_m_1_identity,axi_m_1_stream} <= (axi_m_1_ready) ? {identity,stream} : {axi_m_1_identity,axi_m_1_stream};
        default;
    endcase
end

always_ff @(posedge clock) begin
    if(reset) begin
        axi_s_ready <= 1'b0;
        state <= 6'h01;
        axi_m_0_valid <= 1'b0;
        axi_m_1_valid <= 1'b0;
    end else begin
        case(state)
            6'h01:begin
                axi_s_ready <= 1'b1;
                state <= 6'h02;
                axi_m_0_valid <= 1'b0;
                axi_m_1_valid <= 1'b0;
            end
            6'h02:begin
                if(axi_s_valid) begin
                    if(axi_s_identity[identity_width] == 1'b0) begin
                        axi_s_ready <= axi_m_0_ready;
                        state <= (axi_m_0_ready) ? 6'h02 : ((axi_m_0_valid) ? 6'h04 : 6'h10);
                        axi_m_0_valid <= 1'b1;
                        axi_m_1_valid <= ({axi_m_1_valid,axi_m_1_ready} == 2'b11) ? 1'b0 : axi_m_1_valid;
                    end else begin
                        axi_s_ready <= axi_m_1_ready;
                        state <= (axi_m_1_ready) ? 6'h02 : ((axi_m_1_valid) ? 6'h08: 6'h20);
                        axi_m_0_valid <= ({axi_m_0_valid,axi_m_0_ready} == 2'b11) ? 1'b0 : axi_m_0_valid;
                        axi_m_1_valid <= 1'b1;
                    end
                end else begin
                    axi_s_ready <= 1'b1;
                    state <= state;
                    axi_m_0_valid <= ({axi_m_0_valid,axi_m_0_ready} == 2'b11) ? 1'b0 : axi_m_0_valid;
                    axi_m_1_valid <= ({axi_m_1_valid,axi_m_1_ready} == 2'b11) ? 1'b0 : axi_m_1_valid;
                end
            end
            6'h04:begin
                axi_s_ready <= axi_m_0_ready;
                state <= (axi_m_0_ready) ? 6'h02 : state;
                axi_m_0_valid <= 1'b1;
                axi_m_1_valid <= ({axi_m_1_valid,axi_m_1_ready} == 2'b11) ? 1'b0 : axi_m_1_valid;
            end
            6'h08:begin
                axi_s_ready <= axi_m_1_ready;
                state <= (axi_m_1_ready) ? 6'h02 : state;
                axi_m_0_valid <= ({axi_m_0_valid,axi_m_0_ready} == 2'b11) ? 1'b0 : axi_m_0_valid;
                axi_m_1_valid <= 1'b1;
            end
            6'h10:begin
                axi_s_ready <= axi_m_0_ready;
                state <= (axi_m_0_ready) ? 6'h02 : state;
                axi_m_0_valid <= ({axi_m_0_valid,axi_m_0_ready} == 2'b11) ? 1'b0 : axi_m_0_valid;
                axi_m_1_valid <= ({axi_m_1_valid,axi_m_1_ready} == 2'b11) ? 1'b0 : axi_m_1_valid;
            end
            default:begin // 6'h20
                axi_s_ready <= axi_m_1_ready;
                state <= (axi_m_1_ready) ? 6'h02 : state;
                axi_m_0_valid <= ({axi_m_0_valid,axi_m_0_ready} == 2'b11) ? 1'b0 : axi_m_0_valid;
                axi_m_1_valid <= ({axi_m_1_valid,axi_m_1_ready} == 2'b11) ? 1'b0 : axi_m_1_valid;
            end
        endcase
    end
end

endmodule
