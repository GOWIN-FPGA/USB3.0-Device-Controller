`include "./usb30_user_layer/UserEndpt_define.v"
module top
#(
	parameter DRAM_NUM = 2'd2 
)
(
    input           sys_clk
	
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
	,inout  wire [16*DRAM_NUM-1:0]  ddr_dq      
	,inout  wire [2*DRAM_NUM-1:0]   ddr_dqs     
	,inout  wire [2*DRAM_NUM-1:0]   ddr_dqs_n   	
	
	
	
	
	,output led1 
	,output led2 
	
	,output dbg_0 
	,output dbg_1 
	,output dbg_2 
	,output dbg_3 
	,output dbg_4 
	,output dbg_5 
	,output dbg_6 
	,output dbg_7 
	,output dbg_8 
	,output dbg_9 
	,output dbg_10
	,output dbg_11
	,output dbg_12
	,output dbg_13
	,output dbg_14
	,output dbg_15
	,output dbg_16
	,output dbg_17


);

reg     [7:0]   cnt0 = 0;
reg     [15:0]  cnt1 = 0;
reg     [15:0]  cnt2 = 0;
reg     [31:0]  cnt3 = 0;
reg     [31:0]  cnt4 = 0;
reg     [7:0]   cnt5 = 0;
reg		[7:0]	key_resetn_r = 8'b11111111;
reg            	phy_resetn = 0;
wire            phy_resetn_o;
wire            pclk;
reg				led1_r = 1'b0;
reg				led2_r = 1'b0;

wire	[2:0]	RxStatus;
wire			PhyStatus;
wire			phy_pipe_half_clk;        // 125MHz:  1/2 PCLK
wire			phy_pipe_half_clk_phase;  // 125MHz:  1/2 PCLK, phase shift 90
wire			phy_pipe_quarter_clk;     // 62.5MHz: 1/4 PCLK
wire	[31:0]	phy_pipe_rx_data;
wire	[3:0]	phy_pipe_rx_datak;
wire			phy_pipe_rx_valid;
wire			phy_pipe_rx_valid_o;
wire	[31:0]	phy_pipe_tx_data;
wire	[3:0]	phy_pipe_tx_datak;
wire			phy_reset_n;
wire			phy_out_enable;
wire			phy_phy_reset_n;
wire			phy_tx_detrx_lpbk;
wire			phy_tx_elecidle;
wire			phy_rx_elecidle;
wire	[2:0]	phy_rx_status;
wire	[1:0]	phy_power_down;
wire			phy_phy_status_i;
wire	        phy_phy_status_o;
wire			phy_pwrpresent;
wire			phy_tx_oneszeros;
wire	[1:0]	phy_tx_deemph;
wire	[2:0]	phy_tx_margin;
wire			phy_tx_swing;
wire			phy_rx_polarity;
wire			phy_rx_termination;
wire			phy_rate;
wire			phy_elas_buf_mode;
wire	[31:0]	ep0_in_buf_data          ;
wire			ep0_in_buf_wren          ;
wire			ep0_in_buf_ready         ;
wire			ep0_in_buf_data_commit        ;
wire	[10:0]	ep0_in_buf_data_commit_len    ;	
wire	[31:0]	ep0_out_buf_data		 ;
wire	[10:0]	ep0_out_buf_len		     ;
wire			ep0_out_buf_has_data	     ;
wire			ep0_out_buf_data_ack			 ;
wire			ep0_out_buf_rden 		 ;
wire			request_active 	         ;
wire	[7:0]	bmRequestType	         ;
wire	[7:0]	bRequest		         ;
wire	[15:0]	wValue			         ;
wire	[15:0]	wIndex			         ;
wire	[15:0]	wLength		             ;
wire				set_interface 		 ;
wire			   	get_interface 		 ;
wire 	[15:0] 		set_intf_alt_setting ;	
wire 	[15:0] 		set_intf_num	     ;
wire	[15:0]		get_intf_alt_setting ;
wire	[15:0]  	get_intf_num         ;
wire				set_address          ;
wire		[6:0]	dev_address          ;
wire			set_sel                  ;
wire 	[7:0]   set_u1_sel               ;
wire 	[7:0]   set_u1_pel               ;
wire 	[15:0]  set_u2_sel               ;
wire 	[15:0]  set_u2_pel               ;
wire				set_feature          ;
wire				clear_feature        ;
wire		[15:0]	set_feat_sel         ;
wire		[15:0]  set_feat_wIndex      ;
wire		[1:0]  	set_feat_recipient 	 ;
wire		[15:0]	clr_feat_sel         ;
wire		[15:0]	clr_feat_wIndex      ;
wire		[1:0]	clr_feat_recipient	;	
wire				set_config			;
wire		[7:0]	set_config_value    ;
wire				get_config          ;
wire		[7:0] 	get_config_value	;
wire 				warm_or_hot_reset ;
wire  				host_requests_data_from_endpt;  
wire  [3:0] 		host_requests_endpt_num;
wire				itp_recieved ;
wire				attached ;

`ifdef USER_ENDPT1_IN
wire	[31:0]	ep1_in_buf_data             ;
wire			ep1_in_buf_wren             ;
wire			ep1_in_buf_ready            ;
wire			ep1_in_buf_data_commit      ;
wire	[10:0]	ep1_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT1_OUT
wire	[31:0]	ep1_out_buf_data             ;
wire	[10:0]	ep1_out_buf_len              ;
wire			ep1_out_buf_has_data         ;
wire			ep1_out_buf_data_ack         ;
wire			ep1_out_buf_rden			 ;
`endif

`ifdef USER_ENDPT2_IN
wire	[31:0]	ep2_in_buf_data             ;
wire			ep2_in_buf_wren             ;
wire			ep2_in_buf_ready            ;
wire			ep2_in_buf_data_commit      ;
wire	[10:0]	ep2_in_buf_data_commit_len  ;
wire			ep2_in_buf_eob ;
`endif 


`ifdef USER_ENDPT2_OUT
wire	[31:0]	ep2_out_buf_data             ;
wire	[10:0]	ep2_out_buf_len              ;
wire			ep2_out_buf_has_data         ;
wire			ep2_out_buf_data_ack         ;
wire			ep2_out_buf_rden			 ;
`endif

`ifdef USER_ENDPT3_IN
wire	[31:0]	ep3_in_buf_data             ;
wire			ep3_in_buf_wren             ;
wire			ep3_in_buf_ready            ;
wire			ep3_in_buf_data_commit      ;
wire	[10:0]	ep3_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT3_OUT
wire	[31:0]	ep3_out_buf_data             ;
wire	[10:0]	ep3_out_buf_len              ;
wire			ep3_out_buf_has_data         ;
wire			ep3_out_buf_data_ack         ;
wire			ep3_out_buf_rden			 ;
`endif

`ifdef USER_ENDPT4_IN
wire	[31:0]	ep4_in_buf_data             ;
wire			ep4_in_buf_wren             ;
wire			ep4_in_buf_ready            ;
wire			ep4_in_buf_data_commit      ;
wire	[10:0]	ep4_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT4_OUT
wire	[31:0]	ep4_out_buf_data             ;
wire	[10:0]	ep4_out_buf_len              ;
wire			ep4_out_buf_has_data         ;
wire			ep4_out_buf_data_ack         ;
wire			ep4_out_buf_rden			 ;
`endif

`ifdef USER_ENDPT5_IN
wire	[31:0]	ep5_in_buf_data             ;
wire			ep5_in_buf_wren             ;
wire			ep5_in_buf_ready            ;
wire			ep5_in_buf_data_commit      ;
wire	[10:0]	ep5_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT5_OUT
wire	[31:0]	ep5_out_buf_data             ;
wire	[10:0]	ep5_out_buf_len              ;
wire			ep5_out_buf_has_data         ;
wire			ep5_out_buf_data_ack         ;
wire			ep5_out_buf_rden			 ;
`endif

`ifdef USER_ENDPT6_IN
wire	[31:0]	ep6_in_buf_data             ;
wire			ep6_in_buf_wren             ;
wire			ep6_in_buf_ready            ;
wire			ep6_in_buf_data_commit      ;
wire	[10:0]	ep6_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT6_OUT
wire	[31:0]	ep6_out_buf_data             ;
wire	[10:0]	ep6_out_buf_len              ;
wire			ep6_out_buf_has_data         ;
wire			ep6_out_buf_data_ack         ;
wire			ep6_out_buf_rden			 ;
`endif

`ifdef USER_ENDPT7_IN
wire	[31:0]	ep7_in_buf_data             ;
wire			ep7_in_buf_wren             ;
wire			ep7_in_buf_ready            ;
wire			ep7_in_buf_data_commit      ;
wire	[10:0]	ep7_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT7_OUT
wire	[31:0]	ep7_out_buf_data             ;
wire	[10:0]	ep7_out_buf_len              ;
wire			ep7_out_buf_has_data         ;
wire			ep7_out_buf_data_ack         ;
wire			ep7_out_buf_rden			 ;
`endif

`ifdef USER_ENDPT8_IN
wire	[31:0]	ep8_in_buf_data             ;
wire			ep8_in_buf_wren             ;
wire			ep8_in_buf_ready            ;
wire			ep8_in_buf_data_commit      ;
wire	[10:0]	ep8_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT8_OUT
wire	[31:0]	ep8_out_buf_data             ;
wire	[10:0]	ep8_out_buf_len              ;
wire			ep8_out_buf_has_data         ;
wire			ep8_out_buf_data_ack         ;
wire			ep8_out_buf_rden			 ;
`endif

`ifdef USER_ENDPT9_IN
wire	[31:0]	ep9_in_buf_data             ;
wire			ep9_in_buf_wren             ;
wire			ep9_in_buf_ready            ;
wire			ep9_in_buf_data_commit      ;
wire	[10:0]	ep9_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT9_OUT
wire	[31:0]	ep9_out_buf_data             ;
wire	[10:0]	ep9_out_buf_len              ;
wire			ep9_out_buf_has_data         ;
wire			ep9_out_buf_data_ack         ;
wire			ep9_out_buf_rden			 ;
`endif

`ifdef USER_ENDPT10_IN
wire	[31:0]	ep10_in_buf_data             ;
wire			ep10_in_buf_wren             ;
wire			ep10_in_buf_ready            ;
wire			ep10_in_buf_data_commit      ;
wire	[10:0]	ep10_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT10_OUT
wire	[31:0]	ep10_out_buf_data             ;
wire	[10:0]	ep10_out_buf_len              ;
wire			ep10_out_buf_has_data         ;
wire			ep10_out_buf_data_ack         ;
wire			ep10_out_buf_rden			  ;
`endif

`ifdef USER_ENDPT11_IN
wire	[31:0]	ep11_in_buf_data             ;
wire			ep11_in_buf_wren             ;
wire			ep11_in_buf_ready            ;
wire			ep11_in_buf_data_commit      ;
wire	[10:0]	ep11_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT11_OUT
wire	[31:0]	ep11_out_buf_data             ;
wire	[10:0]	ep11_out_buf_len              ;
wire			ep11_out_buf_has_data         ;
wire			ep11_out_buf_data_ack         ;
wire			ep11_out_buf_rden			 ;
`endif

`ifdef USER_ENDPT12_IN
wire	[31:0]	ep12_in_buf_data             ;
wire			ep12_in_buf_wren             ;
wire			ep12_in_buf_ready            ;
wire			ep12_in_buf_data_commit      ;
wire	[10:0]	ep12_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT12_OUT
wire	[31:0]	ep12_out_buf_data             ;
wire	[10:0]	ep12_out_buf_len              ;
wire			ep12_out_buf_has_data         ;
wire			ep12_out_buf_data_ack         ;
wire			ep12_out_buf_rden			  ;
`endif

`ifdef USER_ENDPT13_IN
wire	[31:0]	ep13_in_buf_data             ;
wire			ep13_in_buf_wren             ;
wire			ep13_in_buf_ready            ;
wire			ep13_in_buf_data_commit      ;
wire	[10:0]	ep13_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT13_OUT
wire	[31:0]	ep13_out_buf_data             ;
wire	[10:0]	ep13_out_buf_len              ;
wire			ep13_out_buf_has_data         ;
wire			ep13_out_buf_data_ack         ;
wire			ep13_out_buf_rden			  ;
`endif

`ifdef USER_ENDPT14_IN
wire	[31:0]	ep14_in_buf_data             ;
wire			ep14_in_buf_wren             ;
wire			ep14_in_buf_ready            ;
wire			ep14_in_buf_data_commit      ;
wire	[10:0]	ep14_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT14_OUT
wire	[31:0]	ep14_out_buf_data             ;
wire	[10:0]	ep14_out_buf_len              ;
wire			ep14_out_buf_has_data         ;
wire			ep14_out_buf_data_ack         ;
wire			ep14_out_buf_rden			  ;
`endif

`ifdef USER_ENDPT15_IN
wire	[31:0]	ep15_in_buf_data             ;
wire			ep15_in_buf_wren             ;
wire			ep15_in_buf_ready            ;
wire			ep15_in_buf_data_commit      ;
wire	[10:0]	ep15_in_buf_data_commit_len  ;
`endif 


`ifdef USER_ENDPT15_OUT
wire	[31:0]	ep15_out_buf_data             ;
wire	[10:0]	ep15_out_buf_len              ;
wire			ep15_out_buf_has_data         ;
wire			ep15_out_buf_data_ack         ;
wire			ep15_out_buf_rden			  ;
`endif

assign led1 = led1_r;
assign led2 = led2_r;





always@(posedge sys_clk)
begin
	if(cnt3 < 50000000)
	begin
		cnt3	<= cnt3 + 1'b1;
	end
	else
	begin
		cnt3	<= 32'd0;
		led1_r	<= ~led1_r;
	end
end

always@(posedge pclk)
begin
	if(cnt4 < 125000000)
	begin
		cnt4	<= cnt4 + 1'b1;
	end
	else
	begin
		cnt4	<= 32'd0;
		led2_r	<= ~led2_r;
	end
end

reg sys_rst_n ;
always@(posedge pclk)
begin
    if(cnt0 < 255)
    begin
        cnt0                <= cnt0 + 1'b1;
    end
    else
    begin
        cnt0                <= cnt0;
    end
	
	if(cnt0 == 255)
	begin
		phy_resetn <= 1'b1;
		sys_rst_n <= 1 ;
	end
	else
	begin
		phy_resetn <= 1'b0;
		sys_rst_n <= 0 ;
	end
end

SerDes_Top SerDes_Top_inst(
	//.sys_clk_i			( )
    .USB3_0_PHY_Top_pclk(pclk), //output USB3_0_PHY_Top_pclk
    .USB3_0_PHY_Top_PipeRxData(phy_pipe_rx_data), //output [31:0] USB3_0_PHY_Top_PipeRxData
    .USB3_0_PHY_Top_PipeRxDataK(phy_pipe_rx_datak), //output [3:0] USB3_0_PHY_Top_PipeRxDataK
    .USB3_0_PHY_Top_PipeRxDataValid(phy_pipe_rx_valid_o), //output USB3_0_PHY_Top_PipeRxDataValid
    .USB3_0_PHY_Top_RxElecIdle(phy_rx_elecidle), //output USB3_0_PHY_Top_RxElecIdle
    .USB3_0_PHY_Top_RxStatus(RxStatus), //output [2:0] USB3_0_PHY_Top_RxStatus
    .USB3_0_PHY_Top_PhyStatus(PhyStatus), //output USB3_0_PHY_Top_PhyStatus
    .USB3_0_PHY_Top_PowerPresent(phy_pwrpresent), //output USB3_0_PHY_Top_PowerPresent
    .USB3_0_PHY_Top_phy_resetn(phy_resetn_o), //input USB3_0_PHY_Top_phy_resetn
    .USB3_0_PHY_Top_PipeTxData(phy_pipe_tx_data), //input [31:0] USB3_0_PHY_Top_PipeTxData
    .USB3_0_PHY_Top_PipeTxDataK(phy_pipe_tx_datak), //input [3:0] USB3_0_PHY_Top_PipeTxDataK
    .USB3_0_PHY_Top_TxDetectRx_loopback(phy_tx_detrx_lpbk), //input USB3_0_PHY_Top_TxDetectRx_loopback
    .USB3_0_PHY_Top_TxElecIdle(phy_tx_elecidle), //input USB3_0_PHY_Top_TxElecIdle
    .USB3_0_PHY_Top_RxPolarity(phy_rx_polarity), //input USB3_0_PHY_Top_RxPolarity
    .USB3_0_PHY_Top_RxEqTraining(1'b0), //input USB3_0_PHY_Top_RxEqTraining
    .USB3_0_PHY_Top_RxTermination(phy_rx_termination), //input USB3_0_PHY_Top_RxTermination
    .USB3_0_PHY_Top_TxOnesZeros(phy_tx_oneszeros), //input USB3_0_PHY_Top_TxOnesZeros
    .USB3_0_PHY_Top_PowerDown(phy_power_down), //input [1:0] USB3_0_PHY_Top_PowerDown
    .USB3_0_PHY_Top_ElasticityBufferMode(phy_elas_buf_mode) //input USB3_0_PHY_Top_ElasticityBufferMode
);

assign phy_rx_status =  RxStatus;
assign phy_phy_status =  PhyStatus;
assign phy_pipe_rx_valid = phy_pipe_rx_valid_o;

USB30_Device_Controller_Top USB30_Device_Controller_Top_inst (
	.phy_clk_i						(pclk)//input	wire			
	,.reset_n_i						(phy_resetn )//input	wire			
	,.phy_pipe_rx_data_i			(phy_pipe_rx_data)//input	wire	[31:0]	
	,.phy_pipe_rx_datak_i			(phy_pipe_rx_datak)//input	wire	[3:0]	
	,.phy_pipe_rx_valid_i			(phy_pipe_rx_valid)//input	wire	[1:0]	
	,.phy_pipe_tx_data_o			(phy_pipe_tx_data)//output	wire	[31:0]	
	,.phy_pipe_tx_datak_o			(phy_pipe_tx_datak)//output	wire	[3:0]	
	,.phy_reset_n_o					(phy_resetn_o)//output	wire								
	,.phy_tx_detrx_lpbk_o			(phy_tx_detrx_lpbk)//output	wire			
	,.phy_tx_elecidle_o				(phy_tx_elecidle	)//output	wire			
	,.phy_rx_elecidle_i				(phy_rx_elecidle	)//inout	wire			
	,.phy_rx_status_i				(phy_rx_status		)//input	wire	[5:0]	
	,.phy_power_down_o				(phy_power_down		)//output	wire	[1:0]	
	,.phy_phy_status_i				(phy_phy_status		)//input   wire	[1:0]		        
	,.phy_pwrpresent_i				(phy_pwrpresent		)//input	wire			
	,.phy_tx_oneszeros_o			(phy_tx_oneszeros	)//output	wire			
	,.phy_tx_deemph_o				(phy_tx_deemph		)//output	wire	[1:0]	
	,.phy_tx_margin_o				(phy_tx_margin		)//output	wire	[2:0]	
	,.phy_tx_swing_o				(phy_tx_swing		)//output	wire			
	,.phy_rx_polarity_o				(phy_rx_polarity	)//output	wire			
	,.phy_rx_termination_o			(phy_rx_termination	)//output	wire			
	,.phy_rate_o					(phy_rate			)//output	wire			
	,.phy_elas_buf_mode_o			(phy_elas_buf_mode	)//output	wire	


	// external interface
	
	,.warm_or_hot_reset_o 				( warm_or_hot_reset 			 ) 
	,.host_requests_data_from_endpt_o  	( host_requests_data_from_endpt	 )
	,.host_requests_endpt_num_o	       	( host_requests_endpt_num		 )
	,.itp_recieved						( itp_recieved 					 )
	,.attached							( attached						 ) 
	
	// requests 
	,.request_active_o 		(request_active	)
	,.bmRequestType_o		(bmRequestType	)
	,.bRequest_o			(bRequest		)
	,.wValue_o				(wValue			)
	,.wIndex_o				(wIndex			)
	,.wLength_o				(wLength		)
			
	// ep0 IN  					
	,.ep0_in_buf_data_i					(ep0_in_buf_data		)
	,.ep0_in_buf_wren_i         		(ep0_in_buf_wren	    )
	,.ep0_in_buf_ready_o        		(ep0_in_buf_ready	    )
	,.ep0_in_buf_data_commit_i 	   		(ep0_in_buf_data_commit	    )
	,.ep0_in_buf_data_commit_len_i   	(ep0_in_buf_data_commit_len	)
	
	`ifdef USER_ENDPT1_IN 
	,.ep1_in_buf_data_i					(ep1_in_buf_data		)
	,.ep1_in_buf_wren_i         		(ep1_in_buf_wren	    )
	,.ep1_in_buf_ready_o        		(ep1_in_buf_ready	    )
	,.ep1_in_buf_data_commit_i 	  	 	(ep1_in_buf_data_commit	    )
	,.ep1_in_buf_data_commit_len_i   	(ep1_in_buf_data_commit_len	)
	`endif	
	
	`ifdef USER_ENDPT2_IN 
	,.ep2_in_buf_data_i					(ep2_in_buf_data		)
	,.ep2_in_buf_wren_i         		(ep2_in_buf_wren	    )
	,.ep2_in_buf_ready_o        		(ep2_in_buf_ready	    )
	,.ep2_in_buf_data_commit_i 	  	 	(ep2_in_buf_data_commit	    )
	,.ep2_in_buf_data_commit_len_i   	(ep2_in_buf_data_commit_len	)
	,.ep2_in_buf_eob_i					(ep2_in_buf_eob)
	`endif	
	
	`ifdef USER_ENDPT3_IN 
	,.ep3_in_buf_data_i					(ep3_in_buf_data		)
	,.ep3_in_buf_wren_i         		(ep3_in_buf_wren	    )
	,.ep3_in_buf_ready_o        		(ep3_in_buf_ready	    )
	,.ep3_in_buf_data_commit_i 	   		(ep3_in_buf_data_commit	    )
	,.ep3_in_buf_data_commit_len_i		(ep3_in_buf_data_commit_len	)
	`endif	
	
	`ifdef USER_ENDPT4_IN 
	,.ep4_in_buf_data_i					(ep4_in_buf_data		)
	,.ep4_in_buf_wren_i         		(ep4_in_buf_wren	    )
	,.ep4_in_buf_ready_o        		(ep4_in_buf_ready	    )
	,.ep4_in_buf_data_commit_i 	  	 	(ep4_in_buf_data_commit	    )
	,.ep4_in_buf_data_commit_len_i		(ep4_in_buf_data_commit_len	)
	`endif
	
	`ifdef USER_ENDPT5_IN 
	,.ep5_in_buf_data_i					(ep5_in_buf_data		)
	,.ep5_in_buf_wren_i         		(ep5_in_buf_wren	    )
	,.ep5_in_buf_ready_o        		(ep5_in_buf_ready	    )
	,.ep5_in_buf_data_commit_i 	   		(ep5_in_buf_data_commit	    )
	,.ep5_in_buf_data_commit_len_i		(ep5_in_buf_data_commit_len	)
	`endif	
	
	`ifdef USER_ENDPT6_IN 
	,.ep6_in_buf_data_i					(ep6_in_buf_data		)
	,.ep6_in_buf_wren_i         		(ep6_in_buf_wren	    )
	,.ep6_in_buf_ready_o        		(ep6_in_buf_ready	    )
	,.ep6_in_buf_data_commit_i 	  	 	(ep6_in_buf_data_commit	    )
	,.ep6_in_buf_data_commit_len_i		(ep6_in_buf_data_commit_len	)
	`endif	
	
	`ifdef USER_ENDPT7_IN 
	,.ep7_in_buf_data_i					(ep7_in_buf_data		)
	,.ep7_in_buf_wren_i         		(ep7_in_buf_wren	    )
	,.ep7_in_buf_ready_o        		(ep7_in_buf_ready	    )
	,.ep7_in_buf_data_commit_i 	   		(ep7_in_buf_data_commit	    )
	,.ep7_in_buf_data_commit_len_i		(ep7_in_buf_data_commit_len	)
	`endif	
	
	`ifdef USER_ENDPT8_IN 
	,.ep8_in_buf_data_i					(ep8_in_buf_data		)
	,.ep8_in_buf_wren_i         		(ep8_in_buf_wren	    )
	,.ep8_in_buf_ready_o        		(ep8_in_buf_ready	    )
	,.ep8_in_buf_data_commit_i 	   		(ep8_in_buf_data_commit	    )
	,.ep8_in_buf_data_commit_len_i		(ep8_in_buf_data_commit_len	)
	`endif	
	
	`ifdef USER_ENDPT9_IN 
	,.ep9_in_buf_data_i					(ep9_in_buf_data		)
	,.ep9_in_buf_wren_i         		(ep9_in_buf_wren	    )
	,.ep9_in_buf_ready_o        		(ep9_in_buf_ready	    )
	,.ep9_in_buf_data_commit_i 	   		(ep9_in_buf_data_commit	    )
	,.ep9_in_buf_data_commit_len_i		(ep9_in_buf_data_commit_len	)
	`endif	
	
	
	
	`ifdef USER_ENDPT10_IN 
	,.ep10_in_buf_data_i				(ep10_in_buf_data		)
	,.ep10_in_buf_wren_i        		(ep10_in_buf_wren	    )
	,.ep10_in_buf_ready_o       		(ep10_in_buf_ready	    )
	,.ep10_in_buf_data_commit_i 	  	(ep10_in_buf_data_commit	    )
	,.ep10_in_buf_data_commit_len_i		(ep10_in_buf_data_commit_len	)
	`endif	
	
	`ifdef USER_ENDPT11_IN 
	,.ep11_in_buf_data_i				(ep11_in_buf_data		)
	,.ep11_in_buf_wren_i        		(ep11_in_buf_wren	    )
	,.ep11_in_buf_ready_o       		(ep11_in_buf_ready	    )
	,.ep11_in_buf_data_commit_i 	  	(ep11_in_buf_data_commit	    )
	,.ep11_in_buf_data_commit_len_i		(ep11_in_buf_data_commit_len	)
	`endif		
	
	`ifdef USER_ENDPT12_IN 
	,.ep12_in_buf_data_i				(ep12_in_buf_data		)
	,.ep12_in_buf_wren_i        		(ep12_in_buf_wren	    )
	,.ep12_in_buf_ready_o         		(ep12_in_buf_ready	    )
	,.ep12_in_buf_data_commit_i 	  	(ep12_in_buf_data_commit	    )
	,.ep12_in_buf_data_commit_len_i		(ep12_in_buf_data_commit_len	)
	`endif		
	
	`ifdef USER_ENDPT13_IN 
	,.ep13_in_buf_data_i				(ep13_in_buf_data		)
	,.ep13_in_buf_wren_i        		(ep13_in_buf_wren	    )
	,.ep13_in_buf_ready_o       		(ep13_in_buf_ready	    )
	,.ep13_in_buf_data_commit_i 	  	(ep13_in_buf_data_commit	    )
	,.ep13_in_buf_data_commit_len_i		(ep13_in_buf_data_commit_len	)
	`endif		
	
	`ifdef USER_ENDPT14_IN 
	,.ep14_in_buf_data_i				(ep14_in_buf_data		)
	,.ep14_in_buf_wren_i        		(ep14_in_buf_wren	    )
	,.ep14_in_buf_ready_o         		(ep14_in_buf_ready	    )
	,.ep14_in_buf_data_commit_i 	  	(ep14_in_buf_data_commit	    )
	,.ep14_in_buf_data_commit_len_i		(ep14_in_buf_data_commit_len	)
	`endif		
	
	`ifdef USER_ENDPT15_IN 
	,.ep15_in_buf_data_i				(ep15_in_buf_data		)
	,.ep15_in_buf_wren_i        		(ep15_in_buf_wren	    )
	,.ep15_in_buf_ready_o       		(ep15_in_buf_ready	    )
	,.ep15_in_buf_data_commit_i 	  	(ep15_in_buf_data_commit	    )
	,.ep15_in_buf_data_commit_len_i		(ep15_in_buf_data_commit_len	)
	`endif		
	
	
	// ep0 OUT	
	,.ep0_out_buf_data_o		 (ep0_out_buf_data		)	
	,.ep0_out_buf_len_o		     (ep0_out_buf_len		)
	,.ep0_out_buf_has_data_o	     (ep0_out_buf_has_data	)
	,.ep0_out_buf_data_ack_i     (ep0_out_buf_data_ack	)
	,.ep0_out_buf_rden_i         (ep0_out_buf_rden		)
	
	
	`ifdef USER_ENDPT1_OUT
	,.ep1_out_buf_data_o			(ep1_out_buf_data		)
	,.ep1_out_buf_len_o             (ep1_out_buf_len		)
	,.ep1_out_buf_has_data_o        (ep1_out_buf_has_data	)
	,.ep1_out_buf_data_ack_i        (ep1_out_buf_data_ack	)
	,.ep1_out_buf_rden_i            (ep1_out_buf_rden		)
	`endif
	
	
	`ifdef USER_ENDPT2_OUT
	,.ep2_out_buf_data_o			(ep2_out_buf_data		)	 	
	,.ep2_out_buf_len_o			    (ep2_out_buf_len		)
	,.ep2_out_buf_has_data_o	        (ep2_out_buf_has_data	)
	,.ep2_out_buf_data_ack_i        (ep2_out_buf_data_ack	)
	,.ep2_out_buf_rden_i            (ep2_out_buf_rden		)
	`endif	
	
	
	`ifdef USER_ENDPT3_OUT
	,.ep3_out_buf_data_o			(ep3_out_buf_data		)	 	
	,.ep3_out_buf_len_o		        (ep3_out_buf_len		)
	,.ep3_out_buf_has_data_o	        (ep3_out_buf_has_data	)
	,.ep3_out_buf_data_ack_i        (ep3_out_buf_data_ack	)
	,.ep3_out_buf_rden_i            (ep3_out_buf_rden		)
	`endif
	
	
	
	`ifdef USER_ENDPT4_OUT
	,.ep4_out_buf_data_o			(ep4_out_buf_data		) 	
	,.ep4_out_buf_len_o	            (ep4_out_buf_len		)
	,.ep4_out_buf_has_data_o         (ep4_out_buf_has_data	)
	,.ep4_out_buf_data_ack_i        (ep4_out_buf_data_ack	)
	,.ep4_out_buf_rden_i            (ep4_out_buf_rden		)
	`endif	
	
	
	`ifdef USER_ENDPT5_OUT
	,.ep5_out_buf_data_o			(ep5_out_buf_data		)	 	
	,.ep5_out_buf_len_o	            (ep5_out_buf_len		)
	,.ep5_out_buf_has_data_o         (ep5_out_buf_has_data	)
	,.ep5_out_buf_data_ack_i 	    (ep5_out_buf_data_ack	)
	,.ep5_out_buf_rden_i            (ep5_out_buf_rden		)
	`endif	
		
	
	`ifdef USER_ENDPT6_OUT
	,.ep6_out_buf_data_o		 	(ep6_out_buf_data		)	
	,.ep6_out_buf_len_o	            (ep6_out_buf_len		)
	,.ep6_out_buf_has_data_o         (ep6_out_buf_has_data	)
	,.ep6_out_buf_data_ack_i        (ep6_out_buf_data_ack	)
	,.ep6_out_buf_rden_i            (ep6_out_buf_rden		)
	`endif		
		
	
	`ifdef USER_ENDPT7_OUT
	,.ep7_out_buf_data_o			(ep7_out_buf_data		)	 	
	,.ep7_out_buf_len_o	            (ep7_out_buf_len		)
	,.ep7_out_buf_has_data_o         (ep7_out_buf_has_data	)
	,.ep7_out_buf_data_ack_i 	    (ep7_out_buf_data_ack	)
	,.ep7_out_buf_rden_i            (ep7_out_buf_rden		)
	`endif		
	
	
	
	
	`ifdef USER_ENDPT8_OUT
	,.ep8_out_buf_data_o		 	(ep8_out_buf_data		)	
	,.ep8_out_buf_len_o	            (ep8_out_buf_len		)
	,.ep8_out_buf_has_data_o         (ep8_out_buf_has_data	)
	,.ep8_out_buf_data_ack_i 	    (ep8_out_buf_data_ack	)
	,.ep8_out_buf_rden_i            (ep8_out_buf_rden		)
	`endif	
	
	
	
	`ifdef USER_ENDPT9_OUT
	,.ep9_out_buf_data_o		 	(ep9_out_buf_data		)	
	,.ep9_out_buf_len_o	            (ep9_out_buf_len		)
	,.ep9_out_buf_has_data_o         (ep9_out_buf_has_data	)
	,.ep9_out_buf_data_ack_i        (ep9_out_buf_data_ack	)
	,.ep9_out_buf_rden_i            (ep9_out_buf_rden		)
	`endif
	
	
	
	`ifdef USER_ENDPT10_OUT
	,.ep10_out_buf_data_o		 	(ep10_out_buf_data		)	
	,.ep10_out_buf_len_o		    (ep10_out_buf_len		)
	,.ep10_out_buf_has_data_o	    (ep10_out_buf_has_data	)
	,.ep10_out_buf_data_ack_i 	    (ep10_out_buf_data_ack	)
	,.ep10_out_buf_rden_i           (ep10_out_buf_rden		)
	`endif		
	
	
	`ifdef USER_ENDPT11_OUT
	,.ep11_out_buf_data_o			(ep11_out_buf_data		) 	
	,.ep11_out_buf_len_o		    (ep11_out_buf_len		)
	,.ep11_out_buf_has_data_o	    (ep11_out_buf_has_data	)
	,.ep11_out_buf_data_ack_i 	    (ep11_out_buf_data_ack	)
	,.ep11_out_buf_rden_i           (ep11_out_buf_rden		)
	`endif		
	
	`ifdef USER_ENDPT12_OUT
	,.ep12_out_buf_data_o		 	(ep12_out_buf_data		)	
	,.ep12_out_buf_len_o		    (ep12_out_buf_len		)
	,.ep12_out_buf_has_data_o	    (ep12_out_buf_has_data	)
	,.ep12_out_buf_data_ack_i 	    (ep12_out_buf_data_ack	)
	,.ep12_out_buf_rden_i           (ep12_out_buf_rden		)
	`endif		
	
	
	`ifdef USER_ENDPT13_OUT
	,.ep13_out_buf_data_o		 	(ep13_out_buf_data		)	
	,.ep13_out_buf_len_o		    (ep13_out_buf_len		)
	,.ep13_out_buf_has_data_o	    (ep13_out_buf_has_data	)
	,.ep13_out_buf_data_ack_i 	    (ep13_out_buf_data_ack	)
	,.ep13_out_buf_rden_i           (ep13_out_buf_rden		)
	`endif		
	
	
	`ifdef USER_ENDPT14_OUT
	,.ep14_out_buf_data_o		 	(ep14_out_buf_data		)	
	,.ep14_out_buf_len_o		    (ep14_out_buf_len		)
	,.ep14_out_buf_has_data_o	    (ep14_out_buf_has_data	)
	,.ep14_out_buf_data_ack_i 	    (ep14_out_buf_data_ack	)
	,.ep14_out_buf_rden_i           (ep14_out_buf_rden		)
	`endif		
	
	`ifdef USER_ENDPT15_OUT
	,.ep15_out_buf_data_o		 	(ep15_out_buf_data		)
	,.ep15_out_buf_len_o		    (ep15_out_buf_len		)
	,.ep15_out_buf_has_data_o	    (ep15_out_buf_has_data	)
	,.ep15_out_buf_data_ack_i 	    (ep15_out_buf_data_ack	)
	,.ep15_out_buf_rden_i           (ep15_out_buf_rden		)
	`endif	
	

);




UserLayer_top
#(
	.DRAM_NUM (DRAM_NUM)
)
UserLayer_top_inst
(
	 .sys_clk		(sys_clk)
	,.pclk 			(pclk 	   )
	,.phy_resetn    (sys_rst_n || attached  )
	
	,.warm_or_hot_reset				(warm_or_hot_reset)
	,.host_requests_data_from_endpt (host_requests_data_from_endpt)
	,.host_requests_endpt_num       (host_requests_endpt_num      )
	,.itp_recieved					(itp_recieved				  )


	// requests
	,.request_active 		(request_active	)
	,.bmRequestType	        (bmRequestType	)
	,.bRequest		        (bRequest		)
	,.wValue			    (wValue			)
	,.wIndex			    (wIndex			)
	,.wLength		        (wLength		)


	// ep0 IN  
	,.ep0_in_buf_data           (ep0_in_buf_data       )
	,.ep0_in_buf_wren           (ep0_in_buf_wren       )
	,.ep0_in_buf_ready          (ep0_in_buf_ready      )
	,.ep0_in_buf_data_commit         (ep0_in_buf_data_commit     )
	,.ep0_in_buf_data_commit_len     (ep0_in_buf_data_commit_len )

	// ep0 OUT
	,.ep0_out_buf_data		 	(ep0_out_buf_data		)
	,.ep0_out_buf_len		    (ep0_out_buf_len		)
	,.ep0_out_buf_has_data	    (ep0_out_buf_has_data	)
	,.ep0_out_buf_data_ack		(ep0_out_buf_data_ack	)
	,.ep0_out_buf_rden			(ep0_out_buf_rden		)

	
	`ifdef USER_ENDPT1_IN 
	,.ep1_in_buf_data              (ep1_in_buf_data              )
	,.ep1_in_buf_wren              (ep1_in_buf_wren              )
	,.ep1_in_buf_ready             (ep1_in_buf_ready             )
	,.ep1_in_buf_data_commit       (ep1_in_buf_data_commit       )
	,.ep1_in_buf_data_commit_len   (ep1_in_buf_data_commit_len   )
	`endif

	`ifdef USER_ENDPT1_OUT
	,.ep1_out_buf_data              (ep1_out_buf_data      )
	,.ep1_out_buf_len               (ep1_out_buf_len       )
	,.ep1_out_buf_has_data          (ep1_out_buf_has_data  )
	,.ep1_out_buf_rden				(ep1_out_buf_rden	   )
	,.ep1_out_buf_data_ack          (ep1_out_buf_data_ack  )
	`endif

	`ifdef USER_ENDPT2_IN 
	,.ep2_in_buf_data				(ep2_in_buf_data			)
	,.ep2_in_buf_wren               (ep2_in_buf_wren           )
	,.ep2_in_buf_ready              (ep2_in_buf_ready          )
	,.ep2_in_buf_data_commit        (ep2_in_buf_data_commit    )
	,.ep2_in_buf_data_commit_len    (ep2_in_buf_data_commit_len)
	,.ep2_in_buf_eob				(ep2_in_buf_eob				)
	`endif	
	
	`ifdef USER_ENDPT2_OUT
	,.ep2_out_buf_data		 (ep2_out_buf_data		)
	,.ep2_out_buf_len        (ep2_out_buf_len       )
	,.ep2_out_buf_has_data   (ep2_out_buf_has_data  )
	,.ep2_out_buf_rden       (ep2_out_buf_rden      )
	,.ep2_out_buf_data_ack   (ep2_out_buf_data_ack  )
	`endif	
	
	`ifdef USER_ENDPT3_IN 
	,.ep3_in_buf_data				(ep3_in_buf_data			)
	,.ep3_in_buf_wren               (ep3_in_buf_wren           )
	,.ep3_in_buf_ready              (ep3_in_buf_ready          )
	,.ep3_in_buf_data_commit        (ep3_in_buf_data_commit    )
	,.ep3_in_buf_data_commit_len    (ep3_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT3_OUT
	,.ep3_out_buf_data			(ep3_out_buf_data		)
	,.ep3_out_buf_len           (ep3_out_buf_len       )
	,.ep3_out_buf_has_data      (ep3_out_buf_has_data  )
	,.ep3_out_buf_rden          (ep3_out_buf_rden      )
	,.ep3_out_buf_data_ack      (ep3_out_buf_data_ack  )
	`endif

	`ifdef USER_ENDPT4_IN 	
	,.ep4_in_buf_data					(ep4_in_buf_data			)	
	,.ep4_in_buf_wren                   (ep4_in_buf_wren            )
	,.ep4_in_buf_ready                  (ep4_in_buf_ready           )
	,.ep4_in_buf_data_commit            (ep4_in_buf_data_commit     )
	,.ep4_in_buf_data_commit_len        (ep4_in_buf_data_commit_len )
	`endif	
	
	`ifdef USER_ENDPT4_OUT
	,.ep4_out_buf_data					(ep4_out_buf_data	   )
	,.ep4_out_buf_len                   (ep4_out_buf_len       )
	,.ep4_out_buf_has_data              (ep4_out_buf_has_data  )
	,.ep4_out_buf_rden                  (ep4_out_buf_rden      )
	,.ep4_out_buf_data_ack              (ep4_out_buf_data_ack  )
	`endif	

	`ifdef USER_ENDPT5_IN 
	,.ep5_in_buf_data					(ep5_in_buf_data			)
	,.ep5_in_buf_wren                   (ep5_in_buf_wren           )
	,.ep5_in_buf_ready                  (ep5_in_buf_ready          )
	,.ep5_in_buf_data_commit            (ep5_in_buf_data_commit    )
	,.ep5_in_buf_data_commit_len        (ep5_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT5_OUT			
	,.ep5_out_buf_data					(ep5_out_buf_data	   )	
	,.ep5_out_buf_len                   (ep5_out_buf_len       )
	,.ep5_out_buf_has_data              (ep5_out_buf_has_data  )
	,.ep5_out_buf_rden                  (ep5_out_buf_rden      )
	,.ep5_out_buf_data_ack              (ep5_out_buf_data_ack  )
	`endif	

	`ifdef USER_ENDPT6_IN 
	,.ep6_in_buf_data					 (ep6_in_buf_data			)
	,.ep6_in_buf_wren                    (ep6_in_buf_wren           )
	,.ep6_in_buf_ready                   (ep6_in_buf_ready          )
	,.ep6_in_buf_data_commit             (ep6_in_buf_data_commit    )
	,.ep6_in_buf_data_commit_len         (ep6_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT6_OUT
	,.ep6_out_buf_data					 (ep6_out_buf_data		)
	,.ep6_out_buf_len                    (ep6_out_buf_len     )
	,.ep6_out_buf_has_data               (ep6_out_buf_has_data)
	,.ep6_out_buf_rden                   (ep6_out_buf_rden    )
	,.ep6_out_buf_data_ack               (ep6_out_buf_data_ack)
	`endif		
	
	`ifdef USER_ENDPT7_IN 
	,.ep7_in_buf_data					 (ep7_in_buf_data			)
	,.ep7_in_buf_wren                    (ep7_in_buf_wren           )
	,.ep7_in_buf_ready                   (ep7_in_buf_ready          )
	,.ep7_in_buf_data_commit             (ep7_in_buf_data_commit    )
	,.ep7_in_buf_data_commit_len         (ep7_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT7_OUT
	,.ep7_out_buf_data					  (ep7_out_buf_data)
	,.ep7_out_buf_len                     (ep7_out_buf_len)
	,.ep7_out_buf_has_data                (ep7_out_buf_has_data)
	,.ep7_out_buf_rden                    (ep7_out_buf_rden)
	,.ep7_out_buf_data_ack                (ep7_out_buf_data_ack)
	`endif		
	
	`ifdef USER_ENDPT8_IN 
	,.ep8_in_buf_data						(ep8_in_buf_data)
	,.ep8_in_buf_wren                       (ep8_in_buf_wren)
	,.ep8_in_buf_ready                      (ep8_in_buf_ready)
	,.ep8_in_buf_data_commit                (ep8_in_buf_data_commit)
	,.ep8_in_buf_data_commit_len            (ep8_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT8_OUT
	,.ep8_out_buf_data						(ep8_out_buf_data)					
	,.ep8_out_buf_len                       (ep8_out_buf_len)
	,.ep8_out_buf_has_data                  (ep8_out_buf_has_data)
	,.ep8_out_buf_rden                      (ep8_out_buf_rden)
	,.ep8_out_buf_data_ack                  (ep8_out_buf_data_ack)
	`endif	
	
	`ifdef USER_ENDPT9_IN 
	,.ep9_in_buf_data						(ep9_in_buf_data)
	,.ep9_in_buf_wren                       (ep9_in_buf_wren)
	,.ep9_in_buf_ready                      (ep9_in_buf_ready)
	,.ep9_in_buf_data_commit                (ep9_in_buf_data_commit)
	,.ep9_in_buf_data_commit_len            (ep9_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT9_OUT
	,.ep9_out_buf_data						(ep9_out_buf_data)			
	,.ep9_out_buf_len                       (ep9_out_buf_len)
	,.ep9_out_buf_has_data                  (ep9_out_buf_has_data)
	,.ep9_out_buf_rden                      (ep9_out_buf_rden)
	,.ep9_out_buf_data_ack                  (ep9_out_buf_data_ack)
	`endif
	
	`ifdef USER_ENDPT10_IN 
	,.ep10_in_buf_data						(ep10_in_buf_data			)
	,.ep10_in_buf_wren                      (ep10_in_buf_wren           )
	,.ep10_in_buf_ready                     (ep10_in_buf_ready          )
	,.ep10_in_buf_data_commit               (ep10_in_buf_data_commit    )
	,.ep10_in_buf_data_commit_len           (ep10_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT10_OUT
	,.ep10_out_buf_data						(ep10_out_buf_data		)
	,.ep10_out_buf_len                      (ep10_out_buf_len      )
	,.ep10_out_buf_has_data                 (ep10_out_buf_has_data )
	,.ep10_out_buf_rden                     (ep10_out_buf_rden     )
	,.ep10_out_buf_data_ack                 (ep10_out_buf_data_ack )
	`endif		

	`ifdef USER_ENDPT11_IN 
	,.ep11_in_buf_data						(ep11_in_buf_data			)
	,.ep11_in_buf_wren                      (ep11_in_buf_wren           )
	,.ep11_in_buf_ready                     (ep11_in_buf_ready          )
	,.ep11_in_buf_data_commit               (ep11_in_buf_data_commit    )
	,.ep11_in_buf_data_commit_len           (ep11_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT11_OUT
	,.ep11_out_buf_data						(ep11_out_buf_data		)
	,.ep11_out_buf_len                      (ep11_out_buf_len      )
	,.ep11_out_buf_has_data                 (ep11_out_buf_has_data )
	,.ep11_out_buf_rden                     (ep11_out_buf_rden     )
	,.ep11_out_buf_data_ack                 (ep11_out_buf_data_ack )
	`endif		

	`ifdef USER_ENDPT12_IN 
	,.ep12_in_buf_data						(ep12_in_buf_data			)
	,.ep12_in_buf_wren                      (ep12_in_buf_wren           )
	,.ep12_in_buf_ready                     (ep12_in_buf_ready          )
	,.ep12_in_buf_data_commit               (ep12_in_buf_data_commit    )
	,.ep12_in_buf_data_commit_len           (ep12_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT12_OUT
	,.ep12_out_buf_data						(ep12_out_buf_data)
	,.ep12_out_buf_len                      (ep12_out_buf_len)
	,.ep12_out_buf_has_data                 (ep12_out_buf_has_data)
	,.ep12_out_buf_rden                     (ep12_out_buf_rden)
	,.ep12_out_buf_data_ack                 (ep12_out_buf_data_ack)
	`endif		
	
	`ifdef USER_ENDPT13_IN 
	,.ep13_in_buf_data						(ep13_in_buf_data			)
	,.ep13_in_buf_wren                      (ep13_in_buf_wren           )
	,.ep13_in_buf_ready                     (ep13_in_buf_ready          )
	,.ep13_in_buf_data_commit               (ep13_in_buf_data_commit    )
	,.ep13_in_buf_data_commit_len           (ep13_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT13_OUT
	,.ep13_out_buf_data						(ep13_out_buf_data		)
	,.ep13_out_buf_len                      (ep13_out_buf_len      )
	,.ep13_out_buf_has_data                 (ep13_out_buf_has_data )
	,.ep13_out_buf_rden                     (ep13_out_buf_rden     )
	,.ep13_out_buf_data_ack                 (ep13_out_buf_data_ack )
	`endif		
	
	`ifdef USER_ENDPT14_IN 
	,.ep14_in_buf_data						(ep14_in_buf_data			)
	,.ep14_in_buf_wren                      (ep14_in_buf_wren           )
	,.ep14_in_buf_ready                     (ep14_in_buf_ready          )
	,.ep14_in_buf_data_commit               (ep14_in_buf_data_commit    )
	,.ep14_in_buf_data_commit_len           (ep14_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT14_OUT
	,.ep14_out_buf_data						(ep14_out_buf_data		)
	,.ep14_out_buf_len                      (ep14_out_buf_len      )
	,.ep14_out_buf_has_data                 (ep14_out_buf_has_data )
	,.ep14_out_buf_rden                     (ep14_out_buf_rden     )
	,.ep14_out_buf_data_ack                 (ep14_out_buf_data_ack )
	`endif		
	
	
	`ifdef USER_ENDPT15_IN 
	,.ep15_in_buf_data						(ep15_in_buf_data			)
	,.ep15_in_buf_wren                      (ep15_in_buf_wren           )
	,.ep15_in_buf_ready                     (ep15_in_buf_ready          )
	,.ep15_in_buf_data_commit               (ep15_in_buf_data_commit    )
	,.ep15_in_buf_data_commit_len           (ep15_in_buf_data_commit_len)
	`endif	
	
	`ifdef USER_ENDPT15_OUT
	,.ep15_out_buf_data						(ep15_out_buf_data		   )
	,.ep15_out_buf_len                      (ep15_out_buf_len          )
	,.ep15_out_buf_has_data                 (ep15_out_buf_has_data     )
	,.ep15_out_buf_rden                     (ep15_out_buf_rden         )
	,.ep15_out_buf_data_ack                 (ep15_out_buf_data_ack     )
	`endif			

	,.ddr_addr 	        (ddr_addr 	)
	,.ddr_bank          (ddr_bank   )
	,.ddr_cs            (ddr_cs     )
	,.ddr_ras           (ddr_ras    )
	,.ddr_cas           (ddr_cas    )
	,.ddr_we            (ddr_we     )
	,.ddr_ck            (ddr_ck     )
	,.ddr_ck_n          (ddr_ck_n   )
	,.ddr_cke           (ddr_cke    )
	,.ddr_odt           (ddr_odt    )
	,.ddr_reset_n       (ddr_reset_n)
	,.ddr_dm            (ddr_dm     )
	,.ddr_dq            (ddr_dq     )
	,.ddr_dqs           (ddr_dqs    )
	,.ddr_dqs_n         (ddr_dqs_n  )


);


//debug
reg [4:0] dbg_ltssm_state ;
reg [4:0] dbg_ltssm_state_d ;
reg [3:0] host_requests_ep ;
reg dbg_rxeleidle ;
reg dbg_txeleidle ;
reg dbg_warm_or_hot_reset ;
reg host_requests_data ;
reg deb_host_req_ep_0 ;
reg deb_host_req_ep_1 ;
reg deb_host_req_ep_2 ;
reg deb_lfps_send_ping_local ;
reg lfps_send_u1_local ;
reg deb_ltssm_state_error ;


always@(posedge pclk)
begin
	dbg_warm_or_hot_reset 	<= warm_or_hot_reset ;
	dbg_ltssm_state <= USB30_Device_Controller_Top_inst.usb30_device_controller_inst.ltssm_state ;
	dbg_ltssm_state_d <= dbg_ltssm_state ;
	deb_ltssm_state_error <= ( dbg_ltssm_state == 10 ) ? 1'b1 : 1'b0 ;
	dbg_rxeleidle 	<= phy_rx_elecidle ;
	dbg_txeleidle 	<= phy_tx_elecidle ;
	host_requests_data <= USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3r.host_requests_data ;
	host_requests_ep <= USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3r.host_requests_endpt ;
	//deb_phy_tx_detrx_lpbk <= phy_tx_detrx_lpbk ;
	//deb_proc_active <= USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3p.proc_active;
	lfps_send_u1_local <= USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3lt.lfps_send_u1_local ;
	//deb_cnt2 <= deb_cnt1 ;
	//deb_lfps_send_poll_local <= USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3lt.lfps_send_poll_local ;
	deb_lfps_send_ping_local <= USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3lt.lfps_send_ping_local ;
	deb_host_req_ep_0 <= ( host_requests_data && host_requests_ep == 0 ) ? 1 : 0 ;
	deb_host_req_ep_1 <= ( host_requests_data && host_requests_ep == 1 ) ? 1 : 0 ;
	deb_host_req_ep_2 <= ( host_requests_data && host_requests_ep == 2 ) ? 1 : 0 ;	
end


assign dbg_0 = dbg_ltssm_state [0] ;
assign dbg_1 = dbg_ltssm_state [1] ;
assign dbg_2 = dbg_ltssm_state [2] ;
assign dbg_3 = dbg_ltssm_state [3] ;
assign dbg_4 = dbg_ltssm_state [4] ;
//assign dbg_0 = ( dbg_ltssm_state == 16 ) ;
//assign dbg_1 = ( dbg_ltssm_state == 10 ) ;
//assign dbg_2 = dbg_ltssm_state [2] ;
//assign dbg_3 = dbg_ltssm_state [3] ;
//assign dbg_4 = dbg_ltssm_state [4] ;
//assign dbg_5 = ep2_in_buf_data_commit ;
//assign dbg_6 = ep2_in_buf_eob ;
//assign dbg_5 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.err_lcrd_mismatch ;
assign dbg_5 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.prot_rx_tp_retry ;
assign dbg_6 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.err_lgood_order ;
assign dbg_7 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.err_hp_seq  ;
assign dbg_8 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.err_lbad_recv ;
assign dbg_9 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.err_lbad;
assign dbg_10 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.outp_active ;
//assign dbg_11 = deb_host_req_ep_2 ;
assign dbg_11 = flg ;
assign dbg_12 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3r.burst_in_act;
assign dbg_13 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.prot_rx_tp ;
assign dbg_14 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.prot_tx_dph    ;
//assign dbg_15 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.prot_tx_dph_eob ;
assign dbg_15 = USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.ltssm_go_recovery ;
assign dbg_16 = itp_recieved ;
assign dbg_17 = dbg_16;


reg [15:0] dp_cnt ;
always@(posedge pclk or negedge sys_rst_n ) begin
	if (!sys_rst_n ) begin
		dp_cnt <= 0 ;
	end
	else begin
		if ( USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3r.do_send_dpp &&
			 USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3r.do_send_dpp_ack && 
			 USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3r.tx_endp == 2 && 
			 USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3r.dpp_eob ) begin
			dp_cnt <= dp_cnt + 1 ;
		end
	end
end

reg [31:0] clk_cnt ;
reg flg ;
always@(posedge pclk or negedge sys_rst_n ) begin
	if (!sys_rst_n ) begin
		clk_cnt <= 0 ;
		flg <= 0 ;
	end
	else begin
		flg <= 0 ;
		if ( USB30_Device_Controller_Top_inst.usb30_device_controller_inst.iu3l.prot_tx_dpp_ack ) begin
			clk_cnt <= 0 ;
		end
		else begin
			clk_cnt <= clk_cnt + 1 ;
			if ( clk_cnt + 1 >= 12_500_000 ) begin
				clk_cnt <= 0 ;
				flg <= 1 ;
			end
		end
	end
end






endmodule
