`include "usb3_macro_define.v"	

`ifdef SIM
module usb3_protocol(
`else
module `getname(usb3_protocol,`module_name)(
`endif

     input	wire			slow_clk
	,input	wire			local_clk
	,input	wire			ext_clk
	,input	wire			reset_n
	,input	wire	[4:0]	ltssm_state

	// ========================================= 		link interface
	
	// received tp 
	,input	wire			rx_tp
	,input	wire			rx_tp_hosterr
	,input	wire			rx_tp_retry
	,input	wire			rx_tp_pktpend
	,input	wire	[3:0]	rx_tp_subtype
	,input	wire	[3:0]	rx_tp_endp
	,input	wire	[4:0]	rx_tp_nump
	,input	wire	[4:0]	rx_tp_seq
	,input	wire	[15:0]	rx_tp_stream

	// receive dph 
	,input	wire			rx_dph
	,input	wire			rx_dph_eob
	,input	wire			rx_dph_setup
	,input	wire			rx_dph_pktpend
	,input	wire	[3:0]	rx_dph_endp
	,input	wire	[4:0]	rx_dph_seq
	,input	wire	[15:0]	rx_dph_len
	,input	wire			rx_dpp_start
	,input	wire			rx_dpp_done
	,input	wire			rx_dpp_crcgood
	,input  wire			rx_in_dpp_wasready 


	// send ACK tp 
	,output	reg				tx_tp_a
	,output	reg				tx_tp_a_retry
	,output	reg				tx_tp_a_dir
	,output	reg		[3:0]	tx_tp_a_subtype
	,output	reg		[3:0]	tx_tp_a_endp
	,output	reg		[4:0]	tx_tp_a_nump
	,output	reg		[4:0]	tx_tp_a_seq
	,output	reg		[15:0]	tx_tp_a_stream
	,input	wire			tx_tp_a_ack

	// send  Control transfer tp
	,output	reg				tx_tp_b
	,output	reg				tx_tp_b_retry
	,output	reg				tx_tp_b_dir
	,output	reg		[3:0]	tx_tp_b_subtype
	,output	reg		[3:0]	tx_tp_b_endp
	,output	reg		[4:0]	tx_tp_b_nump
	,output	reg		[4:0]	tx_tp_b_seq
	,output	reg		[15:0]	tx_tp_b_stream
	,input	wire			tx_tp_b_ack

	// send  NRDY tp
	,output	reg				tx_tp_c
	,output	reg				tx_tp_c_retry
	,output	reg				tx_tp_c_dir
	,output	reg		[3:0]	tx_tp_c_subtype
	,output	reg		[3:0]	tx_tp_c_endp
	,output	reg		[4:0]	tx_tp_c_nump
	,output	reg		[4:0]	tx_tp_c_seq
	,output	reg		[15:0]	tx_tp_c_stream
	,input	wire			tx_tp_c_ack

	// sent  dpp 
	,output	reg				tx_dph
	,output	reg				tx_dph_eob
	,output	reg				tx_dph_dir
	,output	reg		[3:0]	tx_dph_endp
	,output	reg		[4:0]	tx_dph_seq
	,output	reg		[15:0]	tx_dph_len
	,input	wire			tx_dpp_ack
	,input	wire			tx_dpp_done
	,output reg				tx_dph_iso_0
	
	// receive dpp 
	,input	wire	[9:0]	buf_in_addr
	,input	wire	[31:0]	buf_in_data
	,input	wire			buf_in_wren
	,output	reg 			buf_in_ready
	,input	wire			buf_in_commit
	,input	wire	[10:0]	buf_in_commit_len

	// send dpp 
	,input	wire	[9:0]	buf_out_addr
	,output reg     [31:0]	buf_out_q 
	,output	reg  	[10:0]	buf_out_len
	,output	reg 			buf_out_hasdata
	,input	wire			buf_out_arm
	,input  wire			buf_out_rden
	
	// protocol signals 
	,output	wire	[1:0]	endp_mode_rx
	,output	wire	[1:0]	endp_mode_tx
	
	,output wire 			set_device_low_power_state 
	,input	wire			set_device_low_power_state_ack 

	
	// protocol error report 
	,output	reg				err_miss_rx
	,output	reg				err_miss_tx
	,output	reg				err_tp_subtype
	,output	reg				err_missed_dpp_start
	,output	reg				err_missed_dpp_done	
	
	,output reg			[6:0]	dev_address 
	
	// ========================================== external interface
	
	,output	reg warm_or_hot_reset 
	
	,output wire  host_requests_data_from_endpt  
	,output wire  [3:0] host_requests_endpt_num
	
	// requests
	,output wire			request_active 	
	,output wire	[7:0]	bmRequestType	
	,output wire	[7:0]	bRequest		
	,output wire	[15:0]	wValue			
	,output wire	[15:0]	wIndex			
	,output wire	[15:0]	wLength			
	
	// ep0 IN  
	,input	wire	[31:0]	ep0_in_buf_data
	,input	wire			ep0_in_buf_wren
	,output	wire			ep0_in_buf_ready
	,input	wire			ep0_in_buf_data_commit 	
	,input	wire	[10:0]	ep0_in_buf_data_commit_len
	
	`ifdef ENDPT1_IN 
	,input	wire	[31:0]	ep1_in_buf_data
	,input	wire			ep1_in_buf_wren
	,output	wire			ep1_in_buf_ready
	,input	wire			ep1_in_buf_data_commit
	,input	wire	[10:0]	ep1_in_buf_data_commit_len
	,input  wire		    ep1_in_buf_eob 	
	`endif	

	`ifdef ENDPT2_IN 
	,input	wire	[31:0]	ep2_in_buf_data
	,input	wire			ep2_in_buf_wren
	,output	wire			ep2_in_buf_ready
	,input	wire			ep2_in_buf_data_commit 	
	,input	wire	[10:0]	ep2_in_buf_data_commit_len
	,input  wire		    ep2_in_buf_eob 
	`endif	
	
	`ifdef ENDPT3_IN 
	,input	wire	[31:0]	ep3_in_buf_data
	,input	wire			ep3_in_buf_wren
	,output	wire			ep3_in_buf_ready
	,input	wire			ep3_in_buf_data_commit 	
	,input	wire	[10:0]	ep3_in_buf_data_commit_len	
	,input  wire		    ep3_in_buf_eob 	
	`endif	
	
	`ifdef ENDPT4_IN 
	,input	wire	[31:0]	ep4_in_buf_data
	,input	wire			ep4_in_buf_wren
	,output	wire			ep4_in_buf_ready
	,input	wire			ep4_in_buf_data_commit
	,input	wire	[10:0]	ep4_in_buf_data_commit_len
	,input  wire		    ep4_in_buf_eob 		
	`endif
	
	`ifdef ENDPT5_IN 
	,input	wire	[31:0]	ep5_in_buf_data
	,input	wire			ep5_in_buf_wren
	,output	wire			ep5_in_buf_ready
	,input	wire			ep5_in_buf_data_commit 	
	,input	wire	[10:0]	ep5_in_buf_data_commit_len
	,input  wire		    ep5_in_buf_eob 	
	`endif	
	
	`ifdef ENDPT6_IN 
	,input	wire	[31:0]	ep6_in_buf_data
	,input	wire			ep6_in_buf_wren
	,output	wire			ep6_in_buf_ready
	,input	wire			ep6_in_buf_data_commit
	,input	wire	[10:0]	ep6_in_buf_data_commit_len
	,input  wire		    ep6_in_buf_eob 	
	`endif	                           

	`ifdef ENDPT7_IN 
	,input	wire	[31:0]	ep7_in_buf_data
	,input	wire			ep7_in_buf_wren
	,output	wire			ep7_in_buf_ready
	,input	wire			ep7_in_buf_data_commit 	
	,input	wire	[10:0]	ep7_in_buf_data_commit_len
	,input  wire		    ep7_in_buf_eob 	
	`endif	
	
	`ifdef ENDPT8_IN 
	,input	wire	[31:0]	ep8_in_buf_data
	,input	wire			ep8_in_buf_wren
	,output	wire			ep8_in_buf_ready
	,input	wire			ep8_in_buf_data_commit
	,input	wire	[10:0]	ep8_in_buf_data_commit_len	
	,input  wire		    ep8_in_buf_eob 	
	`endif	
	
	`ifdef ENDPT9_IN 
	,input	wire	[31:0]	ep9_in_buf_data
	,input	wire			ep9_in_buf_wren
	,output	wire			ep9_in_buf_ready
	,input	wire			ep9_in_buf_data_commit 	
	,input	wire	[10:0]	ep9_in_buf_data_commit_len
	,input  wire		    ep9_in_buf_eob 	
	`endif	
	


	`ifdef ENDPT10_IN 
	,input	wire	[31:0]	ep10_in_buf_data
	,input	wire			ep10_in_buf_wren
	,output	wire			ep10_in_buf_ready
	,input	wire			ep10_in_buf_data_commit 	
	,input	wire	[10:0]	ep10_in_buf_data_commit_len	
	,input  wire		    ep10_in_buf_eob 	
	`endif	
	
	`ifdef ENDPT11_IN 
	,input	wire	[31:0]	ep11_in_buf_data
	,input	wire			ep11_in_buf_wren
	,output	wire			ep11_in_buf_ready
	,input	wire			ep11_in_buf_data_commit 	
	,input	wire	[10:0]	ep11_in_buf_data_commit_len	
	,input  wire		    ep11_in_buf_eob 	
	`endif		
	
	`ifdef ENDPT12_IN 
	,input	wire	[31:0]	ep12_in_buf_data
	,input	wire			ep12_in_buf_wren
	,output	wire			ep12_in_buf_ready
	,input	wire			ep12_in_buf_data_commit 	
	,input	wire	[10:0]	ep12_in_buf_data_commit_len
	,input  wire		    ep12_in_buf_eob 	
	`endif		
	
	`ifdef ENDPT13_IN 
	,input	wire	[31:0]	ep13_in_buf_data
	,input	wire			ep13_in_buf_wren
	,output	wire			ep13_in_buf_ready
	,input	wire			ep13_in_buf_data_commit 	
	,input	wire	[10:0]	ep13_in_buf_data_commit_len
	,input  wire		    ep13_in_buf_eob 	
	`endif		
	
	`ifdef ENDPT14_IN 
	,input	wire	[31:0]	ep14_in_buf_data
	,input	wire			ep14_in_buf_wren
	,output	wire			ep14_in_buf_ready
	,input	wire			ep14_in_buf_data_commit 	
	,input	wire	[10:0]	ep14_in_buf_data_commit_len	
	,input  wire		    ep14_in_buf_eob 	
	`endif		
	
	`ifdef ENDPT15_IN 
	,input	wire	[31:0]	ep15_in_buf_data
	,input	wire			ep15_in_buf_wren
	,output	wire			ep15_in_buf_ready
	,input	wire			ep15_in_buf_data_commit 	
	,input	wire	[10:0]	ep15_in_buf_data_commit_len	
	,input  wire		    ep15_in_buf_eob 	
	`endif		
	
	
	// ep0 OUT	
	,output wire	[31:0]	ep0_out_buf_data		 	
	,output wire	[10:0]	ep0_out_buf_len		
	,output wire			ep0_out_buf_has_data	
	,input wire				ep0_out_buf_data_ack	
	,input wire				ep0_out_buf_rden
	
	

	
	`ifdef ENDPT1_OUT
	,output	wire	[31:0]	ep1_out_buf_data
	,output	wire	[10:0]	ep1_out_buf_len
	,output	wire			ep1_out_buf_has_data
	,input	wire			ep1_out_buf_data_ack 
	,input  wire			ep1_out_buf_rden
	`endif
	
	
	`ifdef ENDPT2_OUT
	,output wire	[31:0]	ep2_out_buf_data		 	
	,output wire	[10:0]	ep2_out_buf_len		
	,output wire			ep2_out_buf_has_data	
	,input wire				ep2_out_buf_data_ack
	,input wire				ep2_out_buf_rden
	`endif	

	
	`ifdef ENDPT3_OUT
	,output wire	[31:0]	ep3_out_buf_data		 	
	,output wire	[10:0]	ep3_out_buf_len		
	,output wire			ep3_out_buf_has_data	
	,input wire				ep3_out_buf_data_ack
	,input wire				ep3_out_buf_rden
	`endif
	
	
	
	`ifdef ENDPT4_OUT
	,output wire	[31:0]	ep4_out_buf_data		 	
	,output wire	[10:0]	ep4_out_buf_len		
	,output wire			ep4_out_buf_has_data	
	,input wire				ep4_out_buf_data_ack
	,input wire				ep4_out_buf_rden
	`endif	
	
	
	`ifdef ENDPT5_OUT
	,output wire	[31:0]	ep5_out_buf_data		 	
	,output wire	[10:0]	ep5_out_buf_len		
	,output wire			ep5_out_buf_has_data	
	,input wire				ep5_out_buf_data_ack	
	,input wire				ep5_out_buf_rden
	`endif	
		
	
	`ifdef ENDPT6_OUT
	,output wire	[31:0]	ep6_out_buf_data		 	
	,output wire	[10:0]	ep6_out_buf_len		
	,output wire			ep6_out_buf_has_data	
	,input wire				ep6_out_buf_data_ack
	,input wire				ep6_out_buf_rden
	`endif		
		
	
	`ifdef ENDPT7_OUT
	,output wire	[31:0]	ep7_out_buf_data		 	
	,output wire	[10:0]	ep7_out_buf_len		
	,output wire			ep7_out_buf_has_data	
	,input wire				ep7_out_buf_data_ack	
	,input wire				ep7_out_buf_rden
	`endif		

	
	
	
	`ifdef ENDPT8_OUT
	,output wire	[31:0]	ep8_out_buf_data		 	
	,output wire	[10:0]	ep8_out_buf_len		
	,output wire			ep8_out_buf_has_data	
	,input wire				ep8_out_buf_data_ack	
	,input wire				ep8_out_buf_rden
	`endif	
	

	
	`ifdef ENDPT9_OUT
	,output wire	[31:0]	ep9_out_buf_data		 	
	,output wire	[10:0]	ep9_out_buf_len		
	,output wire			ep9_out_buf_has_data	
	,input wire				ep9_out_buf_data_ack
	,input wire				ep9_out_buf_rden 
	`endif
	

	
	`ifdef ENDPT10_OUT
	,output wire	[31:0]	ep10_out_buf_data		 	
	,output wire	[10:0]	ep10_out_buf_len		
	,output wire			ep10_out_buf_has_data	
	,input wire				ep10_out_buf_data_ack	
	,input wire				ep10_out_buf_rden
	`endif		
	
	
	`ifdef ENDPT11_OUT
	,output wire	[31:0]	ep11_out_buf_data		 	
	,output wire	[10:0]	ep11_out_buf_len		
	,output wire			ep11_out_buf_has_data	
	,input wire				ep11_out_buf_data_ack	
	,input wire				ep11_out_buf_rden
	`endif		
	
	`ifdef ENDPT12_OUT
	,output wire	[31:0]	ep12_out_buf_data		 	
	,output wire	[10:0]	ep12_out_buf_len		
	,output wire			ep12_out_buf_has_data	
	,input wire				ep12_out_buf_data_ack	
	,input wire				ep12_out_buf_rden
	`endif		

	
	`ifdef ENDPT13_OUT
	,output wire	[31:0]	ep13_out_buf_data		 	
	,output wire	[10:0]	ep13_out_buf_len		
	,output wire			ep13_out_buf_has_data	
	,input wire				ep13_out_buf_data_ack	
	,input wire				ep13_out_buf_rden 
	`endif		

	
	`ifdef ENDPT14_OUT
	,output wire	[31:0]	ep14_out_buf_data		 	
	,output wire	[10:0]	ep14_out_buf_len		
	,output wire			ep14_out_buf_has_data	
	,input wire				ep14_out_buf_data_ack	
	,input wire				ep14_out_buf_rden
	`endif		
	
	`ifdef ENDPT15_OUT
	,output wire	[31:0]	ep15_out_buf_data		 	
	,output wire	[10:0]	ep15_out_buf_len		
	,output wire			ep15_out_buf_has_data	
	,input wire				ep15_out_buf_data_ack	
	,input wire				ep15_out_buf_rden
	`endif	
		
	
);

	reg		[3:0]	rx_endp;
	reg		[3:0]	tx_endp;
	reg		[3:0]	ep_rdy_num;
	reg				ep_dir ;
	reg [15:0] wt_in_ep_rdy ;
	reg [15:0] wt_out_ep_rdy ;
	reg host_requests_data ;
	reg [3:0] host_requests_endpt ;
	
	//wire [4:0] ep0_buf_in_nump	;		
	wire [4:0] ep1_buf_in_nump 	;
	wire [4:0] ep2_buf_in_nump 	;
	wire [4:0] ep3_buf_in_nump 	;
	wire [4:0] ep4_buf_in_nump 	;
	wire [4:0] ep5_buf_in_nump 	;
	wire [4:0] ep6_buf_in_nump 	;
	wire [4:0] ep7_buf_in_nump 	;
	wire [4:0] ep8_buf_in_nump 	;
	wire [4:0] ep9_buf_in_nump 	;
	wire [4:0] ep10_buf_in_nump	;
	wire [4:0] ep11_buf_in_nump	;
	wire [4:0] ep12_buf_in_nump	;
	wire [4:0] ep13_buf_in_nump	;
	wire [4:0] ep14_buf_in_nump	;
	wire [4:0] ep15_buf_in_nump	;

	wire [4:0] ep1_buf_out_nump ;
	wire [4:0] ep2_buf_out_nump ;
	wire [4:0] ep3_buf_out_nump ;
	wire [4:0] ep4_buf_out_nump ;
	wire [4:0] ep5_buf_out_nump ;
	wire [4:0] ep6_buf_out_nump ;
	wire [4:0] ep7_buf_out_nump ;
	wire [4:0] ep8_buf_out_nump ;
	wire [4:0] ep9_buf_out_nump ;
	wire [4:0] ep10_buf_out_nump ;
	wire [4:0] ep11_buf_out_nump ;
	wire [4:0] ep12_buf_out_nump ;	
	wire [4:0] ep13_buf_out_nump ;	
	wire [4:0] ep14_buf_out_nump ;	
	wire [4:0] ep15_buf_out_nump ;	
	
	wire ep0_buf_out_eob		;	
	wire ep1_buf_out_eob 		;
	wire ep2_buf_out_eob 	    ;
	wire ep3_buf_out_eob 	    ;
	wire ep4_buf_out_eob 	    ;
	wire ep5_buf_out_eob 	    ;
	wire ep6_buf_out_eob 	    ;
	wire ep7_buf_out_eob 	    ;
	wire ep8_buf_out_eob 	    ;
	wire ep9_buf_out_eob 	    ;
	wire ep10_buf_out_eob 	    ;
	wire ep11_buf_out_eob	    ;
	wire ep12_buf_out_eob	    ;
	wire ep13_buf_out_eob	    ;
	wire ep14_buf_out_eob	    ;
	wire ep15_buf_out_eob	    ;

	localparam CTRL = 2'b00 ;
	localparam BULK = 2'b01 ;	
	localparam INTR = 2'b10 ;	
	localparam ISO  = 2'b11 ;

	assign  		host_requests_data_from_endpt  = host_requests_data ;
	assign  	 	host_requests_endpt_num = host_requests_endpt ;



	parameter [3:0]	SEL_ENDP0 			= 4'd0,
					SEL_ENDP1 			= 4'd1,
					SEL_ENDP2 			= 4'd2,
					SEL_ENDP3 			= 4'd3,
					SEL_ENDP4 			= 4'd4,
					SEL_ENDP5 			= 4'd5,
					SEL_ENDP6 			= 4'd6,
					SEL_ENDP7 			= 4'd7,
					SEL_ENDP8 			= 4'd8,
					SEL_ENDP9 			= 4'd9,
					SEL_ENDP10 			= 4'd10,
					SEL_ENDP11 			= 4'd11,
					SEL_ENDP12 			= 4'd12,
					SEL_ENDP13 			= 4'd13,
					SEL_ENDP14 			= 4'd14,
					SEL_ENDP15 			= 4'd15;
					
	parameter [1:0]	EP_MODE_CONTROL		= 2'd0,
					EP_MODE_ISOCH		= 2'd1,
					EP_MODE_BULK		= 2'd2,
					EP_MODE_INTERRUPT	= 2'd3;
					
`include "usb3_const.vh"	

	
	wire	[1:0]	EP1_MODE			= EP_MODE_BULK;
	wire	[1:0]	EP2_MODE			= EP_MODE_BULK;
		
	

											
	assign			endp_mode_tx		=	tx_endp == SEL_ENDP1 ? EP1_MODE : 
											tx_endp == SEL_ENDP2 ? EP2_MODE : EP_MODE_CONTROL;
											
	assign			endp_mode_rx		=	rx_endp == SEL_ENDP1 ? EP1_MODE : 
											rx_endp == SEL_ENDP2 ? EP2_MODE : EP_MODE_CONTROL;										
											

					

	reg		[4:0]	rx_state;
parameter	[4:0]	RX_RESET		= 'd0,
					RX_IDLE			= 'd1,
					RX_0			= 'd2,
					RX_1			= 'd3,
					RX_2			= 'd4,
					RX_TP_0			= 'd10,
					RX_TP_1			= 'd11,
					RX_TP_2			= 'd12,
					RX_DPH_0		= 'd20,
					RX_DPH_1		= 'd21,
					RX_DPH_2		= 'd22;
					
	reg		[4:0]	tx_state;
parameter	[4:0]	TX_RESET		= 'd0,
					TX_IDLE			= 'd1,
					TX_DP_WAITDATA	= 'd2,
					TX_DP_0			= 'd3,
					TX_DP_1			= 'd4,
					TX_DP_2			= 'd5,
					TX_DP_3			= 'd6,
					TX_DP_NRDY		= 'd7,
					TX_DP_ERDY		= 'd8,
					TX_STALL		= 'd9,
					TX_DP_NRDY_1	= 'd10,
					TX_DP_0_0	= 'd11;
					
	reg		[4:0]	in_dpp_seq /* synthesis noprune */;
	reg		[4:0]	out_dpp_seq /* synthesis noprune */;
	wire			reset_dp_seq;
	
	reg		[15:0]	out_length;
	reg		[4:0]	out_nump;
	
	reg				do_send_dpp;
	
	reg		[10:0]	recv_count;
	reg		[10:0]	dc;
	
	wire [6:0] dev_address_q ; 
	

	wire set_address ;
	reg set_address_ack ;
	reg enter_status_stage ; 
	reg	ep0_stall ;
	reg tx_out_ep_NRDY ;
	reg do_send_dpp_ack ;
	reg [4:0] out_dpp_seq_latch ;
	reg [4:0] out_dpp_seq_next ;
	reg [4:0] out_dpp_seq_next_latch ;
	reg [4:0] out_nump_latch ;
	reg [15:0] in_ep_rty ;
	
	
////////////////////////////////////////////////////////////
//
// mux bram signals
//
////////////////////////////////////////////////////////////

wire	[31:0]	ep0_buf_in_data		= 	rx_endp == SEL_ENDP0 ? buf_in_data : 'h0;
wire			ep0_buf_in_wren		= 	rx_endp == SEL_ENDP0 ? buf_in_wren : 'h0;
wire			ep0_buf_in_ready	;
wire			ep0_buf_in_commit	= 	rx_endp == SEL_ENDP0 ? buf_in_commit : 'h0;
wire	[10:0]	ep0_buf_in_commit_len = rx_endp == SEL_ENDP0 ? buf_in_commit_len : 'h0;

wire	[31:0]	ep0_buf_out_q;
wire	[10:0]	ep0_buf_out_len;
wire			ep0_buf_out_has_data;
wire			ep0_buf_out_ack		= 	tx_endp == SEL_ENDP0 ? buf_out_arm  : 'h0;
wire			ep0_buf_out_rden	= 	tx_endp == SEL_ENDP0 ? buf_out_rden : 'h0;


wire	[31:0]	ep1_buf_out_q;
wire	[10:0]	ep1_buf_out_len;	
wire			ep1_buf_out_has_data;
wire			ep1_buf_out_ack		= 	tx_endp == SEL_ENDP1 ? buf_out_arm  : 'h0;
wire			ep1_buf_out_rden	= 	tx_endp == SEL_ENDP1 ? buf_out_rden : 'h0;

wire	[31:0]	ep1_buf_in_data		= 	rx_endp == SEL_ENDP1 ? buf_in_data : 'h0;
wire			ep1_buf_in_wren		= 	rx_endp == SEL_ENDP1 ? buf_in_wren : 'h0;
wire			ep1_buf_in_commit 	= 	rx_endp == SEL_ENDP1 ? buf_in_commit : 'h0;
wire	[10:0]	ep1_buf_in_commit_len = rx_endp == SEL_ENDP1 ? buf_in_commit_len : 'h0;
wire			ep1_buf_in_ready;




wire	[31:0]	ep2_buf_out_q;
wire	[10:0]	ep2_buf_out_len;	
wire			ep2_buf_out_has_data;
wire			ep2_buf_out_ack		= 	tx_endp == SEL_ENDP2 ? buf_out_arm  : 'h0;
wire			ep2_buf_out_rden	= 	tx_endp == SEL_ENDP2 ? buf_out_rden : 'h0;




wire	[31:0]	ep2_buf_in_data		= 	rx_endp == SEL_ENDP2 ? buf_in_data : 'h0;
wire			ep2_buf_in_wren		= 	rx_endp == SEL_ENDP2 ? buf_in_wren : 'h0;
wire			ep2_buf_in_commit 	= 	rx_endp == SEL_ENDP2 ? buf_in_commit : 'h0;
wire	[10:0]	ep2_buf_in_commit_len = rx_endp == SEL_ENDP2 ? buf_in_commit_len : 'h0;
wire			ep2_buf_in_ready;




wire	[31:0]	ep3_buf_out_q;
wire	[10:0]	ep3_buf_out_len;	
wire			ep3_buf_out_has_data;
wire			ep3_buf_out_ack		= 	tx_endp == SEL_ENDP3 ? buf_out_arm  : 'h0;
wire			ep3_buf_out_rden	= 	tx_endp == SEL_ENDP3 ? buf_out_rden : 'h0;



wire	[31:0]	ep3_buf_in_data		= 	rx_endp == SEL_ENDP3 ? buf_in_data : 'h0;
wire			ep3_buf_in_wren		= 	rx_endp == SEL_ENDP3 ? buf_in_wren : 'h0;
wire			ep3_buf_in_commit 	= 	rx_endp == SEL_ENDP3 ? buf_in_commit : 'h0;
wire	[10:0]	ep3_buf_in_commit_len = rx_endp == SEL_ENDP3 ? buf_in_commit_len : 'h0;
wire			ep3_buf_in_ready;



wire	[31:0]	ep4_buf_out_q;
wire	[10:0]	ep4_buf_out_len;	
wire			ep4_buf_out_has_data;
wire			ep4_buf_out_ack		= 	tx_endp == SEL_ENDP4 ? buf_out_arm  : 'h0;
wire			ep4_buf_out_rden	= 	tx_endp == SEL_ENDP4 ? buf_out_rden : 'h0;



wire	[31:0]	ep4_buf_in_data		= 	rx_endp == SEL_ENDP4 ? buf_in_data : 'h0;
wire			ep4_buf_in_wren		= 	rx_endp == SEL_ENDP4 ? buf_in_wren : 'h0;
wire			ep4_buf_in_commit 	= 	rx_endp == SEL_ENDP4 ? buf_in_commit : 'h0;
wire	[10:0]	ep4_buf_in_commit_len = rx_endp == SEL_ENDP4 ? buf_in_commit_len : 'h0;
wire			ep4_buf_in_ready;



wire	[31:0]	ep5_buf_out_q;
wire	[10:0]	ep5_buf_out_len;	
wire			ep5_buf_out_has_data;
wire			ep5_buf_out_ack		= 	tx_endp == SEL_ENDP5 ? buf_out_arm  : 'h0;
wire			ep5_buf_out_rden	= 	tx_endp == SEL_ENDP5 ? buf_out_rden : 'h0;



wire	[31:0]	ep5_buf_in_data		= 	rx_endp == SEL_ENDP5 ? buf_in_data : 'h0;
wire			ep5_buf_in_wren		= 	rx_endp == SEL_ENDP5 ? buf_in_wren : 'h0;
wire			ep5_buf_in_commit 	= 	rx_endp == SEL_ENDP5 ? buf_in_commit : 'h0;
wire	[10:0]	ep5_buf_in_commit_len = rx_endp == SEL_ENDP5 ? buf_in_commit_len : 'h0;
wire			ep5_buf_in_ready;



wire	[31:0]	ep6_buf_out_q;
wire	[10:0]	ep6_buf_out_len;	
wire			ep6_buf_out_has_data;
wire			ep6_buf_out_ack		= 	tx_endp == SEL_ENDP6 ? buf_out_arm  : 'h0;
wire			ep6_buf_out_rden	= 	tx_endp == SEL_ENDP6 ? buf_out_rden : 'h0;



wire	[31:0]	ep6_buf_in_data		= 	rx_endp == SEL_ENDP6 ? buf_in_data : 'h0;
wire			ep6_buf_in_wren		= 	rx_endp == SEL_ENDP6 ? buf_in_wren : 'h0;
wire			ep6_buf_in_commit 	= 	rx_endp == SEL_ENDP6 ? buf_in_commit : 'h0;
wire	[10:0]	ep6_buf_in_commit_len = rx_endp == SEL_ENDP6 ? buf_in_commit_len : 'h0;
wire			ep6_buf_in_ready;



wire	[31:0]	ep7_buf_out_q;
wire	[10:0]	ep7_buf_out_len;	
wire			ep7_buf_out_has_data;
wire			ep7_buf_out_ack		= 	tx_endp == SEL_ENDP7 ? buf_out_arm  : 'h0;
wire			ep7_buf_out_rden	= 	tx_endp == SEL_ENDP7 ? buf_out_rden : 'h0;



wire	[31:0]	ep7_buf_in_data		= 	rx_endp == SEL_ENDP7 ? buf_in_data : 'h0;
wire			ep7_buf_in_wren		= 	rx_endp == SEL_ENDP7 ? buf_in_wren : 'h0;
wire			ep7_buf_in_commit 	= 	rx_endp == SEL_ENDP7 ? buf_in_commit : 'h0;
wire	[10:0]	ep7_buf_in_commit_len = rx_endp == SEL_ENDP7 ? buf_in_commit_len : 'h0;
wire			ep7_buf_in_ready;



wire	[31:0]	ep8_buf_out_q;
wire	[10:0]	ep8_buf_out_len;	
wire			ep8_buf_out_has_data;
wire			ep8_buf_out_ack		= 	tx_endp == SEL_ENDP8 ? buf_out_arm  : 'h0;
wire			ep8_buf_out_rden	= 	tx_endp == SEL_ENDP8 ? buf_out_rden : 'h0;



wire	[31:0]	ep8_buf_in_data		= 	rx_endp == SEL_ENDP8 ? buf_in_data : 'h0;
wire			ep8_buf_in_wren		= 	rx_endp == SEL_ENDP8 ? buf_in_wren : 'h0;
wire			ep8_buf_in_commit 	= 	rx_endp == SEL_ENDP8 ? buf_in_commit : 'h0;
wire	[10:0]	ep8_buf_in_commit_len = rx_endp == SEL_ENDP8 ? buf_in_commit_len : 'h0;
wire			ep8_buf_in_ready;



wire	[31:0]	ep9_buf_out_q;
wire	[10:0]	ep9_buf_out_len;	
wire			ep9_buf_out_has_data;
wire			ep9_buf_out_ack		= 	tx_endp == SEL_ENDP9 ? buf_out_arm  : 'h0;
wire			ep9_buf_out_rden	= 	tx_endp == SEL_ENDP9 ? buf_out_rden : 'h0;



wire	[31:0]	ep9_buf_in_data		= 	rx_endp == SEL_ENDP9 ? buf_in_data : 'h0;
wire			ep9_buf_in_wren		= 	rx_endp == SEL_ENDP9 ? buf_in_wren : 'h0;
wire			ep9_buf_in_commit 	= 	rx_endp == SEL_ENDP9 ? buf_in_commit : 'h0;
wire	[10:0]	ep9_buf_in_commit_len = rx_endp == SEL_ENDP9 ? buf_in_commit_len : 'h0;
wire			ep9_buf_in_ready;



wire	[31:0]	ep10_buf_out_q;
wire	[10:0]	ep10_buf_out_len;	
wire			ep10_buf_out_has_data;
wire			ep10_buf_out_ack		= 	tx_endp == SEL_ENDP10 ? buf_out_arm  : 'h0;
wire			ep10_buf_out_rden		= 	tx_endp == SEL_ENDP10 ? buf_out_rden : 'h0;



wire	[31:0]	ep10_buf_in_data		= 	rx_endp == SEL_ENDP10 ? buf_in_data : 'h0;
wire			ep10_buf_in_wren		= 	rx_endp == SEL_ENDP10 ? buf_in_wren : 'h0;
wire			ep10_buf_in_commit 		= 	rx_endp == SEL_ENDP10 ? buf_in_commit : 'h0;
wire	[10:0]	ep10_buf_in_commit_len 	= 	rx_endp == SEL_ENDP10 ? buf_in_commit_len : 'h0;
wire			ep10_buf_in_ready;



wire	[31:0]	ep11_buf_out_q;
wire	[10:0]	ep11_buf_out_len;	
wire			ep11_buf_out_has_data;
wire			ep11_buf_out_ack		= 	tx_endp == SEL_ENDP11 ? buf_out_arm  : 'h0;
wire			ep11_buf_out_rden		= 	tx_endp == SEL_ENDP11 ? buf_out_rden : 'h0;



wire	[31:0]	ep11_buf_in_data		= 	rx_endp == SEL_ENDP11 ? buf_in_data : 'h0;
wire			ep11_buf_in_wren		= 	rx_endp == SEL_ENDP11 ? buf_in_wren : 'h0;
wire			ep11_buf_in_commit 		= 	rx_endp == SEL_ENDP11 ? buf_in_commit : 'h0;
wire	[10:0]	ep11_buf_in_commit_len 	= 	rx_endp == SEL_ENDP11 ? buf_in_commit_len : 'h0;
wire			ep11_buf_in_ready;




wire	[31:0]	ep12_buf_out_q;
wire	[10:0]	ep12_buf_out_len;	
wire			ep12_buf_out_has_data;
wire			ep12_buf_out_ack		= 	tx_endp == SEL_ENDP12 ? buf_out_arm  : 'h0;
wire			ep12_buf_out_rden		= 	tx_endp == SEL_ENDP12 ? buf_out_rden : 'h0;



wire	[31:0]	ep12_buf_in_data		= 	rx_endp == SEL_ENDP12 ? buf_in_data : 'h0;
wire			ep12_buf_in_wren		= 	rx_endp == SEL_ENDP12 ? buf_in_wren : 'h0;
wire			ep12_buf_in_commit 		= 	rx_endp == SEL_ENDP12 ? buf_in_commit : 'h0;
wire	[10:0]	ep12_buf_in_commit_len 	= 	rx_endp == SEL_ENDP12 ? buf_in_commit_len : 'h0;
wire			ep12_buf_in_ready;



wire	[31:0]	ep13_buf_out_q;
wire	[10:0]	ep13_buf_out_len;	
wire			ep13_buf_out_has_data;
wire			ep13_buf_out_ack		= 	tx_endp == SEL_ENDP13 ? buf_out_arm  : 'h0;
wire			ep13_buf_out_rden		= 	tx_endp == SEL_ENDP13 ? buf_out_rden : 'h0;



wire	[31:0]	ep13_buf_in_data		= 	rx_endp == SEL_ENDP13 ? buf_in_data : 'h0;
wire			ep13_buf_in_wren		= 	rx_endp == SEL_ENDP13 ? buf_in_wren : 'h0;
wire			ep13_buf_in_commit 		= 	rx_endp == SEL_ENDP13 ? buf_in_commit : 'h0;
wire	[10:0]	ep13_buf_in_commit_len 	= 	rx_endp == SEL_ENDP13 ? buf_in_commit_len : 'h0;
wire			ep13_buf_in_ready;



wire	[31:0]	ep14_buf_out_q;
wire	[10:0]	ep14_buf_out_len;	
wire			ep14_buf_out_has_data;
wire			ep14_buf_out_ack		= 	tx_endp == SEL_ENDP14 ? buf_out_arm  : 'h0;
wire			ep14_buf_out_rden		= 	tx_endp == SEL_ENDP14 ? buf_out_rden : 'h0;



wire	[31:0]	ep14_buf_in_data		= 	rx_endp == SEL_ENDP14 ? buf_in_data : 'h0;
wire			ep14_buf_in_wren		= 	rx_endp == SEL_ENDP14 ? buf_in_wren : 'h0;
wire			ep14_buf_in_commit 		= 	rx_endp == SEL_ENDP14 ? buf_in_commit : 'h0;
wire	[10:0]	ep14_buf_in_commit_len 	= 	rx_endp == SEL_ENDP14 ? buf_in_commit_len : 'h0;
wire			ep14_buf_in_ready;



wire	[31:0]	ep15_buf_out_q;
wire	[10:0]	ep15_buf_out_len;	
wire			ep15_buf_out_has_data;
wire			ep15_buf_out_ack		= 	tx_endp == SEL_ENDP15 ? buf_out_arm  : 'h0;
wire			ep15_buf_out_rden		= 	tx_endp == SEL_ENDP15 ? buf_out_rden : 'h0;



wire	[31:0]	ep15_buf_in_data		= 	rx_endp == SEL_ENDP15 ? buf_in_data : 'h0;
wire			ep15_buf_in_wren		= 	rx_endp == SEL_ENDP15 ? buf_in_wren : 'h0;
wire			ep15_buf_in_commit 		= 	rx_endp == SEL_ENDP15 ? buf_in_commit : 'h0;
wire	[10:0]	ep15_buf_in_commit_len 	= 	rx_endp == SEL_ENDP15 ? buf_in_commit_len : 'h0;
wire			ep15_buf_in_ready;




reg dpp_eob ;
reg do_send_dpp_eob ;

reg [31:0] ep_buf_out_q_mem [0:15] ;
always @ ( * ) begin
	ep_buf_out_q_mem[0]		 <=  ep0_buf_out_q	;
	ep_buf_out_q_mem[1]      <=  ep1_buf_out_q  ;
	ep_buf_out_q_mem[2]      <=  ep2_buf_out_q  ;
	ep_buf_out_q_mem[3]      <=  ep3_buf_out_q  ;
	ep_buf_out_q_mem[4]      <=  ep4_buf_out_q  ;
	ep_buf_out_q_mem[5]      <=  ep5_buf_out_q  ;
	ep_buf_out_q_mem[6]      <=  ep6_buf_out_q  ;
	ep_buf_out_q_mem[7]      <=  ep7_buf_out_q  ;
	ep_buf_out_q_mem[8]      <=  ep8_buf_out_q  ;
	ep_buf_out_q_mem[9]      <=  ep9_buf_out_q  ;
	ep_buf_out_q_mem[10]     <=  ep10_buf_out_q  ;
	ep_buf_out_q_mem[11]     <=  ep11_buf_out_q ;
	ep_buf_out_q_mem[12]     <=  ep12_buf_out_q ;
	ep_buf_out_q_mem[13]     <=  ep13_buf_out_q ;
	ep_buf_out_q_mem[14]     <=  ep14_buf_out_q ;
	ep_buf_out_q_mem[15]     <=  ep15_buf_out_q ;
end


reg buf_out_eob_mem [0:15] ;
always @ ( * ) begin
	buf_out_eob_mem[0]		<=  1	 ;
	buf_out_eob_mem[1]      <=  ep1_buf_out_eob  ;
	buf_out_eob_mem[2]      <=  ep2_buf_out_eob  ;
	buf_out_eob_mem[3]      <=  ep3_buf_out_eob  ;
	buf_out_eob_mem[4]      <=  ep4_buf_out_eob  ;
	buf_out_eob_mem[5]      <=  ep5_buf_out_eob  ;
	buf_out_eob_mem[6]      <=  ep6_buf_out_eob  ;
	buf_out_eob_mem[7]      <=  ep7_buf_out_eob  ;
	buf_out_eob_mem[8]      <=  ep8_buf_out_eob  ;
	buf_out_eob_mem[9]      <=  ep9_buf_out_eob  ;
	buf_out_eob_mem[10]      <=  ep10_buf_out_eob  ;
	buf_out_eob_mem[11]     <=  ep11_buf_out_eob ;
	buf_out_eob_mem[12]     <=  ep12_buf_out_eob ;
	buf_out_eob_mem[13]     <=  ep13_buf_out_eob ;
	buf_out_eob_mem[14]     <=  ep14_buf_out_eob ;
	buf_out_eob_mem[15]     <=  ep15_buf_out_eob ;	
end

reg [10:0] buf_out_len_mem [0:15] ;
always @ ( * ) begin
	buf_out_len_mem[0]		<=  ep0_buf_out_len	 ;
	buf_out_len_mem[1]      <=  ep1_buf_out_len  ;
	buf_out_len_mem[2]      <=  ep2_buf_out_len  ;
	buf_out_len_mem[3]      <=  ep3_buf_out_len  ;
	buf_out_len_mem[4]      <=  ep4_buf_out_len  ;
	buf_out_len_mem[5]      <=  ep5_buf_out_len  ;
	buf_out_len_mem[6]      <=  ep6_buf_out_len  ;
	buf_out_len_mem[7]      <=  ep7_buf_out_len  ;
	buf_out_len_mem[8]      <=  ep8_buf_out_len  ;
	buf_out_len_mem[9]      <=  ep9_buf_out_len  ;
	buf_out_len_mem[10]      <=  ep10_buf_out_len  ;
	buf_out_len_mem[11]     <=  ep11_buf_out_len ;
	buf_out_len_mem[12]     <=  ep12_buf_out_len ;
	buf_out_len_mem[13]     <=  ep13_buf_out_len ;
	buf_out_len_mem[14]     <=  ep14_buf_out_len ;
	buf_out_len_mem[15]     <=  ep15_buf_out_len ;	
end

reg buf_out_hasdata_mem [0:15] ;
always @ ( * ) begin
	buf_out_hasdata_mem[0]		<=  ep0_buf_out_has_data  ;
	buf_out_hasdata_mem[1]      <=  ep1_buf_out_has_data  ;
	buf_out_hasdata_mem[2]      <=  ep2_buf_out_has_data  ;
	buf_out_hasdata_mem[3]      <=  ep3_buf_out_has_data  ;
	buf_out_hasdata_mem[4]      <=  ep4_buf_out_has_data  ;
	buf_out_hasdata_mem[5]      <=  ep5_buf_out_has_data  ;
	buf_out_hasdata_mem[6]      <=  ep6_buf_out_has_data  ;
	buf_out_hasdata_mem[7]      <=  ep7_buf_out_has_data  ;
	buf_out_hasdata_mem[8]      <=  ep8_buf_out_has_data  ;
	buf_out_hasdata_mem[9]      <=  ep9_buf_out_has_data  ;
	buf_out_hasdata_mem[10]      <=  ep10_buf_out_has_data  ;
	buf_out_hasdata_mem[11]     <=  ep11_buf_out_has_data ;
	buf_out_hasdata_mem[12]     <=  ep12_buf_out_has_data ;
	buf_out_hasdata_mem[13]     <=  ep13_buf_out_has_data ;
	buf_out_hasdata_mem[14]     <=  ep14_buf_out_has_data ;
	buf_out_hasdata_mem[15]     <=  ep15_buf_out_has_data ;	
end

reg buf_in_ready_mem [0:15] ;
always @ ( * ) begin
	buf_in_ready_mem[0]		 <=  ep0_buf_in_ready  ;
	buf_in_ready_mem[1]      <=  ep1_buf_in_ready  ;
	buf_in_ready_mem[2]      <=  ep2_buf_in_ready  ;
	buf_in_ready_mem[3]      <=  ep3_buf_in_ready  ;
	buf_in_ready_mem[4]      <=  ep4_buf_in_ready  ;
	buf_in_ready_mem[5]      <=  ep5_buf_in_ready  ;
	buf_in_ready_mem[6]      <=  ep6_buf_in_ready  ;
	buf_in_ready_mem[7]      <=  ep7_buf_in_ready  ;
	buf_in_ready_mem[8]      <=  ep8_buf_in_ready  ;
	buf_in_ready_mem[9]      <=  ep9_buf_in_ready  ;
	buf_in_ready_mem[10]      <= ep10_buf_in_ready  ;
	buf_in_ready_mem[11]     <=  ep11_buf_in_ready ;
	buf_in_ready_mem[12]     <=  ep12_buf_in_ready ;
	buf_in_ready_mem[13]     <=  ep13_buf_in_ready ;
	buf_in_ready_mem[14]     <=  ep14_buf_in_ready ;
	buf_in_ready_mem[15]     <=  ep15_buf_in_ready ;	
end

reg [10:0] in_ep_max_mem [0:15] ;
always @ ( * ) begin
	in_ep_max_mem[0]	  <=  512	 ;
	`ifdef ENDPT1_IN 
	in_ep_max_mem[1]      <=  `ENDPT1_IN_MAX ;
	`endif
	`ifdef ENDPT2_IN 	
	in_ep_max_mem[2]      <=  `ENDPT2_IN_MAX ;
	`endif	
	`ifdef ENDPT3_IN 	
	in_ep_max_mem[3]      <=  `ENDPT3_IN_MAX ;
	`endif	
	`ifdef ENDPT4_IN 	
	in_ep_max_mem[4]      <=  `ENDPT4_IN_MAX ;
	`endif	
	`ifdef ENDPT5_IN 	
	in_ep_max_mem[5]      <=  `ENDPT5_IN_MAX ;
	`endif	
	`ifdef ENDPT6_IN 	
	in_ep_max_mem[6]      <=  `ENDPT6_IN_MAX ;
	`endif	
	`ifdef ENDPT7_IN 	
	in_ep_max_mem[7]      <=  `ENDPT7_IN_MAX ;
	`endif	
	`ifdef ENDPT8_IN 	
	in_ep_max_mem[8]      <=  `ENDPT8_IN_MAX ;
	`endif	
	`ifdef ENDPT9_IN 	
	in_ep_max_mem[9]      <=  `ENDPT9_IN_MAX ;
	`endif	
	`ifdef ENDPT10_IN 	
	in_ep_max_mem[10]     <=  `ENDPT10_IN_MAX ;
	`endif	
	`ifdef ENDPT11_IN 	
	in_ep_max_mem[11]     <=  `ENDPT11_IN_MAX ;
	`endif	
	`ifdef ENDPT12_IN 	
	in_ep_max_mem[12]     <=  `ENDPT12_IN_MAX ;
	`endif	
	`ifdef ENDPT13_IN 	
	in_ep_max_mem[13]     <=  `ENDPT13_IN_MAX ;
	`endif	
	`ifdef ENDPT14_IN 	
	in_ep_max_mem[14]     <=  `ENDPT14_IN_MAX ;	
	`endif	
	`ifdef ENDPT15_IN 	
	in_ep_max_mem[15]     <=  `ENDPT15_IN_MAX ;	
	`endif		
end

always @ ( posedge local_clk ) begin
	buf_out_q	<= ep_buf_out_q_mem [tx_endp] ;
	dpp_eob 	<= ( buf_out_eob_mem [tx_endp] | buf_out_len_mem[tx_endp] < in_ep_max_mem [tx_endp]  ) ;
end

always @ ( * ) begin
	buf_out_len <= buf_out_len_mem [tx_endp] ;
	buf_out_hasdata <= buf_out_hasdata_mem [tx_endp] ;
	buf_in_ready <= buf_in_ready_mem [rx_endp];
end



							
				

always @ ( posedge local_clk or negedge reset_n ) begin
	if (! reset_n ) begin
		warm_or_hot_reset <= 0 ;
	end
	else if ( ltssm_state == LT_RX_DETECT_RESET || ltssm_state == LT_HOTRESET  ) begin
		warm_or_hot_reset <= 1 ;
	end
	else begin
		warm_or_hot_reset <= 0 ;
	end
end	
	
	
reg send_ack = 0 ;
reg send_ack_d = 0 ;
reg send_ack_d2 = 0 ;

reg [4:0] buf_in_nump_mem [0:15] ;
always @ ( posedge local_clk ) begin
	buf_in_nump_mem [0]  	<= 	1'b1	;
	buf_in_nump_mem [1]  	<=  ep1_buf_in_nump ;
	buf_in_nump_mem [2]  	<=  ep2_buf_in_nump ;
	buf_in_nump_mem [3]  	<=  ep3_buf_in_nump ;
	buf_in_nump_mem [4]  	<=  ep4_buf_in_nump ;
	buf_in_nump_mem [5]  	<=  ep5_buf_in_nump ;
	buf_in_nump_mem [6]  	<=  ep6_buf_in_nump ;
	buf_in_nump_mem [7]  	<=  ep7_buf_in_nump ;
	buf_in_nump_mem [8]  	<=  ep8_buf_in_nump ;
	buf_in_nump_mem [9]  	<=  ep9_buf_in_nump ;
	buf_in_nump_mem [10]  	<=  ep10_buf_in_nump ;
	buf_in_nump_mem [11]  	<=  ep11_buf_in_nump ;
	buf_in_nump_mem [12]  	<=  ep12_buf_in_nump ;
	buf_in_nump_mem [13]  	<=  ep13_buf_in_nump ;
	buf_in_nump_mem [14]  	<=  ep14_buf_in_nump ;
	buf_in_nump_mem [15]  	<=  ep15_buf_in_nump ;
end


always @ ( posedge local_clk ) begin
	if ( ltssm_state == 16 ) begin
		if ( send_ack_d2 ) begin
			// send ACK
			tx_tp_a			<= 1'b1;
			tx_tp_a_retry	<= (	rx_dpp_crcgood && 
									!err_missed_dpp_start && 
									!err_missed_dpp_done
								) ? LP_TP_NORETRY : LP_TP_RETRY;		
			tx_tp_a_dir		<= LP_TP_HOSTTODEVICE;
			tx_tp_a_subtype <= LP_TP_SUB_ACK;
			tx_tp_a_endp	<= rx_dph_endp;
			tx_tp_a_seq		<= in_dpp_seq;
			tx_tp_a_stream	<= 16'h0;
			tx_tp_a_nump <= buf_in_nump_mem[rx_dph_endp] ;	
		end
		else if ( tx_tp_a  ) begin
			if ( tx_tp_a_ack ) begin
				tx_tp_a <= 0 ;
			end
		end	
		else begin
			tx_tp_a <= 0;			
		end
	end
	else begin
		tx_tp_a <= 0 ;
	end
end
	
	
reg [1:0] out_ep_type_mem [0:15] ;
always @ ( posedge local_clk ) begin
	out_ep_type_mem [0]  	<= 	2'b00			 ;
	`ifdef ENDPT1_OUT
	out_ep_type_mem [1]  	<=  `ENDPT1_OUT_TYPE ;
	`endif
	`ifdef ENDPT2_OUT	
	out_ep_type_mem [2]  	<=  `ENDPT2_OUT_TYPE ;
	`endif 
	`ifdef ENDPT3_OUT		
	out_ep_type_mem [3]  	<=  `ENDPT3_OUT_TYPE ;
	`endif 
	`ifdef ENDPT4_OUT		
	out_ep_type_mem [4]  	<=  `ENDPT4_OUT_TYPE ;
	`endif 
	`ifdef ENDPT5_OUT		
	out_ep_type_mem [5]  	<=  `ENDPT5_OUT_TYPE ;
	`endif 
	`ifdef ENDPT6_OUT		
	out_ep_type_mem [6]  	<=  `ENDPT6_OUT_TYPE ;
	`endif
	`ifdef ENDPT7_OUT		
	out_ep_type_mem [7]  	<=  `ENDPT7_OUT_TYPE ;
	`endif 
	`ifdef ENDPT8_OUT		
	out_ep_type_mem [8]  	<=  `ENDPT8_OUT_TYPE ;
	`endif 
	`ifdef ENDPT9_OUT		
	out_ep_type_mem [9]  	<=  `ENDPT9_OUT_TYPE ;
	`endif 
	`ifdef ENDPT10_OUT		
	out_ep_type_mem [10]  	<=  `ENDPT10_OUT_TYPE ;
	`endif 
	`ifdef ENDPT11_OUT		
	out_ep_type_mem [11]  	<=  `ENDPT11_OUT_TYPE ;
	`endif 
	`ifdef ENDPT12_OUT		
	out_ep_type_mem [12]  	<=  `ENDPT12_OUT_TYPE ;
	`endif 
	`ifdef ENDPT13_OUT		
	out_ep_type_mem [13]  	<=  `ENDPT13_OUT_TYPE ;
	`endif 
	`ifdef ENDPT14_OUT		
	out_ep_type_mem [14]  	<=  `ENDPT14_OUT_TYPE ;
	`endif 
	`ifdef ENDPT15_OUT		
	out_ep_type_mem [15]  	<=  `ENDPT15_OUT_TYPE ;	
	`endif 
end
	
reg [1:0] in_ep_type_mem [0:15] ;
always @ ( posedge local_clk ) begin
	in_ep_type_mem [0]  	<= 	2'b00			 ;
	`ifdef ENDPT1_IN
	in_ep_type_mem [1]  	<=  `ENDPT1_IN_TYPE ;
	`endif
	`ifdef ENDPT2_IN	
	in_ep_type_mem [2]  	<=  `ENDPT2_IN_TYPE ;
	`endif 
	`ifdef ENDPT3_IN		
	in_ep_type_mem [3]  	<=  `ENDPT3_IN_TYPE ;
	`endif 
	`ifdef ENDPT4_IN		
	in_ep_type_mem [4]  	<=  `ENDPT4_IN_TYPE ;
	`endif 
	`ifdef ENDPT5_IN		
	in_ep_type_mem [5]  	<=  `ENDPT5_IN_TYPE ;
	`endif 
	`ifdef ENDPT6_IN		
	in_ep_type_mem [6]  	<=  `ENDPT6_IN_TYPE ;
	`endif
	`ifdef ENDPT7_IN		
	in_ep_type_mem [7]  	<=  `ENDPT7_IN_TYPE ;
	`endif 
	`ifdef ENDPT8_IN		
	in_ep_type_mem [8]  	<=  `ENDPT8_IN_TYPE ;
	`endif 
	`ifdef ENDPT9_IN		
	in_ep_type_mem [9]  	<=  `ENDPT9_IN_TYPE ;
	`endif 
	`ifdef ENDPT10_IN		
	in_ep_type_mem [10]  	<=  `ENDPT10_IN_TYPE ;
	`endif 
	`ifdef ENDPT11_IN		
	in_ep_type_mem [11]  	<=  `ENDPT11_IN_TYPE ;
	`endif 
	`ifdef ENDPT12_IN		
	in_ep_type_mem [12]  	<=  `ENDPT12_IN_TYPE ;
	`endif 
	`ifdef ENDPT13_IN		
	in_ep_type_mem [13]  	<=  `ENDPT13_IN_TYPE ;
	`endif 
	`ifdef ENDPT14_IN		
	in_ep_type_mem [14]  	<=  `ENDPT14_IN_TYPE ;
	`endif 
	`ifdef ENDPT15_IN		
	in_ep_type_mem [15]  	<=  `ENDPT15_IN_TYPE ;	
	`endif 
end  


reg [4:0] buf_out_nump_mem [0:15] ;
always @ ( posedge local_clk ) begin
	buf_out_nump_mem [0]  	<= 	1'b1	;
	buf_out_nump_mem [1]  	<=  ep1_buf_out_nump ;
	buf_out_nump_mem [2]  	<=  ep2_buf_out_nump ;
	buf_out_nump_mem [3]  	<=  ep3_buf_out_nump ;
	buf_out_nump_mem [4]  	<=  ep4_buf_out_nump ;
	buf_out_nump_mem [5]  	<=  ep5_buf_out_nump ;
	buf_out_nump_mem [6]  	<=  ep6_buf_out_nump ;
	buf_out_nump_mem [7]  	<=  ep7_buf_out_nump ;
	buf_out_nump_mem [8]  	<=  ep8_buf_out_nump ;
	buf_out_nump_mem [9]  	<=  ep9_buf_out_nump ;
	buf_out_nump_mem [10]  	<=  ep10_buf_out_nump ;
	buf_out_nump_mem [11]  	<=  ep11_buf_out_nump ;
	buf_out_nump_mem [12]  	<=  ep12_buf_out_nump ;
	buf_out_nump_mem [13]  	<=  ep13_buf_out_nump ;
	buf_out_nump_mem [14]  	<=  ep14_buf_out_nump ;
	buf_out_nump_mem [15]  	<=  ep15_buf_out_nump ;
end
	

 	
reg [15:0] buf_out_dp_acked ;	
	
	
always @(posedge local_clk  ) begin


	set_address_ack <= 0 ;
	
	send_ack <= 0 ;
	send_ack_d <= send_ack ;
	send_ack_d2 <= send_ack_d ;
	
	tx_tp_b <= 0;
	tx_tp_c <= 0;
	tx_dph <= 0;
	
	//do_send_dpp <= 0;
	
	tx_out_ep_NRDY <= 0 ;

	`INC(dc);
	`INC(recv_count);
	
	if ( warm_or_hot_reset || !reset_n ) begin
		dev_address <= 0 ;
	end
	
	buf_out_dp_acked <= 0 ;
	 
	case(rx_state)
	RX_RESET: begin 
		rx_state <= RX_IDLE;
		tx_tp_b <= 0 ;
	end
	RX_IDLE: begin
		enter_status_stage <= 0 ;
		send_ack <= 0 ;
		if(rx_dph) begin
			// receiving data packet header, link layer is stuffing payload
			// into the endpoint buffer
			in_dpp_seq <= rx_dph_seq;
			rx_endp <= rx_dph_endp;
			rx_state <= RX_DPH_0;
			recv_count <= 0;
		end else 
		if(rx_tp) begin
			// receving transaction packet, could be ACK or something else
			rx_state <= RX_TP_0;
		end
	end
	RX_DPH_0: begin
		if(rx_dpp_start) begin
			// received DPP start ordered set
			rx_state <= RX_DPH_1;
		end
		if(ltssm_state != LT_U0 || recv_count == 20) begin
			// we waited too long for DPP start and it hasn't come yet
			err_missed_dpp_start <= 1;
			rx_state <= RX_DPH_2;
		end
	end
	RX_DPH_1: begin
		if(rx_dpp_done) begin
			if(rx_dpp_crcgood) `INC(in_dpp_seq);
			err_missed_dpp_start <= 0;
			err_missed_dpp_done <= 0;
			if ( rx_in_dpp_wasready ) begin
				//rx_state <= RX_DPH_2;
				send_ack <= 1 ; 
				rx_state <= RX_IDLE ;
			end
			else begin
				rx_state <= RX_IDLE ;
				tx_out_ep_NRDY <= ( out_ep_type_mem[rx_endp] == ISO ) ? 0 : 1 ;
			end
		end
		if(ltssm_state != LT_U0 || recv_count == 270) begin
			err_missed_dpp_done <= 1;
			rx_state <= RX_DPH_2;
		end
	end
	RX_TP_0: begin
		// unless otherwise directed, immediately return
		case(rx_tp_subtype) 
		LP_TP_SUB_ACK: begin
			if ( !burst_in_act ) begin
				if( rx_tp_pktpend && rx_tp_nump > 0) begin
					// IN, expecting us to send data , burst starts 
					// switch endpoint mux
					tx_endp <= rx_tp_endp;
					rx_state <= RX_IDLE;
				end
			end
			else begin
				rx_state <= RX_IDLE ;  
				if ( !rx_tp_retry ) begin
					buf_out_dp_acked[rx_tp_endp] <= 1 ; 
				end
			end
		end
		LP_TP_SUB_NRDY: begin
		
		end
		LP_TP_SUB_ERDY: begin
		
		end
		LP_TP_SUB_STATUS: begin
			// for control transfers
			tx_tp_b			<= 1'b1;
			tx_tp_b_retry	<= LP_TP_NORETRY;
			tx_tp_b_dir		<= LP_TP_HOSTTODEVICE;
			tx_tp_b_subtype <= LP_TP_SUB_ACK;
			tx_tp_b_endp	<= rx_tp_endp;
			tx_tp_b_nump	<= 5'h0;
			tx_tp_b_seq		<= in_dpp_seq;
			tx_tp_b_stream	<= 16'h0;
			
			if ( tx_tp_b_ack && set_address ) begin
				set_address_ack <= 1 ;
				dev_address <= dev_address_q ;
			end
			else if ( tx_tp_b_ack ) begin
				rx_state <= RX_IDLE ;
				tx_tp_b <= 0 ;
				enter_status_stage <= 1 ;
			end
			
		end
		LP_TP_SUB_PING: begin
		
		end
		default: begin
			// invalid subtype
			err_tp_subtype <= 1;
		end
		endcase
	end
	
	RX_0: begin
	
	end
	RX_1: begin
	
	end
	endcase
	
	ep0_stall <= 0 ;
	
	
	do_send_dpp_ack <= 0 ;
	
	tx_dph_iso_0 <= 0 ;
	
	in_ep_rty[tx_endp] <= 0 ;
	
	case(tx_state) 
	TX_RESET: begin
		tx_state <= TX_IDLE;
		tx_tp_c <= 0 ;
		tx_dph <= 0 ;
	end
	TX_IDLE: begin
		if(do_send_dpp) begin
			// if you had multiple IN endpoints you would rewrite this part
			do_send_dpp_ack <= 1 ;
			out_dpp_seq_next_latch <= out_dpp_seq_next ;
			
			
			if(buf_out_hasdata) begin
				// data is already in EP buffer 
				// note: overall transfer length
				
				out_length <= buf_out_len;
				tx_state <= TX_DP_0;
				
				if ( do_send_dpp_rty ) begin
					in_ep_rty[tx_endp] <= 1 ;
				end
				
			end else begin
				if ( in_ep_type_mem[tx_endp] == ISO ) begin
					tx_state <= TX_DP_0_0 ;
				end
				else begin
					tx_state <= TX_DP_NRDY ;
				end
			end	
		end
		else if ( tx_out_ep_NRDY ) begin	
			tx_state <= TX_DP_NRDY_1 ;
		end
		else if ( wt_in_ep_rdy[0]  && ep0_buf_out_has_data ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 0 ;
			ep_dir <= LP_TP_DEVICETOHOST ;
		end
		else if ( wt_out_ep_rdy[0] && ep0_in_buf_ready ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 0 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end
		`ifdef ENDPT1_IN 
		else if ( wt_in_ep_rdy[1]  && ep1_buf_out_has_data && `ENDPT1_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 1 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT2_IN 
		//else if ( wt_in_ep_rdy[2]  && ep2_buf_out_has_data && `ENDPT2_IN_TYPE != ISO &&  ep2_buf_out_nump >= `ENDPT2_IN_BURST ) begin
		else if ( wt_in_ep_rdy[2]  && ep2_buf_out_has_data && `ENDPT2_IN_TYPE != ISO  ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 2 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT3_IN 
		else if ( wt_in_ep_rdy[3]  && ep3_buf_out_has_data && `ENDPT3_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 3 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT4_IN 
		else if ( wt_in_ep_rdy[4]  && ep4_buf_out_has_data && `ENDPT4_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 4 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT5_IN 
		else if ( wt_in_ep_rdy[5]  && ep5_buf_out_has_data && `ENDPT5_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 5 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT6_IN 
		else if ( wt_in_ep_rdy[6]  && ep6_buf_out_has_data && `ENDPT6_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 6 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT7_IN 
		else if ( wt_in_ep_rdy[7]  && ep7_buf_out_has_data && `ENDPT7_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 7 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT8_IN 
		else if ( wt_in_ep_rdy[8]  && ep8_buf_out_has_data && `ENDPT8_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 8 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT9_IN 
		else if ( wt_in_ep_rdy[9]  && ep9_buf_out_has_data && `ENDPT9_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 9 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT10_IN 
		else if ( wt_in_ep_rdy[10]  && ep10_buf_out_has_data && `ENDPT10_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 10 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT11_IN 
		else if ( wt_in_ep_rdy[11]  && ep11_buf_out_has_data && `ENDPT11_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 11 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT12_IN 
		else if ( wt_in_ep_rdy[12]  && ep12_buf_out_has_data && `ENDPT12_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 12 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT13_IN 
		else if ( wt_in_ep_rdy[13]  && ep13_buf_out_has_data && `ENDPT13_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 13 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT14_IN 
		else if ( wt_in_ep_rdy[14]  && ep14_buf_out_has_data && `ENDPT14_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 14 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 
		`ifdef ENDPT15_IN 
		else if ( wt_in_ep_rdy[15]  && ep15_buf_out_has_data && `ENDPT15_IN_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 15 ;
			ep_dir <= LP_TP_DEVICETOHOST ;		
		end
		`endif 	
		`ifdef ENDPT1_OUT
		else if ( wt_out_ep_rdy[1] && ep1_buf_in_ready && `ENDPT1_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 1 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT2_OUT
		else if ( wt_out_ep_rdy[2] && ep2_buf_in_ready && `ENDPT2_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 2 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT3_OUT
		else if ( wt_out_ep_rdy[3] && ep3_buf_in_ready && `ENDPT3_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 3 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT4_OUT
		else if ( wt_out_ep_rdy[4] && ep4_buf_in_ready && `ENDPT4_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 4 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT5_OUT
		else if ( wt_out_ep_rdy[5] && ep5_buf_in_ready && `ENDPT5_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 5 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT6_OUT
		else if ( wt_out_ep_rdy[6] && ep6_buf_in_ready && `ENDPT6_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 6 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT7_OUT
		else if ( wt_out_ep_rdy[7] && ep7_buf_in_ready && `ENDPT7_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 7 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT8_OUT
		else if ( wt_out_ep_rdy[8] && ep8_buf_in_ready && `ENDPT8_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 8 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT9_OUT
		else if ( wt_out_ep_rdy[9] && ep9_buf_in_ready && `ENDPT9_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 9 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT10_OUT
		else if ( wt_out_ep_rdy[10] && ep10_buf_in_ready && `ENDPT10_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 10 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT11_OUT
		else if ( wt_out_ep_rdy[11] && ep11_buf_in_ready && `ENDPT11_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 11 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT12_OUT
		else if ( wt_out_ep_rdy[12] && ep12_buf_in_ready && `ENDPT12_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 12 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT13_OUT
		else if ( wt_out_ep_rdy[13] && ep13_buf_in_ready && `ENDPT13_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 13 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT14_OUT
		else if ( wt_out_ep_rdy[14] && ep14_buf_in_ready && `ENDPT14_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 14 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
		`ifdef ENDPT15_OUT
		else if ( wt_out_ep_rdy[15] && ep15_buf_in_ready && `ENDPT15_OUT_TYPE != ISO ) begin
			tx_state <= TX_DP_ERDY ;
			ep_rdy_num <= 15 ;
			ep_dir <= LP_TP_HOSTTODEVICE ;		
		end		
		`endif 
	end
	TX_STALL:begin
		tx_tp_c			<= 1'b1;
		tx_tp_c_retry	<= LP_TP_NORETRY;
		tx_tp_c_dir		<= LP_TP_HOSTTODEVICE;
		tx_tp_c_subtype <= LP_TP_SUB_STALL;
		tx_tp_c_endp	<= tx_endp;
		tx_tp_c_nump	<= 5'h0;
		tx_tp_c_seq		<= 5'h0;
		tx_tp_c_stream	<= 16'h0;
		
		if( tx_tp_c && tx_tp_c_ack) begin
			tx_state <= TX_IDLE ;
			tx_tp_c <= 0 ;
			ep0_stall <= 1 ;
		end
	end
	TX_DP_NRDY: begin
		tx_tp_c			<= 1'b1;
		tx_tp_c_retry	<= LP_TP_NORETRY;
		tx_tp_c_dir		<= LP_TP_DEVICETOHOST;
		tx_tp_c_subtype <= LP_TP_SUB_NRDY;
		tx_tp_c_endp	<= tx_endp;
		tx_tp_c_nump	<= 5'h0;
		tx_tp_c_seq		<= 5'h0;
		tx_tp_c_stream	<= 16'h0;
		
		if( tx_tp_c && tx_tp_c_ack) begin
			tx_tp_c <= 0 ;
			
			tx_state <= TX_IDLE ;
	
		end
	end
	TX_DP_NRDY_1:begin
		tx_tp_c			<= 1'b1;
		tx_tp_c_retry	<= LP_TP_NORETRY;
		tx_tp_c_dir		<= LP_TP_HOSTTODEVICE;
		tx_tp_c_subtype <= LP_TP_SUB_NRDY;
		tx_tp_c_endp	<= rx_endp;
		tx_tp_c_nump	<= 5'h0;
		tx_tp_c_seq		<= 5'h0;
		tx_tp_c_stream	<= 16'h0;		
		
		if( tx_tp_c && tx_tp_c_ack) begin
		
			tx_state <= TX_IDLE ;	
			tx_tp_c <= 0 ;
		end
	end
	TX_DP_ERDY: begin
		tx_tp_c			<= 1'b1;
		tx_tp_c_retry	<= LP_TP_NORETRY;
		tx_tp_c_dir		<= ep_dir;
		tx_tp_c_subtype <= LP_TP_SUB_ERDY;
		tx_tp_c_endp	<= ep_rdy_num;
		tx_tp_c_seq		<= 5'h0;
		tx_tp_c_stream	<= 16'h0;
	
		if( tx_tp_c && tx_tp_c_ack) begin
			tx_state <= TX_IDLE;
			tx_tp_c <= 0 ;
		end
		
		if ( ep_dir == LP_TP_DEVICETOHOST ) begin
			tx_tp_c_nump <= buf_out_nump_mem [ep_rdy_num] ; 
		end		
		else if ( ep_dir == LP_TP_HOSTTODEVICE ) begin
			tx_tp_c_nump <= buf_in_nump_mem [ep_rdy_num] ;
		end
		
	end
	TX_DP_0: begin
		tx_dph			<= 1'b1;
		tx_dph_eob		<= tx_endp == 0 ? 0 : do_send_dpp_eob; // TODO
		tx_dph_dir		<= tx_endp == 0 ? 0 : LP_TP_DEVICETOHOST; // rx_tp_endp
		tx_dph_endp		<= tx_endp;
		tx_dph_seq		<= out_dpp_seq_next_latch;
		tx_dph_len		<= out_length; // TODO

		dc <= 0;
		if(tx_dph && tx_dpp_ack) tx_state <= TX_DP_1;
	end
	TX_DP_0_0: begin
		tx_dph			<= 1'b1;
		tx_dph_eob		<= 1 ; // TODO
		tx_dph_dir		<= LP_TP_DEVICETOHOST; // rx_tp_endp
		tx_dph_endp		<= tx_endp;
		tx_dph_seq		<= out_dpp_seq_next_latch;
		tx_dph_len		<= 0; // TODO
		tx_dph_iso_0    <= 1;
		dc <= 0;
		if(tx_dph && tx_dpp_ack) begin
			tx_state <= TX_DP_1;
			tx_dph_iso_0 <= 0 ;	
		end
	end	
	TX_DP_1: begin
		if(tx_dpp_done ) tx_state <= TX_IDLE;
	end
	endcase
	
	
	
	if(rx_state != RX_IDLE) begin
		// missed an incoming transaction!
		if(rx_dph || rx_tp) err_miss_rx <= 1;
	end
	if(tx_state != TX_IDLE) begin
		if(do_send_dpp) err_miss_tx <= 1;
	end
	
	
	if(~reset_n || warm_or_hot_reset) begin
		rx_state <= RX_RESET;
		tx_state <= TX_RESET;
	end

	if(~reset_n || warm_or_hot_reset) begin
		err_miss_rx <= 0;
		err_miss_tx <= 0;
		err_tp_subtype <= 0;
		err_missed_dpp_start <= 0;
		err_missed_dpp_done <= 0;
	end
end



//managing ep NRDY and ERDY 
always @ ( posedge local_clk or negedge reset_n ) begin
	if (!reset_n) begin
		wt_in_ep_rdy <= 0 ;
	end
	else if ( tx_state == TX_DP_NRDY ) begin
		wt_in_ep_rdy[tx_endp] <= 1 ;
	end
	else if ( tx_dph == 1 && tx_dph_eob == 1 ) begin
		wt_in_ep_rdy[tx_endp] <= 1 ;
	end
	else if ( tx_state == TX_DP_ERDY && ep_dir == LP_TP_DEVICETOHOST ) begin
		wt_in_ep_rdy[ep_rdy_num] <= 0 ;
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if (!reset_n) begin
		wt_out_ep_rdy <= 0 ;
	end
	else if ( tx_state == TX_DP_NRDY_1  ) begin
		wt_out_ep_rdy[rx_endp] <= 1 ;
	end
	else if ( tx_state == TX_DP_ERDY && ep_dir == LP_TP_HOSTTODEVICE ) begin
		wt_out_ep_rdy[ep_rdy_num] <= 0 ;
	end
end

//managing burst IN dpp
reg burst_in_act ; 
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		out_dpp_seq_latch <= 0 ;
		out_nump_latch <= 0 ;
		burst_in_act <= 0 ;
		host_requests_data <= 0 ;
	end
	else if ( burst_in_act == 0 && !burst_in_stop ) begin
		if ( rx_state == RX_TP_0 && rx_tp_subtype == LP_TP_SUB_ACK && rx_tp_pktpend && rx_tp_nump > 0 ) begin
			burst_in_act <= 1 ;
			out_dpp_seq_latch <= rx_tp_seq ;
			out_nump_latch <= rx_tp_nump ;	
			host_requests_data <= 1 ;
			host_requests_endpt <= rx_tp_endp ;
		end
	end
	else if ( burst_in_act == 1 ) begin
		host_requests_data <= 0 ;
		if ( rx_state == RX_TP_0 && rx_tp_subtype == LP_TP_SUB_ACK ) begin 
			if ( rx_tp_nump == 0 ) begin
				burst_in_act <= 0 ;
			end
			else if ( rx_tp_nump > 0 ) begin
				out_dpp_seq_latch <= rx_tp_seq ;
				out_nump_latch <= rx_tp_nump ;				
			end
		end
		else if ( do_send_dpp_ack && dpp_eob && out_ep_type_mem [tx_endp]  == ISO ) begin
			burst_in_act <= 0 ;
		end
		else if ( tx_state == TX_DP_NRDY ) begin
			burst_in_act <= 0 ;
		end
		else if ( tx_state == TX_DP_0_0  ) begin
			burst_in_act <= 0 ;
		end
		//else if ( ltssm_state != 16 ) begin
		//	burst_in_act <= 0 ; 
		//end
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		out_dpp_seq_next <= 0 ;
	end
	else if ( burst_in_act == 0 && rx_state == RX_TP_0 && rx_tp_subtype == LP_TP_SUB_ACK && rx_tp_pktpend && rx_tp_nump > 0 ) begin
		out_dpp_seq_next <= rx_tp_seq ;
	end
	else if ( burst_in_act == 1 && rx_state == RX_TP_0 && rx_tp_subtype == LP_TP_SUB_ACK && rx_tp_retry ) begin
		out_dpp_seq_next <= rx_tp_seq ;
	end
	else if ( do_send_dpp && do_send_dpp_ack ) begin
		out_dpp_seq_next <= out_dpp_seq_next + 1 ;
	end
end

reg burst_in_end ;
reg do_send_dpp_rty ;
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		do_send_dpp <= 0 ;
		burst_in_end <= 0 ;
		do_send_dpp_rty <= 0 ;
	end
	else if ( do_send_dpp_ack ) begin
		do_send_dpp <= 0 ;
		do_send_dpp_eob <= dpp_eob ;
		do_send_dpp_rty <= 0 ;
		//if ( dpp_eob ) begin
		//	burst_in_end <= 1 ;
		//end
		//if ( dpp_eob && out_ep_type_mem [tx_endp]  == ISO ) begin
		//	burst_in_end <= 1 ;
		//end		
	end		
	else if ( out_dpp_seq_latch + out_nump_latch != out_dpp_seq_next  && burst_in_act && !burst_in_stop ) begin
		do_send_dpp <= 1 ;
		do_send_dpp_eob <= dpp_eob ;
		if ( burst_in_act == 1 && rx_state == RX_TP_0 && rx_tp_subtype == LP_TP_SUB_ACK && rx_tp_retry ) begin
			do_send_dpp_rty <= 1 ;
		end
	end
end

reg burst_in_stop ;
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		burst_in_stop <= 0 ;
	end
	else if ( do_send_dpp_ack && dpp_eob ) begin
		burst_in_stop <= 1 ;
	end
	else if ( burst_in_act == 1 && rx_state == RX_TP_0 && rx_tp_subtype == LP_TP_SUB_ACK && rx_tp_retry ) begin
		burst_in_stop <= 0 ;
	end	
	else if ( !burst_in_act ) begin
		burst_in_stop <= 0 ;
	end

end









	





////////////////////////////////////////////////////////////
//
// ENDPOINT 0 IN/OUT
//
////////////////////////////////////////////////////////////
`ifdef SIM
usb3_ep0
`else
`getname(usb3_ep0,`module_name)
`endif 
iu3ep0 (
	.slow_clk			( slow_clk )
	,.local_clk			( local_clk )
	,.reset_n			( reset_n & !warm_or_hot_reset )
	
	,.err_setup_pkt		()
	,.set_device_low_power_state ( set_device_low_power_state )
	,.set_device_low_power_state_ack ( set_device_low_power_state_ack )
	
	
	,.ltssm_state		(ltssm_state)
	
	,.buf_in_data		( ep0_buf_in_data 		)
	,.buf_in_wren		( ep0_buf_in_wren 		)
	,.buf_in_ready		( ep0_buf_in_ready 		)
	,.buf_in_commit		( ep0_buf_in_commit 	)
	,.buf_in_commit_len ( ep0_buf_in_commit_len )
	
	,.buf_out_q			( ep0_buf_out_q 		)
	,.buf_out_len		( ep0_buf_out_len		)
	,.buf_out_hasdata	( ep0_buf_out_has_data 	)
	,.buf_out_arm		( ep0_buf_out_ack 		)
	,.buf_out_rden		( ep0_buf_out_rden		)
	
	,.reset_dp_seq		( reset_dp_seq )
	
	,.buf_out_dp_acked	( buf_out_dp_acked[0] )
	,.in_ep_rty			( in_ep_rty [0] )
	
	
	// external interface 
	,.ep0_in_buf_data               (ep0_in_buf_data       )
	,.ep0_in_buf_wren               (ep0_in_buf_wren       )
	,.ep0_in_buf_ready              (ep0_in_buf_ready      )
	,.ep0_in_buf_commit             (ep0_in_buf_data_commit     )
	,.ep0_in_buf_commit_len         (ep0_in_buf_data_commit_len )
	
	,.ep0_out_buf_data		 	    (ep0_out_buf_data		)
	,.ep0_out_buf_len		        (ep0_out_buf_len		)
	,.ep0_out_buf_hasdata	        (ep0_out_buf_has_data	)
	,.ep0_out_buf_ack		        (ep0_out_buf_data_ack   )
	,.ep0_out_buf_rden 				(ep0_out_buf_rden		)
		
	
	// requests

	,.request_active 			   (request_active 	)
	,.bmRequestType			       (bmRequestType  	)
	,.bRequest				       (bRequest	   	)
	,.wValue			           (wValue		 	)
	,.wIndex			           (wIndex		 	)
	,.wLength				       (wLength		 	)
		
	
	,.set_address 					(set_address)
	,.dev_address                   (dev_address_q)
	,.set_address_ack				(set_address_ack)

	,.enter_status_stage			(enter_status_stage)
	,.ep0_stall						(ep0_stall)
);



`ifdef ENDPT1_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep1_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep1_in_buf_data 				)
	,.buf_in_wren		( ep1_in_buf_wren 				)
	,.buf_in_ready		( ep1_in_buf_ready 				)
	,.buf_in_commit		( ep1_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep1_in_buf_data_commit_len 	)
	,.buf_in_nump		( 				)	
	,.buf_out_dp_acked	( buf_out_dp_acked[1] )
	,.in_ep_rty			( in_ep_rty [1] )	
	
	,.buf_out_q			( ep1_buf_out_q 				)
	,.buf_out_len		( ep1_buf_out_len 				)
	,.buf_out_hasdata	( ep1_buf_out_has_data 			)
	,.buf_out_arm		( ep1_buf_out_ack 				)
	,.buf_out_rden		( ep1_buf_out_rden				)
	,.buf_out_eob		( ep1_buf_out_eob				)
	,.buf_out_nump	    ( ep1_buf_out_nump			    )	
	
);
defparam usb3_ep1_IN.ENDPT_BURST = `ENDPT1_IN_BURST ;
`endif

`ifdef ENDPT2_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep2_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep2_in_buf_data 				)
	,.buf_in_wren		( ep2_in_buf_wren 				)
	,.buf_in_ready		( ep2_in_buf_ready 				)
	,.buf_in_commit		( ep2_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep2_in_buf_data_commit_len 	)
	,.buf_in_nump		( 				)	
	,.buf_in_eob		( ep2_in_buf_eob )

	,.buf_out_dp_acked	( buf_out_dp_acked[2] )	
	,.in_ep_rty			( in_ep_rty [2] )	
	
	,.buf_out_q			( ep2_buf_out_q 				)
	,.buf_out_len		( ep2_buf_out_len 				)
	,.buf_out_hasdata	( ep2_buf_out_has_data 			)
	,.buf_out_arm		( ep2_buf_out_ack 				)
	,.buf_out_rden		( ep2_buf_out_rden				)
	,.buf_out_eob		( ep2_buf_out_eob				)
	,.buf_out_nump	    ( ep2_buf_out_nump			    )	
	
);
defparam usb3_ep2_IN.ENDPT_BURST = `ENDPT2_IN_BURST ;
`endif

`ifdef ENDPT3_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep3_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep3_in_buf_data 				)
	,.buf_in_wren		( ep3_in_buf_wren 				)
	,.buf_in_ready		( ep3_in_buf_ready 				)
	,.buf_in_commit		( ep3_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep3_in_buf_data_commit_len 	)

	,.buf_out_dp_acked	( buf_out_dp_acked[3] )	
	,.in_ep_rty			( in_ep_rty [3] )	
	
	,.buf_out_q			( ep3_buf_out_q 				)
	,.buf_out_len		( ep3_buf_out_len 				)
	,.buf_out_hasdata	( ep3_buf_out_has_data 			)
	,.buf_out_arm		( ep3_buf_out_ack 				)
	,.buf_out_rden		( ep3_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		(ep3_buf_out_eob )
	,.buf_out_nump		(ep3_buf_out_nump )
	
	
);
defparam usb3_ep3_IN.ENDPT_BURST = `ENDPT3_IN_BURST ;
`endif

`ifdef ENDPT4_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep4_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep4_in_buf_data 				)
	,.buf_in_wren		( ep4_in_buf_wren 				)
	,.buf_in_ready		( ep4_in_buf_ready 				)
	,.buf_in_commit		( ep4_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep4_in_buf_data_commit_len 	)

	,.buf_out_dp_acked	( buf_out_dp_acked[4] )	
	,.in_ep_rty			( in_ep_rty [4] )	
	
	,.buf_out_q			( ep4_buf_out_q 				)
	,.buf_out_len		( ep4_buf_out_len 				)
	,.buf_out_hasdata	( ep4_buf_out_has_data 			)
	,.buf_out_arm		( ep4_buf_out_ack 				)
	,.buf_out_rden		( ep4_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		(ep4_buf_out_eob )
	,.buf_out_nump		(ep4_buf_out_nump )	
	
);
defparam usb3_ep4_IN.ENDPT_BURST = `ENDPT4_IN_BURST ;
`endif

`ifdef ENDPT5_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep5_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep5_in_buf_data 				)
	,.buf_in_wren		( ep5_in_buf_wren 				)
	,.buf_in_ready		( ep5_in_buf_ready 				)
	,.buf_in_commit		( ep5_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep5_in_buf_data_commit_len 	)

	,.buf_out_dp_acked	( buf_out_dp_acked[5] )	
	,.in_ep_rty			( in_ep_rty [5] )	
	
	,.buf_out_q			( ep5_buf_out_q 				)
	,.buf_out_len		( ep5_buf_out_len 				)
	,.buf_out_hasdata	( ep5_buf_out_has_data 			)
	,.buf_out_arm		( ep5_buf_out_ack 				)
	,.buf_out_rden		( ep5_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		( ep5_buf_out_eob)
	,.buf_out_nump		( ep5_buf_out_nump)	
	
);
defparam usb3_ep5_IN.ENDPT_BURST = `ENDPT5_IN_BURST ;
`endif

`ifdef ENDPT6_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep6_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep6_in_buf_data 				)
	,.buf_in_wren		( ep6_in_buf_wren 				)
	,.buf_in_ready		( ep6_in_buf_ready 				)
	,.buf_in_commit		( ep6_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep6_in_buf_data_commit_len 	)
	
	,.buf_out_dp_acked	( buf_out_dp_acked[6] )	
	,.in_ep_rty			( in_ep_rty [6] )	
	
	,.buf_out_q			( ep6_buf_out_q 				)
	,.buf_out_len		( ep6_buf_out_len 				)
	,.buf_out_hasdata	( ep6_buf_out_has_data 			)
	,.buf_out_arm		( ep6_buf_out_ack 				)
	,.buf_out_rden		( ep6_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		( ep6_buf_out_eob)
	,.buf_out_nump		( ep6_buf_out_nump)	
	
);
defparam usb3_ep6_IN.ENDPT_BURST = `ENDPT6_IN_BURST ;
`endif

`ifdef ENDPT7_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep7_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep7_in_buf_data 				)
	,.buf_in_wren		( ep7_in_buf_wren 				)
	,.buf_in_ready		( ep7_in_buf_ready 				)
	,.buf_in_commit		( ep7_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep7_in_buf_data_commit_len 	)
	
	,.buf_out_dp_acked	( buf_out_dp_acked[7] )	
	,.in_ep_rty			( in_ep_rty [7] )	
	
	,.buf_out_q			( ep7_buf_out_q 				)
	,.buf_out_len		( ep7_buf_out_len 				)
	,.buf_out_hasdata	( ep7_buf_out_has_data 			)
	,.buf_out_arm		( ep7_buf_out_ack 				)
	,.buf_out_rden		( ep7_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		( ep7_buf_out_eob)
	,.buf_out_nump		( ep7_buf_out_nump)	
	
);
defparam usb3_ep7_IN.ENDPT_BURST = `ENDPT7_IN_BURST ;
`endif

`ifdef ENDPT8_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep8_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep8_in_buf_data 				)
	,.buf_in_wren		( ep8_in_buf_wren 				)
	,.buf_in_ready		( ep8_in_buf_ready 				)
	,.buf_in_commit		( ep8_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep8_in_buf_data_commit_len 	)
	
	,.buf_out_dp_acked	( buf_out_dp_acked[8] )	
	,.in_ep_rty			( in_ep_rty [8] )	
	
	,.buf_out_q			( ep8_buf_out_q 				)
	,.buf_out_len		( ep8_buf_out_len 				)
	,.buf_out_hasdata	( ep8_buf_out_has_data 			)
	,.buf_out_arm		( ep8_buf_out_ack 				)
	,.buf_out_rden		( ep8_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		( ep8_buf_out_eob)
	,.buf_out_nump		( ep8_buf_out_nump)	
	
);
defparam usb3_ep8_IN.ENDPT_BURST = `ENDPT8_IN_BURST ;
`endif

`ifdef ENDPT9_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep9_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep9_in_buf_data 				)
	,.buf_in_wren		( ep9_in_buf_wren 				)
	,.buf_in_ready		( ep9_in_buf_ready 				)
	,.buf_in_commit		( ep9_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep9_in_buf_data_commit_len 	)
	
	,.buf_out_dp_acked	( buf_out_dp_acked[9] )	
	,.in_ep_rty			( in_ep_rty [9] )	
	
	,.buf_out_q			( ep9_buf_out_q 				)
	,.buf_out_len		( ep9_buf_out_len 				)
	,.buf_out_hasdata	( ep9_buf_out_has_data 			)
	,.buf_out_arm		( ep9_buf_out_ack 				)
	,.buf_out_rden		( ep9_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		( ep9_buf_out_eob)
	,.buf_out_nump		( ep9_buf_out_nump)	
	
);
defparam usb3_ep9_IN.ENDPT_BURST = `ENDPT9_IN_BURST ;
`endif

`ifdef ENDPT10_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep10_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep10_in_buf_data 				)
	,.buf_in_wren		( ep10_in_buf_wren 				)
	,.buf_in_ready		( ep10_in_buf_ready 				)
	,.buf_in_commit		( ep10_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep10_in_buf_data_commit_len 	)
	
	,.buf_out_dp_acked	( buf_out_dp_acked[10] )
	,.in_ep_rty			( in_ep_rty [10] )	
	
	,.buf_out_q			( ep10_buf_out_q 				)
	,.buf_out_len		( ep10_buf_out_len 				)
	,.buf_out_hasdata	( ep10_buf_out_has_data 			)
	,.buf_out_arm		( ep10_buf_out_ack 				)
	,.buf_out_rden		( ep10_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		( ep10_buf_out_eob)
	,.buf_out_nump		( ep10_buf_out_nump)	
	
);
defparam usb3_ep10_IN.ENDPT_BURST = `ENDPT10_IN_BURST ;
`endif

`ifdef ENDPT11_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep11_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep11_in_buf_data 				)
	,.buf_in_wren		( ep11_in_buf_wren 				)
	,.buf_in_ready		( ep11_in_buf_ready 				)
	,.buf_in_commit		( ep11_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep11_in_buf_data_commit_len 	)
	
	,.buf_out_dp_acked	( buf_out_dp_acked[11] )	
	,.in_ep_rty			( in_ep_rty [11] )	
	
	,.buf_out_q			( ep11_buf_out_q 				)
	,.buf_out_len		( ep11_buf_out_len 				)
	,.buf_out_hasdata	( ep11_buf_out_has_data 			)
	,.buf_out_arm		( ep11_buf_out_ack 				)
	,.buf_out_rden		( ep11_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		( ep11_buf_out_eob)
	,.buf_out_nump		( ep11_buf_out_nump)	
	
);
defparam usb3_ep11_IN.ENDPT_BURST = `ENDPT11_IN_BURST ;
`endif

`ifdef ENDPT12_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep12_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep12_in_buf_data 				)
	,.buf_in_wren		( ep12_in_buf_wren 				)
	,.buf_in_ready		( ep12_in_buf_ready 				)
	,.buf_in_commit		( ep12_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep12_in_buf_data_commit_len 	)
	
	,.buf_out_dp_acked	( buf_out_dp_acked[12] )	
	,.in_ep_rty			( in_ep_rty [12] )	
	
	,.buf_out_q			( ep12_buf_out_q 				)
	,.buf_out_len		( ep12_buf_out_len 				)
	,.buf_out_hasdata	( ep12_buf_out_has_data 			)
	,.buf_out_arm		( ep12_buf_out_ack 				)
	,.buf_out_rden		( ep12_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		( ep12_buf_out_eob)
	,.buf_out_nump		( ep12_buf_out_nump)	
	
);
defparam usb3_ep12_IN.ENDPT_BURST = `ENDPT12_IN_BURST ;
`endif

`ifdef ENDPT13_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep13_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep13_in_buf_data 				)
	,.buf_in_wren		( ep13_in_buf_wren 				)
	,.buf_in_ready		( ep13_in_buf_ready 				)
	,.buf_in_commit		( ep13_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep13_in_buf_data_commit_len 	)
	
	,.buf_out_dp_acked	( buf_out_dp_acked[13] )	
	,.in_ep_rty			( in_ep_rty [13] )	
	
	,.buf_out_q			( ep13_buf_out_q 				)
	,.buf_out_len		( ep13_buf_out_len 				)
	,.buf_out_hasdata	( ep13_buf_out_has_data 			)
	,.buf_out_arm		( ep13_buf_out_ack 				)
	,.buf_out_rden		( ep13_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		( ep13_buf_out_eob)
	,.buf_out_nump		( ep13_buf_out_nump)	
	
);
defparam usb3_ep13_IN.ENDPT_BURST = `ENDPT13_IN_BURST ;
`endif

`ifdef ENDPT14_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep14_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep14_in_buf_data 				)
	,.buf_in_wren		( ep14_in_buf_wren 				)
	,.buf_in_ready		( ep14_in_buf_ready 			)
	,.buf_in_commit		( ep14_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep14_in_buf_data_commit_len 	)
	
	,.buf_out_dp_acked	( buf_out_dp_acked[14] )	
	,.in_ep_rty			( in_ep_rty [14] )
	
	,.buf_out_q			( ep14_buf_out_q 				)
	,.buf_out_len		( ep14_buf_out_len 				)
	,.buf_out_hasdata	( ep14_buf_out_has_data 			)
	,.buf_out_arm		( ep14_buf_out_ack 				)
	,.buf_out_rden		( ep14_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		( ep14_buf_out_eob)
	,.buf_out_nump		( ep14_buf_out_nump)	
	
);
defparam usb3_ep14_IN.ENDPT_BURST = `ENDPT14_IN_BURST ;
`endif

`ifdef ENDPT15_IN
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep15_IN	 (

	 .clk 				(local_clk)
	,.rst_n             (reset_n)

	,.buf_in_data		( ep15_in_buf_data 				)
	,.buf_in_wren		( ep15_in_buf_wren 				)
	,.buf_in_ready		( ep15_in_buf_ready 				)
	,.buf_in_commit		( ep15_in_buf_data_commit 		)
	,.buf_in_commit_len ( ep15_in_buf_data_commit_len 	)
	
	,.buf_out_dp_acked	( buf_out_dp_acked[15] )
	,.in_ep_rty			( in_ep_rty [15] )	
	
	,.buf_out_q			( ep15_buf_out_q 				)
	,.buf_out_len		( ep15_buf_out_len 				)
	,.buf_out_hasdata	( ep15_buf_out_has_data 			)
	,.buf_out_arm		( ep15_buf_out_ack 				)
	,.buf_out_rden		( ep15_buf_out_rden				)
	
	,.buf_in_nump		( )
	,.buf_out_eob		( ep15_buf_out_eob)
	,.buf_out_nump		( ep15_buf_out_nump)	
	
);
defparam usb3_ep15_IN.ENDPT_BURST = `ENDPT15_IN_BURST ;
`endif



`ifdef ENDPT1_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep1_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep1_buf_in_data 		)
	,.buf_in_wren		( ep1_buf_in_wren 		)
	,.buf_in_ready		( ep1_buf_in_ready 		)
	,.buf_in_commit		( ep1_buf_in_commit 	)
	,.buf_in_commit_len ( ep1_buf_in_commit_len )

	,.buf_out_dp_acked	( )	
	,.in_ep_rty			(  )	
	
	,.buf_out_q			( ep1_out_buf_data 		)
	,.buf_out_len		( ep1_out_buf_len 		)
	,.buf_out_hasdata	( ep1_out_buf_has_data 	)
	,.buf_out_arm		( ep1_out_buf_data_ack 	)
	,.buf_out_rden		( ep1_out_buf_rden		)
	
	,.buf_in_nump		( ep1_buf_in_nump )
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep1_OUT.ENDPT_BURST = `ENDPT1_OUT_BURST ;
defparam usb3_ep1_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT2_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep2_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep2_buf_in_data 		)
	,.buf_in_wren		( ep2_buf_in_wren 		)
	,.buf_in_ready		( ep2_buf_in_ready 		)
	,.buf_in_commit		( ep2_buf_in_commit 	)
	,.buf_in_commit_len ( ep2_buf_in_commit_len )
	,.buf_in_nump		( ep2_buf_in_nump		)

	,.buf_out_dp_acked	( )		
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep2_out_buf_data 		)
	,.buf_out_len		( ep2_out_buf_len 		)
	,.buf_out_hasdata	( ep2_out_buf_has_data 	)
	,.buf_out_arm		( ep2_out_buf_data_ack 	)
	,.buf_out_rden		( ep2_out_buf_rden		)
	,.buf_out_eob 		 (							)
	,.buf_out_nump	     (							)	
);
defparam usb3_ep2_OUT.ENDPT_BURST = `ENDPT2_OUT_BURST ;
defparam usb3_ep2_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT3_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep3_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep3_buf_in_data 		)
	,.buf_in_wren		( ep3_buf_in_wren 		)
	,.buf_in_ready		( ep3_buf_in_ready 		)
	,.buf_in_commit		( ep3_buf_in_commit 	)
	,.buf_in_commit_len ( ep3_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )	
	,.in_ep_rty			(  )		
	
	
	,.buf_out_q			( ep3_out_buf_data 		)
	,.buf_out_len		( ep3_out_buf_len 		)
	,.buf_out_hasdata	( ep3_out_buf_has_data 	)
	,.buf_out_arm		( ep3_out_buf_data_ack 	)
	,.buf_out_rden		( ep3_out_buf_rden		)
	
	,.buf_in_nump		( ep3_buf_in_nump )
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep3_OUT.ENDPT_BURST = `ENDPT3_OUT_BURST ;
defparam usb3_ep3_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT4_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep4_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep4_buf_in_data 		)
	,.buf_in_wren		( ep4_buf_in_wren 		)
	,.buf_in_ready		( ep4_buf_in_ready 		)
	,.buf_in_commit		( ep4_buf_in_commit 	)
	,.buf_in_commit_len ( ep4_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )	
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep4_out_buf_data 		)
	,.buf_out_len		( ep4_out_buf_len 		)
	,.buf_out_hasdata	( ep4_out_buf_has_data 	)
	,.buf_out_arm		( ep4_out_buf_data_ack 	)
	,.buf_out_rden		( ep4_out_buf_rden		)
	
	,.buf_in_nump		( ep4_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep4_OUT.ENDPT_BURST = `ENDPT4_OUT_BURST ;
defparam usb3_ep4_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT5_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep5_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep5_buf_in_data 		)
	,.buf_in_wren		( ep5_buf_in_wren 		)
	,.buf_in_ready		( ep5_buf_in_ready 		)
	,.buf_in_commit		( ep5_buf_in_commit 	)
	,.buf_in_commit_len ( ep5_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )	
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep5_out_buf_data 		)
	,.buf_out_len		( ep5_out_buf_len 		)
	,.buf_out_hasdata	( ep5_out_buf_has_data 	)
	,.buf_out_arm		( ep5_out_buf_data_ack 	)
	,.buf_out_rden		( ep5_out_buf_rden		)
	
	,.buf_in_nump		( ep5_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep5_OUT.ENDPT_BURST = `ENDPT5_OUT_BURST ;
defparam usb3_ep5_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT6_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep6_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep6_buf_in_data 		)
	,.buf_in_wren		( ep6_buf_in_wren 		)
	,.buf_in_ready		( ep6_buf_in_ready 		)
	,.buf_in_commit		( ep6_buf_in_commit 	)
	,.buf_in_commit_len ( ep6_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )	
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep6_out_buf_data 		)
	,.buf_out_len		( ep6_out_buf_len 		)
	,.buf_out_hasdata	( ep6_out_buf_has_data 	)
	,.buf_out_arm		( ep6_out_buf_data_ack 	)
	,.buf_out_rden		( ep6_out_buf_rden		)
	
	,.buf_in_nump		( ep6_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep6_OUT.ENDPT_BURST = `ENDPT6_OUT_BURST ;
defparam usb3_ep6_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT7_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep7_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep7_buf_in_data 		)
	,.buf_in_wren		( ep7_buf_in_wren 		)
	,.buf_in_ready		( ep7_buf_in_ready 		)
	,.buf_in_commit		( ep7_buf_in_commit 	)
	,.buf_in_commit_len ( ep7_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep7_out_buf_data 		)
	,.buf_out_len		( ep7_out_buf_len 		)
	,.buf_out_hasdata	( ep7_out_buf_has_data 	)
	,.buf_out_arm		( ep7_out_buf_data_ack 	)
	,.buf_out_rden		( ep7_out_buf_rden		)
	
	,.buf_in_nump		( ep7_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep7_OUT.ENDPT_BURST = `ENDPT7_OUT_BURST ;
defparam usb3_ep7_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT8_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep8_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep8_buf_in_data 		)
	,.buf_in_wren		( ep8_buf_in_wren 		)
	,.buf_in_ready		( ep8_buf_in_ready 		)
	,.buf_in_commit		( ep8_buf_in_commit 	)
	,.buf_in_commit_len ( ep8_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )		
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep8_out_buf_data 		)
	,.buf_out_len		( ep8_out_buf_len 		)
	,.buf_out_hasdata	( ep8_out_buf_has_data 	)
	,.buf_out_arm		( ep8_out_buf_data_ack 	)
	,.buf_out_rden		( ep8_out_buf_rden		)
	
	,.buf_in_nump		( ep8_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep8_OUT.ENDPT_BURST = `ENDPT8_OUT_BURST ;
defparam usb3_ep8_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT9_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep9_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep9_buf_in_data 		)
	,.buf_in_wren		( ep9_buf_in_wren 		)
	,.buf_in_ready		( ep9_buf_in_ready 		)
	,.buf_in_commit		( ep9_buf_in_commit 	)
	,.buf_in_commit_len ( ep9_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )		
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep9_out_buf_data 		)
	,.buf_out_len		( ep9_out_buf_len 		)
	,.buf_out_hasdata	( ep9_out_buf_has_data 	)
	,.buf_out_arm		( ep9_out_buf_data_ack 	)
	,.buf_out_rden		( ep9_out_buf_rden		)
	
	,.buf_in_nump		( ep9_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep9_OUT.ENDPT_BURST = `ENDPT9_OUT_BURST ;
defparam usb3_ep9_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT10_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep10_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep10_buf_in_data 		)
	,.buf_in_wren		( ep10_buf_in_wren 		)
	,.buf_in_ready		( ep10_buf_in_ready 		)
	,.buf_in_commit		( ep10_buf_in_commit 	)
	,.buf_in_commit_len ( ep10_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )	
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep10_out_buf_data 		)
	,.buf_out_len		( ep10_out_buf_len 		)
	,.buf_out_hasdata	( ep10_out_buf_has_data 	)
	,.buf_out_arm		( ep10_out_buf_data_ack 	)
	,.buf_out_rden		( ep10_out_buf_rden		)
	
	,.buf_in_nump		( ep10_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep10_OUT.ENDPT_BURST = `ENDPT10_OUT_BURST ;
defparam usb3_ep10_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT11_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep11_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep11_buf_in_data 		)
	,.buf_in_wren		( ep11_buf_in_wren 		)
	,.buf_in_ready		( ep11_buf_in_ready 		)
	,.buf_in_commit		( ep11_buf_in_commit 	)
	,.buf_in_commit_len ( ep11_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )		
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep11_out_buf_data 		)
	,.buf_out_len		( ep11_out_buf_len 		)
	,.buf_out_hasdata	( ep11_out_buf_has_data 	)
	,.buf_out_arm		( ep11_out_buf_data_ack 	)
	,.buf_out_rden		( ep11_out_buf_rden		)
	
	,.buf_in_nump		( ep11_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep11_OUT.ENDPT_BURST = `ENDPT11_OUT_BURST ;
defparam usb3_ep11_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT12_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep12_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep12_buf_in_data 		)
	,.buf_in_wren		( ep12_buf_in_wren 		)
	,.buf_in_ready		( ep12_buf_in_ready 		)
	,.buf_in_commit		( ep12_buf_in_commit 	)
	,.buf_in_commit_len ( ep12_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )	
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep12_out_buf_data 		)
	,.buf_out_len		( ep12_out_buf_len 		)
	,.buf_out_hasdata	( ep12_out_buf_has_data 	)
	,.buf_out_arm		( ep12_out_buf_data_ack 	)
	,.buf_out_rden		( ep12_out_buf_rden		)
	
	,.buf_in_nump		( ep12_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep12_OUT.ENDPT_BURST = `ENDPT12_OUT_BURST ;
defparam usb3_ep12_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT13_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep13_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep13_buf_in_data 		)
	,.buf_in_wren		( ep13_buf_in_wren 		)
	,.buf_in_ready		( ep13_buf_in_ready 		)
	,.buf_in_commit		( ep13_buf_in_commit 	)
	,.buf_in_commit_len ( ep13_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )	
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep13_out_buf_data 		)
	,.buf_out_len		( ep13_out_buf_len 		)
	,.buf_out_hasdata	( ep13_out_buf_has_data 	)
	,.buf_out_arm		( ep13_out_buf_data_ack 	)
	,.buf_out_rden		( ep13_out_buf_rden		)
	
	,.buf_in_nump		( ep13_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep13_OUT.ENDPT_BURST = `ENDPT13_OUT_BURST ;
defparam usb3_ep13_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT14_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep14_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep14_buf_in_data 		)
	,.buf_in_wren		( ep14_buf_in_wren 		)
	,.buf_in_ready		( ep14_buf_in_ready 		)
	,.buf_in_commit		( ep14_buf_in_commit 	)
	,.buf_in_commit_len ( ep14_buf_in_commit_len )
	
	,.buf_out_dp_acked	( )	
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep14_out_buf_data 		)
	,.buf_out_len		( ep14_out_buf_len 		)
	,.buf_out_hasdata	( ep14_out_buf_has_data 	)
	,.buf_out_arm		( ep14_out_buf_data_ack 	)
	,.buf_out_rden		( ep14_out_buf_rden		)
	
	,.buf_in_nump		( ep14_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
	
);
defparam usb3_ep14_OUT.ENDPT_BURST = `ENDPT14_OUT_BURST ;
defparam usb3_ep14_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif

`ifdef ENDPT15_OUT
`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep15_OUT (
	 .clk 				(local_clk)
	,.rst_n             (reset_n)


	,.buf_in_data		( ep15_buf_in_data 		 )
	,.buf_in_wren		( ep15_buf_in_wren 		 )
	,.buf_in_ready		( ep15_buf_in_ready 	 )
	,.buf_in_commit		( ep15_buf_in_commit 	 )
	,.buf_in_commit_len ( ep15_buf_in_commit_len )
	
	
	,.buf_out_dp_acked	( )	
	,.in_ep_rty			(  )		
	
	,.buf_out_q			( ep15_out_buf_data 		)
	,.buf_out_len		( ep15_out_buf_len 			)
	,.buf_out_hasdata	( ep15_out_buf_has_data 	)
	,.buf_out_arm		( ep15_out_buf_data_ack 	)
	,.buf_out_rden		( ep15_out_buf_rden			)	
	
	,.buf_in_nump		( ep15_buf_in_nump)
	,.buf_out_eob		( )
	,.buf_out_nump		( )	
		
);
defparam usb3_ep15_OUT.ENDPT_BURST = `ENDPT15_OUT_BURST ;
defparam usb3_ep15_OUT.BUF_OUT_DP_ACKED_VAL   = 0 ;
`endif


//debug
//reg[31:0] rx_dph_cnt ;
//reg[31:0] rx_dph_len_cnt ;
//reg[31:0] ep2_ack_dp_cnt ;
//reg ep2_rx_dp ;
//reg tx_in_ep_NRDY ;
//always @ ( posedge  local_clk ) begin
//	if ( rx_dph && rx_dph_endp == 2 ) begin
//		rx_dph_cnt <= rx_dph_cnt + 1 ;
//		rx_dph_len_cnt <= rx_dph_len_cnt + rx_dph_len ;
//		ep2_rx_dp <= 1 ;
//	end
//	else begin
//		ep2_rx_dp <= 0 ;
//	end
//	if ( tx_state == TX_DP_NRDY ) begin
//		tx_in_ep_NRDY <= 1 ;
//	end
//	else begin
//		tx_in_ep_NRDY <= 0 ;
//	end
//	if ( rx_state == RX_DPH_2 && tx_tp_a_ack && tx_tp_a_endp == 2 ) begin
//		ep2_ack_dp_cnt <= ep2_ack_dp_cnt + 1 ;
//	end
//end


endmodule
