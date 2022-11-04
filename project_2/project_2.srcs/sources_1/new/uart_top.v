`timescale 1ns / 1ps

module uart_top(
    input               clk                  ,
    input               rst_n                ,
    
    input               i_uart_rx            ,
    output              o_uart_tx            ,

    input               i_calc_done          ,
    input               i_bluetooth_init     ,
    
    output              o_uart_req           ,
    output     [31:0]   o_bram_uart_addr     ,
    input      [31:0]   i_bram_uart_din      ,
    output              o_bram_uart_en       ,
    output     [3:0]    o_bram_uart_we       ,
    
    output              o_reply_vld          ,
    output              o_ok_or_ng      
    
    );               

    parameter   BAUDRATE                    = 115200;
    parameter   CLK_PERIOD                  = 50000;  //kHZ  
    parameter  	INIT_Y_PARA_ADDR    		= 32'h02c0 	;
    
    parameter  	IDLE_TX    		            = 4'd0 	;
    parameter  	HEAD_TX    		            = 4'd1 	;
    parameter  	TYPE_TX    		            = 4'd2 	;
    parameter  	LENGTH_H_TX    		        = 4'd3 	;
    parameter  	LENGTH_L_TX    		        = 4'd4 	;
    parameter  	DATA_TX    		            = 4'd5 	;
    parameter  	DATA_AA_TX    		        = 4'd6 	;
    parameter  	DATA_CRC_TX    		        = 4'd7 	;
    
    parameter  	IDLE_RX    		            = 4'd0 	;
    parameter  	DATA1_RX    		        = 4'd1 	;
    parameter  	DATA2_RX    		        = 4'd2 	;
    parameter  	DATA3_RX    		        = 4'd3 	;
    parameter  	DATA4_RX    		        = 4'd4 	;
    parameter  	DATA_AA_RX    		        = 4'd5 	;
    parameter  	DATA_CRC_RX   		        = 4'd6 	;
    
    (* dont_touch="true" *)reg         calc_done_d0           ;
    reg         calc_done_d1           ;
    reg         bluetooth_init_d0      ;
    reg         bluetooth_init_d1      ;
    
    reg [7:0]   data_type              ;
    reg [15:0]  data_length            ;
    

    reg [3:0]   state_rd_y             ;            
    reg [7:0]   data_tx                ;
    reg [15:0]  cnt_tx_byte            ;
    reg [3:0]   cnt_tx                 ;
    reg         bram_rd_4byte          ;
    reg [7:0]   delay_cnt              ;
    reg [31:0]  data_y_in              ;
    reg         uart_tx_data_flag      ;
    
    reg [3:0]   state_tx               ;
    reg         bluetooth_init_en      ;
    reg         calc_done_en           ;
    reg [7:0]   check_sum_tx           ;
    reg [7:0]   uart_tx_data           ;
    reg         start_tx               ;
    
    reg [31:0]  cnt_over_time          ;
    reg         break_rx_state         ;
            
    reg [3:0]   state_rx               ;
    reg [7:0]   check_sum_rx           ;
    reg         over_time_flag         ;
    reg         update_flag            ;
    reg         ok_or_ng               ;
            
    wire [7:0] uart_rx_data;
    wire       valid_uart_rx;
    wire       tx_busy;
   
    
    reg [31:0]  bram_uart_addr         ;                
    reg         bram_uart_en           ;
    reg [3:0]   bram_uart_we           ;
    
    
    
      
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            calc_done_d0 <= 1'd0;
            calc_done_d1 <= 1'd0;
        end
        else begin 
            calc_done_d0 <= i_calc_done;
            calc_done_d1 <= calc_done_d0;
        end 
    end
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            bluetooth_init_d0 <= 1'd0;
            bluetooth_init_d1 <= 1'd0;
        end
        else begin 
            bluetooth_init_d0 <= i_bluetooth_init;
            bluetooth_init_d1 <= bluetooth_init_d0;
        end 
    end
    
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            data_type   <= 8'h0;
            data_length <= 16'h0;
        end
        else begin 
            if(calc_done_en)begin
                data_type   <= 8'h01;
                data_length <= 16'h10;
            end
            else if(bluetooth_init_en) begin
                data_type   <= 8'h00;
                data_length <= 16'h01;
            end      
        end 
    end
    
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            state_rd_y   <= 4'd0;
            data_tx      <= 8'h0;
            cnt_tx_byte  <= 16'h0;
            cnt_tx       <= 4'd0;
            bram_rd_4byte<= 1'd0;
            delay_cnt    <= 8'd0;
            data_y_in    <= 32'd0;
            uart_tx_data_flag   <=1'b0; 
        end
        else begin 
            case(state_rd_y)
                4'd0:begin
                    if(calc_done_en && (state_tx==DATA_TX)&& (uart_tx_data_flag == 1'b0)&&(cnt_tx_byte < data_length))begin
                        bram_rd_4byte<= 1'd1;
                        state_rd_y   <= 4'd3;
                    end
                    else if(bluetooth_init_en && (state_tx==DATA_TX)&&(uart_tx_data_flag == 1'b0))begin
                        state_rd_y   <= 4'd1;
                    end
                    else  begin
                        state_rd_y          <= state_rd_y;
                        uart_tx_data_flag   <= 1'b0;
                        cnt_tx_byte         <= 16'd0;
                    end
                end
                4'd1:begin
                     if(tx_busy == 1'b0 && start_tx == 1'b0)begin
                        data_tx             <= 8'h01;                        
                        uart_tx_data_flag   <=1;
                        cnt_tx_byte         <= 16'd1;
                        state_rd_y          <= 4'd2;                        
                    end
                    else begin                       
                        uart_tx_data_flag   <= 1'b0;                                            
                    end 
                    
                end
                4'd2:begin 
                        uart_tx_data_flag   <= 1'b0;
                        if(start_tx == 1'b1)begin                
                            state_rd_y          <= 4'd0;                                                                                         
                        end
                        else begin
                            state_rd_y          <= state_rd_y;
                        end                        
                end
                4'd3:begin
                    if(delay_cnt[2])begin
                        state_rd_y   <= state_rd_y +1;
                        delay_cnt    <= 8'h00;
                        data_y_in    <= i_bram_uart_din;                        
                    end
                    else begin                    
                        delay_cnt    <= {delay_cnt[6:0], 1'b1}; 
                        bram_rd_4byte<= 1'd0;
                    end
                end
                4'd4:begin
                    
                    if(tx_busy == 1'b0 && start_tx == 1'b0 && uart_tx_data_flag==1'b0)begin
                        data_tx             <= data_y_in[31:24]; 
                        data_y_in           <= data_y_in<<8;
                        uart_tx_data_flag   <=1; 
                        cnt_tx              <= cnt_tx+1;                        
                    end
                    else begin
                        
                        uart_tx_data_flag   <= 1'b0;
                                             
                    end 
                    if(cnt_tx==4)begin
                        cnt_tx_byte         <= cnt_tx_byte+16'h4; 
                        state_rd_y          <= 0;
                        cnt_tx              <=4'd0;
                        uart_tx_data_flag   <= 1'b0;                        
                    end                    
                end
                default: state_rd_y          <= 0;
            endcase
                
        end 
    end
   
    
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            bram_uart_addr       <= INIT_Y_PARA_ADDR;                
            bram_uart_en         <= 1'd0;
            bram_uart_we         <= 4'b0000;
        end
        else begin 
            if(calc_done_en)begin
                if(bram_rd_4byte)begin
                    bram_uart_addr       <= bram_uart_addr+32'd4;                
                    bram_uart_en         <= 1'd1;
                    bram_uart_we         <= 4'b0000;
                end
                else begin
                    bram_uart_en         <= 1'd0;
                end               
            end            
            else begin                             
                bram_uart_addr       <= INIT_Y_PARA_ADDR;                
                bram_uart_en         <= 1'd0;
                bram_uart_we         <= 4'b0000;               
            end      
        end 
    end
    assign o_bram_uart_addr       = bram_uart_addr-4;
    assign o_bram_uart_en         = bram_uart_en;
    assign o_bram_uart_we         = bram_uart_we;
    assign o_uart_req             = calc_done_en;
  
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n)begin
            state_tx               <= 4'd0;
            bluetooth_init_en      <= 1'd0;
            calc_done_en           <= 1'd0;
            start_tx               <= 1'b0;
            uart_tx_data           <= 8'd0;
            check_sum_tx           <= 8'd0;
        end
        else begin
            case(state_tx)
                IDLE_TX:
                    begin
                        if(~calc_done_d1 && calc_done_d0)begin                           
                            calc_done_en             <= 1'b1;
                            state_tx                 <= state_tx+1;
                        end
                        else if(~bluetooth_init_d1 && bluetooth_init_d0)begin
                            bluetooth_init_en        <= 1'b1;
                            state_tx                 <= state_tx+1;
                        end
                        else begin
                            state_tx                 <= state_tx;
                            start_tx                 <= 1'b0;
                            uart_tx_data             <= 8'd0;
                            check_sum_tx             <= 8'd0;
                            calc_done_en             <= 1'b0;
                            bluetooth_init_en        <= 1'b0;
                        end                   
                    end
                HEAD_TX://8'h42
                    begin                        
                        start_tx        <= 1'b0;
                        if (tx_busy == 1'b0 && start_tx == 1'b0) begin 
                            start_tx        <= 1'b1;
                            uart_tx_data    <= 8'h42;
                            check_sum_tx    <= 8'h42;
                            state_tx        <= TYPE_TX;                           
                        end
			        end                                                             
                TYPE_TX://8'h00 or 8'h01
                    begin
                        start_tx        <= 1'b0;
                        if (tx_busy == 1'b0 && start_tx == 1'b0) begin 
                            start_tx        <= 1'b1;
                            uart_tx_data    <= data_type;
                            check_sum_tx    <= check_sum_tx+data_type;
                            state_tx        <= LENGTH_H_TX;                             
                        end
                    end
                LENGTH_H_TX://LENGTH_H_TX
                    begin                        
                        start_tx        <= 1'b0;
                        if (tx_busy == 1'b0 && start_tx == 1'b0) begin 
                            start_tx        <= 1'b1;
                            uart_tx_data    <= data_length[15:8];
                            check_sum_tx    <= check_sum_tx+data_length[15:8];
                            state_tx        <= LENGTH_L_TX; 
                        end                            
			        end     
                LENGTH_L_TX://LENGTH_L_TX
                    begin                        
                        start_tx        <= 1'b0;
                        if (tx_busy == 1'b0 && start_tx == 1'b0) begin 
                            start_tx        <= 1'b1;
                            uart_tx_data    <= data_length[7:0];
                            check_sum_tx    <= check_sum_tx+data_length[7:0];
                            state_tx        <= DATA_TX;  
                        end
			        end     
                DATA_TX://data
                    begin                                                                     
                        if (tx_busy == 1'b0 && start_tx == 1'b0 && uart_tx_data_flag) begin 
                            start_tx        <= 1'b1;
                            uart_tx_data    <= data_tx;
                            check_sum_tx    <= check_sum_tx+data_tx;
                            
                        end
                        else if(cnt_tx_byte == data_length)begin
                            state_tx        <= DATA_AA_TX;
                        end 
                        else begin
                            start_tx        <= 1'b0;
                        end
			        end 
                DATA_AA_TX://8'haa
                    begin
                        start_tx        <= 1'b0;
                        if (tx_busy == 1'b0 && start_tx == 1'b0) begin 
                            start_tx        <= 1'b1;
                            uart_tx_data    <= 8'haa;
                            check_sum_tx    <= check_sum_tx+8'haa;
                            state_tx        <= DATA_CRC_TX;  
                        end
                    
                    end
                DATA_CRC_TX://crc
                    begin
                        start_tx        <= 1'b0;
                        if (tx_busy == 1'b0 && start_tx == 1'b0) begin 
                            start_tx        <= 1'b1;
                            uart_tx_data    <= check_sum_tx;
                            check_sum_tx    <= 8'h00;
                            state_tx        <= IDLE_TX; 
                            calc_done_en    <= 1'b0;
                            bluetooth_init_en <= 1'b0;                            
                        end
                    
                    end
                default:state_tx        <= IDLE_TX; 
            endcase                               
        end
    end
    

    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n)begin
            cnt_over_time  <= 32'd0;
            break_rx_state <= 1'b0;
        end
        else begin
            if ( over_time_flag == 1'b1) begin
		       cnt_over_time <= cnt_over_time + 32'd1;
		    end
		    else begin
		       cnt_over_time <= 32'd0;
		    end
		    if (cnt_over_time > CLK_PERIOD*20) begin//20ms
		       break_rx_state <= 1'b1;
		    end
		    else begin
		       break_rx_state <= 1'b0;
		    end	
        end
    end
    
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n)begin
            state_rx               <= 4'd0;
            check_sum_rx           <= 8'd0;
            over_time_flag         <= 1'b0;
            update_flag            <= 1'b0;
            ok_or_ng               <= 1'b0;
        end
        else begin
            case(state_rx)
                IDLE_RX:
                    begin                        
                         update_flag       <= 1'b0 ;  
                         over_time_flag    <= 1'b0 ; 
                        if (break_rx_state == 1'b1) begin
                            state_rx  <= IDLE_RX;                                                              
                        end
                        else if (valid_uart_rx == 1'b1 && uart_rx_data == 8'h42) begin 
                            state_rx          <= DATA1_RX;
                            over_time_flag    <=  1'b1; 
                            check_sum_rx      <= uart_rx_data;
                        end
                                               
                    end                                                            
                DATA1_RX://8'h00 
                    begin
                        if (break_rx_state == 1'b1) begin
                            state_rx          <= IDLE_RX;
                        end
                        else if (valid_uart_rx == 1'b1 ) begin // valid_uart_rx == 1'b1 && uart_rx_data == 8'h00                          
                            state_rx          <= DATA2_RX;
                            check_sum_rx      <= check_sum_rx+uart_rx_data;
                        end
                    end
                DATA2_RX://8'h00 
                    begin
                        if (break_rx_state == 1'b1) begin
                            state_rx          <= IDLE_RX;
                        end
                        else if (valid_uart_rx == 1'b1 ) begin                          
                            state_rx          <= DATA3_RX;
                            check_sum_rx      <= check_sum_rx+uart_rx_data;
                        end
                    end    
                DATA3_RX://8'h00 
                    begin
                        if (break_rx_state == 1'b1) begin
                            state_rx          <= IDLE_RX;
                        end
                        else if (valid_uart_rx == 1'b1 ) begin                         
                            state_rx          <= DATA4_RX;
                            check_sum_rx      <= check_sum_rx+uart_rx_data;
                        end
                    end    
                DATA4_RX:// OK OR NG
                    begin
                        if (break_rx_state == 1'b1) begin
                            state_rx          <= IDLE_RX;
                        end
                        else if (valid_uart_rx == 1'b1 ) begin                           
                            state_rx          <= DATA_AA_RX;
                            check_sum_rx      <= check_sum_rx+uart_rx_data;
                            ok_or_ng          <= uart_rx_data[0];
                        end
                    end    
                    
                DATA_AA_RX:
                    begin                        
                        if (break_rx_state == 1'b1) begin
                            state_rx          <= IDLE_RX;
                        end
                        else if (valid_uart_rx == 1'b1 && uart_rx_data == 8'haa) begin                           
                            state_rx          <= DATA_CRC_RX;
                            check_sum_rx      <= check_sum_rx+uart_rx_data;                           
                        end                            
			        end     
                DATA_CRC_RX:
                    begin                        
                        if (break_rx_state == 1'b1) begin
                            state_rx          <= IDLE_RX;
                        end
                        else if (valid_uart_rx == 1'b1 && (uart_rx_data==check_sum_rx)) begin //crc is ok?                          
                            state_rx          <= IDLE_RX;
                            check_sum_rx      <= 8'h00;
                            update_flag       <= 1'b1;
                            over_time_flag    <= 1'b0; 
                        end
			        end     
               
                default:state_rx        <= IDLE_RX; 
            endcase                               
        end
    end

/*
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n)begin
            o_reply_vld <= 1'b0;
        end
        else begin
            if ( update_flag == 1'b1) begin
		       o_reply_vld <= ok_or_ng;
		    end
		    else begin
		       o_reply_vld <= o_reply_vld;
		    end		    
        end
    end
*/
assign o_reply_vld=  update_flag;
assign o_ok_or_ng =  ok_or_ng   ;  


    
    uart_rx
        #(
        .BAUDRATE   (BAUDRATE) , 
        .CLK_PERIOD (CLK_PERIOD)  
        )
        uart_rx_INST0
        (
        .iclk      (clk),
        .irst_n    (rst_n),
        .i_RX      (i_uart_rx ),
        .o_RX_DATA (uart_rx_data),
        .o_valid_RX(valid_uart_rx)
	);	
	
    uart_tx
        #(
        .BAUDRATE   (BAUDRATE) , 
        .CLK_PERIOD (CLK_PERIOD)  
        )
        uart_tx_INST0
        (	 
        .iclk      (clk),
        .irst_n    (rst_n),
        .i_TX_DATA (uart_tx_data),
        .i_TX_START(start_tx), 
        .o_TX      (o_uart_tx),	
        .o_TX_BUSY (tx_busy),
        .o_CNT_BIT () 	
    );
 


 
endmodule
