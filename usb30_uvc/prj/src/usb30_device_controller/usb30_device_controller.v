`include "usb3_macro_define.v"	

`ifdef SIM
module usb30_device_controller(
`else
module `getname(usb30_device_controller,`module_name)(
`endif


input	wire			phy_clk
,input	wire			reset_n


,input	wire	[31:0]	phy_pipe_rx_data
,input	wire	[3:0]	phy_pipe_rx_datak
,input	wire			phy_pipe_rx_valid
,output	wire	[31:0]	phy_pipe_tx_data
,output	wire	[3:0]	phy_pipe_tx_datak

,output	wire			phy_reset_n
,output	wire			phy_tx_detrx_lpbk
,output	wire			phy_tx_elecidle
,input	wire			phy_rx_elecidle
,input	wire	[2:0]	phy_rx_status
,output	wire	[1:0]	phy_power_down
,input   wire			phy_phy_status
,input	wire			phy_pwrpresent

,output	wire			phy_tx_oneszeros
,output	wire	[1:0]	phy_tx_deemph
,output	wire	[2:0]	phy_tx_margin
,output	wire			phy_tx_swing
,output	wire			phy_rx_polarity
,output	wire			phy_rx_termination
,output	wire			phy_rate
,output	wire			phy_elas_buf_mode



,output wire 	warm_or_hot_reset 
,output wire 	itp_recieved 
,output reg		attached 

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
,input	wire			ep1_in_buf_eob
`endif	

`ifdef ENDPT2_IN 
,input	wire	[31:0]	ep2_in_buf_data
,input	wire			ep2_in_buf_wren
,output	wire			ep2_in_buf_ready
,input	wire			ep2_in_buf_data_commit 	
,input	wire	[10:0]	ep2_in_buf_data_commit_len	
,input	wire			ep2_in_buf_eob
`endif	

`ifdef ENDPT3_IN 
,input	wire	[31:0]	ep3_in_buf_data
,input	wire			ep3_in_buf_wren
,output	wire			ep3_in_buf_ready
,input	wire			ep3_in_buf_data_commit 	
,input	wire	[10:0]	ep3_in_buf_data_commit_len	
,input	wire			ep3_in_buf_eob
`endif	

`ifdef ENDPT4_IN 
,input	wire	[31:0]	ep4_in_buf_data
,input	wire			ep4_in_buf_wren
,output	wire			ep4_in_buf_ready
,input	wire			ep4_in_buf_data_commit 	
,input	wire	[10:0]	ep4_in_buf_data_commit_len	
,input	wire			ep4_in_buf_eob
`endif

`ifdef ENDPT5_IN 
,input	wire	[31:0]	ep5_in_buf_data
,input	wire			ep5_in_buf_wren
,output	wire			ep5_in_buf_ready
,input	wire			ep5_in_buf_data_commit 	
,input	wire	[10:0]	ep5_in_buf_data_commit_len	
,input	wire			ep5_in_buf_eob
`endif	

`ifdef ENDPT6_IN 
,input	wire	[31:0]	ep6_in_buf_data
,input	wire			ep6_in_buf_wren
,output	wire			ep6_in_buf_ready
,input	wire			ep6_in_buf_data_commit 	
,input	wire	[10:0]	ep6_in_buf_data_commit_len	
,input	wire			ep6_in_buf_eob
`endif	

`ifdef ENDPT7_IN 
,input	wire	[31:0]	ep7_in_buf_data
,input	wire			ep7_in_buf_wren
,output	wire			ep7_in_buf_ready
,input	wire			ep7_in_buf_data_commit 	
,input	wire	[10:0]	ep7_in_buf_data_commit_len
,input	wire			ep7_in_buf_eob	
`endif	

`ifdef ENDPT8_IN 
,input	wire	[31:0]	ep8_in_buf_data
,input	wire			ep8_in_buf_wren
,output	wire			ep8_in_buf_ready
,input	wire			ep8_in_buf_data_commit 	
,input	wire	[10:0]	ep8_in_buf_data_commit_len	
,input	wire			ep8_in_buf_eob
`endif	

`ifdef ENDPT9_IN 
,input	wire	[31:0]	ep9_in_buf_data
,input	wire			ep9_in_buf_wren
,output	wire			ep9_in_buf_ready
,input	wire			ep9_in_buf_data_commit 	
,input	wire	[10:0]	ep9_in_buf_data_commit_len	
,input	wire			ep9_in_buf_eob
`endif	

`ifdef ENDPT10_IN 
,input	wire	[31:0]	ep10_in_buf_data
,input	wire			ep10_in_buf_wren
,output	wire			ep10_in_buf_ready
,input	wire			ep10_in_buf_data_commit 	
,input	wire	[10:0]	ep10_in_buf_data_commit_len
,input	wire			ep10_in_buf_eob
`endif	

`ifdef ENDPT11_IN 
,input	wire	[31:0]	ep11_in_buf_data
,input	wire			ep11_in_buf_wren
,output	wire			ep11_in_buf_ready
,input	wire			ep11_in_buf_data_commit 	
,input	wire	[10:0]	ep11_in_buf_data_commit_len	
,input	wire			ep11_in_buf_eob
`endif		

`ifdef ENDPT12_IN 
,input	wire	[31:0]	ep12_in_buf_data
,input	wire			ep12_in_buf_wren
,output	wire			ep12_in_buf_ready
,input	wire			ep12_in_buf_data_commit 	
,input	wire	[10:0]	ep12_in_buf_data_commit_len
,input	wire			ep12_in_buf_eob
`endif		

`ifdef ENDPT13_IN 
,input	wire	[31:0]	ep13_in_buf_data
,input	wire			ep13_in_buf_wren
,output	wire			ep13_in_buf_ready
,input	wire			ep13_in_buf_data_commit 	
,input	wire	[10:0]	ep13_in_buf_data_commit_len	
,input	wire			ep13_in_buf_eob
`endif		

`ifdef ENDPT14_IN 
,input	wire	[31:0]	ep14_in_buf_data
,input	wire			ep14_in_buf_wren
,output	wire			ep14_in_buf_ready
,input	wire			ep14_in_buf_data_commit 	
,input	wire	[10:0]	ep14_in_buf_data_commit_len
,input	wire			ep14_in_buf_eob
`endif		

`ifdef ENDPT15_IN 
,input	wire	[31:0]	ep15_in_buf_data
,input	wire			ep15_in_buf_wren
,output	wire			ep15_in_buf_ready
,input	wire			ep15_in_buf_data_commit 	
,input	wire	[10:0]	ep15_in_buf_data_commit_len	
,input	wire			ep15_in_buf_eob
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

assign phy_pipe_half_clk      		= phy_clk ;
assign phy_pipe_half_clk_phase 		= phy_clk ;
assign phy_pipe_quarter_clk    		= phy_clk ;
assign ext_clk = phy_clk ;





	wire set_device_low_power_state ;
	wire set_device_low_power_state_ack ;

	reg 			reset_1, reset_2;				// local reset
	wire			local_reset		= reset_n & phy_pwrpresent;

	

	wire	[4:0]	ltssm_state;
	wire			port_rx_term;
	wire			port_tx_detrx_lpbk;
	wire			port_tx_elecidle;

	wire	[1:0]	port_power_down;
	wire			port_power_go;
	wire			port_power_ack;
	wire			port_power_err;
	wire			ltssm_hot_reset;

	wire			ltssm_training;
	wire			ltssm_train_rxeq;
	wire			ltssm_train_rxeq_pass;
	wire			ltssm_train_active;
	wire			ltssm_train_ts1;
	wire			ltssm_train_ts2;
	wire			ltssm_train_config;
	wire			ltssm_train_idle;
	wire			ltssm_train_idle_pass;

	wire			partner_detect;
	wire			partner_looking;
	wire			partner_detected;

	wire			lfps_recv_active;
	wire			lfps_recv_poll_u1;
	wire			lfps_recv_ping;
	wire			lfps_recv_reset;
	wire			lfps_recv_u2lb;
	wire			lfps_recv_u3;

	wire			ltssm_warm_reset;

	

	wire		[31:0]	link_in_data;
	wire		[3:0]	link_in_datak;
	wire				link_in_active;
	wire		[31:0]	link_out_data;
	wire		[3:0]	link_out_datak;
	wire				link_out_active;
	wire				link_out_stall;
	wire				ltssm_go_disabled;
	wire				ltssm_go_recovery;
	wire		[2:0]	ltssm_go_u;
	
	wire [6:0] dev_address ;

	//wire	[31:0]	prot_in_data;
	//wire	[3:0]	prot_in_datak;
	//wire			prot_in_active;

	wire	[1:0]	prot_endp_mode_rx;
	wire	[1:0]	prot_endp_mode_tx;
	wire	[6:0]	prot_dev_addr;



	wire			prot_rx_tp;
	wire			prot_rx_tp_hosterr;
	wire			prot_rx_tp_retry;
	wire			prot_rx_tp_pktpend;
	wire	[3:0]	prot_rx_tp_subtype;
	wire	[3:0]	prot_rx_tp_endp;
	wire	[4:0]	prot_rx_tp_nump;
	wire	[4:0]	prot_rx_tp_seq;
	wire	[15:0]	prot_rx_tp_stream;

	wire			prot_rx_dph;
	wire			prot_rx_dph_eob;
	wire			prot_rx_dph_setup;
	wire			prot_rx_dph_pktpend;
	wire	[3:0]	prot_rx_dph_endp;
	wire	[4:0]	prot_rx_dph_seq;
	wire	[15:0]	prot_rx_dph_len;
	wire			prot_rx_dpp_start;
	wire			prot_rx_dpp_done;
	wire			prot_rx_dpp_crcgood;

	wire			prot_tx_tp_a;
	wire			prot_tx_tp_a_retry;
	wire			prot_tx_tp_a_dir;
	wire	[3:0]	prot_tx_tp_a_subtype;
	wire	[3:0]	prot_tx_tp_a_endp;
	wire	[4:0]	prot_tx_tp_a_nump;
	wire	[4:0]	prot_tx_tp_a_seq;
	wire	[15:0]	prot_tx_tp_a_stream;
	wire			prot_tx_tp_a_ack;

	wire			prot_tx_tp_b;
	wire			prot_tx_tp_b_retry;
	wire			prot_tx_tp_b_dir;
	wire	[3:0]	prot_tx_tp_b_subtype;
	wire	[3:0]	prot_tx_tp_b_endp;
	wire	[4:0]	prot_tx_tp_b_nump;
	wire	[4:0]	prot_tx_tp_b_seq;
	wire	[15:0]	prot_tx_tp_b_stream;
	wire			prot_tx_tp_b_ack;

	wire			prot_tx_tp_c;
	wire			prot_tx_tp_c_retry;
	wire			prot_tx_tp_c_dir;
	wire	[3:0]	prot_tx_tp_c_subtype;
	wire	[3:0]	prot_tx_tp_c_endp;
	wire	[4:0]	prot_tx_tp_c_nump;
	wire	[4:0]	prot_tx_tp_c_seq;
	wire	[15:0]	prot_tx_tp_c_stream;
	wire			prot_tx_tp_c_ack;

	wire			prot_tx_dph;
	wire			prot_tx_dph_eob;
	wire			prot_tx_dph_dir;
	wire	[3:0]	prot_tx_dph_endp;
	wire	[4:0]	prot_tx_dph_seq;
	wire	[15:0]	prot_tx_dph_len;
	wire			prot_tx_dpp_ack;
	wire			prot_tx_dpp_done;
	wire			prot_tx_dph_iso_0;


	wire	[9:0]	prot_buf_in_addr;
	wire	[31:0]	prot_buf_in_data;
	wire			prot_buf_in_wren;
	wire			prot_buf_in_ready;
	wire			prot_buf_in_commit;
	wire	[10:0]	prot_buf_in_commit_len;
	wire			prot_buf_in_commit_ack;

	wire	[9:0]	prot_buf_out_addr;
	wire	[31:0]	prot_buf_out_q;
	wire	[10:0]	prot_buf_out_len;
	wire			prot_buf_out_hasdata;
	wire			prot_buf_out_arm;
	wire			prot_buf_out_arm_ack;
	wire			prot_in_dpp_wasready ;
	


always @(posedge phy_pipe_half_clk ) begin

	// synchronize external reset to local domain
	{reset_2, reset_1} <= {reset_1, local_reset};

end

	assign			phy_reset_n = reset_n;			// TUSB1310A has minimum 1uS pulse width for RESET
													// responsibility of the toplevel module to supply this reset
													// NOTE: reset entire phy will cause loss of PLL lock
													// reset the PHY along with all our core code if cable unplugged
	assign			phy_out_enable = 1'b1;

	wire	[1:0]	mux_tx_margin;

	parameter		XTAL_SEL			= 1'b0; 	// crystal input
	parameter		OSC_SEL				= 1'b1; 	// clock input
	parameter [2:0]	SSC_DIS				= 2'b11;	// spread spectrum clock disable
	parameter [2:0]	SSC_EN				= 2'b00;	// spread spectrum clock enable
	parameter		PIPE_16BIT			= 1'b0;		// sdr 16bit pipe interface
	// strap pins
//	assign			phy_rx_elecidle 	= reset_2 ? 1'bZ : XTAL_SEL;
	assign			phy_tx_margin	  	= reset_2 ? mux_tx_margin  : SSC_DIS;
	assign			phy_phy_status_o 	= reset_2 ? 1'bZ : PIPE_16BIT;

////////////////////////////////////////////////////////////
//
// USB 3.0 PIPE3 interface
//
////////////////////////////////////////////////////////////

	wire		ltssm_reset_n;
`ifdef SIM
usb3_pipe
`else
`getname(usb3_pipe,`module_name)
`endif
iu3p (

	.slow_clk				( phy_pipe_quarter_clk ),
	.local_clk				( phy_pipe_half_clk ),
	.local_clk_capture		( phy_pipe_half_clk_phase ),
	.reset_n				( reset_2 ),
	.ltssm_reset_n			( ltssm_reset_n ),

	.phy_pipe_rx_data		( phy_pipe_rx_data ),
	.phy_pipe_rx_datak		( phy_pipe_rx_datak	 ),
	.phy_pipe_rx_valid		( {phy_pipe_rx_valid,phy_pipe_rx_valid} ),
	.phy_pipe_tx_data		( phy_pipe_tx_data ),
	.phy_pipe_tx_datak		( phy_pipe_tx_datak ),

	.phy_tx_detrx_lpbk		( phy_tx_detrx_lpbk ),
	.phy_tx_elecidle		( phy_tx_elecidle ),
	.phy_rx_elecidle		( phy_rx_elecidle ),
	.phy_rx_status			( {3'b000,phy_rx_status} ),
	.phy_power_down			( phy_power_down ),
	.phy_phy_status			( {1'b0,phy_phy_status} ),
	.phy_pwrpresent			( phy_pwrpresent ),

	.phy_tx_oneszeros		( phy_tx_oneszeros ),
	.phy_tx_deemph			( phy_tx_deemph ),
	.phy_tx_margin			( mux_tx_margin ),
	.phy_tx_swing			( phy_tx_swing ),
	.phy_rx_polarity		( phy_rx_polarity ),
	.phy_rx_termination		( phy_rx_termination ),
	.phy_rate				( phy_rate ),
	.phy_elas_buf_mode		( phy_elas_buf_mode ),

	.link_in_data			( link_in_data ),
	.link_in_datak			( link_in_datak ),
	.link_in_active			( link_in_active ),
	.link_out_data			( link_out_data ),
	.link_out_datak			( link_out_datak ),
	.link_out_active		( link_out_active ),
	.link_out_stall			( link_out_stall ),

	.partner_detect			( partner_detect ),
	.partner_looking		( partner_looking ),
	.partner_detected		( partner_detected ),

	.ltssm_tx_detrx_lpbk	( port_tx_detrx_lpbk ),
	.ltssm_tx_elecidle		( port_tx_elecidle ),
	.ltssm_power_down		( port_power_down ),
	.ltssm_power_go			( port_power_go ),
	.ltssm_power_ack		( port_power_ack ),
	.ltssm_hot_reset		( ltssm_hot_reset ),

	.ltssm_state				( ltssm_state ),
	.ltssm_training				( ltssm_training ),
	.ltssm_train_rxeq			( ltssm_train_rxeq ),
	.ltssm_train_rxeq_pass		( ltssm_train_rxeq_pass ),
	.ltssm_train_active			( ltssm_train_active ),
	.ltssm_train_ts1			( ltssm_train_ts1 ),
	.ltssm_train_ts2			( ltssm_train_ts2 ),
	.ltssm_train_config			( ltssm_train_config ),
	.ltssm_train_idle			( ltssm_train_idle ),
	.ltssm_train_idle_pass		( ltssm_train_idle_pass ),

	.lfps_recv_active		( lfps_recv_active ),
	.lfps_recv_poll_u1		( lfps_recv_poll_u1 ),
	.lfps_recv_ping			( lfps_recv_ping ),
	.lfps_recv_reset		( lfps_recv_reset ),
	.lfps_recv_u2lb			( lfps_recv_u2lb ),
	.lfps_recv_u3			( lfps_recv_u3 ),
	.dbg_state              (  ),
	.link_out_skp_inhibit	(0),
	.link_out_skp_defer     (0),
	.ltssm_power_err        ()
	
);

////////////////////////////////////////////////////////////
//
// USB 3.0 LTSSM, LFPS
//
////////////////////////////////////////////////////////////
`ifdef SIM
usb3_ltssm_device
`else
`getname(usb3_ltssm_device,`module_name)
`endif
iu3lt (

	.slow_clk				( phy_pipe_quarter_clk ),
	.local_clk				( phy_pipe_half_clk ),
	.reset_n				( ltssm_reset_n ),

	// inputs
	.vbus_present			( phy_pwrpresent ),
	.port_rx_valid			( phy_pipe_rx_valid ),	// these signals are in the 250mhz source
	.port_rx_elecidle		( phy_rx_elecidle ),	// domain, but no problem for lfps in 62.5mhz
	.partner_looking		( partner_looking ),
	.partner_detected		( partner_detected ),
	.port_power_state		( phy_power_down ),		// reflect actual value driven by PIPE pd_fsm
	.port_power_ack			( port_power_ack ),
	.port_power_err			( 0 ),

	.train_rxeq_pass		( ltssm_train_rxeq_pass ),
	.train_idle_pass		( ltssm_train_idle_pass ),
	.train_ts1				( ltssm_train_ts1 ),
	.train_ts2				( ltssm_train_ts2 ),
	.go_disabled			( ltssm_go_disabled ),
	.go_recovery			( ltssm_go_recovery ),
	.go_u					( ltssm_go_u ),
	.hot_reset				( ltssm_hot_reset ),

	// outputs
	.ltssm_state			( ltssm_state ),
	.port_rx_term			( port_rx_term ),
	.port_tx_detrx_lpbk		( port_tx_detrx_lpbk ),
	.port_tx_elecidle		( port_tx_elecidle ),
	.port_power_down		( port_power_down ),
	.port_power_go			( port_power_go ),
	.partner_detect			( partner_detect ),

	.training				( ltssm_training ),
	.train_rxeq				( ltssm_train_rxeq ),
	.train_active			( ltssm_train_active ),
	.train_config			( ltssm_train_config ),
	.train_idle				( ltssm_train_idle ),

	.lfps_recv_active		( lfps_recv_active ),
	.lfps_recv_poll_u1		( lfps_recv_poll_u1 ),
	.lfps_recv_ping			( lfps_recv_ping ),
	.lfps_recv_reset		( lfps_recv_reset ),
	.lfps_recv_u2lb			( lfps_recv_u2lb ),
	.lfps_recv_u3			( lfps_recv_u3 ),

	.warm_reset				( ltssm_warm_reset ),
	.dbg_state              (  ),
	
	.lfps_send_ack			(),	
	.lfps_send_poll         (0),
	.lfps_send_ping         (0),
	.lfps_send_u1           (0),
	.lfps_send_u2lb         (0),
	.lfps_send_u3           (0)
	
);


always @ ( posedge phy_pipe_half_clk or negedge reset_2 ) begin
	if ( !reset_2 ) begin
		attached <= 0 ;
	end
	else if ( ltssm_state == 9 || ltssm_state == 8 ) begin
		attached <= 0 ;
	end	
	else begin
		attached <= 1 ;
	end
end




////////////////////////////////////////////////////////////
//
// USB 3.0 Link layer interface
//
////////////////////////////////////////////////////////////
`ifdef SIM
usb3_link
`else
`getname(usb3_link,`module_name)
`endif 
iu3l (

 	.local_clk				( phy_pipe_half_clk ),
 	.reset_n				( reset_2  ),

 	.ltssm_state			( ltssm_state ),
 	.ltssm_hot_reset		( ltssm_hot_reset ),
 	.ltssm_go_disabled		( ltssm_go_disabled ),
 	.ltssm_go_recovery		( ltssm_go_recovery ),
 	.ltssm_go_u				( ltssm_go_u),
 	.in_data				( link_in_data ),
 	.in_datak				( link_in_datak ),
 	.in_active				( link_in_active ),

 	.outp_data				( link_out_data ),
 	.outp_datak				( link_out_datak ),
 	.outp_active			( link_out_active ),
 	.out_stall				( link_out_stall ),

 	.endp_mode_rx			( prot_endp_mode_rx ),
 	.endp_mode_tx			( prot_endp_mode_tx ),
	.set_device_low_power_state	(1'b0),
	.set_device_low_power_state_ack	( set_device_low_power_state_ack ) ,
	
	.itp_recieved ( itp_recieved ),


 	.prot_rx_tp				( prot_rx_tp ),
 	.prot_rx_tp_hosterr		( prot_rx_tp_hosterr ),
 	.prot_rx_tp_retry		( prot_rx_tp_retry ),
 	.prot_rx_tp_pktpend		( prot_rx_tp_pktpend ),
 	.prot_rx_tp_subtype		( prot_rx_tp_subtype ),
 	.prot_rx_tp_endp		( prot_rx_tp_endp ),
 	.prot_rx_tp_nump		( prot_rx_tp_nump ),
 	.prot_rx_tp_seq			( prot_rx_tp_seq ),
 	.prot_rx_tp_stream		( prot_rx_tp_stream ),

 	.prot_rx_dph			( prot_rx_dph ),
 	.prot_rx_dph_eob		( prot_rx_dph_eob ),
 	.prot_rx_dph_setup		( prot_rx_dph_setup ),
 	.prot_rx_dph_pktpend	( prot_rx_dph_pktpend ),
 	.prot_rx_dph_endp		( prot_rx_dph_endp ),
 	.prot_rx_dph_seq		( prot_rx_dph_seq ),
 	.prot_rx_dph_len		( prot_rx_dph_len ),
 	.prot_rx_dpp_start		( prot_rx_dpp_start ),
 	.prot_rx_dpp_done		( prot_rx_dpp_done ),
 	.prot_rx_dpp_crcgood	( prot_rx_dpp_crcgood ),
	.prot_in_dpp_wasready	( prot_in_dpp_wasready ),

 	.prot_tx_tp_a			( prot_tx_tp_a ),
 	.prot_tx_tp_a_retry		( prot_tx_tp_a_retry ),
 	.prot_tx_tp_a_dir		( prot_tx_tp_a_dir ),
 	.prot_tx_tp_a_subtype	( prot_tx_tp_a_subtype ),
 	.prot_tx_tp_a_endp		( prot_tx_tp_a_endp ),
 	.prot_tx_tp_a_nump		( prot_tx_tp_a_nump ),
 	.prot_tx_tp_a_seq		( prot_tx_tp_a_seq ),
 	.prot_tx_tp_a_stream	( prot_tx_tp_a_stream ),
 	.prot_tx_tp_a_ack		( prot_tx_tp_a_ack ),

 	.prot_tx_tp_b			( prot_tx_tp_b ),
 	.prot_tx_tp_b_retry		( prot_tx_tp_b_retry ),
 	.prot_tx_tp_b_dir		( prot_tx_tp_b_dir ),
 	.prot_tx_tp_b_subtype	( prot_tx_tp_b_subtype ),
 	.prot_tx_tp_b_endp		( prot_tx_tp_b_endp ),
 	.prot_tx_tp_b_nump		( prot_tx_tp_b_nump ),
 	.prot_tx_tp_b_seq		( prot_tx_tp_b_seq ),
 	.prot_tx_tp_b_stream	( prot_tx_tp_b_stream ),
 	.prot_tx_tp_b_ack		( prot_tx_tp_b_ack ),

 	.prot_tx_tp_c			( prot_tx_tp_c ),
 	.prot_tx_tp_c_retry		( prot_tx_tp_c_retry ),
 	.prot_tx_tp_c_dir		( prot_tx_tp_c_dir ),
 	.prot_tx_tp_c_subtype	( prot_tx_tp_c_subtype ),
 	.prot_tx_tp_c_endp		( prot_tx_tp_c_endp ),
 	.prot_tx_tp_c_nump		( prot_tx_tp_c_nump ),
 	.prot_tx_tp_c_seq		( prot_tx_tp_c_seq ),
 	.prot_tx_tp_c_stream	( prot_tx_tp_c_stream ),
 	.prot_tx_tp_c_ack		( prot_tx_tp_c_ack ),

 	.prot_tx_dph			( prot_tx_dph ),
 	.prot_tx_dph_eob		( prot_tx_dph_eob ),
 	.prot_tx_dph_dir		( prot_tx_dph_dir ),
 	.prot_tx_dph_endp		( prot_tx_dph_endp ),
 	.prot_tx_dph_seq		( prot_tx_dph_seq ),
 	.prot_tx_dph_len		( prot_tx_dph_len ),
 	.prot_tx_dpp_ack		( prot_tx_dpp_ack ),
 	.prot_tx_dpp_done		( prot_tx_dpp_done ),
	.prot_tx_dph_iso_0		( prot_tx_dph_iso_0),
	

 	.buf_in_addr			( prot_buf_in_addr ),
 	.buf_in_data			( prot_buf_in_data ),
 	.buf_in_wren			( prot_buf_in_wren ),
 	.buf_in_ready			( prot_buf_in_ready ),
 	.buf_in_commit			( prot_buf_in_commit ),
 	.buf_in_commit_len		( prot_buf_in_commit_len ),

 	.buf_out_addr			( prot_buf_out_addr ),
 	.buf_out_q				( prot_buf_out_q ),
 	.buf_out_len			( prot_buf_out_len ),
 	.buf_out_hasdata		( prot_buf_out_hasdata ),
 	.buf_out_arm			( prot_buf_out_arm ),
	.buf_out_rden			( prot_buf_out_rden),


 	// current device address, driven by endpoint 0
 	.dev_address			( dev_address )
	
 );



////////////////////////////////////////////////////////////
//
// USB 3.0 Protocol layer interface
//
////////////////////////////////////////////////////////////
`ifdef SIM
usb3_protocol
`else
`getname(usb3_protocol,`module_name)
`endif  
iu3r (

 	.local_clk				( phy_pipe_half_clk ),
 	.slow_clk				( phy_pipe_quarter_clk ),
 	.ext_clk				( ext_clk ),

 	.reset_n				( reset_2 & attached ),
 	.ltssm_state			( ltssm_state ),

 	// muxed endpoint signals
 	.endp_mode_rx			( prot_endp_mode_rx ),
 	.endp_mode_tx			( prot_endp_mode_tx ),
	.err_miss_rx			(),
	.err_miss_tx            (),
	.err_tp_subtype         (),
	.err_missed_dpp_start   (),
	.err_missed_dpp_done	(),




 	.rx_tp					( prot_rx_tp ),
 	.rx_tp_hosterr			( prot_rx_tp_hosterr ),
 	.rx_tp_retry			( prot_rx_tp_retry ),
 	.rx_tp_pktpend			( prot_rx_tp_pktpend ),
 	.rx_tp_subtype			( prot_rx_tp_subtype ),
 	.rx_tp_endp				( prot_rx_tp_endp ),
 	.rx_tp_nump				( prot_rx_tp_nump ),
 	.rx_tp_seq				( prot_rx_tp_seq ),
 	.rx_tp_stream			( prot_rx_tp_stream ),

 	.rx_dph					( prot_rx_dph ),
 	.rx_dph_eob				( prot_rx_dph_eob ),
 	.rx_dph_setup			( prot_rx_dph_setup ),
 	.rx_dph_pktpend			( prot_rx_dph_pktpend ),
 	.rx_dph_endp			( prot_rx_dph_endp ),
 	.rx_dph_seq				( prot_rx_dph_seq ),
 	.rx_dph_len				( prot_rx_dph_len ),
 	.rx_dpp_start			( prot_rx_dpp_start ),
 	.rx_dpp_done			( prot_rx_dpp_done ),
 	.rx_dpp_crcgood			( prot_rx_dpp_crcgood ),
	.rx_in_dpp_wasready     ( prot_in_dpp_wasready),

 	.tx_tp_a				( prot_tx_tp_a ),
 	.tx_tp_a_retry			( prot_tx_tp_a_retry ),
 	.tx_tp_a_dir			( prot_tx_tp_a_dir ),
 	.tx_tp_a_subtype		( prot_tx_tp_a_subtype ),
 	.tx_tp_a_endp			( prot_tx_tp_a_endp ),
 	.tx_tp_a_nump			( prot_tx_tp_a_nump ),
 	.tx_tp_a_seq			( prot_tx_tp_a_seq ),
 	.tx_tp_a_stream			( prot_tx_tp_a_stream ),
 	.tx_tp_a_ack			( prot_tx_tp_a_ack ),

 	.tx_tp_b				( prot_tx_tp_b ),
 	.tx_tp_b_retry			( prot_tx_tp_b_retry ),
 	.tx_tp_b_dir			( prot_tx_tp_b_dir ),
 	.tx_tp_b_subtype		( prot_tx_tp_b_subtype ),
 	.tx_tp_b_endp			( prot_tx_tp_b_endp ),
 	.tx_tp_b_nump			( prot_tx_tp_b_nump ),
 	.tx_tp_b_seq			( prot_tx_tp_b_seq ),
 	.tx_tp_b_stream			( prot_tx_tp_b_stream ),
 	.tx_tp_b_ack			( prot_tx_tp_b_ack ),

 	.tx_tp_c				( prot_tx_tp_c ),
 	.tx_tp_c_retry			( prot_tx_tp_c_retry ),
 	.tx_tp_c_dir			( prot_tx_tp_c_dir ),
 	.tx_tp_c_subtype		( prot_tx_tp_c_subtype ),
 	.tx_tp_c_endp			( prot_tx_tp_c_endp ),
 	.tx_tp_c_nump			( prot_tx_tp_c_nump ),
 	.tx_tp_c_seq			( prot_tx_tp_c_seq ),
 	.tx_tp_c_stream			( prot_tx_tp_c_stream ),
 	.tx_tp_c_ack			( prot_tx_tp_c_ack ),

 	.tx_dph					( prot_tx_dph ),
 	.tx_dph_eob				( prot_tx_dph_eob ),
 	.tx_dph_dir				( prot_tx_dph_dir ),
 	.tx_dph_endp			( prot_tx_dph_endp ),
 	.tx_dph_seq				( prot_tx_dph_seq ),
 	.tx_dph_len				( prot_tx_dph_len ),
 	.tx_dpp_ack				( prot_tx_dpp_ack ),
 	.tx_dpp_done			( prot_tx_dpp_done ),
	.tx_dph_iso_0			( prot_tx_dph_iso_0),
	

 	.buf_in_addr			( prot_buf_in_addr ),
 	.buf_in_data			( prot_buf_in_data ),
 	.buf_in_wren			( prot_buf_in_wren ),
 	.buf_in_ready			( prot_buf_in_ready ),
 	.buf_in_commit			( prot_buf_in_commit ),
 	.buf_in_commit_len		( prot_buf_in_commit_len ),


 	.buf_out_addr			( prot_buf_out_addr ),
 	.buf_out_q				( prot_buf_out_q ),
 	.buf_out_len			( prot_buf_out_len ),
 	.buf_out_hasdata		( prot_buf_out_hasdata ),
 	.buf_out_arm			( prot_buf_out_arm ),
    .buf_out_rden 			( prot_buf_out_rden ),
 	
	.dev_address 		(dev_address),
	.set_device_low_power_state	( set_device_low_power_state ) ,
	.set_device_low_power_state_ack	( set_device_low_power_state_ack ) ,
	
 	
	// external interface
	.warm_or_hot_reset	(warm_or_hot_reset)
	
	,.host_requests_data_from_endpt (host_requests_data_from_endpt )
	,.host_requests_endpt_num	    (host_requests_endpt_num	   )

	// requests 
	,.request_active 	(request_active	)
	,.bmRequestType		(bmRequestType	)
	,.bRequest			(bRequest		)
	,.wValue			(wValue			)
	,.wIndex			(wIndex			)
	,.wLength			(wLength		)
	
	// ep0 IN 	
	,.ep0_in_buf_data            (ep0_in_buf_data        )
	,.ep0_in_buf_wren            (ep0_in_buf_wren        )
	,.ep0_in_buf_ready           (ep0_in_buf_ready       )
	,.ep0_in_buf_data_commit 	      (ep0_in_buf_data_commit 	  )
	,.ep0_in_buf_data_commit_len      (ep0_in_buf_data_commit_len  )
	
	// ep0 OUT
	,.ep0_out_buf_data		 	(ep0_out_buf_data		)
	,.ep0_out_buf_len		    (ep0_out_buf_len		)
	,.ep0_out_buf_has_data	    (ep0_out_buf_has_data	)
	,.ep0_out_buf_data_ack	    (ep0_out_buf_data_ack	)
	,.ep0_out_buf_rden			(ep0_out_buf_rden 		)	

	`ifdef ENDPT1_IN 
	,.ep1_in_buf_data         		( ep1_in_buf_data 				)
	,.ep1_in_buf_wren         		( ep1_in_buf_wren 				)			
	,.ep1_in_buf_ready   			( ep1_in_buf_ready				)       	
	,.ep1_in_buf_data_commit 			( ep1_in_buf_data_commit 			)
	,.ep1_in_buf_data_commit_len  		( ep1_in_buf_data_commit_len 		)
	,.ep1_in_buf_eob					(ep1_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT2_IN 
	,.ep2_in_buf_data				(ep2_in_buf_data			)
	,.ep2_in_buf_wren               (ep2_in_buf_wren           )
	,.ep2_in_buf_ready              (ep2_in_buf_ready          )
	,.ep2_in_buf_data_commit        (ep2_in_buf_data_commit 	)
	,.ep2_in_buf_data_commit_len    (ep2_in_buf_data_commit_len)
	,.ep2_in_buf_eob				(ep2_in_buf_eob)
	`endif	
	
	`ifdef ENDPT3_IN 
	,.ep3_in_buf_data				(ep3_in_buf_data			)
	,.ep3_in_buf_wren               (ep3_in_buf_wren           )
	,.ep3_in_buf_ready              (ep3_in_buf_ready          )
	,.ep3_in_buf_data_commit        (ep3_in_buf_data_commit 	)
	,.ep3_in_buf_data_commit_len    (ep3_in_buf_data_commit_len)
	,.ep3_in_buf_eob				(ep3_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT4_IN 	
	,.ep4_in_buf_data					(ep4_in_buf_data			)	
	,.ep4_in_buf_wren                   (ep4_in_buf_wren            )
	,.ep4_in_buf_ready                  (ep4_in_buf_ready           )
	,.ep4_in_buf_data_commit            (ep4_in_buf_data_commit 	 )
	,.ep4_in_buf_data_commit_len        (ep4_in_buf_data_commit_len )
	,.ep4_in_buf_eob					(ep4_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT5_IN 
	,.ep5_in_buf_data					(ep5_in_buf_data			)
	,.ep5_in_buf_wren                   (ep5_in_buf_wren           )
	,.ep5_in_buf_ready                  (ep5_in_buf_ready          )
	,.ep5_in_buf_data_commit            (ep5_in_buf_data_commit    )
	,.ep5_in_buf_data_commit_len        (ep5_in_buf_data_commit_len)
	,.ep5_in_buf_eob					(ep5_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT6_IN 
	,.ep6_in_buf_data					 (ep6_in_buf_data			)
	,.ep6_in_buf_wren                    (ep6_in_buf_wren           )
	,.ep6_in_buf_ready                   (ep6_in_buf_ready          )
	,.ep6_in_buf_data_commit             (ep6_in_buf_data_commit    )
	,.ep6_in_buf_data_commit_len         (ep6_in_buf_data_commit_len)
	,.ep6_in_buf_eob					 (ep6_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT7_IN 
	,.ep7_in_buf_data					 (ep7_in_buf_data			)
	,.ep7_in_buf_wren                    (ep7_in_buf_wren           )
	,.ep7_in_buf_ready                   (ep7_in_buf_ready          )
	,.ep7_in_buf_data_commit             (ep7_in_buf_data_commit    )
	,.ep7_in_buf_data_commit_len         (ep7_in_buf_data_commit_len)
	,.ep7_in_buf_eob					 (ep7_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT8_IN 
	,.ep8_in_buf_data						(ep8_in_buf_data)
	,.ep8_in_buf_wren                       (ep8_in_buf_wren)
	,.ep8_in_buf_ready                      (ep8_in_buf_ready)
	,.ep8_in_buf_data_commit                (ep8_in_buf_data_commit)
	,.ep8_in_buf_data_commit_len            (ep8_in_buf_data_commit_len)
	,.ep8_in_buf_eob						(ep8_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT9_IN 
	,.ep9_in_buf_data						(ep9_in_buf_data)
	,.ep9_in_buf_wren                       (ep9_in_buf_wren)
	,.ep9_in_buf_ready                      (ep9_in_buf_ready)
	,.ep9_in_buf_data_commit                (ep9_in_buf_data_commit)
	,.ep9_in_buf_data_commit_len            (ep9_in_buf_data_commit_len)
	,.ep9_in_buf_eob						(ep9_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT10_IN 
	,.ep10_in_buf_data						(ep10_in_buf_data			)
	,.ep10_in_buf_wren                      (ep10_in_buf_wren           )
	,.ep10_in_buf_ready                     (ep10_in_buf_ready          )
	,.ep10_in_buf_data_commit               (ep10_in_buf_data_commit    )
	,.ep10_in_buf_data_commit_len           (ep10_in_buf_data_commit_len)
	,.ep10_in_buf_eob						(ep10_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT11_IN 
	,.ep11_in_buf_data						(ep11_in_buf_data			)
	,.ep11_in_buf_wren                      (ep11_in_buf_wren           )
	,.ep11_in_buf_ready                     (ep11_in_buf_ready          )
	,.ep11_in_buf_data_commit               (ep11_in_buf_data_commit    )
	,.ep11_in_buf_data_commit_len           (ep11_in_buf_data_commit_len)
	,.ep11_in_buf_eob						(ep11_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT12_IN 
	,.ep12_in_buf_data						(ep12_in_buf_data			)
	,.ep12_in_buf_wren                      (ep12_in_buf_wren           )
	,.ep12_in_buf_ready                     (ep12_in_buf_ready          )
	,.ep12_in_buf_data_commit               (ep12_in_buf_data_commit    )
	,.ep12_in_buf_data_commit_len           (ep12_in_buf_data_commit_len)
	,.ep12_in_buf_eob						(ep12_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT13_IN 
	,.ep13_in_buf_data						(ep13_in_buf_data			)
	,.ep13_in_buf_wren                      (ep13_in_buf_wren           )
	,.ep13_in_buf_ready                     (ep13_in_buf_ready          )
	,.ep13_in_buf_data_commit               (ep13_in_buf_data_commit    )
	,.ep13_in_buf_data_commit_len           (ep13_in_buf_data_commit_len)
	,.ep13_in_buf_eob						(ep13_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT14_IN 
	,.ep14_in_buf_data						(ep14_in_buf_data			)
	,.ep14_in_buf_wren                      (ep14_in_buf_wren           )
	,.ep14_in_buf_ready                     (ep14_in_buf_ready          )
	,.ep14_in_buf_data_commit               (ep14_in_buf_data_commit    )
	,.ep14_in_buf_data_commit_len           (ep14_in_buf_data_commit_len)
	,.ep14_in_buf_eob						(ep14_in_buf_eob)	
	`endif	
	
	`ifdef ENDPT15_IN 
	,.ep15_in_buf_data						(ep15_in_buf_data			)
	,.ep15_in_buf_wren                      (ep15_in_buf_wren           )
	,.ep15_in_buf_ready                     (ep15_in_buf_ready          )
	,.ep15_in_buf_data_commit               (ep15_in_buf_data_commit    )
	,.ep15_in_buf_data_commit_len           (ep15_in_buf_data_commit_len)
	,.ep15_in_buf_eob						(ep15_in_buf_eob)	
	`endif	
	

	`ifdef ENDPT1_OUT
	,.ep1_out_buf_data				(ep1_out_buf_data	   )
	,.ep1_out_buf_len           	(ep1_out_buf_len       )
	,.ep1_out_buf_has_data      	(ep1_out_buf_has_data  )
	,.ep1_out_buf_data_ack      			(ep1_out_buf_data_ack  )
	,.ep1_out_buf_rden				(ep1_out_buf_rden  	   )
	`endif
	
	`ifdef ENDPT2_OUT
	,.ep2_out_buf_data		 (ep2_out_buf_data		)
	,.ep2_out_buf_len        (ep2_out_buf_len       )
	,.ep2_out_buf_has_data   (ep2_out_buf_has_data  )
	,.ep2_out_buf_rden       (ep2_out_buf_rden      )
	,.ep2_out_buf_data_ack   (ep2_out_buf_data_ack  )
	`endif	
	
	`ifdef ENDPT3_OUT
	,.ep3_out_buf_data			(ep3_out_buf_data		)
	,.ep3_out_buf_len           (ep3_out_buf_len       )
	,.ep3_out_buf_has_data      (ep3_out_buf_has_data  )
	,.ep3_out_buf_rden          (ep3_out_buf_rden      )
	,.ep3_out_buf_data_ack      (ep3_out_buf_data_ack  )
	`endif

	`ifdef ENDPT4_OUT
	,.ep4_out_buf_data					(ep4_out_buf_data	   )
	,.ep4_out_buf_len                   (ep4_out_buf_len       )
	,.ep4_out_buf_has_data              (ep4_out_buf_has_data  )
	,.ep4_out_buf_rden                  (ep4_out_buf_rden      )
	,.ep4_out_buf_data_ack              (ep4_out_buf_data_ack  )
	`endif	

	`ifdef ENDPT5_OUT			
	,.ep5_out_buf_data					(ep5_out_buf_data	   )	
	,.ep5_out_buf_len                   (ep5_out_buf_len       )
	,.ep5_out_buf_has_data              (ep5_out_buf_has_data  )
	,.ep5_out_buf_rden                  (ep5_out_buf_rden      )
	,.ep5_out_buf_data_ack              (ep5_out_buf_data_ack  )
	`endif	

	`ifdef ENDPT6_OUT
	,.ep6_out_buf_data					 (ep6_out_buf_data		)
	,.ep6_out_buf_len                    (ep6_out_buf_len     )
	,.ep6_out_buf_has_data               (ep6_out_buf_has_data)
	,.ep6_out_buf_rden                   (ep6_out_buf_rden    )
	,.ep6_out_buf_data_ack               (ep6_out_buf_data_ack)
	`endif		
	
	`ifdef ENDPT7_OUT
	,.ep7_out_buf_data					  (ep7_out_buf_data)
	,.ep7_out_buf_len                     (ep7_out_buf_len)
	,.ep7_out_buf_has_data                (ep7_out_buf_has_data)
	,.ep7_out_buf_rden                    (ep7_out_buf_rden)
	,.ep7_out_buf_data_ack                (ep7_out_buf_data_ack)
	`endif		

	`ifdef ENDPT8_OUT
	,.ep8_out_buf_data						(ep8_out_buf_data)					
	,.ep8_out_buf_len                       (ep8_out_buf_len)
	,.ep8_out_buf_has_data                  (ep8_out_buf_has_data)
	,.ep8_out_buf_rden                      (ep8_out_buf_rden)
	,.ep8_out_buf_data_ack                  (ep8_out_buf_data_ack)
	`endif	
	
	`ifdef ENDPT9_OUT
	,.ep9_out_buf_data						(ep9_out_buf_data)			
	,.ep9_out_buf_len                       (ep9_out_buf_len)
	,.ep9_out_buf_has_data                  (ep9_out_buf_has_data)
	,.ep9_out_buf_rden                      (ep9_out_buf_rden)
	,.ep9_out_buf_data_ack                  (ep9_out_buf_data_ack)
	`endif
	
	`ifdef ENDPT10_OUT
	,.ep10_out_buf_data						(ep10_out_buf_data		)
	,.ep10_out_buf_len                      (ep10_out_buf_len      )
	,.ep10_out_buf_has_data                 (ep10_out_buf_has_data )
	,.ep10_out_buf_rden                     (ep10_out_buf_rden     )
	,.ep10_out_buf_data_ack                 (ep10_out_buf_data_ack )
	`endif		

	`ifdef ENDPT11_OUT
	,.ep11_out_buf_data						(ep11_out_buf_data		)
	,.ep11_out_buf_len                      (ep11_out_buf_len      )
	,.ep11_out_buf_has_data                 (ep11_out_buf_has_data )
	,.ep11_out_buf_rden                     (ep11_out_buf_rden     )
	,.ep11_out_buf_data_ack                 (ep11_out_buf_data_ack )
	`endif		

	`ifdef ENDPT12_OUT
	,.ep12_out_buf_data						(ep12_out_buf_data)
	,.ep12_out_buf_len                      (ep12_out_buf_len)
	,.ep12_out_buf_has_data                 (ep12_out_buf_has_data)
	,.ep12_out_buf_rden                     (ep12_out_buf_rden)
	,.ep12_out_buf_data_ack                 (ep12_out_buf_data_ack)
	`endif		

	`ifdef ENDPT13_OUT
	,.ep13_out_buf_data						(ep13_out_buf_data		)
	,.ep13_out_buf_len                      (ep13_out_buf_len      )
	,.ep13_out_buf_has_data                 (ep13_out_buf_has_data )
	,.ep13_out_buf_rden                     (ep13_out_buf_rden     )
	,.ep13_out_buf_data_ack                 (ep13_out_buf_data_ack )
	`endif		

	`ifdef ENDPT14_OUT
	,.ep14_out_buf_data						(ep14_out_buf_data		)
	,.ep14_out_buf_len                      (ep14_out_buf_len      )
	,.ep14_out_buf_has_data                 (ep14_out_buf_has_data )
	,.ep14_out_buf_rden                     (ep14_out_buf_rden     )
	,.ep14_out_buf_data_ack                 (ep14_out_buf_data_ack )
	`endif		

	`ifdef ENDPT15_OUT
	,.ep15_out_buf_data						(ep15_out_buf_data		   )
	,.ep15_out_buf_len                      (ep15_out_buf_len          )
	,.ep15_out_buf_has_data                 (ep15_out_buf_has_data     )
	,.ep15_out_buf_rden                     (ep15_out_buf_rden         )
	,.ep15_out_buf_data_ack                 (ep15_out_buf_data_ack     )
	`endif	
 );

endmodule
