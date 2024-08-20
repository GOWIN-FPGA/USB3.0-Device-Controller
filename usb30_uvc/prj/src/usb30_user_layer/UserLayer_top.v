`include "UserEndpt_define.v"	

module UserLayer_top 
#(
	parameter DRAM_NUM = 2'd2
)
(
	 input sys_clk
	,input pclk 
	,input phy_resetn
	
	,input wire 	  warm_or_hot_reset				
	,input wire 	  host_requests_data_from_endpt 
	,input wire [3:0] host_requests_endpt_num      
	,input wire		  itp_recieved
	

	// requests
	,input wire			request_active 	
	,input wire	[7:0]	bmRequestType	
	,input wire	[7:0]	bRequest		
	,input wire	[15:0]	wValue			
	,input wire	[15:0]	wIndex			
	,input wire	[15:0]	wLength	

	// ep0 IN  
	,output	wire	[31:0]	ep0_in_buf_data
	,output	wire			ep0_in_buf_wren
	,input	wire			ep0_in_buf_ready
	,output	wire			ep0_in_buf_data_commit
	,output	wire	[10:0]	ep0_in_buf_data_commit_len		

	// ep0 OUT	
	,input  wire	[31:0]	ep0_out_buf_data		 	
	,input  wire	[10:0]	ep0_out_buf_len		
	,input  wire			ep0_out_buf_has_data	
	,output wire			ep0_out_buf_rden
	,output wire			ep0_out_buf_data_ack		


	`ifdef USER_ENDPT1_IN 
	,output	wire	[31:0]	ep1_in_buf_data
	,output	wire			ep1_in_buf_wren
	,input	wire			ep1_in_buf_ready
	,output	wire			ep1_in_buf_data_commit
	,output	wire	[10:0]	ep1_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT1_OUT
	,input	wire	[31:0]	ep1_out_buf_data
	,input	wire	[10:0]	ep1_out_buf_len
	,input	wire			ep1_out_buf_has_data
	,output wire 			ep1_out_buf_rden
	,output	wire			ep1_out_buf_data_ack 
	`endif	
	
	`ifdef USER_ENDPT2_IN 
	,output	wire	[31:0]	ep2_in_buf_data
	,output	wire			ep2_in_buf_wren
	,input	wire			ep2_in_buf_ready
	,output	wire			ep2_in_buf_data_commit
	,output	wire	[10:0]	ep2_in_buf_data_commit_len
	,output wire			ep2_in_buf_eob
	`endif	
	
	`ifdef USER_ENDPT2_OUT
	,input	wire	[31:0]	ep2_out_buf_data
	,input	wire	[10:0]	ep2_out_buf_len
	,input	wire			ep2_out_buf_has_data
	,output wire 			ep2_out_buf_rden
	,output	wire			ep2_out_buf_data_ack 
	`endif	
	
	`ifdef USER_ENDPT3_IN 
	,output	wire	[31:0]	ep3_in_buf_data
	,output	wire			ep3_in_buf_wren
	,input	wire			ep3_in_buf_ready
	,output	wire			ep3_in_buf_data_commit
	,output	wire	[10:0]	ep3_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT3_OUT
	,input	wire	[31:0]	ep3_out_buf_data
	,input	wire	[10:0]	ep3_out_buf_len
	,input	wire			ep3_out_buf_has_data
	,output wire 			ep3_out_buf_rden
	,output	wire			ep3_out_buf_data_ack 
	`endif

	`ifdef USER_ENDPT4_IN 
	,output	wire	[31:0]	ep4_in_buf_data
	,output	wire			ep4_in_buf_wren
	,input	wire			ep4_in_buf_ready
	,output	wire			ep4_in_buf_data_commit
	,output	wire	[10:0]	ep4_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT4_OUT
	,input	wire	[31:0]	ep4_out_buf_data
	,input	wire	[10:0]	ep4_out_buf_len
	,input	wire			ep4_out_buf_has_data
	,output wire 			ep4_out_buf_rden
	,output	wire			ep4_out_buf_data_ack 
	`endif	

	`ifdef USER_ENDPT5_IN 
	,output	wire	[31:0]	ep5_in_buf_data
	,output	wire			ep5_in_buf_wren
	,input	wire			ep5_in_buf_ready
	,output	wire			ep5_in_buf_data_commit
	,output	wire	[10:0]	ep5_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT5_OUT
	,input	wire	[31:0]	ep5_out_buf_data
	,input	wire	[10:0]	ep5_out_buf_len
	,input	wire			ep5_out_buf_has_data
	,output wire 			ep5_out_buf_rden
	,output	wire			ep5_out_buf_data_ack 
	`endif	

	`ifdef USER_ENDPT6_IN 
	,output	wire	[31:0]	ep6_in_buf_data
	,output	wire			ep6_in_buf_wren
	,input	wire			ep6_in_buf_ready
	,output	wire			ep6_in_buf_data_commit
	,output	wire	[10:0]	ep6_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT6_OUT
	,input	wire	[31:0]	ep6_out_buf_data
	,input	wire	[10:0]	ep6_out_buf_len
	,input	wire			ep6_out_buf_has_data
	,output wire 			ep6_out_buf_rden
	,output	wire			ep6_out_buf_data_ack 
	`endif		
	
	`ifdef USER_ENDPT7_IN 
	,output	wire	[31:0]	ep7_in_buf_data
	,output	wire			ep7_in_buf_wren
	,input	wire			ep7_in_buf_ready
	,output	wire			ep7_in_buf_data_commit
	,output	wire	[10:0]	ep7_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT7_OUT
	,input	wire	[31:0]	ep7_out_buf_data
	,input	wire	[10:0]	ep7_out_buf_len
	,input	wire			ep7_out_buf_has_data
	,output wire 			ep7_out_buf_rden
	,output	wire			ep7_out_buf_data_ack 
	`endif		
	
	`ifdef USER_ENDPT8_IN 
	,output	wire	[31:0]	ep8_in_buf_data
	,output	wire			ep8_in_buf_wren
	,input	wire			ep8_in_buf_ready
	,output	wire			ep8_in_buf_data_commit
	,output	wire	[10:0]	ep8_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT8_OUT
	,input	wire	[31:0]	ep8_out_buf_data
	,input	wire	[10:0]	ep8_out_buf_len
	,input	wire			ep8_out_buf_has_data
	,output wire 			ep8_out_buf_rden
	,output	wire			ep8_out_buf_data_ack 
	`endif	
	
	`ifdef USER_ENDPT9_IN 
	,output	wire	[31:0]	ep9_in_buf_data
	,output	wire			ep9_in_buf_wren
	,input	wire			ep9_in_buf_ready
	,output	wire			ep9_in_buf_data_commit
	,output	wire	[10:0]	ep9_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT9_OUT
	,input	wire	[31:0]	ep9_out_buf_data
	,input	wire	[10:0]	ep9_out_buf_len
	,input	wire			ep9_out_buf_has_data
	,output wire 			ep9_out_buf_rden
	,output	wire			ep9_out_buf_data_ack 
	`endif
	
	`ifdef USER_ENDPT10_IN 
	,output	wire	[31:0]	ep10_in_buf_data
	,output	wire			ep10_in_buf_wren
	,input	wire			ep10_in_buf_ready
	,output	wire			ep10_in_buf_data_commit
	,output	wire	[10:0]	ep10_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT10_OUT
	,input	wire	[31:0]	ep10_out_buf_data
	,input	wire	[10:0]	ep10_out_buf_len
	,input	wire			ep10_out_buf_has_data
	,output wire 			ep10_out_buf_rden
	,output	wire			ep10_out_buf_data_ack 
	`endif		

	`ifdef USER_ENDPT11_IN 
	,output	wire	[31:0]	ep11_in_buf_data
	,output	wire			ep11_in_buf_wren
	,input	wire			ep11_in_buf_ready
	,output	wire			ep11_in_buf_data_commit
	,output	wire	[10:0]	ep11_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT11_OUT
	,input	wire	[31:0]	ep11_out_buf_data
	,input	wire	[10:0]	ep11_out_buf_len
	,input	wire			ep11_out_buf_has_data
	,output wire 			ep11_out_buf_rden
	,output	wire			ep11_out_buf_data_ack 
	`endif		

	`ifdef USER_ENDPT12_IN 
	,output	wire	[31:0]	ep12_in_buf_data
	,output	wire			ep12_in_buf_wren
	,input	wire			ep12_in_buf_ready
	,output	wire			ep12_in_buf_data_commit
	,output	wire	[10:0]	ep12_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT12_OUT
	,input	wire	[31:0]	ep12_out_buf_data
	,input	wire	[10:0]	ep12_out_buf_len
	,input	wire			ep12_out_buf_has_data
	,output wire 			ep12_out_buf_rden
	,output	wire			ep12_out_buf_data_ack 
	`endif		
	
	`ifdef USER_ENDPT13_IN 
	,output	wire	[31:0]	ep13_in_buf_data
	,output	wire			ep13_in_buf_wren
	,input	wire			ep13_in_buf_ready
	,output	wire			ep13_in_buf_data_commit
	,output	wire	[10:0]	ep13_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT13_OUT
	,input	wire	[31:0]	ep13_out_buf_data
	,input	wire	[10:0]	ep13_out_buf_len
	,input	wire			ep13_out_buf_has_data
	,output wire 			ep13_out_buf_rden
	,output	wire			ep13_out_buf_data_ack 
	`endif		
	
	`ifdef USER_ENDPT14_IN 
	,output	wire	[31:0]	ep14_in_buf_data
	,output	wire			ep14_in_buf_wren
	,input	wire			ep14_in_buf_ready
	,output	wire			ep14_in_buf_data_commit
	,output	wire	[10:0]	ep14_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT14_OUT
	,input	wire	[31:0]	ep14_out_buf_data
	,input	wire	[10:0]	ep14_out_buf_len
	,input	wire			ep14_out_buf_has_data
	,output wire 			ep14_out_buf_rden
	,output	wire			ep14_out_buf_data_ack 
	`endif		
	
	
	`ifdef USER_ENDPT15_IN 
	,output	wire	[31:0]	ep15_in_buf_data
	,output	wire			ep15_in_buf_wren
	,input	wire			ep15_in_buf_ready
	,output	wire			ep15_in_buf_data_commit
	,output	wire	[10:0]	ep15_in_buf_data_commit_len
	`endif	
	
	`ifdef USER_ENDPT15_OUT
	,input	wire	[31:0]	ep15_out_buf_data
	,input	wire	[10:0]	ep15_out_buf_len
	,input	wire			ep15_out_buf_has_data
	,output wire 			ep15_out_buf_rden
	,output	wire			ep15_out_buf_data_ack 
	`endif		
	
		
	,output wire [13:0] 			ddr_addr 	
	,output wire [2:0]  			ddr_bank    
	,output wire 					ddr_cs      
	,output wire 					ddr_ras     
	,output wire 					ddr_cas     
	,output wire 					ddr_we      
	,output wire 					ddr_ck      
	,output wire 					ddr_ck_n    
	,output wire 					ddr_cke     
	,output wire 					ddr_odt     
	,output wire 					ddr_reset_n 
	,output wire [2*DRAM_NUM-1:0]   ddr_dm      
	,inout wire [16*DRAM_NUM-1:0]   ddr_dq      
	,inout wire [2*DRAM_NUM-1:0]    ddr_dqs     
	,inout wire [2*DRAM_NUM-1:0]    ddr_dqs_n   
	
);


localparam APP_DATA_WIDTH 			= 256 	; 
localparam ADDR_WIDTH	  			= 28  	;
localparam APP_MASK_WIDTH 			= 32  	;
localparam CAM_FIFO_RD_NUM_WIDTH 	= 13	; 
localparam YUV_FIFO_WR_NUM_WIDTH 	= 16	; 
localparam DDR_FIFO_RD_NUM_WIDTH 	= 10	;
localparam DDR_FIFO_WR_NUM_WIDTH 	= 10	; 



wire 	 [7:0] 		current_config_value 		;
wire	 			set_interface				;
wire	 [15:0]		set_interface_num           ;
wire	 [15:0]  	set_interface_alt_setting   ;
wire			cam_active 		;
wire 			yuv_fifo_empty  ;
wire [31:0] 	yuv_data_d      ;
wire [31:0] 	yuv_data_q      ;
wire			yuv_data_pop    ;
wire [15:0]		yuv_fifo_rd_num    ;
wire [15:0]		yuv_fifo_wr_num    ;
wire			yuv_fifo_rst ;
wire			cam_de_active; 

wire         				cmd_en				;
wire [2:0] 					cmd                 ;
wire [ADDR_WIDTH-1:0] 		addr                ;
wire [APP_DATA_WIDTH-1:0]	wr_data             ;
wire 						wr_data_en          ;
wire    					wr_data_end         ;
wire [APP_MASK_WIDTH-1:0] 	wr_data_mask        ;
wire						burst               ;
wire						sr_req              ;
wire						ref_req             ;
wire						cam_fifo_rd_en 		;
wire						yuv_fifo_wr_en		; 
wire [31:0] 				yuv_fifo_wr_dat     ;

wire [12:0] cam_fifo_rd_num ;
wire [12:0] cam_fifo_wr_num ;
wire [31:0] cam_fifo_rd_dat ;

wire cmd_ready ;
wire wr_data_rdy ;
wire [255:0] rd_data;
wire rd_data_valid ;
wire rd_data_end ;
wire init_calib_complete ;
wire pll_stop ;


Gowin_PLL Gowin_PLL_inst (
    .lock(pll_lock), //output lock
    .clkout0(), //output clkout0
    .clkout1(), //output clkout1
    .clkout2(memory_clk), //output clkout2
    .clkin(sys_clk), //input clkin
    .reset(!phy_resetn), //input reset
    .enclk0(1'b1), //input enclk0
    .enclk1(1'b1), //input enclk1
    .enclk2(pll_stop) //input enclk2
);



ControlTransfer ControlTransfer_inst
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	// requests
	,.request_active 	(request_active	)	
	,.bmRequestType	    (bmRequestType	)
	,.bRequest		    (bRequest		)
	,.wValue			(wValue			)
	,.wIndex			(wIndex			)
	,.wLength	        (wLength	    )

	// ep0 IN  
	,.ep0_in_buf_data		(ep0_in_buf_data	   )
	,.ep0_in_buf_wren       (ep0_in_buf_wren       )
	,.ep0_in_buf_ready      (ep0_in_buf_ready      )
	,.ep0_in_buf_data_commit     (ep0_in_buf_data_commit     )
	,.ep0_in_buf_data_commit_len	(ep0_in_buf_data_commit_len )	

	// ep0 OUT	
	,.ep0_out_buf_data			(ep0_out_buf_data		)	 	
	,.ep0_out_buf_len			(ep0_out_buf_len		)
	,.ep0_out_buf_has_data		(ep0_out_buf_has_data	)
	,.ep0_out_buf_rden      	(ep0_out_buf_rden       )
	,.ep0_out_buf_data_ack		(ep0_out_buf_data_ack		)	

	,.current_config_value 		(current_config_value)
	,.set_interface				(set_interface			   )
	,.set_interface_num         (set_interface_num         )
	,.set_interface_alt_setting (set_interface_alt_setting )
		
	
	
);


DataTransfer DataTransfer_inst 
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)
	
	,.current_config_value ( current_config_value )

	,.set_interface					(set_interface			   )
	,.set_interface_num         	(set_interface_num         )
	,.set_interface_alt_setting 	(set_interface_alt_setting )
	,.host_requests_data_from_endpt	(host_requests_data_from_endpt)
	,.host_requests_endpt_num      	(host_requests_endpt_num      )
	
	,.itp_recieved		(itp_recieved) 

	,.cam_active 		(cam_active    )
	,.cam_de_active		(cam_de_active )
	,.yuv_fifo_empty    (yuv_fifo_empty)
	,.yuv_fifo_num		(yuv_fifo_rd_num  )
	,.yuv_data          (yuv_data_q    )
	,.yuv_data_pop      (yuv_data_pop  )



	// ep1 IN 
	,.ep1_in_buf_data				(ep1_in_buf_data		   )
	,.ep1_in_buf_wren	            (ep1_in_buf_wren	       )
	,.ep1_in_buf_ready              (ep1_in_buf_ready          )
	,.ep1_in_buf_data_commit        (ep1_in_buf_data_commit    )
	,.ep1_in_buf_data_commit_len    (ep1_in_buf_data_commit_len)

	
	// ep2 IN
	,.ep2_in_buf_data				 (ep2_in_buf_data			 )
	,.ep2_in_buf_wren                (ep2_in_buf_wren            )
	,.ep2_in_buf_ready               (ep2_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep2_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep2_in_buf_data_commit_len )
	,.ep2_in_buf_eob				 (ep2_in_buf_eob             )


);



yuv_data_fifo yuv_data_fifo_inst(
	.Data(yuv_fifo_wr_dat), //input [31:0] Data
	.WrReset(!phy_resetn), //input WrReset
	.RdReset(!phy_resetn), //input RdReset	
	.WrClk(clk_x1), //input WrClk
	.RdClk(pclk), //input RdClk
	.WrEn(yuv_fifo_wr_en), //input WrEn
	.RdEn(yuv_data_pop), //input RdEn
	.Wnum(yuv_fifo_wr_num), //output [15:0] Wnum	
	.Rnum(yuv_fifo_rd_num), //output [15:0] Rnum
	.Q(yuv_data_q), //output [31:0] Q
	.Empty(yuv_fifo_empty), //output Empty
	.Full(yuv_fifo_full) //output Full
);



ddr3_controller
#(
	 .APP_DATA_WIDTH 		( APP_DATA_WIDTH 		  	) 
	,.ADDR_WIDTH	  		( ADDR_WIDTH	  		  	)
	,.APP_MASK_WIDTH 		( APP_MASK_WIDTH 		  	)
	,.CAM_FIFO_RD_NUM_WIDTH ( CAM_FIFO_RD_NUM_WIDTH 	) 
	,.YUV_FIFO_WR_NUM_WIDTH ( YUV_FIFO_WR_NUM_WIDTH 	) 
	,.DDR_FIFO_RD_NUM_WIDTH ( DDR_FIFO_RD_NUM_WIDTH 	)
	,.DDR_FIFO_WR_NUM_WIDTH ( DDR_FIFO_WR_NUM_WIDTH 	) 
)
ddr3_controller_inst 
(
	 .clk 		(clk_x1)			
	,.rst_n		(phy_resetn)
	
	,.cmd_ready				(cmd_ready			   )
    ,.rd_data_valid         (rd_data_valid         )
    ,.wr_data_rdy           (wr_data_rdy           )
    ,.rd_data               (rd_data               )
	,.rd_data_end			(rd_data_end		   )
    ,.init_calib_complete   (init_calib_complete   )

    ,.cmd_en				(cmd_en		  )
    ,.cmd                   (cmd          )
    ,.addr                  (addr         )
    ,.wr_data               (wr_data      )
    ,.wr_data_en            (wr_data_en   )
    ,.wr_data_end           (wr_data_end  )
    ,.wr_data_mask          (wr_data_mask )
    ,.burst                 (burst        )
    ,.sr_req                (sr_req       )
    ,.ref_req               (ref_req      )
	
		
	,.cam_fifo_rd_num 		(cam_fifo_rd_num)
	,.yuv_fifo_wr_num       (yuv_fifo_wr_num)
	
	,.cam_fifo_rd_en 		(cam_fifo_rd_en )
	,.cam_fifo_rd_dat       (cam_fifo_rd_dat )
	
	,.yuv_fifo_wr_en 		(yuv_fifo_wr_en )	
	,.yuv_fifo_wr_dat       (yuv_fifo_wr_dat )
	
);


cam_fifo cam_fifo_inst (
	.Data(yuv_data_d), //input [31:0] Data
	.Reset(!phy_resetn), //input Reset
	.WrClk(pclk), //input WrClk
	.RdClk(clk_x1), //input RdClk
	.WrEn(yuv_data_val), //input WrEn
	.RdEn(cam_fifo_rd_en), //input RdEn
	.Wnum(cam_fifo_wr_num), //output [12:0] Wnum
	.Rnum(cam_fifo_rd_num), //output [12:0] Rnum
	.Q(cam_fifo_rd_dat), //output [31:0] Q
	.Empty(), //output Empty
	.Full() //output Full
);



PixelGen PixelGen_inst
(
	 .clk 		(pclk)
	,.rst_n		(phy_resetn)
	
	,.cam_active 	(cam_active )
	,.itp_recieved  (itp_recieved)
	,.yuv_fifo_full ( yuv_fifo_full ) 
	,.cam_de_active ( cam_de_active )
	,.yuv_fifo_wr_num( cam_fifo_wr_num )
	
	,.yuv_data 		(yuv_data_d 	 )	
	,.yuv_data_val  (yuv_data_val    )
	,.yuv_fifo_rst	(yuv_fifo_rst    )
	
);


DDR3_Memory_Interface_Top u_ddr3 (
    .memory_clk      (memory_clk),
    //.pll_stop        (pll_stop),
    .pll_stop        (pll_stop),
    .clk             (sys_clk),
    .rst_n           (phy_resetn),   //rst_n
    //.app_burst_number(0),
    .cmd_ready       (cmd_ready),
    .cmd             (cmd),
    .cmd_en          (cmd_en),
    .addr            (addr),
    .wr_data_rdy     (wr_data_rdy),
    .wr_data         (wr_data),
    .wr_data_en      (wr_data_en),
    .wr_data_end     (wr_data_end),
    .wr_data_mask    (wr_data_mask),
    .rd_data         (rd_data),
    .rd_data_valid   (rd_data_valid),
    .rd_data_end     (rd_data_end),
    .sr_req          (sr_req),
    .ref_req         (ref_req),
    .sr_ack          (),
    .ref_ack         (),
    .init_calib_complete(init_calib_complete),
    .clk_out         (clk_x1),
    .pll_lock        (pll_lock), 
    .burst           (burst),
    // mem interface
    .ddr_rst         (ddr_rst),
    .O_ddr_addr      (ddr_addr),
    .O_ddr_ba        (ddr_bank),
    .O_ddr_cs_n      (ddr_cs),
    .O_ddr_ras_n     (ddr_ras),
    .O_ddr_cas_n     (ddr_cas),
    .O_ddr_we_n      (ddr_we),
    .O_ddr_clk       (ddr_ck),
    .O_ddr_clk_n     (ddr_ck_n),
    .O_ddr_cke       (ddr_cke),
    .O_ddr_odt       (ddr_odt),
    .O_ddr_reset_n   (ddr_reset_n),
    .O_ddr_dqm       (ddr_dm),
    .IO_ddr_dq       (ddr_dq),
    .IO_ddr_dqs      (ddr_dqs),
    .IO_ddr_dqs_n    (ddr_dqs_n)
);






/*
DataTransfer DataTransfer_inst_1
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep1_in_buf_data			  )
	,.ep2_in_buf_wren                (ep1_in_buf_wren            )
	,.ep2_in_buf_ready               (ep1_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep1_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep1_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep1_out_buf_data	    )
	,.ep2_out_buf_len               (ep1_out_buf_len       )
	,.ep2_out_buf_has_data          (ep1_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep1_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep1_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_2
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep2_in_buf_data			  )
	,.ep2_in_buf_wren                (ep2_in_buf_wren            )
	,.ep2_in_buf_ready               (ep2_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep2_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep2_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep2_out_buf_data	    )
	,.ep2_out_buf_len               (ep2_out_buf_len       )
	,.ep2_out_buf_has_data          (ep2_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep2_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep2_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_3
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep3_in_buf_data			  )
	,.ep2_in_buf_wren                (ep3_in_buf_wren            )
	,.ep2_in_buf_ready               (ep3_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep3_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep3_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep3_out_buf_data	    )
	,.ep2_out_buf_len               (ep3_out_buf_len       )
	,.ep2_out_buf_has_data          (ep3_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep3_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep3_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_4
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep4_in_buf_data			  )
	,.ep2_in_buf_wren                (ep4_in_buf_wren            )
	,.ep2_in_buf_ready               (ep4_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep4_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep4_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep4_out_buf_data	    )
	,.ep2_out_buf_len               (ep4_out_buf_len       )
	,.ep2_out_buf_has_data          (ep4_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep4_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep4_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_5
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep5_in_buf_data			  )
	,.ep2_in_buf_wren                (ep5_in_buf_wren            )
	,.ep2_in_buf_ready               (ep5_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep5_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep5_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep5_out_buf_data	    )
	,.ep2_out_buf_len               (ep5_out_buf_len       )
	,.ep2_out_buf_has_data          (ep5_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep5_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep5_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_6
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep6_in_buf_data			  )
	,.ep2_in_buf_wren                (ep6_in_buf_wren            )
	,.ep2_in_buf_ready               (ep6_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep6_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep6_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep6_out_buf_data	    )
	,.ep2_out_buf_len               (ep6_out_buf_len       )
	,.ep2_out_buf_has_data          (ep6_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep6_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep6_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_7
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep7_in_buf_data			  )
	,.ep2_in_buf_wren                (ep7_in_buf_wren            )
	,.ep2_in_buf_ready               (ep7_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep7_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep7_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep7_out_buf_data	    )
	,.ep2_out_buf_len               (ep7_out_buf_len       )
	,.ep2_out_buf_has_data          (ep7_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep7_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep7_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_8
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep8_in_buf_data			  )
	,.ep2_in_buf_wren                (ep8_in_buf_wren            )
	,.ep2_in_buf_ready               (ep8_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep8_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep8_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep8_out_buf_data	    )
	,.ep2_out_buf_len               (ep8_out_buf_len       )
	,.ep2_out_buf_has_data          (ep8_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep8_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep8_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_9
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep9_in_buf_data			  )
	,.ep2_in_buf_wren                (ep9_in_buf_wren            )
	,.ep2_in_buf_ready               (ep9_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep9_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep9_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep9_out_buf_data	    )
	,.ep2_out_buf_len               (ep9_out_buf_len       )
	,.ep2_out_buf_has_data          (ep9_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep9_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep9_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_10
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep10_in_buf_data			  )
	,.ep2_in_buf_wren                (ep10_in_buf_wren            )
	,.ep2_in_buf_ready               (ep10_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep10_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep10_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep10_out_buf_data	    )
	,.ep2_out_buf_len               (ep10_out_buf_len       )
	,.ep2_out_buf_has_data          (ep10_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep10_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep10_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_11
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep11_in_buf_data			  )
	,.ep2_in_buf_wren                (ep11_in_buf_wren            )
	,.ep2_in_buf_ready               (ep11_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep11_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep11_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep11_out_buf_data	    )
	,.ep2_out_buf_len               (ep11_out_buf_len       )
	,.ep2_out_buf_has_data          (ep11_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep11_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep11_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_12
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep12_in_buf_data			  )
	,.ep2_in_buf_wren                (ep12_in_buf_wren            )
	,.ep2_in_buf_ready               (ep12_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep12_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep12_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep12_out_buf_data	    )
	,.ep2_out_buf_len               (ep12_out_buf_len       )
	,.ep2_out_buf_has_data          (ep12_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep12_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep12_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_13
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep13_in_buf_data			  )
	,.ep2_in_buf_wren                (ep13_in_buf_wren            )
	,.ep2_in_buf_ready               (ep13_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep13_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep13_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep13_out_buf_data	    )
	,.ep2_out_buf_len               (ep13_out_buf_len       )
	,.ep2_out_buf_has_data          (ep13_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep13_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep13_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_14
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep14_in_buf_data			  )
	,.ep2_in_buf_wren                (ep14_in_buf_wren            )
	,.ep2_in_buf_ready               (ep14_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep14_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep14_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep14_out_buf_data	    )
	,.ep2_out_buf_len               (ep14_out_buf_len       )
	,.ep2_out_buf_has_data          (ep14_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep14_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep14_out_buf_data_ack  )


);
DataTransfer DataTransfer_inst_15
(
	.clk 	(pclk)
	,.rst_n (phy_resetn)

	,.current_config_value ( current_config_value )

	// ep2 IN
	,.ep2_in_buf_data				 (ep15_in_buf_data			  )
	,.ep2_in_buf_wren                (ep15_in_buf_wren            )
	,.ep2_in_buf_ready               (ep15_in_buf_ready           )
	,.ep2_in_buf_data_commit         (ep15_in_buf_data_commit     )
	,.ep2_in_buf_data_commit_len     (ep15_in_buf_data_commit_len )


	// ep2 OUT
	,.ep2_out_buf_data				(ep15_out_buf_data	    )
	,.ep2_out_buf_len               (ep15_out_buf_len       )
	,.ep2_out_buf_has_data          (ep15_out_buf_has_data  )
	,.ep2_out_buf_rden              (ep15_out_buf_rden      )
	,.ep2_out_buf_data_ack          (ep15_out_buf_data_ack  )


);


*/




endmodule