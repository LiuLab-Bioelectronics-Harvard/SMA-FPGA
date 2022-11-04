
`timescale 1 ns / 1ps

module tb;

parameter integer                       rom_depth = 1024;

logic                                   clock;
logic                                   reset_n;

initial begin
    clock = 1'b1;
    forever #10 clock = ~clock; // 50MHz
end

initial begin
    reset_n = 1'b0;
    #200
    reset_n = 1'b1;
end


logic [7:0]                             state;
integer                                 count;
shortreal                               fp_din;
shortreal                               fp_dout;

logic                                   write;
logic [31:0]                            address;
logic [31:0]                            din;
logic [31:0]                            dout;
logic                                   trigger;
logic                                   done;

always_ff @(posedge clock) begin
    if(!reset_n) begin
        state <= 8'h01;
    end else begin
        case(state)
            8'h01: // wait a few clocks after reset
                state <= (count == 'hf) ? 8'h02 : state;
            8'h02: // init these matrixs: w, z, m, t, x, y
                state <= (count == 'hB3) ? 8'h04 : state;
            8'h04: // init the step
                state <= 8'h08;
            8'h08: // init 1-step
                state <= 8'h10;
            8'h10: // init the const float(-1.0)
                state <= 8'h20;
            8'h20: // trigger the calc-module to work
                state <= 8'h40;
            8'h40: // waiting for the done signal
                state <= (done) ? 8'h80 : state;
            8'h80: // stop here
                state <= 8'h80;
        endcase

    end
end

always_ff @(posedge clock) begin
    if(!reset_n) begin
        count <= 'h0;
    end else begin
        case(state)
            8'h01:
                count <= (count == 'hf) ? 'h0 : (count+1'b1);
            8'h02, 8'h04, 8'h08:
                count <= count+1'b1;
            default:
                count <= 'h0;
        endcase
    end
end

always_ff @(posedge clock) begin
    if(!reset_n) begin
        write <= 'h0;
    end else begin
        case(state)
            8'h02, 8'h04, 8'h08, 8'h10:
                write <= 1'b1;
            default:
                write <= 1'b0;
        endcase
    end
end

always_ff @(posedge clock) begin
    if(!reset_n) begin
        address <= 'h0;
    end else begin
        address <= {count,2'h0};
    end
end

always_ff @(posedge clock) begin
    if(!reset_n) begin
        trigger <= 'h0;
    end else begin
        case(state)
            8'h20:
                trigger <= 1'b1;
            default:
                trigger <= 1'b0;
        endcase
    end
end

always_ff @(posedge clock) begin
    if(!reset_n) begin
        fp_din <= 0;
    end else begin
        case(state)
            8'h02:
                fp_din <= fp_din + 0.001;
            8'h04:
                fp_din <= 0.01;
            8'h08:
                fp_din <= 0.99;
            8'h10:
                fp_din <= -1.0;
            default:
                fp_din <= 0;
        endcase
    end
end

assign din = $shortrealtobits(fp_din);
assign fp_dout = $bitstoshortreal(dout);

calc
#(
    .rom_depth                          (rom_depth)
)
calc(
    .clock                              (clock),
    .reset_n                            (reset_n),
    .write                              (write),
    .address                            (address),
    .din                                (din),
    .dout                               (dout),
    .trigger                            (trigger),
    .done                               (done)
);

endmodule
