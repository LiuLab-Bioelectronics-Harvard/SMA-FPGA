`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
//  1.get parameter from pc
//  2.receive user data
/////////////////////////////////////////////////////////////////////////////

module bram_zynq_calc(
    input               clk                  ,
    input               rst_n                ,
    //parameter
    input               bram_zynq_data_rdy   ,
    output reg [31:0]   bram_zynq_addr       ,
    output reg [31:0]   bram_zynq_dout       ,
    input      [31:0]   bram_zynq_din        ,
    output reg          bram_zynq_en         ,
    output reg [3:0]    bram_zynq_we         ,
    //data-calc
    output     [31:0]   o_bram_calc_addr     ,
    output     [31:0]   o_bram_calc_dout     ,
    input      [31:0]   i_bram_calc_din      ,
    output              o_bram_calc_en       ,
    output     [3:0]    o_bram_calc_we       ,
    output reg          o_calc_trigger       ,
    //uart read y parameter
    input               i_uart_req           ,
    input      [31:0]   bram_uart_addr       ,
    output     [31:0]   bram_uart_dout       ,
    input               bram_uart_en         ,
    input      [3:0]    bram_uart_we         ,
    //write machine bram
    output     [31:0]   o_bram_machine_addr  ,
    output     [31:0]   o_bram_machine_dout  ,
    output              o_bram_machine_en    ,
    output     [3:0]    o_bram_machine_we    ,
    //bluetooth init
    output              o_bluetooth_init     ,
    //
    input               i_reply_vld          ,//uart 
    input               i_ok_or_ng           ,//result
    output    reg       o_overtime_flag       ,
    output    reg       o_zynq_reply_flag       //pc
    );
 
//------------------------------------------------------------------
//1.1 parameter
//------------------------------------------------------------------ 
    parameter   CLK_PERIOD                   = 50000; 
    
    parameter  	ADDR_IDLE          			= 4'd0 	;   
    parameter  	ADDR_START         			= 4'd1 	;	
    parameter  	ADDR_ADD    			    = 4'd2 	;
    parameter  	HEAD_REPLY          	    = 4'd3 	;   
    parameter  	DATA1_REPLY         		= 4'd4 	;	
    parameter  	DATA2_REPLY    			    = 4'd5 	;
    parameter  	DATA3_REPLY          		= 4'd6 	;   
    parameter  	DATA4_REPLY         		= 4'd7 	;	
    parameter  	AA_REPLY    			    = 4'd8 	;
	parameter  	END_REPLY    			    = 4'd9 	;

    parameter  	DATA_IDLE          			= 4'd0 	;
    parameter  	DATA_HEAD         			= 4'd1 	;	
    parameter  	DATA_TYPE    			    = 4'd2 	;	
    parameter  	DATA_LENGTH_H    			= 4'd3 	;	
    parameter  	DATA_LENGTH_L			    = 4'd4 	;	
    parameter  	DATA_WAIT          			= 4'd5 	;
	parameter  	DATA_END          			= 4'd6 	;

	parameter	BRAM_ZYNQ_START_ADDR	    = 0		;	
    
    parameter  	INIT_W_PARA_ADDR          	= 32'h0000 	;
    parameter  	INIT_Z_PARA_ADDR         	= 32'h0100 	;	
    parameter  	INIT_M_PARA_ADDR    	    = 32'h0200 	;	
    parameter  	INIT_T_PARA_ADDR    		= 32'h0240 	;
	parameter  	INIT_X_PARA_ADDR    		= 32'h0280 	;
    //parameter  	INIT_Y_PARA_ADDR    		= 32'h02c0 	;
    parameter  	INIT_STEP_PARA_ADDR			= 32'h02d0 	;	
    parameter  	INIT_1STEP_PARA_ADDR        = 32'h02d4 	;
	parameter  	INIT_1_PARA_ADDR          	= 32'h02d8 	;
    
    parameter  	INIT_MACHINE_PARA_ADDR      = 32'h0000 	;


//------------------------------------------------------------------
//1.2 register
//------------------------------------------------------------------
    reg [31:0]   bram_calc_addr ;
    reg [31:0]   bram_calc_dout ;
    reg          bram_calc_en   ;
    reg [3:0]    bram_calc_we   ;
    
    reg [31:0]   bram_machine_addr  ;
    reg [31:0]   bram_machine_dout  ;
    reg          bram_machine_en    ;
    reg [3:0]    bram_machine_we    ;
    
    reg [3:0]   state_addr      ; 
    reg [3:0]   state_data      ;
    reg [15:0]  data_length     ;
    reg [7:0]   data_pack_type  ;
    reg         para_ok_or_ng   ;
    
    reg         zynq_reply_flag;
    reg [31:0]   reply_time_cnt;
    reg [31:0]   over_time_cnt;
    reg         overtime_flag_d0;
    reg         overtime_flag_d1;
    

    reg         start_rd_d0     ;
    reg         start_rd_d1     ;
    reg         reply_vld_d0     ;
    reg         reply_vld_d1     ;
    reg [3:0]   next_state       ;
    
    reg         bluetooth_init_start;
    reg [3:0]   data_cnt        ;
    reg [31:0]  data_4bty       ; 
    reg         data_4bty_en    ;
    

//------------------------------------------------------------------
//2.1 read instruction
//------------------------------------------------------------------ 

    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            start_rd_d0 <= 1'd0;
            start_rd_d1 <= 1'd0;
        end
        else begin 
            start_rd_d0 <= bram_zynq_data_rdy;
            start_rd_d1 <= start_rd_d0;
        end 
    end
    
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            reply_vld_d0 <= 1'd0;
            reply_vld_d1 <= 1'd0;
        end
        else begin 
            reply_vld_d0 <= i_reply_vld;
            reply_vld_d1 <= reply_vld_d0;
        end 
    end
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            next_state <= 4'd0;
        end
        else begin 
            next_state <= state_data;
        end 
    end
//------------------------------------------------------------------
//2.2 address
//------------------------------------------------------------------        
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            state_addr       <= ADDR_IDLE;
            bram_zynq_en     <= 1'd0;
            bram_zynq_addr   <= 32'd0;
            bram_zynq_we     <= 4'b0000;
            bram_zynq_dout   <= 32'd0;
            zynq_reply_flag  <= 1'b0;
        end
        else begin 
            case(state_addr)
                ADDR_IDLE:
                    begin
                        if(~start_rd_d1 && start_rd_d0)begin 
                            bram_zynq_en    <= 1'b1;
                            bram_zynq_addr  <= 32'd0;
                            bram_zynq_we    <= 4'b0000;
                            state_addr      <=state_addr+ 8'd1;
                            end
                        else if((~reply_vld_d1 && reply_vld_d0)|| (~overtime_flag_d1 && overtime_flag_d0) ||(next_state==DATA_END && state_data==DATA_IDLE && (data_pack_type!=8'h00) && (data_pack_type!=8'h09) ))begin
                            bram_zynq_en    <= 1'b0;
                            bram_zynq_addr  <= 32'd0;
                            bram_zynq_we    <= 4'b1111;
                            state_addr      <= HEAD_REPLY;
                            
                        end
                        zynq_reply_flag <= 1'b0;
                    end
                ADDR_START:
                    begin
                        state_addr       <=state_addr+ 8'd1;
                        bram_zynq_addr   <= bram_zynq_addr+4;
                    end
                ADDR_ADD:
                    begin
                        if((state_data==DATA_IDLE)||(state_data==DATA_END))begin
                            bram_zynq_en   <= 1'b0;
                            bram_zynq_addr <= 32'd0;
                            state_addr     <= ADDR_IDLE;                               
                        end
                        else begin                               
                            state_addr     <=state_addr;
                            bram_zynq_addr <= bram_zynq_addr+4;
                        end
                    end
                HEAD_REPLY:
                    begin                        
                        bram_zynq_en   <= 1'b1;
                        bram_zynq_addr <= 32'd0;
                        bram_zynq_dout <= 32'h00000042;
                        state_addr     <= DATA1_REPLY;                                                     
                    end    
                DATA1_REPLY:
                    begin                        
                        bram_zynq_en   <= 1'b1;
                        bram_zynq_addr <= 32'd4;
                        bram_zynq_dout <= 32'h00000000;
                        state_addr     <= DATA2_REPLY;                                                     
                    end
                DATA2_REPLY:
                    begin                        
                        bram_zynq_en   <= 1'b1;
                        bram_zynq_addr <= 32'd8;
                        bram_zynq_dout <= 32'h00000000;
                        state_addr     <= DATA3_REPLY;                                                     
                    end
                DATA3_REPLY:
                    begin                        
                        bram_zynq_en   <= 1'b1;
                        bram_zynq_addr <= 32'd12;
                        bram_zynq_dout <= 32'h00000000;
                        state_addr     <= DATA4_REPLY;                                                     
                    end
                DATA4_REPLY:
                    begin                        
                        bram_zynq_en   <= 1'b1;
                        bram_zynq_addr <= 32'd16;
                        bram_zynq_dout <= o_overtime_flag?32'h00000000:i_ok_or_ng || para_ok_or_ng;
                        state_addr     <= AA_REPLY;                                                     
                    end
                AA_REPLY:
                    begin                        
                        bram_zynq_en   <= 1'b1;
                        bram_zynq_addr <= 32'd20;
                        bram_zynq_dout <= 32'h000000aa;
                        state_addr     <= END_REPLY;                                                     
                    end
                END_REPLY:
                    begin                        
                        bram_zynq_en   <= 1'b0;
                        bram_zynq_addr <= 32'd0;
                        bram_zynq_dout <= 32'h00000000;
                        state_addr     <= ADDR_IDLE;
                        zynq_reply_flag <= 1'b1;                        
                    end                                       
                    
                default: state_addr<= ADDR_IDLE;
            endcase
        end
    end 
//------------------------------------------------------------------
//2.3 crc
//------------------------------------------------------------------     
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n)begin
            reply_time_cnt    <= 32'd0;
            over_time_cnt     <= 32'd0;
            o_zynq_reply_flag <= 1'b0;
            o_overtime_flag   <= 1'b0;
            overtime_flag_d0   <= 1'b0;
            overtime_flag_d1   <= 1'b0;
        end
        else begin
            if ( zynq_reply_flag == 1'b1) begin
		       o_zynq_reply_flag <= 1'b1;
		    end
		    else if(reply_time_cnt > CLK_PERIOD*5) begin//5ms
		       o_zynq_reply_flag <= 1'b0;
		    end
            
		    if (o_zynq_reply_flag) begin
		       reply_time_cnt <= reply_time_cnt+1'b1;
		    end
		    else begin
		       reply_time_cnt <= 32'd0;
		    end	
            
            
           if(o_zynq_reply_flag || o_overtime_flag)begin
              over_time_cnt  <= 32'd0;
           end
           else if(bram_zynq_data_rdy)begin
              over_time_cnt   <= over_time_cnt+ 1'b1;
           end                     
           if(over_time_cnt>CLK_PERIOD*4000)begin//4s
              o_overtime_flag   <= 1'b1;
           end
           else if(bram_zynq_data_rdy==1'b0) begin
              o_overtime_flag   <= 1'b0;
           end
           
           overtime_flag_d0<=o_overtime_flag;
           overtime_flag_d1<=overtime_flag_d0;
            
        end
    end
//------------------------------------------------------------------
//2.4 instruction
//------------------------------------------------------------------                  
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            state_data       <= DATA_IDLE;
            data_length      <= 16'd0;
            data_pack_type   <= 8'd0;
            para_ok_or_ng    <=1'b0;
        end
        else begin 
            case(state_data)
                DATA_IDLE:
                    begin
                        if(bram_zynq_en && (bram_zynq_we == 4'b0000))begin
                            state_data<=state_data+ 8'd1;
                            para_ok_or_ng<=1'b0;
                        end
                    end
                DATA_HEAD:
                    begin//解�?包头
                        if(bram_zynq_din[7:0]==8'h42)begin
                            state_data<=state_data+ 8'd1;
                        end
                        else begin
                            state_data<= DATA_IDLE;
                        end
                    end
                DATA_TYPE:
                    begin
                        data_pack_type     <=bram_zynq_din[7:0];
                        if(bram_zynq_din[7:0]>8'h0a)begin
                            state_data     <= DATA_IDLE;
                        end
                        else begin                       
                            state_data     <=state_data+ 8'd1; 
                        end                        
                    end
                DATA_LENGTH_H:
                    begin
                        data_length[15:8]  <=bram_zynq_din[7:0];
                        state_data         <=state_data+ 8'd1;                         
                    end
                DATA_LENGTH_L:
                    begin
                        data_length[7:0]   <=bram_zynq_din[7:0];
                        state_data         <=state_data+ 8'd1;                         
                    end               
                DATA_WAIT:
                    begin
                        if(bram_zynq_addr=={data_length[15:0],2'b00}+20)begin
                            state_data<=state_data+1;    
                        end
                        else begin
                            state_data<=state_data; 
                        end                                  
                    end
                DATA_END:
                    begin
                        state_data<=DATA_IDLE;
                        para_ok_or_ng<=1'b1;                        
                    end    
                default: state_data<=DATA_IDLE;
            endcase
        end 
    end 
//================================================================================================
//3.setup calc parameter                                                      
//================================================================================================ 
//------------------------------------------------------------------
//3.1 bluetooth init
//------------------------------------------------------------------    
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            bluetooth_init_start <= 1'd0;           
        end
        else begin 
            if((data_pack_type==8'h00) && (state_data==DATA_WAIT))begin
                bluetooth_init_start <= 1'd1; 
            end
            else begin
                bluetooth_init_start <= 1'd0; 
            end
        end 
    end     
    assign o_bluetooth_init=bluetooth_init_start;
    
//------------------------------------------------------------------
//3.2 data_4Bty
//------------------------------------------------------------------   
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin            
            data_cnt             <= 4'd0;
            data_4bty            <= 32'd0; 
            data_4bty_en         <= 1'b0;            
        end
        else begin 
            
            if(data_cnt==4'd3)begin
                data_cnt             <= 4'd0;
                data_4bty[31:0]      <= {data_4bty[23:0],bram_zynq_din[7:0]};
                data_4bty_en         <= 1'b1; 
            end
            else if(state_data==DATA_WAIT && data_pack_type!=8'h00)begin 
                data_4bty[31:0]      <= {data_4bty[23:0],bram_zynq_din[7:0]};
                data_cnt             <= data_cnt+4'd1;
                data_4bty_en         <= 1'b0; 
            end
            else begin
                data_cnt             <= 4'd0;
                data_4bty[31:0]      <= 32'd0;
                data_4bty_en         <= 1'b0;
            end
        end 
    end 
//------------------------------------------------------------------
//3.3 calc model init
//------------------------------------------------------------------      
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            bram_calc_addr       <= 32'd0;
            bram_calc_dout       <= 32'd0;
            bram_calc_en         <= 1'd0;
            bram_calc_we         <= 1'd0;  
            
        end
        else begin 
            if((data_pack_type==8'h01) && (state_data==DATA_LENGTH_L))begin // w
                bram_calc_addr       <= INIT_W_PARA_ADDR;
                bram_calc_dout       <= 32'd0;
                bram_calc_en         <= 1'd0;
                bram_calc_we         <= 1'd0; 
            end
            else if((data_pack_type==8'h01) && (state_data==DATA_WAIT)&& data_4bty_en)begin
                bram_calc_addr       <= bram_calc_addr+4;
                bram_calc_dout       <= data_4bty;
                bram_calc_en         <= 1'd1;
                bram_calc_we         <= 1'd1;
            end
            else if((data_pack_type==8'h02) && (state_data==DATA_LENGTH_L))begin // z
                bram_calc_addr       <= INIT_Z_PARA_ADDR;
                bram_calc_dout       <= 32'd0;
                bram_calc_en         <= 1'd0;
                bram_calc_we         <= 1'd0; 
            end
            else if((data_pack_type==8'h02) && (state_data==DATA_WAIT)&& data_4bty_en)begin
                bram_calc_addr       <= bram_calc_addr+4;
                bram_calc_dout       <= data_4bty;
                bram_calc_en         <= 1'd1;
                bram_calc_we         <= 1'd1;
            end
            else if((data_pack_type==8'h03) && (state_data==DATA_LENGTH_L))begin // m
                bram_calc_addr       <= INIT_M_PARA_ADDR;
                bram_calc_dout       <= 32'd0;
                bram_calc_en         <= 1'd0;
                bram_calc_we         <= 1'd0; 
            end
            else if((data_pack_type==8'h03) && (state_data==DATA_WAIT)&& data_4bty_en)begin
                bram_calc_addr       <= bram_calc_addr+4;
                bram_calc_dout       <= data_4bty;
                bram_calc_en         <= 1'd1;
                bram_calc_we         <= 1'd1;
            end
            else if((data_pack_type==8'h04) && (state_data==DATA_LENGTH_L))begin // T
                bram_calc_addr       <= INIT_T_PARA_ADDR;
                bram_calc_dout       <= 32'd0;
                bram_calc_en         <= 1'd0;
                bram_calc_we         <= 1'd0; 
            end
            else if((data_pack_type==8'h04) && (state_data==DATA_WAIT)&& data_4bty_en)begin
                bram_calc_addr       <= bram_calc_addr+4;
                bram_calc_dout       <= data_4bty;
                bram_calc_en         <= 1'd1;
                bram_calc_we         <= 1'd1;
            end
            else if((data_pack_type==8'h05) && (state_data==DATA_LENGTH_L))begin // STEP
                bram_calc_addr       <= INIT_STEP_PARA_ADDR;
                bram_calc_dout       <= 32'd0;
                bram_calc_en         <= 1'd0;
                bram_calc_we         <= 1'd0; 
            end
            else if((data_pack_type==8'h05) && (state_data==DATA_WAIT)&& data_4bty_en)begin
                bram_calc_addr       <= bram_calc_addr+4;
                bram_calc_dout       <= data_4bty;
                bram_calc_en         <= 1'd1;
                bram_calc_we         <= 1'd1;
            end
            else if((data_pack_type==8'h06) && (state_data==DATA_LENGTH_L))begin // 1STEP
                bram_calc_addr       <= INIT_1STEP_PARA_ADDR;
                bram_calc_dout       <= 32'd0;
                bram_calc_en         <= 1'd0;
                bram_calc_we         <= 1'd0; 
            end
            else if((data_pack_type==8'h06) && (state_data==DATA_WAIT)&& data_4bty_en)begin
                bram_calc_addr       <= bram_calc_addr+4;
                bram_calc_dout       <= data_4bty;
                bram_calc_en         <= 1'd1;
                bram_calc_we         <= 1'd1;
            end
            else if((data_pack_type==8'h07) && (state_data==DATA_LENGTH_L))begin // -1
                bram_calc_addr       <= INIT_1_PARA_ADDR;
                bram_calc_dout       <= 32'd0;
                bram_calc_en         <= 1'd0;
                bram_calc_we         <= 1'd0; 
            end
            else if((data_pack_type==8'h07) && (state_data==DATA_WAIT)&& data_4bty_en)begin
                bram_calc_addr       <= bram_calc_addr+4;
                bram_calc_dout       <= data_4bty;
                bram_calc_en         <= 1'd1;
                bram_calc_we         <= 1'd1;
            end
            else if((data_pack_type==8'h09) && (state_data==DATA_LENGTH_L))begin // X
                bram_calc_addr       <= INIT_X_PARA_ADDR;
                bram_calc_dout       <= 32'd0;
                bram_calc_en         <= 1'd0;
                bram_calc_we         <= 1'd0;                                
            end
            else if((data_pack_type==8'h09) && (state_data==DATA_WAIT)&& data_4bty_en)begin
                bram_calc_addr       <= bram_calc_addr+4;
                bram_calc_dout       <= data_4bty;
                bram_calc_en         <= 1'd1;
                bram_calc_we         <= 1'd1;
            end
            else begin
                bram_calc_en         <= 1'd0;
            end                    
        end 
    end
//------------------------------------------------------------------
//3.4 o_calc_trigger
//------------------------------------------------------------------   
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin            
            o_calc_trigger         <= 1'b0;            
        end
        else begin            
            if((data_pack_type==8'h09) && (state_data==DATA_END))begin
                o_calc_trigger         <= 1'b1; 
            end
            else begin 
                o_calc_trigger         <= 1'b0; 
            end
        end 
    end     
//------------------------------------------------------------------
//3.5 read Y parameter
//------------------------------------------------------------------ 
    assign o_bram_calc_addr = i_uart_req?bram_uart_addr:(bram_calc_addr-4);
    assign o_bram_calc_en   = i_uart_req?bram_uart_en  :bram_calc_en;        
    assign o_bram_calc_we   = i_uart_req?bram_uart_we  :bram_calc_we;
    assign o_bram_calc_dout = i_uart_req?32'd0         :bram_calc_dout;
    assign bram_uart_dout   = i_uart_req?i_bram_calc_din : 32'd0;
//------------------------------------------------------------------
//3.6 machine code
//------------------------------------------------------------------ 
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            bram_machine_addr       <= 32'd0;
            bram_machine_dout       <= 32'd0;
            bram_machine_en         <= 1'd0;
            bram_machine_we         <= 1'd0;  
            
        end
        else begin 
            if((data_pack_type==8'h08) && (state_data==DATA_LENGTH_L))begin // machine
                bram_machine_addr       <= INIT_MACHINE_PARA_ADDR;
                bram_machine_dout       <= 32'd0;
                bram_machine_en         <= 1'd0;
                bram_machine_we         <= 1'd0; 
            end
            else if((data_pack_type==8'h08) && (state_data==DATA_WAIT)&& data_4bty_en)begin
                bram_machine_addr       <= bram_machine_addr+4;
                bram_machine_dout       <= data_4bty;
                bram_machine_en         <= 1'd1;
                bram_machine_we         <= 1'd1;
            end
            else begin
                bram_machine_en         <= 1'd0;
            end
        end
    end
    assign o_bram_machine_addr =bram_machine_addr-4; 
    assign o_bram_machine_dout =bram_machine_dout; 
    assign o_bram_machine_en   =bram_machine_en; 
    assign o_bram_machine_we   =bram_machine_we;     
 



//================================================================================================
//4.debug test                                                       
//================================================================================================  
    (* dont_touch="true" *)(* mark_debug = "true" *)	reg           de_bram_en   ;
    (* dont_touch="true" *)(* mark_debug = "true" *)	reg  [31:0]   de_bram_addr ;
    (* dont_touch="true" *)(* mark_debug = "true" *)	reg  [31:0]   de_bram_din  ;
    (* dont_touch="true" *)(* mark_debug = "true" *)	reg           de_bram_data_rdy; 
    (* dont_touch="true" *)(* mark_debug = "true" *)	reg  [3:0]    de_state_data   ; 
    (* dont_touch="true" *)(* mark_debug = "true" *)	reg           de_o_calc_trigger;    
    
    always@(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            de_bram_en          <= 1'd0 ;
            de_bram_addr        <= 32'd0;
            de_bram_din         <= 32'd0;
            de_bram_data_rdy    <= 1'd0 ;
            de_state_data       <= 4'd0 ;
            de_o_calc_trigger   <= 1'd0;
        end
        else begin 
            de_bram_en          <= bram_zynq_en       ;
            de_bram_addr        <= bram_zynq_addr     ;
            de_bram_din         <= bram_zynq_din      ;
            de_bram_data_rdy    <= bram_zynq_data_rdy ;
            de_state_data       <= state_data    ;
            de_o_calc_trigger   <= o_calc_trigger;
        end 
    end 
    
    
    
endmodule
