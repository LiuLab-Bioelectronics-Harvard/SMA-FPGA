`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
////  1.pc
////  2.calc
////  3.ble

//////////////////////////////////////////////////////////////////////////////////
module zynq_top(
    DDR_addr           ,
    DDR_ba             ,
    DDR_cas_n          ,
    DDR_ck_n           ,
    DDR_ck_p           ,
    DDR_cke            ,
    DDR_cs_n           ,
    DDR_dm             ,
    DDR_dq             ,
    DDR_dqs_n          ,
    DDR_dqs_p          ,
    DDR_odt            ,
    DDR_ras_n          ,
    DDR_reset_n        ,
    DDR_we_n           ,
    FIXED_IO_ddr_vrn   ,
    FIXED_IO_ddr_vrp   ,
    FIXED_IO_mio       ,
    FIXED_IO_ps_clk    ,
    FIXED_IO_ps_porb   ,
    FIXED_IO_ps_srstb  ,
    i_uart_rx         ,
    o_uart_tx         ,
    fpga_clk       
    );               
//================================================================================================
// interface                                                       
//================================================================================================     
    inout [14:0]    DDR_addr            ;
    inout [2:0]     DDR_ba              ;
    inout           DDR_cas_n           ;
    inout           DDR_ck_n            ;
    inout           DDR_ck_p            ;
    inout           DDR_cke             ;
    inout           DDR_cs_n            ;
    inout [3:0]     DDR_dm              ;
    inout [31:0]    DDR_dq              ;
    inout [3:0]     DDR_dqs_n           ;
    inout [3:0]     DDR_dqs_p           ;
    inout           DDR_odt             ;
    inout           DDR_ras_n           ;
    inout           DDR_reset_n         ;
    inout           DDR_we_n            ;
    inout           FIXED_IO_ddr_vrn    ;
    inout           FIXED_IO_ddr_vrp    ;
    inout [53:0]    FIXED_IO_mio        ;
    inout           FIXED_IO_ps_clk     ;
    inout           FIXED_IO_ps_porb    ;
    inout           FIXED_IO_ps_srstb   ;   
    input           i_uart_rx          ;
    output          o_uart_tx          ;    
    input           fpga_clk            ;
  


//================================================================================================
// signal definition                                                      
//================================================================================================   
    wire [31:0]     bram_zynq_addr      ;
    wire [31:0]     bram_zynq_dout      ;
    wire [31:0]     bram_zynq_din       ;
    wire            bram_zynq_en        ;
    wire [3:0]      bram_zynq_we        ;
    wire            package_receive     ;
    
    wire [31:0]     bram_calc_addr      ;
    wire [31:0]     bram_calc_dout      ;
    wire [31:0]     bram_calc_din       ;
    wire            bram_calc_en        ;
    wire [3:0]      bram_calc_we        ;
    wire            calc_trigger        ;
    wire            calc_done           ;
    
    wire            uart_req            ;
    wire [31:0]     bram_uart_addr      ;
    wire [31:0]     bram_uart_dout      ;
    wire            bram_uart_en        ;
    wire [3:0]      bram_uart_we        ;
    
    wire [31:0]     bram_machine_addr   ;
    wire [31:0]     bram_machine_dout   ;
    wire            bram_machine_en     ;
    wire [3:0]      bram_machine_we     ;
    wire            bluetooth_init      ;
    wire            reply_vld           ;
    wire            ok_or_ng            ;
    wire            overtime_flag       ;
    wire            zynq_reply_flag     ;
    
    
    

    design_1_wrapper u1_zynq_process(
        .DDR_addr               (DDR_addr           ),
        .DDR_ba                 (DDR_ba             ),
        .DDR_cas_n              (DDR_cas_n          ),
        .DDR_ck_n               (DDR_ck_n           ),
        .DDR_ck_p               (DDR_ck_p           ),
        .DDR_cke                (DDR_cke            ),
        .DDR_cs_n               (DDR_cs_n           ),
        .DDR_dm                 (DDR_dm             ),
        .DDR_dq                 (DDR_dq             ),
        .DDR_dqs_n              (DDR_dqs_n          ),
        .DDR_dqs_p              (DDR_dqs_p          ),
        .DDR_odt                (DDR_odt            ),
        .DDR_ras_n              (DDR_ras_n          ),
        .DDR_reset_n            (DDR_reset_n        ),
        .DDR_we_n               (DDR_we_n           ),
        .FIXED_IO_ddr_vrn       (FIXED_IO_ddr_vrn   ),
        .FIXED_IO_ddr_vrp       (FIXED_IO_ddr_vrp   ),
        .FIXED_IO_mio           (FIXED_IO_mio       ),
        .FIXED_IO_ps_clk        (FIXED_IO_ps_clk    ),
        .FIXED_IO_ps_porb       (FIXED_IO_ps_porb   ),
        .FIXED_IO_ps_srstb      (FIXED_IO_ps_srstb  ),
        .bram_portb_addr        (bram_zynq_addr      ),
        .bram_portb_clk         (fpga_clk           ),
        .bram_portb_din         (bram_zynq_dout      ),
        .bram_portb_dout        (bram_zynq_din       ),
        .bram_portb_en          (bram_zynq_en        ),
        .bram_portb_rst         (1'b0               ),
        .bram_portb_we          (bram_zynq_we        ),
        .package_receive        (package_receive    ),
        .i_overtime_flag        (overtime_flag     ),
        .i_zynq_reply_flag      (zynq_reply_flag    )
                         
    );
//================================================================================================
//2.calc                                                   
//================================================================================================    
    calc
        #(
        .rom_depth               (1024              )
        )
        u2_calc(
        .clock                   (fpga_clk          ),
        .reset_n                 (1'b1              ),
        .write                   (bram_calc_we[0]   ),
        .address                 (bram_calc_addr    ),
        .din                     (bram_calc_dout    ),
        .dout                    (bram_calc_din     ),
        .trigger                 (calc_trigger      ),//input
        .done                    (calc_done         ) //output
        //machine code
        //.i_bram_machine_addr     (bram_machine_addr ),
        //.i_bram_machine_dout     (bram_machine_dout ),
        //.i_bram_machine_en       (bram_machine_en   ),
        //.i_bram_machine_we       (bram_machine_we   ),
        
    );
//================================================================================================
//3.instruction                                                 
//================================================================================================
    bram_zynq_calc  u3_bram_zynq_calc(
        .clk                    (fpga_clk           ),
        .rst_n                  (1'b1               ),
        .bram_zynq_data_rdy     (package_receive    ),
        .bram_zynq_addr         (bram_zynq_addr     ),
        .bram_zynq_dout         (bram_zynq_dout     ),
        .bram_zynq_din          (bram_zynq_din      ),
        .bram_zynq_en           (bram_zynq_en       ),
        .bram_zynq_we           (bram_zynq_we       ),
        //write
        .o_bram_calc_addr       (bram_calc_addr     ),
        .o_bram_calc_dout       (bram_calc_dout     ),
        .i_bram_calc_din        (bram_calc_din      ),
        .o_bram_calc_en         (bram_calc_en       ),//
        .o_bram_calc_we         (bram_calc_we       ),
        .o_calc_trigger         (calc_trigger       ),
        //read y parameter
        .i_uart_req             (uart_req           ),
        .bram_uart_addr         (bram_uart_addr     ),
        .bram_uart_dout         (bram_uart_dout     ),
        .bram_uart_en           (bram_uart_en       ),
        .bram_uart_we           (bram_uart_we       ),
        //machine parameter
        .o_bram_machine_addr    (bram_machine_addr  ),
        .o_bram_machine_dout    (bram_machine_dout  ),
        .o_bram_machine_en      (bram_machine_en    ),
        .o_bram_machine_we      (bram_machine_we    ),
        //
        .o_bluetooth_init       (bluetooth_init     ),
        //
        .i_reply_vld            (reply_vld          ),
        .i_ok_or_ng             (ok_or_ng           ),
        .o_overtime_flag         (overtime_flag      ),
        .o_zynq_reply_flag       (zynq_reply_flag    )
        
        
    );

//================================================================================================
//4.result calc                                                     
//================================================================================================     

    uart_top#(
        .BAUDRATE                (115200             ),  
        .CLK_PERIOD              (50000              ),     
        .INIT_Y_PARA_ADDR    	   (32'h02c0 	        ) 
        )   
    u4_uart_top(
        .clk                     (fpga_clk           ),
        .rst_n                   (1'b1               ),       
        .i_uart_rx               (i_uart_rx          ),
        .o_uart_tx               (o_uart_tx          ),       
        .i_calc_done             (calc_done          ),
        .i_bluetooth_init        (bluetooth_init     ),       
        .o_uart_req              (uart_req           ),
        .o_bram_uart_addr        (bram_uart_addr     ),
        .i_bram_uart_din         (bram_uart_dout     ),
        .o_bram_uart_en          (bram_uart_en       ),
        .o_bram_uart_we          (bram_uart_we       ),        
        .o_reply_vld             (reply_vld          ),
        .o_ok_or_ng              (ok_or_ng           )
    ); 
 
 
endmodule


