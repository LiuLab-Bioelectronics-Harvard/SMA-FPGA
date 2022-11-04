
`timescale 1ns / 1ps

module uart_rx
   #(
	parameter BAUDRATE   = 115200 , //BPS
	parameter CLK_PERIOD = 50000  //kHZ
	)
	(
	input            iclk      ,
	input            irst_n    ,
	input            i_RX      ,
	output [7:0]     o_RX_DATA ,
	output reg       o_valid_RX
	);

// ======================================================
// reg/wire/localparam signal define
// ======================================================
localparam CLK_DIV = CLK_PERIOD * 1000 / ( BAUDRATE * 16 );

reg [8:0] cnt_div;				
reg clk_uart_rx;					
wire rxd;
reg [7:0] R_RX_DATA;
reg  RX_D1,RX_D2,RX_D3;
wire clk_uart_rx_bufg;

reg rst_byte_n;
reg [3:0] cnt_16;
reg [9:0] uart_buf;				
reg [3:0] cnt_bit;
reg busy_rx;
// ======================================================
// RTL
// ======================================================
assign rxd       = RX_D3;		 //input uart
assign o_RX_DATA = R_RX_DATA;

// --------------------------------------------------
// baudrate*16
// --------------------------------------------------	
always @(negedge iclk or negedge irst_n)
begin
   if (irst_n == 1'b0) begin
	   cnt_div     <= 9'd0 ;
		clk_uart_rx <= 1'b0 ;
		RX_D1       <= 1'b1 ;
		RX_D2       <= 1'b1 ;
		RX_D3       <= 1'b1 ;//1
	end
	else begin
	   if (rst_byte_n == 1'b0) begin 
	      cnt_div     <= 9'd0 ;
		   clk_uart_rx <= 1'b0 ;
	   end
		else if (cnt_div < CLK_DIV) begin
			cnt_div     <= cnt_div+1;
			clk_uart_rx <= 1'b0;
		end
		else begin
			cnt_div     <= 9'd0;
			clk_uart_rx <= 1'b1;
		end
		
		//异步UART信号
		RX_D1 <= i_RX ;
		RX_D2 <= RX_D1 ;
		RX_D3 <= RX_D2 ;
	end
end

//BUFG BUFG_inst (
//      .O(clk_uart_rx_bufg), // 1-bit output: Clock buffer output
//      .I(clk_uart_rx)  // 1-bit input: Clock buffer input
//   );


// --------------------------------------------------
// UART receiver
// --------------------------------------------------	
always @ (posedge iclk or negedge irst_n)
begin
	if (irst_n == 1'b0) begin
	   R_RX_DATA   <= 8'd0;
		o_valid_RX  <= 1'b0;
		busy_rx     <= 1'b0;
		rst_byte_n  <= 1'b1;
		cnt_16      <= 4'd0;
		uart_buf    <= 10'd0;
		cnt_bit <= 4'd0;
	end
	else begin
		if (busy_rx == 1'b0) begin //idle
		   cnt_16 <= 4'd0;
			cnt_bit <= 4'd0;
		   o_valid_RX  <= 1'b0;
		   if (rxd == 1'b0) begin
			   busy_rx <= 1'b1;
				rst_byte_n <= 1'b0;
			end
		end
		else begin
		   rst_byte_n <= 1'b1;
			if (clk_uart_rx == 1'b1) begin
			   if (cnt_16 < 4'd15) 
					cnt_16 <= cnt_16 + 4'd1;
				else
					cnt_16 <= 4'd0;
					
				if (cnt_16 == 4'd6) begin
			      uart_buf[8:0] <= uart_buf[9:1];
				   uart_buf[9]   <= rxd;
					cnt_bit <= cnt_bit + 4'd1;
					if (cnt_bit == 4'd9) begin 
					   busy_rx     <= 1'b0;
						R_RX_DATA   <= uart_buf[9:2];
		                o_valid_RX  <= 1'b1;
					end
			   end								
			end						
		end
	end
end

endmodule


