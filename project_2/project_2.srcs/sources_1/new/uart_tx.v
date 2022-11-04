`timescale 1ns / 1ps

module uart_tx
   #(
	parameter BAUDRATE   = 9600 , //BPS
	parameter CLK_PERIOD = 50000  //kHZ
	)
   (	 
	input            iclk      ,
	input            irst_n    ,
	input  [7:0]     i_TX_DATA ,
	input            i_TX_START, 
	output           o_TX      ,	
	output reg       o_TX_BUSY ,
	output reg [3:0] o_CNT_BIT  	
   );
// ======================================================
// reg/wire/localparam signal define
// ======================================================
localparam CLK_DIV = CLK_PERIOD * 1000 / BAUDRATE;

reg txd_reg;					
reg [15:0] count;				
reg clk_uart_tx;					
reg [7:0] uart_buf;			
reg state_tx;

// ======================================================
// RTL
// ======================================================
assign o_TX = txd_reg;	

// --------------------------------------------------
// baudrate
// --------------------------------------------------	
always @(posedge iclk or negedge irst_n)
begin
   if (irst_n == 1'b0) begin
	   count       <= 16'd0;
		clk_uart_tx <= 1'b0;
	end
	else begin
		if (count < CLK_DIV) begin
			count       <= count + 16'd1;
			clk_uart_tx <= 1'b0;
		end
		else begin
			count       <= 16'd0;
			clk_uart_tx <= 1'b1;
		end
	end
end

// --------------------------------------------------
// UART send
// --------------------------------------------------	
always @(posedge iclk or negedge irst_n)
begin
   if (irst_n == 1'b0) begin
	   o_TX_BUSY   <= 1'b0;
		state_tx    <= 1'b0;
		uart_buf    <= 8'd0;
		o_CNT_BIT   <= 4'd0;
		txd_reg     <= 1'b1;
	end
	else begin
		if(i_TX_START==1'b1) begin
			state_tx    <= 1'b1;
			o_TX_BUSY   <= 1'b1;
			uart_buf    <= i_TX_DATA;
		end
		else if (clk_uart_tx == 1'b1) begin
			if (state_tx == 1'b1) begin
				if (o_CNT_BIT < 4'd9) begin 
					o_CNT_BIT    <= o_CNT_BIT+ 4'd1;
					o_TX_BUSY    <= 1'b1;
				end
				else begin
					o_CNT_BIT    <= 4'd0;
					state_tx     <= 1'b0;
					o_TX_BUSY    <= 1'b0;
				end
				
				case (o_CNT_BIT)
					4'h0 : txd_reg <= 1'b0 ;
					4'h1 : txd_reg <= uart_buf[0] ;
					4'h2 : txd_reg <= uart_buf[1] ;
					4'h3 : txd_reg <= uart_buf[2] ;
					4'h4 : txd_reg <= uart_buf[3] ;
					4'h5 : txd_reg <= uart_buf[4] ;
					4'h6 : txd_reg <= uart_buf[5] ;
					4'h7 : txd_reg <= uart_buf[6] ;
					4'h8 : txd_reg <= uart_buf[7] ;
					4'h9 : txd_reg <= 1'b1 ;
				default : txd_reg <= 1'b1 ;
				endcase
			end
			else begin
				o_TX_BUSY <= 1'b0 ;
				txd_reg <= 1'b1 ;
			end
		end
	end
end	

endmodule

