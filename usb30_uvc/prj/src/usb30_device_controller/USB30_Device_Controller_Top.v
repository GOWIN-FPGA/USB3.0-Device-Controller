`include "usb3_macro_define.v"	
module USB30_Device_Controller_Top
(

input	wire			phy_clk_i
,input	wire			reset_n_i


,input	wire	[31:0]	phy_pipe_rx_data_i
,input	wire	[3:0]	phy_pipe_rx_datak_i
,input	wire			phy_pipe_rx_valid_i
,output	wire	[31:0]	phy_pipe_tx_data_o
,output	wire	[3:0]	phy_pipe_tx_datak_o

,output	wire			phy_reset_n_o
,output	wire			phy_tx_detrx_lpbk_o
,output	wire			phy_tx_elecidle_o
,input	wire			phy_rx_elecidle_i
,input	wire	[2:0]	phy_rx_status_i
,output	wire	[1:0]	phy_power_down_o
,input   wire			phy_phy_status_i
,input	wire			phy_pwrpresent_i

,output	wire			phy_tx_oneszeros_o
,output	wire	[1:0]	phy_tx_deemph_o
,output	wire	[2:0]	phy_tx_margin_o
,output	wire			phy_tx_swing_o
,output	wire			phy_rx_polarity_o
,output	wire			phy_rx_termination_o
,output	wire			phy_rate_o
,output	wire			phy_elas_buf_mode_o



,output wire 		warm_or_hot_reset_o
,output wire  		host_requests_data_from_endpt_o  
,output wire  [3:0] host_requests_endpt_num_o
,output wire		itp_recieved
,output wire		attached

// requests
,output wire			request_active_o	
,output wire	[7:0]	bmRequestType_o	
,output wire	[7:0]	bRequest_o		
,output wire	[15:0]	wValue_o		
,output wire	[15:0]	wIndex_o			
,output wire	[15:0]	wLength_o		


// ep0 IN  
,input	wire	[31:0]	ep0_in_buf_data_i
,input	wire			ep0_in_buf_wren_i
,output	wire			ep0_in_buf_ready_o
,input	wire			ep0_in_buf_data_commit_i 	
,input	wire	[10:0]	ep0_in_buf_data_commit_len_i


`ifdef ENDPT1_IN 
,input	wire	[31:0]	ep1_in_buf_data_i
,input	wire			ep1_in_buf_wren_i
,output	wire			ep1_in_buf_ready_o
,input	wire			ep1_in_buf_data_commit_i 	
,input	wire	[10:0]	ep1_in_buf_data_commit_len_i
,input  wire			ep1_in_buf_eob_i
`endif	

`ifdef ENDPT2_IN 
,input	wire	[31:0]	ep2_in_buf_data_i
,input	wire			ep2_in_buf_wren_i
,output	wire			ep2_in_buf_ready_o
,input	wire			ep2_in_buf_data_commit_i 	
,input	wire	[10:0]	ep2_in_buf_data_commit_len_i
,input  wire			ep2_in_buf_eob_i
`endif	

`ifdef ENDPT3_IN 
,input	wire	[31:0]	ep3_in_buf_data_i
,input	wire			ep3_in_buf_wren_i
,output	wire			ep3_in_buf_ready_o
,input	wire			ep3_in_buf_data_commit_i 	
,input	wire	[10:0]	ep3_in_buf_data_commit_len_i	
,input  wire			ep3_in_buf_eob_i
`endif	

`ifdef ENDPT4_IN 
,input	wire	[31:0]	ep4_in_buf_data_i
,input	wire			ep4_in_buf_wren_i
,output	wire			ep4_in_buf_ready_o
,input	wire			ep4_in_buf_data_commit_i 	
,input	wire	[10:0]	ep4_in_buf_data_commit_len_i	
,input  wire			ep4_in_buf_eob_i
`endif

`ifdef ENDPT5_IN 
,input	wire	[31:0]	ep5_in_buf_data_i
,input	wire			ep5_in_buf_wren_i
,output	wire			ep5_in_buf_ready_o
,input	wire			ep5_in_buf_data_commit_i 	
,input	wire	[10:0]	ep5_in_buf_data_commit_len_i
,input  wire			ep5_in_buf_eob_i	
`endif	

`ifdef ENDPT6_IN 
,input	wire	[31:0]	ep6_in_buf_data_i
,input	wire			ep6_in_buf_wren_i
,output	wire			ep6_in_buf_ready_o
,input	wire			ep6_in_buf_data_commit_i 	
,input	wire	[10:0]	ep6_in_buf_data_commit_len_i
,input  wire			ep6_in_buf_eob_i	
`endif	

`ifdef ENDPT7_IN 
,input	wire	[31:0]	ep7_in_buf_data_i
,input	wire			ep7_in_buf_wren_i
,output	wire			ep7_in_buf_ready_o
,input	wire			ep7_in_buf_data_commit_i 	
,input	wire	[10:0]	ep7_in_buf_data_commit_len_i
,input  wire			ep7_in_buf_eob_i	
`endif	

`ifdef ENDPT8_IN 
,input	wire	[31:0]	ep8_in_buf_data_i
,input	wire			ep8_in_buf_wren_i
,output	wire			ep8_in_buf_ready_o
,input	wire			ep8_in_buf_data_commit_i 	
,input	wire	[10:0]	ep8_in_buf_data_commit_len_i
,input  wire			ep8_in_buf_eob_i
`endif	

`ifdef ENDPT9_IN 
,input	wire	[31:0]	ep9_in_buf_data_i
,input	wire			ep9_in_buf_wren_i
,output	wire			ep9_in_buf_ready_o
,input	wire			ep9_in_buf_data_commit_i 	
,input	wire	[10:0]	ep9_in_buf_data_commit_len_i
,input  wire			ep9_in_buf_eob_i	
`endif	



`ifdef ENDPT10_IN 
,input	wire	[31:0]	ep10_in_buf_data_i
,input	wire			ep10_in_buf_wren_i
,output	wire			ep10_in_buf_ready_o
,input	wire			ep10_in_buf_data_commit_i 	
,input	wire	[10:0]	ep10_in_buf_data_commit_len_i
,input  wire			ep10_in_buf_eob_i	
`endif	

`ifdef ENDPT11_IN 
,input	wire	[31:0]	ep11_in_buf_data_i
,input	wire			ep11_in_buf_wren_i
,output	wire			ep11_in_buf_ready_o
,input	wire			ep11_in_buf_data_commit_i 	
,input	wire	[10:0]	ep11_in_buf_data_commit_len_i	
,input  wire			ep11_in_buf_eob_i
`endif		

`ifdef ENDPT12_IN 
,input	wire	[31:0]	ep12_in_buf_data_i
,input	wire			ep12_in_buf_wren_i
,output	wire			ep12_in_buf_ready_o
,input	wire			ep12_in_buf_data_commit_i 	
,input	wire	[10:0]	ep12_in_buf_data_commit_len_i
,input  wire			ep12_in_buf_eob_i	
`endif		

`ifdef ENDPT13_IN 
,input	wire	[31:0]	ep13_in_buf_data_i
,input	wire			ep13_in_buf_wren_i
,output	wire			ep13_in_buf_ready_o
,input	wire			ep13_in_buf_data_commit_i 	
,input	wire	[10:0]	ep13_in_buf_data_commit_len_i
,input  wire			ep13_in_buf_eob_i	
`endif		

`ifdef ENDPT14_IN 
,input	wire	[31:0]	ep14_in_buf_data_i
,input	wire			ep14_in_buf_wren_i
,output	wire			ep14_in_buf_ready_o
,input	wire			ep14_in_buf_data_commit_i 	
,input	wire	[10:0]	ep14_in_buf_data_commit_len_i	
,input  wire			ep14_in_buf_eob_i
`endif		

`ifdef ENDPT15_IN 
,input	wire	[31:0]	ep15_in_buf_data_i
,input	wire			ep15_in_buf_wren_i
,output	wire			ep15_in_buf_ready_o
,input	wire			ep15_in_buf_data_commit_i 	
,input	wire	[10:0]	ep15_in_buf_data_commit_len_i
,input  wire			ep15_in_buf_eob_i	
`endif		


// ep0 OUT	
,output wire	[31:0]	ep0_out_buf_data_o		 	
,output wire	[10:0]	ep0_out_buf_len_o		
,output wire			ep0_out_buf_has_data_o	
,input wire				ep0_out_buf_data_ack_i
,input wire				ep0_out_buf_rden_i


`ifdef ENDPT1_OUT
,output	wire	[31:0]	ep1_out_buf_data_o
,output	wire	[10:0]	ep1_out_buf_len_o
,output	wire			ep1_out_buf_has_data_o
,input	wire			ep1_out_buf_data_ack_i 
,input  wire			ep1_out_buf_rden_i
`endif


`ifdef ENDPT2_OUT
,output wire	[31:0]	ep2_out_buf_data_o		 	
,output wire	[10:0]	ep2_out_buf_len_o		
,output wire			ep2_out_buf_has_data_o	
,input wire				ep2_out_buf_data_ack_i 
,input wire				ep2_out_buf_rden_i
`endif	


`ifdef ENDPT3_OUT
,output wire	[31:0]	ep3_out_buf_data_o		 	
,output wire	[10:0]	ep3_out_buf_len_o		
,output wire			ep3_out_buf_has_data_o	
,input wire				ep3_out_buf_data_ack_i 
,input wire				ep3_out_buf_rden_i
`endif



`ifdef ENDPT4_OUT
,output wire	[31:0]	ep4_out_buf_data_o		 	
,output wire	[10:0]	ep4_out_buf_len_o	
,output wire			ep4_out_buf_has_data_o
,input wire				ep4_out_buf_data_ack_i 
,input wire				ep4_out_buf_rden_i
`endif	


`ifdef ENDPT5_OUT
,output wire	[31:0]	ep5_out_buf_data_o		 	
,output wire	[10:0]	ep5_out_buf_len_o	
,output wire			ep5_out_buf_has_data_o
,input wire				ep5_out_buf_data_ack_i 	
,input wire				ep5_out_buf_rden_i
`endif	
	

`ifdef ENDPT6_OUT
,output wire	[31:0]	ep6_out_buf_data_o		 	
,output wire	[10:0]	ep6_out_buf_len_o	
,output wire			ep6_out_buf_has_data_o
,input wire				ep6_out_buf_data_ack_i 
,input wire				ep6_out_buf_rden_i
`endif		
	

`ifdef ENDPT7_OUT
,output wire	[31:0]	ep7_out_buf_data_o		 	
,output wire	[10:0]	ep7_out_buf_len_o	
,output wire			ep7_out_buf_has_data_o
,input wire				ep7_out_buf_data_ack_i 	
,input wire				ep7_out_buf_rden_i
`endif		




`ifdef ENDPT8_OUT
,output wire	[31:0]	ep8_out_buf_data_o		 	
,output wire	[10:0]	ep8_out_buf_len_o	
,output wire			ep8_out_buf_has_data_o
,input wire				ep8_out_buf_data_ack_i 	
,input wire				ep8_out_buf_rden_i
`endif	



`ifdef ENDPT9_OUT
,output wire	[31:0]	ep9_out_buf_data_o		 	
,output wire	[10:0]	ep9_out_buf_len_o	
,output wire			ep9_out_buf_has_data_o
,input wire				ep9_out_buf_data_ack_i 
,input wire				ep9_out_buf_rden_i
`endif



`ifdef ENDPT10_OUT
,output wire	[31:0]	ep10_out_buf_data_o		 	
,output wire	[10:0]	ep10_out_buf_len_o		
,output wire			ep10_out_buf_has_data_o	
,input wire				ep10_out_buf_data_ack_i 	
,input wire				ep10_out_buf_rden_i
`endif		


`ifdef ENDPT11_OUT
,output wire	[31:0]	ep11_out_buf_data_o		 	
,output wire	[10:0]	ep11_out_buf_len_o		
,output wire			ep11_out_buf_has_data_o	
,input wire				ep11_out_buf_data_ack_i 	
,input wire				ep11_out_buf_rden_i
`endif		

`ifdef ENDPT12_OUT
,output wire	[31:0]	ep12_out_buf_data_o		 	
,output wire	[10:0]	ep12_out_buf_len_o		
,output wire			ep12_out_buf_has_data_o	
,input wire				ep12_out_buf_data_ack_i 	
,input wire				ep12_out_buf_rden_i
`endif		


`ifdef ENDPT13_OUT
,output wire	[31:0]	ep13_out_buf_data_o		 	
,output wire	[10:0]	ep13_out_buf_len_o		
,output wire			ep13_out_buf_has_data_o	
,input wire				ep13_out_buf_data_ack_i 	
,input wire				ep13_out_buf_rden_i
`endif		


`ifdef ENDPT14_OUT
,output wire	[31:0]	ep14_out_buf_data_o		 	
,output wire	[10:0]	ep14_out_buf_len_o		
,output wire			ep14_out_buf_has_data_o	
,input wire				ep14_out_buf_data_ack_i 	
,input wire				ep14_out_buf_rden_i
`endif		

`ifdef ENDPT15_OUT
,output wire	[31:0]	ep15_out_buf_data_o		 	
,output wire	[10:0]	ep15_out_buf_len_o		
,output wire			ep15_out_buf_has_data_o	
,input wire				ep15_out_buf_data_ack_i 	
,input wire				ep15_out_buf_rden_i
`endif	



		

);

`ifdef SIM
usb30_device_controller
`else
`getname(usb30_device_controller,`module_name)
`endif
usb30_device_controller_inst (
	.phy_clk					(phy_clk_i)//input	wire			
	,.reset_n					(reset_n_i )//input	wire			
	,.phy_pipe_rx_data			(phy_pipe_rx_data_i)//input	wire	[31:0]	
	,.phy_pipe_rx_datak			(phy_pipe_rx_datak_i)//input	wire	[3:0]	
	,.phy_pipe_rx_valid			(phy_pipe_rx_valid_i)//input	wire	[1:0]	
	,.phy_pipe_tx_data			(phy_pipe_tx_data_o)//output	wire	[31:0]	
	,.phy_pipe_tx_datak			(phy_pipe_tx_datak_o)//output	wire	[3:0]	
	,.phy_reset_n				(phy_reset_n_o)//output	wire								
	,.phy_tx_detrx_lpbk			(phy_tx_detrx_lpbk_o)//output	wire			
	,.phy_tx_elecidle			(phy_tx_elecidle_o	)//output	wire			
	,.phy_rx_elecidle			(phy_rx_elecidle_i	)//inout	wire			
	,.phy_rx_status				(phy_rx_status_i)//input	wire	[5:0]	
	,.phy_power_down			(phy_power_down_o		)//output	wire	[1:0]	
	,.phy_phy_status			(phy_phy_status_i		)//input   wire	[1:0]		        
	,.phy_pwrpresent			(phy_pwrpresent_i		)//input	wire			
	,.phy_tx_oneszeros			(phy_tx_oneszeros_o	)//output	wire			
	,.phy_tx_deemph				(phy_tx_deemph_o		)//output	wire	[1:0]	
	,.phy_tx_margin				(phy_tx_margin_o		)//output	wire	[2:0]	
	,.phy_tx_swing				(phy_tx_swing_o		)//output	wire			
	,.phy_rx_polarity			(phy_rx_polarity_o)//output	wire			
	,.phy_rx_termination		(phy_rx_termination_o	)//output	wire			
	,.phy_rate					(phy_rate_o			)//output	wire			
	,.phy_elas_buf_mode			(phy_elas_buf_mode_o)//output	wire	


	// external interface
	
	,.warm_or_hot_reset ( warm_or_hot_reset_o ) 
	,.host_requests_data_from_endpt (host_requests_data_from_endpt_o ) 
	,.host_requests_endpt_num	    (host_requests_endpt_num_o	   )
	,.itp_recieved					( itp_recieved)
	,.attached						( attached )
	
	// requests 
	,.request_active 	(request_active_o	)
	,.bmRequestType		(bmRequestType_o	)
	,.bRequest			(bRequest_o)
	,.wValue			(wValue_o			)
	,.wIndex			(wIndex_o			)
	,.wLength			(wLength_o)
		
	// ep0 IN 	
	,.ep0_in_buf_data            (ep0_in_buf_data_i        )
	,.ep0_in_buf_wren            (ep0_in_buf_wren_i        )
	,.ep0_in_buf_ready           (ep0_in_buf_ready_o       )
	,.ep0_in_buf_data_commit     (ep0_in_buf_data_commit_i 	  )
	,.ep0_in_buf_data_commit_len (ep0_in_buf_data_commit_len_i  )
	
	// ep0 OUT	
	,.ep0_out_buf_data		 	(ep0_out_buf_data_o		)
	,.ep0_out_buf_len		    (ep0_out_buf_len_o		)
	,.ep0_out_buf_has_data	    (ep0_out_buf_has_data_o	)
	,.ep0_out_buf_data_ack	    (ep0_out_buf_data_ack_i	)
	,.ep0_out_buf_rden			(ep0_out_buf_rden_i		)		
	
	
	`ifdef ENDPT1_IN 
	,.ep1_in_buf_data         		(ep1_in_buf_data_i        )
	,.ep1_in_buf_wren         		(ep1_in_buf_wren_i        )
	,.ep1_in_buf_ready   			(ep1_in_buf_ready_o       )
	,.ep1_in_buf_data_commit		(ep1_in_buf_data_commit_i 	  )
	,.ep1_in_buf_data_commit_len    (ep1_in_buf_data_commit_len_i  )
	,.ep1_in_buf_eob			    (ep1_in_buf_eob_i  )	
	`endif
	
	`ifdef ENDPT2_IN 
	,.ep2_in_buf_data				(ep2_in_buf_data_i        )
	,.ep2_in_buf_wren               (ep2_in_buf_wren_i        )
	,.ep2_in_buf_ready              (ep2_in_buf_ready_o       )
	,.ep2_in_buf_data_commit        (ep2_in_buf_data_commit_i 	  )
	,.ep2_in_buf_data_commit_len    (ep2_in_buf_data_commit_len_i  )
	,.ep2_in_buf_eob			    (ep2_in_buf_eob_i  )
	`endif	
		
	`ifdef ENDPT3_IN 
	,.ep3_in_buf_data				(ep3_in_buf_data_i        )
	,.ep3_in_buf_wren               (ep3_in_buf_wren_i        )
	,.ep3_in_buf_ready              (ep3_in_buf_ready_o       )
	,.ep3_in_buf_data_commit        (ep3_in_buf_data_commit_i 	  )
	,.ep3_in_buf_data_commit_len    (ep3_in_buf_data_commit_len_i  )
	,.ep3_in_buf_eob			    (ep3_in_buf_eob_i  )	
	`endif	
	
	`ifdef ENDPT4_IN 	
	,.ep4_in_buf_data					(ep4_in_buf_data_i        )	
	,.ep4_in_buf_wren                   (ep4_in_buf_wren_i        )
	,.ep4_in_buf_ready                  (ep4_in_buf_ready_o       )
	,.ep4_in_buf_data_commit            (ep4_in_buf_data_commit_i 	  )
	,.ep4_in_buf_data_commit_len        (ep4_in_buf_data_commit_len_i  )
	,.ep4_in_buf_eob			    	(ep4_in_buf_eob_i  )	
	`endif	
	
	`ifdef ENDPT5_IN 
	,.ep5_in_buf_data					(ep5_in_buf_data_i        )
	,.ep5_in_buf_wren                   (ep5_in_buf_wren_i        )
	,.ep5_in_buf_ready                  (ep5_in_buf_ready_o       )
	,.ep5_in_buf_data_commit            (ep5_in_buf_data_commit_i 	 )
	,.ep5_in_buf_data_commit_len        (ep5_in_buf_data_commit_len_i )
	,.ep5_in_buf_eob			    	(ep5_in_buf_eob_i  )	
	`endif	
	
	`ifdef ENDPT6_IN 
	,.ep6_in_buf_data					 (ep6_in_buf_data_i        )
	,.ep6_in_buf_wren                    (ep6_in_buf_wren_i        )
	,.ep6_in_buf_ready                   (ep6_in_buf_ready_o       )
	,.ep6_in_buf_data_commit             (ep6_in_buf_data_commit_i 	  )
	,.ep6_in_buf_data_commit_len         (ep6_in_buf_data_commit_len_i  )
	,.ep6_in_buf_eob			    	 (ep6_in_buf_eob_i  )	
	`endif	
	
	`ifdef ENDPT7_IN 
	,.ep7_in_buf_data					 (ep7_in_buf_data_i        )
	,.ep7_in_buf_wren                    (ep7_in_buf_wren_i        )
	,.ep7_in_buf_ready                   (ep7_in_buf_ready_o       )
	,.ep7_in_buf_data_commit             (ep7_in_buf_data_commit_i 	  )
	,.ep7_in_buf_data_commit_len         (ep7_in_buf_data_commit_len_i  )
	,.ep7_in_buf_eob			    	 (ep7_in_buf_eob_i  )	
	`endif	
	
	`ifdef ENDPT8_IN 
	,.ep8_in_buf_data						(ep8_in_buf_data_i        )
	,.ep8_in_buf_wren                       (ep8_in_buf_wren_i        )
	,.ep8_in_buf_ready                      (ep8_in_buf_ready_o       )
	,.ep8_in_buf_data_commit                (ep8_in_buf_data_commit_i 	  )
	,.ep8_in_buf_data_commit_len            (ep8_in_buf_data_commit_len_i  )
	,.ep8_in_buf_eob			    		(ep8_in_buf_eob_i  )	
	`endif	

	`ifdef ENDPT9_IN 
	,.ep9_in_buf_data						(ep9_in_buf_data_i        )
	,.ep9_in_buf_wren                       (ep9_in_buf_wren_i        )
	,.ep9_in_buf_ready                      (ep9_in_buf_ready_o       )
	,.ep9_in_buf_data_commit                (ep9_in_buf_data_commit_i 	  )
	,.ep9_in_buf_data_commit_len            (ep9_in_buf_data_commit_len_i  )
	,.ep9_in_buf_eob			    		(ep9_in_buf_eob_i  )	
	`endif	
	
	`ifdef ENDPT10_IN 
	,.ep10_in_buf_data						(ep10_in_buf_data_i        )
	,.ep10_in_buf_wren                      (ep10_in_buf_wren_i        )
	,.ep10_in_buf_ready                     (ep10_in_buf_ready_o       )
	,.ep10_in_buf_data_commit               (ep10_in_buf_data_commit_i 	  )
	,.ep10_in_buf_data_commit_len           (ep10_in_buf_data_commit_len_i  )
	,.ep10_in_buf_eob			    		(ep10_in_buf_eob_i  )	
	`endif	
	
	`ifdef ENDPT11_IN 
	,.ep11_in_buf_data						(ep11_in_buf_data_i        )
	,.ep11_in_buf_wren                      (ep11_in_buf_wren_i        )
	,.ep11_in_buf_ready                     (ep11_in_buf_ready_o       )
	,.ep11_in_buf_data_commit               (ep11_in_buf_data_commit_i 	  )
	,.ep11_in_buf_data_commit_len           (ep11_in_buf_data_commit_len_i  )
	,.ep11_in_buf_eob			    		(ep11_in_buf_eob_i  )	
	`endif	
	
	`ifdef ENDPT12_IN 
	,.ep12_in_buf_data						(ep12_in_buf_data_i        )
	,.ep12_in_buf_wren                      (ep12_in_buf_wren_i        )
	,.ep12_in_buf_ready                     (ep12_in_buf_ready_o       )
	,.ep12_in_buf_data_commit               (ep12_in_buf_data_commit_i 	  )
	,.ep12_in_buf_data_commit_len           (ep12_in_buf_data_commit_len_i  )
	,.ep12_in_buf_eob			    		(ep12_in_buf_eob_i  )	
	`endif	
	
	`ifdef ENDPT13_IN 
	,.ep13_in_buf_data						(ep13_in_buf_data_i        )
	,.ep13_in_buf_wren                      (ep13_in_buf_wren_i        )
	,.ep13_in_buf_ready                     (ep13_in_buf_ready_o       )
	,.ep13_in_buf_data_commit               (ep13_in_buf_data_commit_i 	  )
	,.ep13_in_buf_data_commit_len           (ep13_in_buf_data_commit_len_i  )
	,.ep13_in_buf_eob			    		(ep13_in_buf_eob_i  )	
	`endif	
	
	`ifdef ENDPT14_IN 
	,.ep14_in_buf_data						(ep14_in_buf_data_i        )
	,.ep14_in_buf_wren                      (ep14_in_buf_wren_i        )
	,.ep14_in_buf_ready                     (ep14_in_buf_ready_o       )
	,.ep14_in_buf_data_commit               (ep14_in_buf_data_commit_i 	 )
	,.ep14_in_buf_data_commit_len           (ep14_in_buf_data_commit_len_i )
	,.ep14_in_buf_eob			    		(ep14_in_buf_eob_i  )	
	`endif	
		
	`ifdef ENDPT15_IN 
	,.ep15_in_buf_data						(ep15_in_buf_data_i        )
	,.ep15_in_buf_wren                      (ep15_in_buf_wren_i        )
	,.ep15_in_buf_ready                     (ep15_in_buf_ready_o       )
	,.ep15_in_buf_data_commit               (ep15_in_buf_data_commit_i 	  )
	,.ep15_in_buf_data_commit_len           (ep15_in_buf_data_commit_len_i  )
	,.ep15_in_buf_eob			   			(ep15_in_buf_eob_i  )	
	`endif	


	`ifdef ENDPT1_OUT
	,.ep1_out_buf_data				(ep1_out_buf_data_o	   		)
	,.ep1_out_buf_len           	(ep1_out_buf_len_o       	)
	,.ep1_out_buf_has_data      	(ep1_out_buf_has_data_o  	)
	,.ep1_out_buf_data_ack      	(ep1_out_buf_data_ack_i  	)
	,.ep1_out_buf_rden				(ep1_out_buf_rden_i  	    )
	`endif
	
	`ifdef ENDPT2_OUT
	,.ep2_out_buf_data		 (ep2_out_buf_data_o		)
	,.ep2_out_buf_len        (ep2_out_buf_len_o         )
	,.ep2_out_buf_has_data   (ep2_out_buf_has_data_o    )
	,.ep2_out_buf_rden       (ep2_out_buf_rden_i        )
	,.ep2_out_buf_data_ack   (ep2_out_buf_data_ack_i    )
	`endif	
	
	`ifdef ENDPT3_OUT
	,.ep3_out_buf_data			(ep3_out_buf_data_o		)
	,.ep3_out_buf_len           (ep3_out_buf_len_o       )
	,.ep3_out_buf_has_data      (ep3_out_buf_has_data_o  )
	,.ep3_out_buf_rden          (ep3_out_buf_rden_i      )
	,.ep3_out_buf_data_ack      (ep3_out_buf_data_ack_i  )
	`endif

	`ifdef ENDPT4_OUT
	,.ep4_out_buf_data					(ep4_out_buf_data_o	 )
	,.ep4_out_buf_len                   (ep4_out_buf_len_o      )
	,.ep4_out_buf_has_data              (ep4_out_buf_has_data_o )
	,.ep4_out_buf_rden                  (ep4_out_buf_rden_i     )
	,.ep4_out_buf_data_ack              (ep4_out_buf_data_ack_i )
	`endif	

	`ifdef ENDPT5_OUT			
	,.ep5_out_buf_data					(ep5_out_buf_data_o	  )	
	,.ep5_out_buf_len                   (ep5_out_buf_len_o       )
	,.ep5_out_buf_has_data              (ep5_out_buf_has_data_o  )
	,.ep5_out_buf_rden                  (ep5_out_buf_rden_i      )
	,.ep5_out_buf_data_ack              (ep5_out_buf_data_ack_i  )
	`endif	

	`ifdef ENDPT6_OUT
	,.ep6_out_buf_data					 (ep6_out_buf_data_o	)
	,.ep6_out_buf_len                    (ep6_out_buf_len_o     )
	,.ep6_out_buf_has_data               (ep6_out_buf_has_data_o)
	,.ep6_out_buf_rden                   (ep6_out_buf_rden_i    )
	,.ep6_out_buf_data_ack               (ep6_out_buf_data_ack_i)
	`endif		
	
	`ifdef ENDPT7_OUT
	,.ep7_out_buf_data					  (ep7_out_buf_data_o	)
	,.ep7_out_buf_len                     (ep7_out_buf_len_o     )
	,.ep7_out_buf_has_data                (ep7_out_buf_has_data_o)
	,.ep7_out_buf_rden                    (ep7_out_buf_rden_i    )
	,.ep7_out_buf_data_ack                (ep7_out_buf_data_ack_i)
	`endif		

	`ifdef ENDPT8_OUT
	,.ep8_out_buf_data						(ep8_out_buf_data_o	)			
	,.ep8_out_buf_len                       (ep8_out_buf_len_o     )
	,.ep8_out_buf_has_data                  (ep8_out_buf_has_data_o)
	,.ep8_out_buf_rden                      (ep8_out_buf_rden_i    )
	,.ep8_out_buf_data_ack                  (ep8_out_buf_data_ack_i)
	`endif	
	
	`ifdef ENDPT9_OUT
	,.ep9_out_buf_data						(ep9_out_buf_data_o	)	
	,.ep9_out_buf_len                       (ep9_out_buf_len_o     )
	,.ep9_out_buf_has_data                  (ep9_out_buf_has_data_o)
	,.ep9_out_buf_rden                      (ep9_out_buf_rden_i    )
	,.ep9_out_buf_data_ack                  (ep9_out_buf_data_ack_i)
	`endif
	
	`ifdef ENDPT10_OUT
	,.ep10_out_buf_data						(ep10_out_buf_data_o	)
	,.ep10_out_buf_len                      (ep10_out_buf_len_o     )
	,.ep10_out_buf_has_data                 (ep10_out_buf_has_data_o)
	,.ep10_out_buf_rden                     (ep10_out_buf_rden_i    )
	,.ep10_out_buf_data_ack                 (ep10_out_buf_data_ack_i)
	`endif		

	`ifdef ENDPT11_OUT
	,.ep11_out_buf_data						(ep11_out_buf_data_o	)
	,.ep11_out_buf_len                      (ep11_out_buf_len_o     )
	,.ep11_out_buf_has_data                 (ep11_out_buf_has_data_o)
	,.ep11_out_buf_rden                     (ep11_out_buf_rden_i    )
	,.ep11_out_buf_data_ack                 (ep11_out_buf_data_ack_i)
	`endif		

	`ifdef ENDPT12_OUT
	,.ep12_out_buf_data						(ep12_out_buf_data_o	)
	,.ep12_out_buf_len                      (ep12_out_buf_len_o     )
	,.ep12_out_buf_has_data                 (ep12_out_buf_has_data_o)
	,.ep12_out_buf_rden                     (ep12_out_buf_rden_i    )
	,.ep12_out_buf_data_ack                 (ep12_out_buf_data_ack_i)
	`endif		

	`ifdef ENDPT13_OUT
	,.ep13_out_buf_data						(ep13_out_buf_data_o	)
	,.ep13_out_buf_len                      (ep13_out_buf_len_o     )
	,.ep13_out_buf_has_data                 (ep13_out_buf_has_data_o)
	,.ep13_out_buf_rden                     (ep13_out_buf_rden_i    )
	,.ep13_out_buf_data_ack                 (ep13_out_buf_data_ack_i)
	`endif		

	`ifdef ENDPT14_OUT
	,.ep14_out_buf_data						(ep14_out_buf_data_o	)
	,.ep14_out_buf_len                      (ep14_out_buf_len_o     )
	,.ep14_out_buf_has_data                 (ep14_out_buf_has_data_o)
	,.ep14_out_buf_rden                     (ep14_out_buf_rden_i    )
	,.ep14_out_buf_data_ack                 (ep14_out_buf_data_ack_i)
	`endif		

	`ifdef ENDPT15_OUT
	,.ep15_out_buf_data						(ep15_out_buf_data_o	)
	,.ep15_out_buf_len                      (ep15_out_buf_len_o     )
	,.ep15_out_buf_has_data                 (ep15_out_buf_has_data_o)
	,.ep15_out_buf_rden                     (ep15_out_buf_rden_i    )
	,.ep15_out_buf_data_ack                 (ep15_out_buf_data_ack_i)
	`endif	




);

endmodule