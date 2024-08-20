`include "usb3_macro_define.v"	
`ifdef SIM
module usb3_link(
`else
module `getname(usb3_link,`module_name)(
`endif
input	wire			local_clk,
input	wire			reset_n,

input	wire	[4:0]	ltssm_state,
input	wire			ltssm_hot_reset,
output	reg				ltssm_go_disabled,
output	reg		[2:0]	ltssm_go_u,
output	reg				ltssm_go_recovery,

output reg 			itp_recieved, 

// pipe interface
input	wire	[31:0]	in_data,
input	wire	[3:0]	in_datak,
input	wire			in_active,

output	reg		[31:0]	outp_data,
output	reg		[3:0]	outp_datak,
output	reg				outp_active,
input	wire			out_stall,

// protocol interface
input	wire	[1:0]	endp_mode_rx,
input	wire	[1:0]	endp_mode_tx,
input 	wire    [6:0]   dev_address,
input 	wire 			set_device_low_power_state ,
output	reg				set_device_low_power_state_ack,

output	reg				prot_rx_tp,
output	reg				prot_rx_tp_hosterr,
output	reg				prot_rx_tp_retry,
output	reg				prot_rx_tp_pktpend,
output	reg		[3:0]	prot_rx_tp_subtype,
output	reg		[3:0]	prot_rx_tp_endp,
output	reg		[4:0]	prot_rx_tp_nump,
output	reg		[4:0]	prot_rx_tp_seq,
output	reg		[15:0]	prot_rx_tp_stream,

output	reg				prot_rx_dph,
output	reg				prot_rx_dph_eob,
output	reg				prot_rx_dph_setup,
output	reg				prot_rx_dph_pktpend,
output	reg		[3:0]	prot_rx_dph_endp,
output	reg		[4:0]	prot_rx_dph_seq,
output	reg		[15:0]	prot_rx_dph_len,
output	reg				prot_rx_dpp_start,
output	reg				prot_rx_dpp_done,
output	reg				prot_rx_dpp_crcgood,
output  reg				prot_in_dpp_wasready,

input	wire			prot_tx_tp_a,
input	wire			prot_tx_tp_a_retry,
input	wire			prot_tx_tp_a_dir,
input	wire	[3:0]	prot_tx_tp_a_subtype,
input	wire	[3:0]	prot_tx_tp_a_endp,
input	wire	[4:0]	prot_tx_tp_a_nump,
input	wire	[4:0]	prot_tx_tp_a_seq,
input	wire	[15:0]	prot_tx_tp_a_stream,
output	reg				prot_tx_tp_a_ack,

input	wire			prot_tx_tp_b,
input	wire			prot_tx_tp_b_retry,
input	wire			prot_tx_tp_b_dir,
input	wire	[3:0]	prot_tx_tp_b_subtype,
input	wire	[3:0]	prot_tx_tp_b_endp,
input	wire	[4:0]	prot_tx_tp_b_nump,
input	wire	[4:0]	prot_tx_tp_b_seq,
input	wire	[15:0]	prot_tx_tp_b_stream,
output	reg				prot_tx_tp_b_ack,

input	wire			prot_tx_tp_c,
input	wire			prot_tx_tp_c_retry,
input	wire			prot_tx_tp_c_dir,
input	wire	[3:0]	prot_tx_tp_c_subtype,
input	wire	[3:0]	prot_tx_tp_c_endp,
input	wire	[4:0]	prot_tx_tp_c_nump,
input	wire	[4:0]	prot_tx_tp_c_seq,
input	wire	[15:0]	prot_tx_tp_c_stream,
output	reg				prot_tx_tp_c_ack,

input	wire			prot_tx_dph,
input	wire			prot_tx_dph_eob,
input	wire			prot_tx_dph_dir,
input	wire	[3:0]	prot_tx_dph_endp,
input	wire	[4:0]	prot_tx_dph_seq,
input	wire	[15:0]	prot_tx_dph_len,
output	reg				prot_tx_dpp_ack,
output	reg				prot_tx_dpp_done,
input   wire			prot_tx_dph_iso_0,


output	reg		[9:0]	buf_in_addr,
output	reg		[31:0]	buf_in_data,
output	reg				buf_in_wren,
input	wire			buf_in_ready,
output	reg				buf_in_commit,
output	reg		[10:0]	buf_in_commit_len,


output	reg		[9:0]	buf_out_addr,
input	wire	[31:0]	buf_out_q,
input	wire	[10:0]	buf_out_len,
input	wire			buf_out_hasdata,
output	reg				buf_out_arm,
output  reg				buf_out_rden




);

`include "usb3_const.vh"	

reg [4:0] ltssm_state_d ;
reg [4:0] ltssm_state_d1 ;
reg  local_rx_cred_count_dec ;
reg [4:0] ltssm_current_state ;
reg [4:0] ltssm_last_state ;
reg	ltssm_state_change ;
reg	[7:0]	qc ;
reg	tx_lgood_act ;
reg	queue_send_u0_adv ;
reg	do_not_send_credit ;
reg	queue_send_u0_portcap ;
reg	tx_lcrd_act ;
reg [10:0] tx_lcrd ;
reg tx_lcrd_on_parsed_header ;
reg [1:0] rx_cred_idx_latch ;
reg [10:0] tx_lgood ;
reg [2:0] rx_hdr_seq_num ;
wire [2:0] rx_hdr_seq_num_dec = rx_hdr_seq_num - 1 ;
reg tx_lgood_on_rx_valid_header ;
reg send_port_cfg_resp ;
reg send_port_cfg_resp_ack ;
reg[31:0] tx_hp_word_0 ;
reg[31:0] tx_hp_word_1 ;
reg[31:0] tx_hp_word_2 ;
reg tx_hp_act ;
reg tx_hp_act_d ;
reg tx_hp_dph ;
reg [15:0] out_dpp_length ;
reg [31:0] out_data_1 ;
reg [31:0] out_data_1_d ;
reg [3:0] out_datak_1 ;
reg [3:0] out_datak_1_d ;
reg  out_active_1 ;
reg  out_active_1_d ;
reg [31:0] out_data_2 ;
reg [31:0] out_data_2_d ;
reg [3:0] out_datak_2 ;
reg [3:0] out_datak_2_d ;
reg  out_active_2 ;
reg  out_active_2_d ;
reg [31:0] out_data_3 ;
reg [31:0] out_data_3_d ;
reg [3:0] out_datak_3 ;
reg [3:0] out_datak_3_d ;
reg  out_active_3 ;
reg  out_active_3_d ;
reg	tx_link_busy ;
reg	tx_link_busy_d ;
reg	tx_link_busy_d2 ;
reg	tx_lcmd_req ;
reg	tx_lcmd_req_ack ;
reg	[10:0] tx_lcmd_latch ;
reg [10:0] crc_lcmd_in ;
wire [4:0] crc_lcmd_out ;
reg [2:0] remote_rx_cred_count ;
reg tx_hp_req ;
reg tx_hp_req_ack ;
reg tx_res_req_ack ;
reg [1:0] out_header_pkt_sel ;
reg [1:0] out_header_pkt_sel_latch ;
reg [95:0] out_header_pkt_a ;
reg [95:0] out_header_pkt_b ;
reg [95:0] out_header_pkt_c ;
reg [95:0] out_header_pkt_d ;
reg [95:0] in_header_pkt_latch ;
reg remote_rx_cred_count_dec ;
reg crc_hptx_rst ;
reg [31:0] crc_hptx_in ;
reg [10:0] crc_cw4_in ;
reg [10:0] out_header_cw ;
reg  tx_hp_retry ;
reg  [2:0] tx_hdr_seq_num ;
reg crc_dpptx_rst ;
reg [15:0] out_dpp_length_remain ;
wire [31:0] crc_dpptx32_out ;
wire [31:0] crc_dpptx24_out ;
wire [31:0] crc_dpptx16_out ;
wire [31:0] crc_dpptx8_out ;
wire	[31:0]	crc_dpptx_out = (out_dpp_length[1:0] == 0) ? (swap32(crc_dpptx32_out)) :
								(out_dpp_length[1:0] == 3) ? (swap32(crc_dpptx24_out)) :
								(out_dpp_length[1:0] == 2) ? (swap32(crc_dpptx16_out)) :
								(out_dpp_length[1:0] == 1) ? (swap32(crc_dpptx8_out)) : (swap32(crc_dpptx32_out));
reg [2:0] tx_sel ;								
reg [2:0] tx_sel_d ;								
reg [2:0] tx_sel_d_2 ;								
reg in_link_command_act ;
reg in_header_act ;
reg link_cmd_det ;
reg [31:0] in_link_command ;
reg u0_recovery_timeout_reset_on_rx_lcmd ;
reg u0_recovery_timeout_reset_on_rx_hp ;
reg hp_det ;
reg crc_hprx_rst ;
reg crc_hprx_en ;
reg [1:0] rx_cred_idx ;
reg [31:0] in_header_pkt_a0 ;
reg [31:0] in_header_pkt_a1 ;
reg [31:0] in_header_pkt_a2 ;
reg [31:0] in_header_pkt_b0 ;
reg [31:0] in_header_pkt_b1 ;
reg [31:0] in_header_pkt_b2 ;
reg [31:0] in_header_pkt_c0 ;
reg [31:0] in_header_pkt_c1 ;
reg [31:0] in_header_pkt_c2 ;
reg [31:0] in_header_pkt_d0 ;
reg [31:0] in_header_pkt_d1 ;
reg [31:0] in_header_pkt_d2 ;
reg [31:0] crc_hprx_in ;
reg hp1_det ;
reg hp2_det ;
reg hp3_det ;
reg [15:0] in_header_crc ;
reg [15:0] in_header_cw ;
wire [15:0] crc_hprx_out ;
reg dpp_act ;
reg in_dpp_wasready ;
reg buf_in_addr_rst ;
reg [15:0] in_dpp_length ;
reg [15:0] in_dpp_length_expect ;
reg dpp_act_mask ;
reg dpp_act_d ;
reg [31:0] crc_dpprx_in ;
wire [31:0] crc_dpprx32_out ;
reg dpp_crc_good ;
wire [31:0] crc_dpprx8_out ;
wire [31:0] crc_dpprx16_out ;
wire [31:0] crc_dpprx24_out ;
reg recv_u0_adv ;
reg [2:0]local_rx_cred_count ;
wire [4:0] crc_cw1_out ;
wire [4:0] crc_cw2_out ;
reg [10:0] in_link_command_latch ;
reg in_link_command_latch_act ;
reg [2:0] ack_tx_hdr_seq_num ;
reg pending_hp_timer_reset_on_rx_lgood ;
reg [1:0] tx_cred_idx ;
reg remote_rx_cred_count_inc ;
reg [1:0] lgo_latch ;
reg local_rx_cred_count_inc ;
reg hp_crc_good ;
reg in_header_pkt_latch_act ;
reg [1:0] recv_port_cmdcfg ;
reg [26:0] itp_value ;
reg pending_hp_timer_rst ;
reg credit_hp_timer_act ;
reg credit_hp_timer_rst ;
reg u0_recovery_timeout_act ;
reg u0_recovery_timeout_rst ;
reg port_config_timeout_act ;
reg u0l_timeout_act ;
reg u0l_timeout_rst ;
reg	[24:0]	pending_hp_timer;
reg	[24:0]	u0l_timeout;
reg	[24:0]	u0_recovery_timeout;
reg	[24:0]	u2_timeout;
reg	[24:0]	credit_hp_timer;
reg	[24:0]	T_PORT_U2_TIMEOUT;
reg	[24:0]	port_config_timeout;
reg	[31:0]	crc_dpptx_out_1;
reg pending_hp_timer_act ;
reg credit_hp_timer_reset_on_rx_lcrd ;
reg u2_timeout_act ;
reg u2_timeout_rst ;
reg ltssm_go_u2 ;
reg ltssm_go_u2_d ;
reg tx_lgood_pop ;
reg tx_lcrd_pop ;
reg tx_lup_pop ;
reg tx_lau_pop ;
reg tx_lgo_pop ;
reg tx_lpma_pop ;
reg tx_lbad_pop ;
reg tx_ltry_pop ;
reg tx_lpma_act ;
reg tx_lup_act ;
wire [4:0] crc_cw3_out ;
wire [31:0] crc_dpprx_q ;
wire [15:0] crc_hptx_out ;
wire [10:0]	tx_lgood_q ;
wire 		tx_lgood_empty ;
wire [10:0]	tx_lcrd_q ;
wire 		tx_lcrd_empty ;
wire 		tx_lau_empty ;
wire 		tx_lgo_empty ;
wire 		tx_lpma_empty ;
wire 		tx_lbad_empty ;
wire 		tx_ltry_empty ;
wire [10:0]	tx_lup_q ;
wire [10:0]	tx_lau_q ;
wire [10:0]	tx_lgo_q ;
wire [10:0]	tx_lpma_q ;
wire [10:0]	tx_lbad_q ;
wire [10:0]	tx_ltry_q ;
wire 		tx_lup_empty ;
wire [4:0]  crc_cw4_out ;
wire [31:0] crc_dpptx_q ;
reg [31:0] in_data_1 ;
reg [31:0] in_data_2 ;
reg [31:0] in_data_3 ;
reg [31:0] in_data_4 ;
reg [3:0] in_datak_1 ;
reg [3:0] in_datak_2 ;
reg [3:0] in_datak_3 ;
reg [3:0] in_datak_4 ;
reg  in_active_1 ;
reg  in_active_2 ;
reg  in_active_3 ;
reg  in_active_4 ;
reg crc_dpprx_en ;
reg crc_dpprx_rst ; 
reg dpp_act_d2 ; 
reg dpp_act_d3 ; 
reg rx_dpp_done ;
reg [31:0] swap32_in  ; 
reg in_link_command_good ;
reg in_link_command_crc_good ;
reg dpp_det ;
reg tx_lau_act; 
wire tx_lgo_act; 
reg rx_lpma_act ;
reg force_LinkPM_accept ;
reg u2_inact_timeout_set ;
reg tx_hdr_seq_num_adv ;
reg rx_lau_act ;
reg out_data_3_val_0 ;
reg out_data_3_val_1 ;
reg out_data_3_val_2 ;
reg out_data_3_val_3 ;
reg out_data_3_val_4 ;
reg out_active_4 ;
reg [3:0] out_datak_4 ;
reg [31:0] buf_out_q_d ;
reg [31:0] swap32_crc_dpptx32_out_d ;
reg [31:0] comb0_d ;
reg [31:0] comb1_d ;
reg [31:0] comb2_d ;
reg [31:0] comb3_d ;
reg [31:0] comb4_d ;
reg [31:0] comb5_d ;
reg [31:0] comb6_d ;
reg [31:0] comb7_d ;
reg [31:0] comb8_d ;
reg [31:0] comb9_d ;
reg [31:0] comb10_d ;
reg [31:0] out_data_4;
reg  out_data_3_val;
reg wait_for_in_active ;
reg wait_for_in_active_d ;
reg wait_for_in_active_d2 ;
wire			hp_empty 	;
reg				hp_rd       ;
wire	[31:0]	hp_word_0_q ;
wire	[31:0]	hp_word_1_q ;
wire	[31:0]	hp_word_2_q ;
reg hp_wr ;
reg [31:0] hp_word_0 ;
reg [31:0] hp_word_1 ;
reg [31:0] hp_word_2 ;
reg tx_dph_iso_0_latch ;
reg tx_lbad_act ;
reg wait_retry ;
reg rx_retry ;
reg tx_ltry_act ;
reg res_mem_rd_dat_val ;
reg [32+4-1:0] res_mem_rd_dat ;
reg [31:0] out_data_5 ;
reg [3:0]  out_datak_5 ;
reg out_active_5 ;
reg tx_res_req ;




reg				err_lbad					;
reg				err_lbad_recv               ;
reg				err_stuck_hpseq             ;
reg				err_lcmd_undefined          ;
reg				err_lcrd_mismatch           ;
reg				err_lgood_order             ;
reg				err_lgood_missed            ;
reg				err_pending_hp              ;
reg				err_credit_hp               ;
reg				err_hp_crc                  ;
reg				err_hp_seq                  ;
reg				err_hp_type                 ;
reg				err_dpp_len_mismatch        ;
	
localparam ST_LINK_QUEUE_W 		= 3 ;
localparam LINK_QUEUE_IDLE 		= 3'd0 ;
localparam LINK_QUEUE_PORTCAP 	= 3'd1 ;
localparam LINK_QUEUE_PORTRESP 	= 3'd2 ;
localparam LINK_QUEUE_TP_A 		= 3'd3 ;
localparam LINK_QUEUE_TP_B 		= 3'd4 ;
localparam LINK_QUEUE_TP_C 		= 3'd5 ;
localparam LINK_QUEUE_DP 		= 3'd6 ;
localparam LINK_QUEUE_TP 		= 3'd7 ;
reg [ST_LINK_QUEUE_W-1:0] queue_state ;

localparam ST_SEND_LCMD_W 	= 4 ;
localparam SEND_LCMD_IDLE 	= 4'd0 ;
localparam SEND_CMDW_0 		= 4'd1 ;
localparam SEND_CMDW_1 		= 4'd2 ;
localparam SEND_LCMD_DONE 	= 4'd3 ;
localparam SEND_LGOOD_REQ 	= 4'd4 ;
localparam SEND_LCRD_REQ 	= 4'd5 ;
localparam SEND_LUP_REQ 	= 4'd6 ;
localparam SEND_LAU_REQ 	= 4'd7 ;
localparam SEND_LGO_REQ 	= 4'd8 ;
localparam SEND_LPMA_REQ 	= 4'd9 ;
localparam SEND_LBAD_REQ 	= 4'd10 ;
localparam SEND_LTRY_REQ 	= 4'd11 ;
reg [ST_SEND_LCMD_W-1:0] send_lcmd_state ;

localparam ST_SEND_HP_W = 3 ;
localparam SEND_HP_IDLE = 3'd0 ;
localparam SEND_HP_0 	= 3'd1 ;
localparam SEND_HP_1 	= 3'd2 ;
localparam SEND_HP_2 	= 3'd3 ;
localparam SEND_HP_3 	= 3'd4 ;
localparam SEND_HP_4 	= 3'd5 ;
localparam SEND_HP_DONE = 3'd6 ;
reg [ST_SEND_HP_W-1:0] send_hp_state ;


localparam ST_SEND_DPP_W 	= 4 ;
localparam SEND_DPP_IDLE 	= 4'd0 ;
localparam SEND_DPP_1 		= 4'd1 ;
localparam SEND_DPP_6 		= 4'd2 ;
localparam SEND_DPP_7 		= 4'd3 ;
localparam SEND_DPP_8 		= 4'd4 ;
localparam SEND_DPP_10 		= 4'd5 ;
localparam SEND_DPP_11 		= 4'd6 ;
localparam SEND_DPP_12 		= 4'd7 ;
localparam SEND_DPP_13 		= 4'd8 ;
localparam SEND_DPP_DONE 	= 4'd9 ;
reg [ST_SEND_DPP_W-1:0] send_dpp_state ;
reg [ST_SEND_DPP_W-1:0] send_dpp_state_d ;


localparam ST_RES_IDLE = 3'd0;
localparam ST_RES_REQ  = 3'd1;
localparam ST_RES_SEND = 3'd2;
localparam ST_RES_DONE = 3'd3;
localparam ST_RES_ACK = 3'd4;
reg [2:0] res_state ;

// monitor change of ltssm state 
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		ltssm_state_d <= 0 ;
		ltssm_state_change <= 0 ;
		ltssm_current_state <= 0 ;
		ltssm_last_state <= 0 ;
	end
	else begin
		ltssm_state_d <= ltssm_state ;
		
		if ( ltssm_state_d != ltssm_state ) begin
			ltssm_state_change <= 1 ;
			ltssm_current_state <= ltssm_state ;
			ltssm_last_state <= ltssm_state_d ;
		end
		else begin
			ltssm_state_change <= 0 ;
		end
	end
end

reg ltssm_enter_u0 ;
always @ ( * ) begin
	if ( ltssm_state_change && ltssm_current_state == LT_U0 ) begin
		ltssm_enter_u0 <= 1 ;
	end
	else begin
		ltssm_enter_u0 <= 0 ;
	end
end

reg ltssm_exit_u0 ;
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		ltssm_exit_u0 <= 0 ;
	end
	else if ( ltssm_state_change && ltssm_current_state != LT_U0 && ltssm_last_state == LT_U0 ) begin
		ltssm_exit_u0 <= 1 ;
	end
	else begin
		ltssm_exit_u0 <= 0 ;
	end
end

// managing tx link cmd  , tx hp 

// tx lcrd 
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		tx_lcrd_act <= 0 ;
		local_rx_cred_count_inc <= 0 ;
		queue_send_u0_adv <= 1 ;
		do_not_send_credit <= 0 ;
	end
	//else if ( ltssm_enter_u0 ) begin
	//	if ( ltssm_last_state == LT_RECOVERY_IDLE ) begin
	//		queue_send_u0_adv <= 0 ;
	//		qc <= 0 ;
	//	end
	//	else begin
	//		queue_send_u0_adv <= 0 ;
	//		qc <= 0 ;
	//	end
	//end	
	else if ( ltssm_current_state != LT_U0 ) begin
		queue_send_u0_adv <= 0 ;
		qc <= 0 ;		
	end
	else if ( !queue_send_u0_adv && ltssm_current_state == LT_U0) begin
		qc <= qc + 1 ;
			
		if ( qc == 11 ) begin
			tx_lcrd <= LCMD_LCRD_A ;
			tx_lcrd_act <= 1'b1 ;		
		end
		else if ( qc == 12 ) begin
			tx_lcrd <= LCMD_LCRD_B ;
			tx_lcrd_act <= 1'b1 ;		
		end	
		else if ( qc == 13 ) begin
			tx_lcrd <= LCMD_LCRD_C ;
			tx_lcrd_act <= 1'b1 ;			
		end			
		else if ( qc == 14 ) begin
			tx_lcrd <= LCMD_LCRD_D ;
			tx_lcrd_act <= 1'b1 ;			
		end
		else if ( qc == 15 ) begin
			tx_lcrd_act <= 0 ;
			qc <= qc ;
			if ( tx_lgood_empty && tx_lcrd_empty ) begin
				queue_send_u0_adv <= 1 ;
			end				
		end
	end
	else if ( tx_lcrd_on_parsed_header ) begin
		tx_lcrd <= {LCMD_LCRD_A[10:2],rx_cred_idx_latch[1:0]} ;
		tx_lcrd_act <= 1 ;
		local_rx_cred_count_inc <= 1 ;
	end
	else begin
		tx_lcrd_act <= 0 ; 
		local_rx_cred_count_inc <= 0 ; 
	end
end

// TX lgood
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		tx_lgood_act <= 0 ;
		tx_lgood <= 0 ;
	end
	else if ( !queue_send_u0_adv ) begin
		if ( qc == 1 ) begin
			tx_lgood <= {LCMD_LGOOD_0[10:3], rx_hdr_seq_num_dec[2:0] };
			tx_lgood_act <= 1;			
		end
		else begin
			tx_lgood_act <= 0 ;
		end
	end
	else if ( tx_lgood_on_rx_valid_header ) begin
			tx_lgood <= {LCMD_LGOOD_0[10:3], rx_hdr_seq_num_dec[2:0]};
			tx_lgood_act <= 1;	
	end
	else begin
		tx_lgood_act <= 0 ;
	end
end

// TX hp
reg ltssm_enter_u0_by_polling ;
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		ltssm_enter_u0_by_polling <= 0 ;
	end
	else if ( ltssm_enter_u0 ) begin
		ltssm_enter_u0_by_polling <= 0 ;
	end
	else if ( ltssm_current_state == LT_POLLING_LFPS ) begin
		ltssm_enter_u0_by_polling <= 1 ;
	end
end


`ifdef SIM
usb3_TxHp
`else
`getname(usb3_TxHp,`module_name)
`endif 
usb3_TxHp_inst	
(
	.clk (local_clk) 
	,.rst_n ( reset_n )

	,.hp_wr				(hp_wr	   )
	,.hp_word_0         (hp_word_0 )
	,.hp_word_1         (hp_word_1 )
	,.hp_word_2         (hp_word_2 )
	
	,.hp_empty 			(hp_empty 	  )
	,.hp_rd             (hp_rd        )
	,.hp_word_0_q       (hp_word_0_q  )
	,.hp_word_1_q       (hp_word_1_q  )
	,.hp_word_2_q       (hp_word_2_q  )
	

);

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		prot_tx_tp_a_ack <= 0 ;
		prot_tx_tp_b_ack <= 0 ;
		prot_tx_tp_c_ack <= 0 ;
		hp_wr <= 0 ;
	end
	else if ( ltssm_current_state == LT_U0 ) begin
		if ( prot_tx_tp_a_ack | prot_tx_tp_b_ack | prot_tx_tp_c_ack ) begin
			hp_wr <= 0 ;	
			prot_tx_tp_a_ack <= 0 ;
			prot_tx_tp_b_ack <= 0 ;
			prot_tx_tp_c_ack <= 0 ;	
		end
		else if ( prot_tx_tp_a ) begin
			hp_wr <= 1 ;
			hp_word_0 <= {	dev_address, LP_TP_ROUTE0, LP_TYPE_TP};
			hp_word_1 <= {	6'h0, prot_tx_tp_a_seq, prot_tx_tp_a_nump, 
							1'b0, 3'h0, prot_tx_tp_a_endp, prot_tx_tp_a_dir, prot_tx_tp_a_retry, 2'h0, prot_tx_tp_a_subtype};
			hp_word_2 <= {	LP_TP_NBI_0, LP_TP_PPEND_NO, LP_TP_DBI_NO, LP_TP_WPA_NO, LP_TP_SSI_NO, 8'h0, prot_tx_tp_a_stream};
			
			prot_tx_tp_a_ack <= 1 ;
		end
		else if ( prot_tx_tp_b ) begin
			hp_wr <= 1 ;
			hp_word_0 <= {	dev_address, LP_TP_ROUTE0, LP_TYPE_TP};
			hp_word_1 <= {	6'h0, prot_tx_tp_b_seq, prot_tx_tp_b_nump, 
							1'b0, 3'h0, prot_tx_tp_b_endp, prot_tx_tp_b_dir, prot_tx_tp_b_retry, 2'h0, prot_tx_tp_b_subtype};
			hp_word_2 <= {	LP_TP_NBI_0, LP_TP_PPEND_NO, LP_TP_DBI_NO, LP_TP_WPA_NO, LP_TP_SSI_NO, 8'h0, prot_tx_tp_b_stream};
			
			prot_tx_tp_b_ack <= 1 ;	
		end
		else if ( prot_tx_tp_c ) begin
			hp_wr <= 1 ;
			hp_word_0 <= {	dev_address, LP_TP_ROUTE0, LP_TYPE_TP};
			hp_word_1 <= {	6'h0, prot_tx_tp_c_seq, prot_tx_tp_c_nump, 
							1'b0, 3'h0, prot_tx_tp_c_endp, prot_tx_tp_c_dir, prot_tx_tp_c_retry, 2'h0, prot_tx_tp_c_subtype};
			hp_word_2 <= {	LP_TP_NBI_0, LP_TP_PPEND_NO, LP_TP_DBI_NO, LP_TP_WPA_NO, LP_TP_SSI_NO, 8'h0, prot_tx_tp_c_stream};
			
			prot_tx_tp_c_ack <= 1 ;	
		end
	end
end




always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		queue_state <= LINK_QUEUE_IDLE ;
		send_port_cfg_resp_ack <= 0 ;
		tx_hp_act <= 0 ;
		tx_hp_dph <= 0 ;
		//prot_tx_tp_a_ack <= 0 ;
		//prot_tx_tp_b_ack <= 0 ;
		//prot_tx_tp_c_ack <= 0 ;
		prot_tx_dpp_ack <= 0 ;

	end
	else if ( ltssm_enter_u0 && ltssm_enter_u0_by_polling ) begin
		queue_send_u0_portcap <= 0 ;
		send_port_cfg_resp_ack <= 0 ;
	end	
	else begin
		case ( queue_state ) 
		LINK_QUEUE_IDLE: begin
			if ( ltssm_current_state == LT_U0 ) begin
				if ( queue_send_u0_adv && recv_u0_adv && !queue_send_u0_portcap  ) begin
					queue_state <= LINK_QUEUE_PORTCAP ;
				end
				else if ( send_port_cfg_resp && !send_port_cfg_resp_ack  ) begin
					queue_state <= LINK_QUEUE_PORTRESP ;
				end
				else if ( !hp_empty ) begin
					queue_state <= LINK_QUEUE_TP ;
					hp_rd <= 1 ; 
				end
				else if ( 	prot_tx_dph && 
							recv_u0_adv && queue_send_u0_adv &&				
							tx_lbad_empty && !wait_retry && 
							!err_lgood_order && !err_lcrd_mismatch && !err_hp_seq &&
							res_state == ST_RES_IDLE && tx_ltry_empty && !tx_ltry_act && !resend_hp_act &&
							tx_lgood_empty && tx_lcrd_empty
							) begin
					queue_state <= LINK_QUEUE_DP; 
				end
			end
		end
		LINK_QUEUE_PORTCAP: begin
			tx_hp_word_0 <= {16'h0, LP_LMP_SPEED_5GBPS, LP_LMP_SUB_PORTCAP, LP_TYPE_LMP};
			tx_hp_word_1 <= {8'h0, LP_LMP_TIEBREAK, 1'b0, LP_LMP_OTG_INCAPABLE, LP_LMP_DIR_UP, 8'b0, LP_LMP_NUM_HP_4};
			tx_hp_word_2 <= {32'h0};
			tx_hp_act <= 1;
			if ( send_hp_state == SEND_HP_DONE ) begin
				queue_send_u0_portcap <= 1 ;
				tx_hp_act <= 0 ; 
				queue_state <= LINK_QUEUE_IDLE ;
			end
		end	
		LINK_QUEUE_PORTRESP: begin
			tx_hp_word_0 <= {16'h0, LP_LMP_SPEED_ACCEPT, LP_LMP_SUB_PORTCFGRSP, LP_TYPE_LMP};
			tx_hp_word_1 <= {32'h0};
			tx_hp_word_2 <= {32'h0};
			tx_hp_act <= 1;		
			if ( send_hp_state == SEND_HP_DONE ) begin
				send_port_cfg_resp_ack <= 1 ;
				tx_hp_act <= 0 ;	 
				queue_state <= LINK_QUEUE_IDLE ;
			end
		end
		LINK_QUEUE_TP: begin
			hp_rd <= 0 ;
			tx_hp_word_0 <= hp_word_0_q ;
			tx_hp_word_1 <= hp_word_1_q ;
			tx_hp_word_2 <= hp_word_2_q	;	
			
			tx_hp_act <= 1;
			if ( tx_hp_act ) begin
				if ( send_hp_state == SEND_HP_DONE ) begin
					queue_state <= LINK_QUEUE_IDLE ;
					tx_hp_act <= 0 ;		
				end
			end			
		
		end
		LINK_QUEUE_DP:begin
			tx_hp_word_0 <= {	dev_address, LP_TP_ROUTE0, LP_TYPE_DP};
			tx_hp_word_1 <= {	prot_tx_dph_len, 1'b0, 3'b0, prot_tx_dph_endp, prot_tx_dph_dir, prot_tx_dph_eob, 1'b0, prot_tx_dph_seq};
			tx_hp_word_2 <= {	32'h0};
			tx_hp_act <= 1;
			tx_hp_dph <= 1;
			tx_dph_iso_0_latch <= prot_tx_dph_iso_0 ; 
	
			out_dpp_length <= prot_tx_dph_len;
			
	
			if ( send_dpp_state == SEND_DPP_DONE ) begin
				tx_hp_act <= 0 ;
				prot_tx_dpp_ack <= 1 ; 
				if ( !tx_dph_iso_0_latch ) begin
					buf_out_arm <= 1 ;
				end
			end
			else if ( prot_tx_dpp_ack ) begin 
				tx_hp_act <= 0 ;
				buf_out_arm <= 0 ;
				if (!prot_tx_dph ) begin
					queue_state <= LINK_QUEUE_IDLE ;
					prot_tx_dpp_ack <= 0 ;
					buf_out_arm <= 0 ;
					tx_hp_dph <= 0 ;
				end
			end
			else begin
				buf_out_arm <= 0 ;
			end
		
		end
		default:begin
		end
		endcase	
	end
end

`ifdef SIM
usb3_TXLcmd
`else
`getname(usb3_TXLcmd,`module_name)
`endif 
usb3_TXLgood_cache(
	 .clk 		(local_clk 	)
	,.rst_n		(reset_n & !ltssm_enter_u0 )
	
	,.tx_lcmd_act (tx_lgood_act)
	,.tx_lcmd     (tx_lgood)
	
	,.tx_lcmd_pop	(tx_lgood_pop)
	,.tx_lcmd_q	   (tx_lgood_q)
	
	,.tx_lcmd_empty	(tx_lgood_empty)
	
);


`ifdef SIM
usb3_TXLcmd
`else
`getname(usb3_TXLcmd,`module_name)
`endif 
usb3_TXLcrd_cache(
	 .clk 		(local_clk 	)
	,.rst_n		(reset_n	& !ltssm_enter_u0 )
	
	,.tx_lcmd_act (tx_lcrd_act)
	,.tx_lcmd     (tx_lcrd)
	
	,.tx_lcmd_pop  (tx_lcrd_pop )
	,.tx_lcmd_q		(tx_lcrd_q)
	
	,.tx_lcmd_empty (tx_lcrd_empty)
	
);


`ifdef SIM
usb3_TXLcmd
`else
`getname(usb3_TXLcmd,`module_name)
`endif 
usb3_TXLup_cache(
	 .clk 		(local_clk 	)
	,.rst_n		(reset_n	& !ltssm_enter_u0 )
	
	,.tx_lcmd_act (tx_lup_act)
	,.tx_lcmd     (LCMD_LUP)
	
	,.tx_lcmd_pop  (tx_lup_pop )
	,.tx_lcmd_q		(tx_lup_q)
	
	,.tx_lcmd_empty (tx_lup_empty)
	
);

`ifdef SIM
usb3_TXLcmd
`else
`getname(usb3_TXLcmd,`module_name)
`endif 
usb3_TXLau_cache(
	 .clk 		(local_clk 	)
	,.rst_n		(reset_n	& !ltssm_enter_u0 )
	
	,.tx_lcmd_act (tx_lau_act)
	//,.tx_lcmd     (LCMD_LAU)
	//,.tx_lcmd     (LCMD_LXU)
	,.tx_lcmd     ( (lgo_latch[1:0] == 2'b11 ) ? LCMD_LAU : LCMD_LXU )
	
	,.tx_lcmd_pop  (tx_lau_pop )
	,.tx_lcmd_q		(tx_lau_q)
	
	,.tx_lcmd_empty (tx_lau_empty)
	
);

`ifdef SIM
usb3_TXLcmd
`else
`getname(usb3_TXLcmd,`module_name)
`endif 
usb3_TXLgo_cache(
	 .clk 		(local_clk 	)
	,.rst_n		(reset_n	& !ltssm_enter_u0 )
	
	,.tx_lcmd_act (tx_lgo_act)
	,.tx_lcmd     (LCMD_LGO_U3)
	
	,.tx_lcmd_pop  (tx_lgo_pop )
	,.tx_lcmd_q		(tx_lgo_q)
	
	,.tx_lcmd_empty (tx_lgo_empty)
	
);

`ifdef SIM
usb3_TXLcmd
`else
`getname(usb3_TXLcmd,`module_name)
`endif 
usb3_TXLpma_cache(
	 .clk 		(local_clk 	)
	,.rst_n		(reset_n	 & !ltssm_enter_u0 )
	
	,.tx_lcmd_act (rx_lau_act)
	,.tx_lcmd     (LCMD_LPMA)
	
	,.tx_lcmd_pop  (tx_lpma_pop )
	,.tx_lcmd_q		(tx_lpma_q)
	
	,.tx_lcmd_empty (tx_lpma_empty)
	
);

`ifdef SIM
usb3_TXLcmd
`else
`getname(usb3_TXLcmd,`module_name)
`endif 
usb3_TXLbad_cache(
	 .clk 		(local_clk 	)
	,.rst_n		(reset_n	& !ltssm_enter_u0 )
	
	,.tx_lcmd_act (err_lbad & tx_lbad_empty)
	,.tx_lcmd     (LCMD_LBAD)
	
	,.tx_lcmd_pop  (tx_lbad_pop )
	,.tx_lcmd_q		(tx_lbad_q)
	
	,.tx_lcmd_empty (tx_lbad_empty)
	
);

`ifdef SIM
usb3_TXLcmd
`else
`getname(usb3_TXLcmd,`module_name)
`endif 
usb3_TXLtry_cache(
	 .clk 		(local_clk 	)
	,.rst_n		(reset_n	 & !ltssm_enter_u0 )
	
	//,.tx_lcmd_act ( err_lbad_recv )
	,.tx_lcmd_act ( 1'b0 )
	,.tx_lcmd     (LCMD_LRTY)
	
	,.tx_lcmd_pop  (tx_ltry_pop )
	,.tx_lcmd_q		(tx_ltry_q)
	
	,.tx_lcmd_empty (tx_ltry_empty)
	
);


// managing tx pipe interface  
// pipe send lcmd
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		send_lcmd_state <= SEND_LCMD_IDLE;									
		tx_lcmd_req <= 0 ;
		tx_lgood_pop <= 0 ;
		tx_lcrd_pop <= 0 ;
		tx_lup_pop <= 0 ;
		tx_lau_pop <= 0 ;
		tx_lgo_pop <= 0 ;
		tx_lpma_pop <= 0 ;
		tx_lpma_act <= 0 ;
		tx_lbad_pop <= 0 ;
		tx_lbad_act <= 0 ;
		tx_ltry_pop <= 0 ;
		tx_ltry_act <= 0 ;
	end
	else begin
		case ( send_lcmd_state ) 
		SEND_LCMD_IDLE:begin	
			if ( !tx_lgood_empty ) begin
				tx_lcmd_req <= 1 ;
				send_lcmd_state <= SEND_LGOOD_REQ ;
			end
			else if ( !tx_lcrd_empty ) begin
				tx_lcmd_req <= 1 ;
				send_lcmd_state <= SEND_LCRD_REQ ;		
			end
			else if ( !tx_lup_empty ) begin
				tx_lcmd_req <= 1 ;
				send_lcmd_state <= SEND_LUP_REQ;
			end
			else if ( !tx_lau_empty ) begin
				tx_lcmd_req <= 1 ;
				send_lcmd_state <= SEND_LAU_REQ	;			
			end
			else if ( !tx_lgo_empty ) begin
				tx_lcmd_req <= 1 ;
				send_lcmd_state <= SEND_LGO_REQ	;
			end
			else if ( !tx_lpma_empty ) begin
				tx_lcmd_req <= 1 ;
				send_lcmd_state <= SEND_LPMA_REQ	;
			end	
			else if ( !tx_lbad_empty ) begin
				tx_lcmd_req <= 1 ;
				send_lcmd_state <= SEND_LBAD_REQ	;
			end
			else if ( !tx_ltry_empty && res_state == ST_RES_IDLE && ltssm_current_state == LT_U0 && queue_send_u0_adv && recv_u0_adv ) begin
				tx_lcmd_req <= 1 ;
				send_lcmd_state <= SEND_LTRY_REQ	;				
			end			
			{out_data_1, out_datak_1} <= 0 ;
			out_active_1 <= 0 ;
			tx_lpma_act <= 0 ; 
		end
		SEND_LGOOD_REQ:begin	
			if ( tx_lcmd_req_ack ) begin
				tx_lcmd_latch <= tx_lgood_q ;
				tx_lgood_pop <= 1 ;
				tx_lcmd_req <= 0 ;
				send_lcmd_state <= SEND_CMDW_0;
			end
		end
		SEND_LCRD_REQ:begin		
			if ( tx_lcmd_req_ack ) begin
				tx_lcmd_latch <= tx_lcrd_q ;				
				tx_lcrd_pop <= 1 ;
				tx_lcmd_req <= 0 ;
				send_lcmd_state <= SEND_CMDW_0;
			end	
		end
		SEND_LUP_REQ:begin
			if ( tx_lcmd_req_ack ) begin
				tx_lcmd_latch <= tx_lup_q ;				
				tx_lup_pop <= 1 ;
				tx_lcmd_req <= 0 ;
				send_lcmd_state <= SEND_CMDW_0;
			end
		end			
		SEND_LAU_REQ:begin
			if ( tx_lcmd_req_ack ) begin
				tx_lcmd_latch <= tx_lau_q ;
				tx_lau_pop <= 1 ;
				tx_lcmd_req <= 0 ;
				send_lcmd_state <= SEND_CMDW_0;
			end
		end			
		SEND_LGO_REQ:begin
			if ( tx_lcmd_req_ack ) begin
				tx_lcmd_latch <= tx_lgo_q ; 
				tx_lgo_pop <= 1 ;
				tx_lcmd_req <= 0 ;
				send_lcmd_state <= SEND_CMDW_0 ;
			end
		end			
		SEND_LPMA_REQ:begin
			if ( tx_lcmd_req_ack ) begin
				tx_lcmd_latch <= tx_lpma_q ;
				tx_lpma_pop <= 1 ;
				tx_lcmd_req <= 0 ;
				send_lcmd_state <= SEND_CMDW_0 ;
				tx_lpma_act <= 1 ;
			end
		end			
		SEND_LBAD_REQ:begin
			if ( tx_lcmd_req_ack ) begin
				tx_lcmd_latch <= tx_lbad_q ;
				tx_lbad_pop <= 1 ;
				tx_lcmd_req <= 0 ;
				send_lcmd_state <= SEND_CMDW_0 ;
				tx_lbad_act <= 1 ; 
			end
		end		
		SEND_LTRY_REQ:begin
			if ( tx_lcmd_req_ack ) begin
				tx_lcmd_latch <= tx_ltry_q ;
				tx_ltry_pop <= 1 ;
				tx_lcmd_req <= 0 ;
				send_lcmd_state <= SEND_CMDW_0; 
				tx_ltry_act <= 1 ;
			end	
		end		
		SEND_CMDW_0:begin
			{out_data_1, out_datak_1} <= {32'hFEFEFEF7, 4'b1111};
			out_active_1 <= 1;
			crc_lcmd_in   <= tx_lcmd_latch ;			
			send_lcmd_state <= SEND_CMDW_1;
			
			tx_lgood_pop <= 0 ;
			tx_lcrd_pop <= 0 ;
			tx_lup_pop <= 0 ;
			tx_lau_pop <= 0 ;
			tx_lgo_pop <= 0 ;
			tx_lpma_pop <= 0 ;
			tx_lbad_pop <= 0 ;
			tx_ltry_pop <= 0 ;
			
			tx_lbad_act <= 0 ;
			tx_ltry_act <= 0 ;
		end
		SEND_CMDW_1: begin
			{out_data_1, out_datak_1} <= {{2{tx_lcmd_latch[7:0], crc_lcmd_out[4:0], tx_lcmd_latch[10:8]}}, 4'b00};
			out_active_1 <= 1; 
			send_lcmd_state <= SEND_LCMD_DONE ;
		end
		SEND_LCMD_DONE: begin
			{out_data_1, out_datak_1} <= {32'h0, 4'b0000};
			out_active_1 <= 0 ;
			send_lcmd_state <= SEND_LCMD_IDLE ;
		end
		endcase 
	end
end

// pipe send hp 
always @ ( posedge local_clk ) begin
	if ( tx_hdr_seq_num_adv ) begin
		tx_hdr_seq_num <=  in_link_command_latch[2:0] + 1  ;
	end
	//else if ( send_hp_state == SEND_HP_DONE ) begin
	else if ( send_hp_state == SEND_HP_3 ) begin
		tx_hdr_seq_num <= tx_hdr_seq_num + 1  ;	
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		send_hp_state <= SEND_HP_IDLE ;				
		tx_hp_req <= 0 ;
		out_header_pkt_sel <= 0 ;
		remote_rx_cred_count_dec <= 0 ;
		crc_hptx_rst <= 0 ;
		crc_hptx_in <= 0 ;
		tx_hp_act_d <= 0 ;
	end	
	else begin
		//tx_hp_act_d <= tx_hp_act ;	
		case ( send_hp_state )
		SEND_HP_IDLE : begin
			//if ( !tx_hp_act_d && tx_hp_act && remote_rx_cred_count > 0 ) begin
			if ( !tx_hp_req && tx_hp_act && remote_rx_cred_count > 0 ) begin
				tx_hp_req <= 1 ;
			end
			else if ( tx_hp_req_ack ) begin
				if ( out_header_pkt_sel == 0 ) begin
					out_header_pkt_a <= {tx_hp_word_0, tx_hp_word_1, tx_hp_word_2};
				end
				else if ( out_header_pkt_sel == 1 ) begin
					out_header_pkt_b <= {tx_hp_word_0, tx_hp_word_1, tx_hp_word_2};
				end
				else if ( out_header_pkt_sel == 2 ) begin
					out_header_pkt_c <= {tx_hp_word_0, tx_hp_word_1, tx_hp_word_2};
				end
				else if ( out_header_pkt_sel == 3 ) begin
					out_header_pkt_d <= {tx_hp_word_0, tx_hp_word_1, tx_hp_word_2};
				end
				
				//out_header_pkt_sel <= out_header_pkt_sel + 1 ;
				out_header_pkt_sel <= 0 ;
				out_header_pkt_sel_latch <= out_header_pkt_sel ;
				
				send_hp_state <= SEND_HP_0 ;
				
				tx_hp_req <= 0 ;
				
				crc_hptx_rst <= 1 ;
			end	
			{out_data_2, out_datak_2} <= 0 ;
			out_active_2 <= 0 ;			
		end
		SEND_HP_0: begin
			remote_rx_cred_count_dec <= 1 ;
			
			{out_data_2, out_datak_2} <= {32'hFBFBFBF7, 4'b1111};
			out_active_2 <= 1 ;
			
			crc_hptx_rst <= 0 ;
			
			if ( out_header_pkt_sel_latch == 0 ) begin
				crc_hptx_in  <= out_header_pkt_a[95:64] ;				
			end
			else if ( out_header_pkt_sel_latch == 1 ) begin
				crc_hptx_in  <= out_header_pkt_b[95:64] ;				
			end		
			else if ( out_header_pkt_sel_latch == 2 ) begin
				crc_hptx_in  <= out_header_pkt_c[95:64] ;				
			end
			else if ( out_header_pkt_sel_latch == 3 ) begin
				crc_hptx_in  <= out_header_pkt_d[95:64] ;				
			end			
			
			send_hp_state <= SEND_HP_1 ;
		end
		SEND_HP_1: begin
			remote_rx_cred_count_dec <= 0 ;
			out_active_2 <= 1 ;
			if ( out_header_pkt_sel_latch == 0 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_a[95:64]), 4'b0000} ;
				crc_hptx_in  <= out_header_pkt_a[63:32] ;				
			end
			else if ( out_header_pkt_sel_latch == 1 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_b[95:64]), 4'b0000} ;
				crc_hptx_in  <= out_header_pkt_b[63:32] ;				
			end		
			else if ( out_header_pkt_sel_latch == 2 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_c[95:64]), 4'b0000} ;
				crc_hptx_in  <= out_header_pkt_c[63:32] ;				
			end
			else if ( out_header_pkt_sel_latch == 3 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_d[95:64]), 4'b0000} ;
				crc_hptx_in  <= out_header_pkt_d[63:32] ;				
			end		
			
			crc_hptx_rst <= 0 ;
			
			send_hp_state <= SEND_HP_2 ; 
		
		end
		SEND_HP_2:begin
		
			out_active_2 <= 1 ;
			if ( out_header_pkt_sel_latch == 0 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_a[63:32]), 4'b0000} ;
				crc_hptx_in  <= out_header_pkt_a[31:0] ;
			end
			else if ( out_header_pkt_sel_latch == 1 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_b[63:32]), 4'b0000} ;
				crc_hptx_in  <= out_header_pkt_b[31:0] ;				
			end		
			else if ( out_header_pkt_sel_latch == 2 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_c[63:32]), 4'b0000} ;
				crc_hptx_in  <= out_header_pkt_c[31:0] ;				
			end
			else if ( out_header_pkt_sel_latch == 3 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_d[63:32]), 4'b0000} ;
				crc_hptx_in  <= out_header_pkt_d[31:0] ;				
				
			end	
			
			send_hp_state <= SEND_HP_3 ;
			
		end
		SEND_HP_3:begin
		
			out_active_2 <= 1 ;
			if ( out_header_pkt_sel_latch == 0 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_a[31:0]), 4'b0000} ;					
			end
			else if ( out_header_pkt_sel_latch == 1 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_b[31:0]), 4'b0000} ;				
			end		
			else if ( out_header_pkt_sel_latch == 2 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_c[31:0]), 4'b0000} ;				
			end
			else if ( out_header_pkt_sel_latch == 3 ) begin
				{out_data_2, out_datak_2} <= {swap32(out_header_pkt_d[31:0]), 4'b0000} ;			
			end	
			
			//crc_cw4_in <=  {1'b0, tx_hp_retry, 6'b0, tx_hdr_seq_num} ;
			//out_header_cw <= {1'b0, tx_hp_retry, 6'b0, tx_hdr_seq_num} ;
			
			crc_cw4_in <=  {1'b0, 1'b0, 6'b0, tx_hdr_seq_num} ;
			out_header_cw <= {1'b0, 1'b0 , 6'b0, tx_hdr_seq_num} ;			
			
			send_hp_state <= SEND_HP_4 ;
			
		end
		SEND_HP_4: begin

			out_active_2 <= 1 ;
			{out_data_2, out_datak_2} <= {swap32({crc_cw4_out , out_header_cw ,crc_hptx_out}),4'b0000}; 
		
			crc_hptx_rst <= 1 ;
			
			send_hp_state <= SEND_HP_DONE ;
		end
		SEND_HP_DONE: begin
			if ( tx_hp_dph ) begin
				if ( send_dpp_state == SEND_DPP_DONE ) begin
					send_hp_state <= SEND_HP_IDLE ;
				end
			end
			else begin
				send_hp_state <= SEND_HP_IDLE ;
			end
			
			out_active_2 <= 0 ; 
			{out_data_2, out_datak_2} <= 0 ;			
			 
		end
		
		default:begin
		end
		endcase 
	end
end		


// pipe send dpp 
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		send_dpp_state <= SEND_DPP_IDLE ;		
		crc_dpptx_rst <= 0 ;
		prot_tx_dpp_done <= 0 ;
		buf_out_rden <= 0 ;
	end
	else begin
		case ( send_dpp_state ) 
		SEND_DPP_IDLE:begin
			if ( send_hp_state == SEND_HP_3 && tx_hp_dph )  begin
				buf_out_rden <= 1 ;
			end
			else if ( send_hp_state == SEND_HP_4 && tx_hp_dph ) begin
				buf_out_rden <= 1 ;
			end
			else if ( send_hp_state == SEND_HP_DONE && tx_hp_dph ) begin
				out_active_3 <= 1 ;
				//{out_data_3, out_datak_3} <= {32'h5C5C5CF7, 4'b1111} ;
				out_datak_3 <=  4'b1111 ;
				out_data_3_val <= 1 ;

				buf_out_addr <= -1 ;
				buf_out_rden <= 1 ;
				crc_dpptx_rst <= 0 ;
				
				out_dpp_length_remain <= out_dpp_length ;
				
				send_dpp_state <= SEND_DPP_1 ;
				
				prot_tx_dpp_done <= 0 ; 
								
			end
			else begin
				buf_out_addr <= 0 ;
				buf_out_rden <= 0 ;
				crc_dpptx_rst <= 1 ;
			end
		end
		SEND_DPP_1:begin
		
			out_data_3_val <= 0 ;
			
			buf_out_addr <= buf_out_addr + 1 ;
			buf_out_rden <= 1 ;
			
			
			out_dpp_length_remain <= ( out_dpp_length_remain >= 4 ) ?  out_dpp_length_remain - 4 : out_dpp_length_remain ;
			
			out_active_3 <= 1 ;
			
			out_datak_3 <= 4'b0000 ;
			
			if ( out_dpp_length_remain[15:2] != 0 ) begin
				//out_data_3 <= { buf_out_q[31:0]  } ;
				out_data_3_val_0 <= 1 ;
				out_data_3_val_1 <= 0 ;
				out_data_3_val_2 <= 0 ;
				out_data_3_val_3 <= 0 ;
				out_data_3_val_4 <= 0 ;
				send_dpp_state <= SEND_DPP_1 ;			
			end
			else if ( out_dpp_length_remain[1:0] == 0 ) begin
				//out_data_3  <=  swap32(crc_dpptx32_out)  ;
				out_data_3_val_0 <= 0 ;
				out_data_3_val_1 <= 1 ;
				out_data_3_val_2 <= 0 ;
				out_data_3_val_3 <= 0 ;
				out_data_3_val_4 <= 0 ;
				send_dpp_state <= SEND_DPP_10 ;
			end
			else if ( out_dpp_length_remain[1:0] == 1 ) begin
				// 1 , 3
				//out_data_3 <= { buf_out_q[31:24], crc_dpptx_out [31:8]  } ;
				out_data_3_val_0 <= 0 ;
				out_data_3_val_1 <= 0 ;
				out_data_3_val_2 <= 1 ;
				out_data_3_val_3 <= 0 ;
				out_data_3_val_4 <= 0 ;
				send_dpp_state <= SEND_DPP_8 ;	
				crc_dpptx_out_1 <= crc_dpptx_out ;
			end
			else if ( out_dpp_length_remain[1:0] == 2 ) begin
				// 2 , 2		
				//out_data_3 <= { buf_out_q[31:16], crc_dpptx_out [31:16]  } ;
				out_data_3_val_0 <= 0 ;
				out_data_3_val_1 <= 0 ;
				out_data_3_val_2 <= 0 ;
				out_data_3_val_3 <= 1 ;
				out_data_3_val_4 <= 0 ;
				send_dpp_state <= SEND_DPP_7 ;	
				crc_dpptx_out_1 <= crc_dpptx_out ;		
			end		
			else if ( out_dpp_length_remain[1:0] == 3 ) begin
				// 3 , 1
				//out_data_3 <= { buf_out_q[31:8], crc_dpptx_out [31:24]  } ;
				out_data_3_val_0 <= 0 ;
				out_data_3_val_1 <= 0 ;
				out_data_3_val_2 <= 0 ;
				out_data_3_val_3 <= 0 ;
				out_data_3_val_4 <= 1 ;
				send_dpp_state <= SEND_DPP_6 ;	
				crc_dpptx_out_1 <= crc_dpptx_out ;				
			end	
			
		end
		SEND_DPP_6: begin
			// 3 , 1	
			//{out_data_3, out_datak_3 , out_active_3 } <= {crc_dpptx_out_1[23:0], 8'hFD, 4'b0001, 1'b1}; 
			{ out_datak_3 , out_active_3 } <= {4'b0001, 1'b1}; 
			send_dpp_state <= SEND_DPP_11;
			
			out_data_3_val_0 <= 0 ;
			out_data_3_val_1 <= 0 ;
			out_data_3_val_2 <= 0 ;
			out_data_3_val_3 <= 0 ;
			out_data_3_val_4 <= 0 ;			
		end
		SEND_DPP_7: begin 
			// 2 , 2	
			//{out_data_3, out_datak_3 , out_active_3 } <= {crc_dpptx_out_1[15:0], 16'hFDFD, 4'b0011, 1'b1}; 
			{ out_datak_3 , out_active_3 } <= {4'b0011, 1'b1}; 
			send_dpp_state <= SEND_DPP_12;
			
			out_data_3_val_0 <= 0 ;
			out_data_3_val_1 <= 0 ;
			out_data_3_val_2 <= 0 ;
			out_data_3_val_3 <= 0 ;
			out_data_3_val_4 <= 0 ;	
			
		end
		SEND_DPP_8: begin
			// 1 , 3	
			//{out_data_3, out_datak_3 , out_active_3 } <= {crc_dpptx_out_1[7:0], 24'hFDFDFD, 4'b0111, 1'b1}; 
			{ out_datak_3 , out_active_3 } <= { 4'b0111, 1'b1}; 
			send_dpp_state <= SEND_DPP_13;
			
			out_data_3_val_0 <= 0 ;
			out_data_3_val_1 <= 0 ;
			out_data_3_val_2 <= 0 ;
			out_data_3_val_3 <= 0 ;
			out_data_3_val_4 <= 0 ;	
			
		end			
		SEND_DPP_10: begin
			//{out_data_3, out_datak_3 , out_active_3 } <= {32'hFDFDFDF7, 4'b1111, 1'b1} ; 
			{out_datak_3 , out_active_3 } <= { 4'b1111, 1'b1} ; 
			send_dpp_state <= SEND_DPP_DONE;
			
			out_data_3_val_0 <= 0 ;
			out_data_3_val_1 <= 0 ;
			out_data_3_val_2 <= 0 ;
			out_data_3_val_3 <= 0 ;
			out_data_3_val_4 <= 0 ;	
			
		end		
		SEND_DPP_11: begin
			//{out_data_3, out_datak_3 , out_active_3 } <= {32'hFDFDF700, 4'b1110, 1'b1}; 
			{ out_datak_3 , out_active_3 } <= {4'b1110, 1'b1}; 
			send_dpp_state <= SEND_DPP_DONE;

			out_data_3_val_0 <= 0 ;
			out_data_3_val_1 <= 0 ;
			out_data_3_val_2 <= 0 ;
			out_data_3_val_3 <= 0 ;
			out_data_3_val_4 <= 0 ;				
			
		end	
		SEND_DPP_12: begin 
			//{out_data_3, out_datak_3 , out_active_3 } <= {32'hFDF70000, 4'b1100, 1'b1}; 
			{out_datak_3 , out_active_3 } <= { 4'b1100, 1'b1}; 
			send_dpp_state <= SEND_DPP_DONE;
			
			out_data_3_val_0 <= 0 ;
			out_data_3_val_1 <= 0 ;
			out_data_3_val_2 <= 0 ;
			out_data_3_val_3 <= 0 ;
			out_data_3_val_4 <= 0 ;				
			
		end 
		SEND_DPP_13: begin
			//{out_data_3, out_datak_3 , out_active_3 } <= {32'hF7000000, 4'b1000, 1'b1}; 
			{out_datak_3 , out_active_3 } <= { 4'b1000, 1'b1}; 
			send_dpp_state <= SEND_DPP_DONE;

			out_data_3_val_0 <= 0 ;
			out_data_3_val_1 <= 0 ;
			out_data_3_val_2 <= 0 ;
			out_data_3_val_3 <= 0 ;
			out_data_3_val_4 <= 0 ;	
			
		end
		SEND_DPP_DONE: begin
			// done
			send_dpp_state <= SEND_DPP_IDLE;
			prot_tx_dpp_done <= 1 ;
		end	
		default:begin
		end
		endcase 
	end
end

always @ ( posedge local_clk ) begin
	send_dpp_state_d <= send_dpp_state ; 
	out_active_4 <= out_active_3 ; 
	out_datak_4 <= out_datak_3 ;

	buf_out_q_d <= buf_out_q ;
	swap32_crc_dpptx32_out_d <= swap32(crc_dpptx32_out) ;
	comb0_d <= 32'h5C5C5CF7 ;
	comb1_d <= { buf_out_q[31:24], crc_dpptx_out [31:8]   } ;
	comb2_d <= { buf_out_q[31:16], crc_dpptx_out [31:16]  } ;
	comb3_d <= { buf_out_q[31:8], crc_dpptx_out [31:24]   } ;
	comb4_d <= {crc_dpptx_out_1[23:0], 8'hFD } ;
	comb5_d <= {crc_dpptx_out_1[15:0], 16'hFDFD} ;
	comb6_d <= {crc_dpptx_out_1[7:0], 24'hFDFDFD} ;
	comb7_d <= 32'hFDFDFDF7 ;
	comb8_d <= 32'hFDFDF700 ;
	comb9_d <= 32'hFDF70000 ;
	comb10_d <= 32'hF7000000 ;
	{ out_data_1_d , out_datak_1_d , out_active_1_d }  <= { out_data_1 , out_datak_1 , out_active_1 } ;
	{ out_data_2_d , out_datak_2_d , out_active_2_d }  <= { out_data_2 , out_datak_2 , out_active_2 } ;			
	{ out_data_3_d , out_datak_3_d , out_active_3_d }  <= { out_data_3 , out_datak_3 , out_active_3 } ;	
	
	tx_link_busy_d <= tx_link_busy ;
	tx_link_busy_d2 <= tx_link_busy_d ;
	tx_sel_d <= tx_sel ;
	tx_sel_d_2 <= tx_sel_d ;
	
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		out_data_4 <= 0 ;
	end
	else begin
		if ( out_data_3_val ) begin
			out_data_4 <= comb0_d ;
		end
		else if ( out_data_3_val_0 ) begin
			out_data_4 <= buf_out_q_d ;
		end
		else if ( out_data_3_val_1 ) begin
			out_data_4 <= swap32_crc_dpptx32_out_d ;
		end	
		else if ( out_data_3_val_2 ) begin
			out_data_4 <= comb1_d ;
		end
		else if ( out_data_3_val_3 ) begin
			out_data_4 <= comb2_d ;
		end
		else if ( out_data_3_val_4 ) begin
			out_data_4 <= comb3_d ;
		end
		else if ( send_dpp_state_d == SEND_DPP_6 ) begin
			out_data_4 <= comb4_d ;
		end
		else if ( send_dpp_state_d == SEND_DPP_7 ) begin
			out_data_4 <= comb5_d ;
		end
		else if ( send_dpp_state_d == SEND_DPP_8 ) begin
			out_data_4 <= comb6_d ;
		end		
		else if ( send_dpp_state_d == SEND_DPP_10 ) begin
			out_data_4 <= comb7_d ;
		end
		else if ( send_dpp_state_d == SEND_DPP_11 ) begin
			out_data_4 <= comb8_d ;
		end	
		else if ( send_dpp_state_d == SEND_DPP_12 ) begin
			out_data_4 <= comb9_d ;
		end		
		else if ( send_dpp_state_d == SEND_DPP_13 ) begin
			out_data_4 <= comb10_d ;
		end	
		else begin
			out_data_4 <= 0 ;
		end
	end
end



// pipe send link cmd or hp  or dpp arbit 	
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin							
		tx_link_busy <= 0 ;		
		tx_hp_req_ack <= 0 ;
		tx_res_req_ack <= 0 ;
		tx_lcmd_req_ack <= 0 ;
		tx_sel <= 0 ;
	end
	else if ( !tx_link_busy ) begin
		if ( tx_lcmd_req  ) begin
			tx_lcmd_req_ack <= 1 ;
			tx_link_busy <= 1 ;
			tx_sel <= 0 ;
		end
		else if ( tx_hp_req ) begin
			tx_hp_req_ack <= 1 ;
			tx_link_busy <= 1 ;
			tx_sel <= 1 ;
		end
		else if ( tx_res_req ) begin
			tx_res_req_ack <= 1 ;
			tx_link_busy <= 1 ;
			tx_sel <= 3 ;
		end
	end 
	else begin
		tx_lcmd_req_ack <= 0 ;
		tx_hp_req_ack <= 0 ;
		tx_res_req_ack <= 0 ;
		if ( tx_sel == 0 && send_lcmd_state == SEND_LCMD_DONE ) begin
			tx_link_busy <= 0 ;
			tx_sel <= 0 ;
		end
		else if ( tx_sel == 1 && send_hp_state == SEND_HP_DONE ) begin
			tx_link_busy <= 0 ;
			tx_sel <= 0 ; 
			if ( tx_hp_dph ) begin
				tx_sel <= 2 ;
				tx_link_busy <= 1 ;
			end
		end	
		else if ( tx_sel == 2 && send_dpp_state == SEND_DPP_DONE ) begin
			tx_link_busy <= 0  ;
			tx_sel <= 0 ;
		end	
		else if ( tx_sel == 3 && res_state == ST_RES_DONE ) begin
			tx_link_busy <= 0  ;
			tx_sel <= 0 ;		
		end
	end
end

reg [31:0] out_data_4_d ;
reg [3:0] out_datak_4_d ;
reg  out_active_4_d ;


always @ ( posedge local_clk  or negedge reset_n ) begin
	if ( !reset_n ) begin
		{ outp_data , outp_datak , outp_active }  <= 0 ;
	end
	else if ( !tx_link_busy_d ) begin
		//{ outp_data , outp_datak , outp_active }  <= 0 ;
		{  outp_datak , outp_active }  <= 0 ;

	end
	else if ( tx_sel_d == 0 ) begin
		//{ outp_data , outp_datak , outp_active }  <= { out_data_1 , out_datak_1 , out_active_1 } ;
		{ outp_data , outp_datak , outp_active }  <= { out_data_1_d , out_datak_1_d , out_active_1_d } ;
	end
	else if ( tx_sel_d == 1 ) begin
		//{ outp_data , outp_datak , outp_active }  <= { out_data_2 , out_datak_2 , out_active_2 } ;			
		{ outp_data , outp_datak , outp_active }  <= { out_data_2_d , out_datak_2_d , out_active_2_d } ;			
	end
	else if ( tx_sel_d == 2 ) begin
		//{ outp_data , outp_datak , outp_active }  <= { out_data_3 , out_datak_3 , out_active_3 } ;	
		//{ outp_data , outp_datak , outp_active }  <= { out_data_3_d , out_datak_3_d , out_active_3_d } ;	
		{ outp_data , outp_datak , outp_active }  <= { out_data_4 , out_datak_4 , out_active_4 } ;		
	end
	else if ( tx_sel_d == 3 ) begin
		{ outp_data , outp_datak , outp_active }  <= { out_data_5 , out_datak_5 , out_active_5 } ;
	end
end



reg [31:0] outp_data_d ;
reg [3:0] outp_datak_d ;
reg  outp_active_d ;

always @ ( posedge local_clk   ) begin
	begin
		outp_data_d <= outp_data ;
		outp_datak_d <= outp_datak ;
		outp_active_d <= outp_active ;
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if (!reset_n) begin
	end
	else begin
		if ( outp_data_d != out_data_4_d || outp_datak_d != out_datak_4_d || out_active_4_d != outp_active_d ) begin
			//$finish();
		end
	end

end


`ifdef SIM
usb3_crc_cw
`else
`getname(usb3_crc_cw,`module_name)
`endif 
iu3ccw5 (
	.di			( crc_cw4_in ),
	.crc_out	( crc_cw4_out )
);

`ifdef SIM
usb3_crc_cw
`else
`getname(usb3_crc_cw,`module_name)
`endif 
iu3ccw4 (
	.di			( crc_lcmd_in ),
	.crc_out	( crc_lcmd_out )
);

`ifdef SIM
usb3_crc_hp
`else
`getname(usb3_crc_hp,`module_name)
`endif 
iu3chptx (
	.clk		( local_clk ),
	.rst		( crc_hptx_rst ),
	.crc_en		( 1'b1 ),
	.di			( crc_hptx_in ),
	.crc_out	( crc_hptx_out )
);

wire [31:0] crc_dpptx_in = swap32(buf_out_q);

	
`ifdef SIM
usb3_crc_dpp32_tx
`else
`getname(usb3_crc_dpp32_tx,`module_name)
`endif 
iu3cdptx32 (
	.clk		( local_clk ),
	.rst		( crc_dpptx_rst ),
	.crc_en		( 1'b1 ),
	.di			( crc_dpptx_in ),
	.lfsr_q		( crc_dpptx_q ),
	.crc_out	( crc_dpptx32_out )
);

`ifdef SIM
usb3_crc_dpp24
`else
`getname(usb3_crc_dpp24,`module_name)
`endif 
iu3cdptx24 (
    .rst		(1'b0) ,
	.clk		(1'b0) ,
	.di			( crc_dpptx_in[23:0] ),
	.q			( crc_dpptx_q ),
	.crc_out	( crc_dpptx24_out )
);
`ifdef SIM
usb3_crc_dpp16
`else
`getname(usb3_crc_dpp16,`module_name)
`endif 
iu3cdptx16 (
    .rst		(1'b0) ,
	.clk		(1'b0) ,
	.di			( crc_dpptx_in[15:0] ),
	.q			( crc_dpptx_q ),
	.crc_out	( crc_dpptx16_out )
);
`ifdef SIM
usb3_crc_dpp8
`else
`getname(usb3_crc_dpp8,`module_name)
`endif 
iu3cdptx8 (
    .rst		(1'b0) ,
	.clk		(1'b0) ,
	.di			( crc_dpptx_in[7:0] ),
	.q			( crc_dpptx_q ),
	.crc_out	( crc_dpptx8_out )
);

// managing rx pipe integer
// monitor lcmd K 
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		link_cmd_det <= 0 ;
	end
	else if ( link_cmd_det && in_active ) begin
		link_cmd_det <= 0 ;
	end	
	else if (  ltssm_current_state == LT_U0 ) begin
		if ( {in_data, in_datak,in_active} == {32'hFEFEFEF7, 4'b1111,1'b1} ||   		// all good 
			 {in_data[23:0], in_datak[2:0],in_active} == {24'hFEFEF7, 3'b111,1'b1} ||	// bad good good good
			 {in_data[31:24],in_data[15:0], in_datak[3],in_datak[1:0],in_active} == {24'hFEFEF7, 3'b111,1'b1}  ||    // good bad good good 
			 {in_data[31:16],in_data[7:0], in_datak[3:2],in_datak[0],in_active} == {24'hFEFEF7, 3'b111,1'b1}   ||   // good good bad good 
			 {in_data[31:8], in_datak[3:1],in_active} == {24'hFEFEFE, 3'b111,1'b1}      // good good good bad
			) begin
			link_cmd_det <= 1 ;
		end
	end
end
// rx lcmd
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		in_link_command_act <= 0 ;
		u0_recovery_timeout_reset_on_rx_lcmd <= 0 ;
	end
	else if ( link_cmd_det && in_active ) begin
		in_link_command <= {in_data[23:16], in_data[31:24], in_data[7:0], in_data[15:8]} ;
		in_link_command_act <= 1 ;
		u0_recovery_timeout_reset_on_rx_lcmd <= 1 ;
	end
	else begin
		in_link_command_act <= 0 ;
		u0_recovery_timeout_reset_on_rx_lcmd <= 0 ;
	end
end
// monitor hp k 
wire [3:0] hp_valid_k ;
assign  hp_valid_k[0] = ( in_datak[0] & in_active ) ? (in_data[7+0*8:0+0*8] == 8'hF7)  : 0 ;
assign  hp_valid_k[1] = ( in_datak[1] & in_active ) ? (in_data[7+1*8:0+1*8] == 8'hFB)  : 0 ;
assign  hp_valid_k[2] = ( in_datak[2] & in_active ) ? (in_data[7+2*8:0+2*8] == 8'hFB)  : 0 ;
assign  hp_valid_k[3] = ( in_datak[3] & in_active ) ? (in_data[7+3*8:0+3*8] == 8'hFB)  : 0 ;

wire [2:0] hp_valid_k_cnt ;
assign hp_valid_k_cnt = hp_valid_k[0] + hp_valid_k[1] + hp_valid_k[2] + hp_valid_k[3] ; 

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		hp_det <= 0 ;
		crc_hprx_rst <= 0 ;
		u0_recovery_timeout_reset_on_rx_hp <= 0 ;
	end
	//else if ( {in_data, in_datak,in_active} == {32'hFBFBFBF7, 4'b1111,1'b1} && ltssm_current_state == LT_U0 && !wait_retry ) begin
	else if (  hp_valid_k_cnt >= 3 && ltssm_current_state == LT_U0  ) begin
		hp_det <= 1 ;
		crc_hprx_rst <= 1 ;
		u0_recovery_timeout_reset_on_rx_hp <= 1 ; 
	end	
	else if ( hp_det && in_active )begin
		hp_det <= 0 ;		
		crc_hprx_rst <= 0 ;
		u0_recovery_timeout_reset_on_rx_hp <= 0 ;
	end
	else begin
		u0_recovery_timeout_reset_on_rx_hp <= 0 ;  
	end
end
// rx hp
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		hp1_det <= 0 ;
	end
	else if  ( hp_det && in_active ) begin
		case ( rx_cred_idx ) 
		0: in_header_pkt_a0 <= swap32(in_data);
		1: in_header_pkt_b0 <= swap32(in_data);
		2: in_header_pkt_c0 <= swap32(in_data);
		3: in_header_pkt_d0 <= swap32(in_data);
		default:begin
		end
		endcase 	
		hp1_det <= 1 ;
	end
	else if (hp1_det && in_active ) begin
		hp1_det <= 0 ;
	end
end
always @ ( posedge local_clk  or negedge reset_n ) begin
	if ( !reset_n ) begin
		hp2_det <= 0 ;
	end	
	else if ( hp1_det && in_active ) begin
		case ( rx_cred_idx ) 
		0: in_header_pkt_a1 <= swap32(in_data) ;
		1: in_header_pkt_b1 <= swap32(in_data) ;
		2: in_header_pkt_c1 <= swap32(in_data) ;
		3: in_header_pkt_d1 <= swap32(in_data) ;
		default:begin
		end
		endcase 
		hp2_det <= 1 ;
	end
	else if ( hp2_det && in_active ) begin
		hp2_det <= 0 ;
	end
end
always @ ( posedge local_clk or negedge reset_n ) begin
	if (!reset_n) begin
		hp3_det <= 0 ;
	end
	else if ( hp2_det && in_active ) begin
		case ( rx_cred_idx ) 
		0: in_header_pkt_a2 <= swap32(in_data);
		1: in_header_pkt_b2 <= swap32(in_data);
		2: in_header_pkt_c2 <= swap32(in_data);
		3: in_header_pkt_d2 <= swap32(in_data);
		default:begin
		end
		endcase 
		hp3_det <= 1 ;
	end
	else if ( hp3_det && in_active )begin
		hp3_det <= 0 ;
	end
end
always @ ( posedge local_clk  or negedge reset_n ) begin
	if ( !reset_n ) begin
		in_header_act <= 0 ;
	end
	else if ( hp3_det && in_active ) begin
		in_header_crc <= {in_data[23:16], in_data[31:24]} ;
		in_header_cw <= {in_data[7:0], in_data[15:8]} ;
		in_header_act <= 1 ;
	end
	else begin
		in_header_act <= 0 ;
	end
end	
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		crc_hprx_in <= 0 ;
		crc_hprx_en <= 0 ;
	end
	else if ( (hp_det | hp1_det | hp2_det) && in_active ) begin
		crc_hprx_in <= swap32(in_data) ;
		crc_hprx_en <= 1 ;
	end
	else begin
		crc_hprx_en <= 0 ;
	end
end

// monitor dpp k  , counting rx dpp length 
always @ ( posedge local_clk ) begin 
	{in_data_1, in_datak_1,in_active_1} <= {in_data, in_datak,in_active};
	{in_data_2, in_datak_2,in_active_2} <= {in_data_1, in_datak_1,in_active_1};
	{in_data_3, in_datak_3,in_active_3} <= {in_data_2, in_datak_2,in_active_2};
	{in_data_4, in_datak_4,in_active_4} <= {in_data_3, in_datak_3,in_active_3};
end
// monitor dpp k  , counting rx dpp length 
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		dpp_det <= 0 ;
	end
	else if ( {in_data_3, in_datak_3,in_active_3} == {32'h5C5C5CF7, 4'b1111,1'b1} && ltssm_current_state == LT_U0) begin
		// wait buf_in_ready valid
		dpp_det <= 1 ;
	end
	else if ( dpp_det && in_active_3 )begin
		dpp_det <= 0 ;
	end
end
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		dpp_act_mask <= 0 ;
		prot_rx_dpp_start <= 0 ;
	end
	else if ( dpp_det ) begin
		in_dpp_wasready <= buf_in_ready ;
		buf_in_addr_rst <= 1 ;
		in_dpp_length <= 0 ;
		prot_rx_dpp_start <= 1 ;		
	end
	else if ( dpp_act ) begin
		buf_in_addr_rst <= 0 ;
		prot_rx_dpp_start <= 0 ;
		if ( in_active_4 ) begin
			in_dpp_length <= in_dpp_length + 4 ;
			if ( in_dpp_length + 4 >= in_dpp_length_expect  ) begin
				dpp_act_mask <= 1 ;
			end	
			else begin
				dpp_act_mask <= 0 ;			
			end
		end		
	end
	else begin
		dpp_act_mask <= 0 ;
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		dpp_act <= 0 ;
		wait_for_in_active <= 0 ;
	end
	else if ( dpp_det ) begin
		dpp_act <= 1 ;
		wait_for_in_active <= 0 ;
	end
	else if ( dpp_act && in_active_4 ) begin
		if ( in_dpp_length_expect[1:0] != 0 && in_dpp_length + 4 >= in_dpp_length_expect ) begin
			dpp_act <= 0 ;
			wait_for_in_active <= 1 ;
		end
		else if ( in_dpp_length_expect == 0 ) begin
			dpp_act <= 0 ; 
			wait_for_in_active <= 1 ;
		end
		else if ( in_dpp_length + 4 >= in_dpp_length_expect + 4 ) begin
			dpp_act <= 0 ;
			wait_for_in_active <= 1 ;
		end
	end
	else if ( wait_for_in_active && in_active_4 ) begin
		wait_for_in_active <= 0 ;
	end
end


// rx dpp 
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		buf_in_wren <= 0 ;
		crc_dpprx_en <= 0 ;
		buf_in_addr <= -1 ;
	end
	else if ( dpp_act && in_active_4 ) begin
		if ( !dpp_act_mask ) begin
			buf_in_data <= in_data_4 ;
			buf_in_wren <= in_dpp_wasready ;
			buf_in_addr <= buf_in_addr + 1 ;
			if ( buf_in_addr_rst ) begin
				buf_in_addr <= 0 ;
			end
		end
		else begin
			buf_in_wren <= 0 ;
		end
		
		crc_dpprx_in <= swap32(in_data_4) ;
		crc_dpprx_en <= 1 ;

	end
	else begin
		crc_dpprx_en <= 0 ;
		buf_in_wren <= 0 ;
	end
end

always @ ( posedge local_clk ) begin
	//if ( !dpp_act && dpp_act_d ) begin
	if ( wait_for_in_active && in_active_4 ) begin
		// leftover crc 
		swap32_in <= swap32(in_data_4) ;
	end
end

// check rx dpp crc
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		dpp_act_d <= 0 ;
		dpp_act_d2 <= 0 ;
		dpp_act_d3 <= 0 ;	
		wait_for_in_active_d <= 0 ;
		wait_for_in_active_d2 <= 0 ;
	end
	else begin
		dpp_act_d <= dpp_act ;
		dpp_act_d2 <= dpp_act_d ;	
		dpp_act_d3 <= dpp_act_d2 ;
		
		wait_for_in_active_d <= wait_for_in_active ;
		wait_for_in_active_d2 <= wait_for_in_active_d ;
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		rx_dpp_done <= 0 ;
		dpp_crc_good <= 0 ;
		prot_in_dpp_wasready <= 0 ;
	end
	else begin
		//if ( !dpp_act_d2 &&  dpp_act_d3 ) begin
		if ( !wait_for_in_active_d &&  wait_for_in_active_d2 ) begin
			rx_dpp_done <= 1 ;
			prot_in_dpp_wasready <= in_dpp_wasready ;
			if ( in_dpp_length_expect[1:0] == 0 && crc_dpprx32_out == 32'h2144DF1C ) begin
				dpp_crc_good <= 1 ;
			end
			else if ( in_dpp_length_expect[1:0] == 1 && crc_dpprx8_out == 32'h2144DF1C ) begin
				dpp_crc_good <= 1 ;
			end
			else if ( in_dpp_length_expect[1:0] == 2 && crc_dpprx16_out == 32'h2144DF1C ) begin
				dpp_crc_good <= 1 ;
			end
			else if ( in_dpp_length_expect[1:0] == 3 && crc_dpprx24_out == 32'h2144DF1C ) begin
				dpp_crc_good <= 1 ;
			end		
			else begin
				dpp_crc_good <= 0 ;
			end
		end
		else begin
			rx_dpp_done <= 0 ;
		end
	end
end
// commit rx dpp
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		prot_rx_dpp_done <= 0 ;
		prot_rx_dpp_crcgood <= 0 ;
		buf_in_commit <= 0 ;
		crc_dpprx_rst <= 1 ;
	end
	else if ( rx_dpp_done ) begin
		prot_rx_dpp_done <= 1 ;
		if ( dpp_crc_good ) begin
			prot_rx_dpp_crcgood <= 1 ;
		end
		else begin
			prot_rx_dpp_crcgood <= 0 ;
		end
		
		buf_in_commit <= in_dpp_wasready ;
		buf_in_commit_len <= in_dpp_length_expect ;		

		crc_dpprx_rst <= 1 ;
	end
	else begin	
		buf_in_commit <= 0 ;
		prot_rx_dpp_done <= 0 ;
		crc_dpprx_rst <= 0 ;
	end	
end
`ifdef SIM
usb3_crc_hp
`else
`getname(usb3_crc_hp,`module_name)
`endif 
iu3chprx (
	.clk		( local_clk ),
	.rst		( crc_hprx_rst ),
	.crc_en		( crc_hprx_en ),
	.di			( crc_hprx_in ),
	.crc_out	( crc_hprx_out )
);

`ifdef SIM
usb3_crc_cw
`else
`getname(usb3_crc_cw,`module_name)
`endif 
iu3ccw3 (
	.di			( in_header_cw[10:0] ),
	.crc_out	( crc_cw3_out )
);

`ifdef SIM
usb3_crc_dpp32_rx
`else
`getname(usb3_crc_dpp32_rx,`module_name)
`endif 
iu3cdprx32 (
	.clk		( local_clk ),
	.rst		( crc_dpprx_rst ),
	.crc_en		( crc_dpprx_en ),
	.di			( crc_dpprx_in ),
	.lfsr_q		( crc_dpprx_q ),
	.crc_out	( crc_dpprx32_out )
);

`ifdef SIM
usb3_crc_dpp24
`else
`getname(usb3_crc_dpp24,`module_name)
`endif 
iu3cdprx24 (
	.rst(1'b0),
	.clk(1'b0),
	.di			( swap32_in[23:0] ),
	.q			( crc_dpprx_q ),
	.crc_out	( crc_dpprx24_out )
);

`ifdef SIM
usb3_crc_dpp16
`else
`getname(usb3_crc_dpp16,`module_name)
`endif 
iu3cdprx16 (
	.rst(1'b0),
	.clk(1'b0),
	.di			( swap32_in[15:0] ),
	.q			( crc_dpprx_q ),
	.crc_out	( crc_dpprx16_out )
);

`ifdef SIM
usb3_crc_dpp8
`else
`getname(usb3_crc_dpp8,`module_name)
`endif 
iu3cdprx8 (
	.rst(1'b0),
	.clk(1'b0),
	.di			( swap32_in[7:0] ),
	.q			( crc_dpprx_q ),
	.crc_out	( crc_dpprx8_out )
);

// managing rx link cmd , rx header 
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		in_link_command_good <= 0 ;
		in_link_command_crc_good <= 0 ;
	end
	else if ( in_link_command_act ) begin
		if(	in_link_command[10:0] == in_link_command[26:16] ) begin		
			in_link_command_good <= 1 ; 
		end			
		if ( crc_cw1_out == in_link_command[31:27] && crc_cw2_out == in_link_command[15:11] ) begin
			in_link_command_crc_good <= 1 ;
		end
	end
	else begin
		in_link_command_good <= 0 ;
		in_link_command_crc_good <= 0 ;
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		in_link_command_latch_act <= 0 ;
	end
	else if ( in_link_command_good && in_link_command_crc_good ) begin
		in_link_command_latch <= in_link_command[10:0] ;
		in_link_command_latch_act <= 1 ;		
	end
	else begin
		in_link_command_latch_act <= 0 ;
	end
end		
always @ ( posedge local_clk  or negedge reset_n ) begin
	if ( !reset_n ) begin
		rx_lpma_act <= 0 ;
		tx_lau_act <= 0 ;
		tx_hdr_seq_num_adv <= 0 ;
		rx_lau_act <= 0 ;
		rx_retry <= 0 ;
	end
	else if ( ltssm_enter_u0 ) begin
		recv_u0_adv <= 0 ;
		err_lgood_order <= 0 ;
		err_lcrd_mismatch <= 0 ;
		if ( ltssm_last_state == LT_POLLING_IDLE ) begin
			ack_tx_hdr_seq_num <= 0 ;
		end
		tx_cred_idx <= 0 ;
		tx_lau_act <= 0 ; 
		err_lbad_recv <= 0 ;
		rx_lpma_act <= 0 ;
	end
	else if ( ltssm_exit_u0 ) begin
		err_lgood_order <= 0 ;
		err_lcrd_mismatch <= 0 ;
	end
	else if ( in_link_command_latch_act ) begin 
		if ( queue_send_u0_adv && recv_u0_adv ) begin
			if (in_link_command_latch[10:3] == LCMD_LGOOD_0[10:3]  ) begin
				if(ack_tx_hdr_seq_num != in_link_command_latch[2:0]) begin
					// out of order
					err_lgood_order <= 1;
				end
				else begin
					ack_tx_hdr_seq_num <= ack_tx_hdr_seq_num + 1 ;
					pending_hp_timer_reset_on_rx_lgood <= 1 ;
				end
			end
			else if( in_link_command_latch[10:2] == LCMD_LCRD_A[10:2] ) begin
				// LCRD, after U0 advertisement
				if(remote_rx_cred_count > 3) begin
					// mismatch, remote had too many credits
					err_lcrd_mismatch <= 1;
				end 
				else if(tx_cred_idx != in_link_command_latch[1:0]) begin
					// out of sequence
					err_lcrd_mismatch <= 1;
				end 
				else begin
					tx_cred_idx <= tx_cred_idx + 1 ;
					remote_rx_cred_count_inc <= 1 ;
					credit_hp_timer_reset_on_rx_lcrd <= 1 ;
				end
			end
			else if ( in_link_command_latch [10:2] == LCMD_LGO_U1[10:2] ) begin
				tx_lau_act <= 1 ;
				lgo_latch <= in_link_command_latch[1:0] ;
			end
			else if ( in_link_command_latch[10:0] == LCMD_LPMA ) begin
				rx_lpma_act <= 1 ;
			end
			else if ( in_link_command_latch[10:0] == LCMD_LAU ) begin
				rx_lau_act <= 1 ;
			end
			else if ( in_link_command_latch [10:0] == LCMD_LBAD ) begin
				err_lbad_recv <= 1 ;
			end
			else if ( in_link_command_latch [10:0] == LCMD_LRTY ) begin
				rx_retry <= 1 ;
			end
		end
		else if ( !recv_u0_adv ) begin
			case ( in_link_command_latch[10:0] ) 
			LCMD_LGOOD_0: begin tx_hdr_seq_num_adv <= 1; ack_tx_hdr_seq_num <= 1 ; end
			LCMD_LGOOD_1: begin tx_hdr_seq_num_adv <= 1; ack_tx_hdr_seq_num <= 2 ; end
			LCMD_LGOOD_2: begin tx_hdr_seq_num_adv <= 1; ack_tx_hdr_seq_num <= 3 ; end
			LCMD_LGOOD_3: begin tx_hdr_seq_num_adv <= 1; ack_tx_hdr_seq_num <= 4 ; end
			LCMD_LGOOD_4: begin tx_hdr_seq_num_adv <= 1; ack_tx_hdr_seq_num <= 5 ; end
			LCMD_LGOOD_5: begin tx_hdr_seq_num_adv <= 1; ack_tx_hdr_seq_num <= 6 ; end
			LCMD_LGOOD_6: begin tx_hdr_seq_num_adv <= 1; ack_tx_hdr_seq_num <= 7 ; end
			LCMD_LGOOD_7: begin tx_hdr_seq_num_adv <= 1; ack_tx_hdr_seq_num <= 0 ; end
			
			LCMD_LCRD_A : begin
				remote_rx_cred_count_inc <= 1 ;
			end
			LCMD_LCRD_B : begin
				remote_rx_cred_count_inc <= 1 ;
			end	
			LCMD_LCRD_C : begin
				remote_rx_cred_count_inc <= 1 ;
			end
			LCMD_LCRD_D : begin
				remote_rx_cred_count_inc <= 1 ;
				recv_u0_adv <= 1 ;
			end
			default:begin
			end
			endcase 
		end			
		else begin
			remote_rx_cred_count_inc <= 0 ;	
			credit_hp_timer_reset_on_rx_lcrd <= 0 ;
			pending_hp_timer_reset_on_rx_lgood <= 0 ;
			err_lbad_recv <= 0 ;
			rx_lpma_act <= 0 ;
			tx_hdr_seq_num_adv <= 0;
		end	
	end
	else begin
		remote_rx_cred_count_inc <= 0 ;
		tx_lau_act <= 0 ;
		pending_hp_timer_reset_on_rx_lgood <= 0 ;
		credit_hp_timer_reset_on_rx_lcrd <= 0 ;
		rx_lpma_act <= 0 ;
		tx_hdr_seq_num_adv <= 0 ;
		rx_lau_act <= 0 ;
		rx_retry <= 0 ;
		err_lbad_recv <= 0 ;
		err_lgood_order <= 0 ;
		err_lcrd_mismatch <= 0 ;
	end
end
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		hp_crc_good <= 0 ;
		tx_lgood_on_rx_valid_header <= 0 ;
		local_rx_cred_count_dec <= 0 ;
		err_lbad <= 0 ;
		rx_hdr_seq_num <= 0 ;
	end
	else if ( ltssm_enter_u0 ) begin
		rx_cred_idx <= 0 ;
		err_hp_seq <= 0 ;
		if ( ltssm_last_state == LT_POLLING_IDLE || ltssm_last_state == LT_HOTRESET_EXIT ) begin
			rx_hdr_seq_num <= 0 ;
		end
	end
	else if ( ltssm_exit_u0 ) begin
		err_hp_seq <= 0 ;
		err_lbad <= 0 ;
	end
	else if ( in_header_act && !wait_retry ) begin
		if ( crc_hprx_out == in_header_crc && crc_cw3_out == in_header_cw[15:11] ) begin
			if( in_header_cw[2:0] == rx_hdr_seq_num && local_rx_cred_count > 0) begin
				// header seq num matches what we expect
				hp_crc_good <= 1 ;
				
				tx_lgood_on_rx_valid_header <= 1 ;  
				
				rx_cred_idx <= rx_cred_idx + 1 ;
				rx_cred_idx_latch <= rx_cred_idx ;
				
				local_rx_cred_count_dec <= 1 ;
				
				rx_hdr_seq_num <= rx_hdr_seq_num + 1 ;
									
			end 
			else begin
				err_hp_seq <= 1;
			end					
		end
		else begin
			err_lbad <= 1;				
		end
	end
	else begin
		hp_crc_good <= 0 ;
		tx_lgood_on_rx_valid_header <= 0 ;
		local_rx_cred_count_dec <= 0 ;	
		err_lbad <= 0 ;
		err_hp_seq <= 0 ;
	end
end

always @ ( posedge local_clk  ) begin
	if ( hp_crc_good ) begin
		in_header_pkt_latch_act <= 1 ;
		if ( rx_cred_idx_latch == 0 ) begin
			in_header_pkt_latch <= {in_header_pkt_a2,in_header_pkt_a1,in_header_pkt_a0}; 
		end
		else if ( rx_cred_idx_latch == 1 ) begin
			in_header_pkt_latch <= {in_header_pkt_b2,in_header_pkt_b1,in_header_pkt_b0};
		end
		else if ( rx_cred_idx_latch == 2 ) begin
			in_header_pkt_latch <= {in_header_pkt_c2,in_header_pkt_c1,in_header_pkt_c0};
		end					
		else if ( rx_cred_idx_latch == 3 ) begin
			in_header_pkt_latch <= {in_header_pkt_d2,in_header_pkt_d1,in_header_pkt_d0};
		end		
	end
	else begin
		in_header_pkt_latch_act <= 0 ;
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		tx_lcrd_on_parsed_header <= 0 ;
		prot_rx_tp <= 0 ;
		prot_rx_dph <= 0 ;
		force_LinkPM_accept <= 0 ;
		u2_inact_timeout_set <= 0 ;
		itp_recieved <= 0 ;
	end
	else if ( ltssm_enter_u0 ) begin
		send_port_cfg_resp <= 0 ;
		recv_port_cmdcfg <= 0 ;
	end
	else if ( in_header_pkt_latch_act  ) begin		
		tx_lcrd_on_parsed_header <= 1 ;			
		if ( in_header_pkt_latch[4:0] == LP_TYPE_LMP ) begin
			if ( in_header_pkt_latch [8:5] == LP_LMP_SUB_SETLINK ) begin
				force_LinkPM_accept <= in_header_pkt_latch[10] ;
			end
			else if ( in_header_pkt_latch [8:5] == LP_LMP_SUB_U2INACT ) begin
				T_PORT_U2_TIMEOUT <= in_header_pkt_latch[16:9] * 32000 ;
				u2_inact_timeout_set <= 1 ;
			end
			else if ( in_header_pkt_latch [8:5] == LP_LMP_SUB_VENDTEST) begin
			end
			else if ( in_header_pkt_latch [8:5] == LP_LMP_SUB_PORTCAP ) begin
				recv_port_cmdcfg[1] <= 1'b1; 
			end
			else if ( in_header_pkt_latch [8:5] == LP_LMP_SUB_PORTCFG ) begin
				send_port_cfg_resp <= 1;
				recv_port_cmdcfg[0] <= 1'b1;					
			end	
			else if ( in_header_pkt_latch [8:5] == LP_LMP_SUB_PORTCFGRSP ) begin					
			end						
		end
		else if ( in_header_pkt_latch[4:0] == LP_TYPE_TP ) begin
			prot_rx_tp <= 1;
			prot_rx_tp_hosterr	<= in_header_pkt_latch[(15+32)];
			prot_rx_tp_retry	<= in_header_pkt_latch[( 6+32)];
			prot_rx_tp_pktpend	<= in_header_pkt_latch[(27+64)];
			prot_rx_tp_subtype	<= in_header_pkt_latch[( 3+32):( 0+32)];
			prot_rx_tp_endp		<= in_header_pkt_latch[(11+32):( 8+32)];
			prot_rx_tp_nump		<= in_header_pkt_latch[(20+32):(16+32)];
			prot_rx_tp_seq		<= in_header_pkt_latch[(25+32):(21+32)];
			prot_rx_tp_stream	<= in_header_pkt_latch[79:64];						
		end
		else if ( in_header_pkt_latch[4:0] == LP_TYPE_DP  ) begin
			in_dpp_length_expect	<= in_header_pkt_latch[(31+32):(16+32)];
			// pass the Data Packet Header info onto protocol layer
			prot_rx_dph <= 1;
			prot_rx_dph_eob		<= in_header_pkt_latch[( 6+32)];
			prot_rx_dph_setup	<= in_header_pkt_latch[(15+32)];
			prot_rx_dph_pktpend	<= in_header_pkt_latch[(27+64)];
			prot_rx_dph_endp	<= in_header_pkt_latch[(11+32):( 8+32)];
			prot_rx_dph_seq		<= in_header_pkt_latch[( 4+32):( 0+32)];
			prot_rx_dph_len		<= in_header_pkt_latch[(31+32):(16+32)];			
		end
		else if ( in_header_pkt_latch[4:0]  == LP_TYPE_ITP ) begin
			itp_value <= in_header_pkt_latch[31:5];	
			itp_recieved <= 1 ;
		end
	end
	else begin
		prot_rx_tp <= 0 ;
		prot_rx_dph <= 0 ;
		tx_lcrd_on_parsed_header <= 0 ;	
		itp_recieved <= 0 ;
		u2_inact_timeout_set <= 0 ;
	end
end	

`ifdef SIM
usb3_crc_cw
`else
`getname(usb3_crc_cw,`module_name)
`endif iu3ccw1 (
	.di			( in_link_command[26:16] ),
	.crc_out	( crc_cw1_out )
);

`ifdef SIM
usb3_crc_cw
`else
`getname(usb3_crc_cw,`module_name)
`endif 
iu3ccw2 (
	.di			( in_link_command[10:0] ),
	.crc_out	( crc_cw2_out )
);
// managing local / remote rx credit count 
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		remote_rx_cred_count <= 0 ;
	end
	else begin
		if ( ltssm_enter_u0 ) begin
			remote_rx_cred_count <= 0 ;
		end
		else if ( remote_rx_cred_count_inc && remote_rx_cred_count_dec )begin
			remote_rx_cred_count <= remote_rx_cred_count ;
		end
		else if ( remote_rx_cred_count_inc && !remote_rx_cred_count_dec ) begin
			remote_rx_cred_count <= remote_rx_cred_count + 1  ;
		end
		else if ( !remote_rx_cred_count_inc && remote_rx_cred_count_dec) begin
			remote_rx_cred_count <= remote_rx_cred_count - 1  ; 
		end
	
	end

end
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		local_rx_cred_count <= 4 ;
	end
	else begin
		if ( ltssm_enter_u0 ) begin
			local_rx_cred_count <= 4 ;
		end
		else if ( local_rx_cred_count_inc && local_rx_cred_count_dec ) begin
			local_rx_cred_count <= local_rx_cred_count ;
		end	
		else if ( local_rx_cred_count_inc && !local_rx_cred_count_dec ) begin
			local_rx_cred_count <= local_rx_cred_count + 1 ;
		end
		else if ( !local_rx_cred_count_inc && local_rx_cred_count_dec ) begin
			local_rx_cred_count <= local_rx_cred_count - 1  ;
		end
		
	end
end
//  managing timers 
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		pending_hp_timer_act <= 0 ;
		pending_hp_timer_rst <= 1 ;
		
		credit_hp_timer_act <= 0 ;
		credit_hp_timer_rst <= 1 ;
		
		u0_recovery_timeout_act <= 0 ;
		u0_recovery_timeout_rst <= 1 ;
		
		port_config_timeout_act <= 0 ;
		
		u0l_timeout_act <= 0 ;
		u0l_timeout_rst <= 1 ;

		u2_timeout_act <= 0 ;
		u2_timeout_rst <= 0 ;
		
	end
	else begin
		if ( ltssm_current_state != LT_U0 ) begin
			pending_hp_timer_act <= 0 ;
			pending_hp_timer_rst <= 1 ;
		end
		else begin
			pending_hp_timer_act <= 1 ;
			if ( tx_hdr_seq_num == ack_tx_hdr_seq_num  ) begin
				pending_hp_timer_rst <= 1 ;
			end
			else if ( pending_hp_timer_reset_on_rx_lgood ) begin
				pending_hp_timer_rst <= 1 ;
			end
			else begin
				pending_hp_timer_rst <= 0 ;
			end
		end
		
		if ( ltssm_current_state != LT_U0 ) begin
			credit_hp_timer_act <= 0 ;
			credit_hp_timer_rst <= 1 ;
		end
		else begin
			credit_hp_timer_act <= 1 ;
			if ( remote_rx_cred_count == 4 && recv_u0_adv ) begin
				credit_hp_timer_rst <= 1 ;
			end
			else if ( credit_hp_timer_reset_on_rx_lcrd ) begin
				credit_hp_timer_rst <= 1; 
			end
			else begin
				credit_hp_timer_rst <= 0 ;
			end
		end
		
		if ( ltssm_current_state != LT_U0 ) begin
			u0_recovery_timeout_act <= 0 ;
			u0_recovery_timeout_rst <= 1 ;
		end
		else begin
			u0_recovery_timeout_act <= 1 ;
			if ( u0_recovery_timeout_reset_on_rx_lcmd ||
				 u0_recovery_timeout_reset_on_rx_hp
				) begin
				u0_recovery_timeout_rst <= 1 ;
			end
			else begin
				u0_recovery_timeout_rst <= 0 ;
			end
		end
		
		if ( ltssm_current_state == LT_U1 ) begin
			u2_timeout_act <= 1 ;
		end
		else begin
			u2_timeout_act <= 0 ;
		end
 	
		if ( ltssm_current_state != LT_U0 ) begin
			port_config_timeout_act <= 0 ;
		end
		else begin
			port_config_timeout_act <= 1 ; 
		end
	
		if ( ltssm_current_state != LT_U0 ) begin
			u0l_timeout_act <= 0 ;
			u0l_timeout_rst <= 1 ;
		end
		else begin
			u0l_timeout_act <= 1 ;
			if ( tx_link_busy ) begin
				u0l_timeout_rst <= 1 ;
			end
			else begin
				u0l_timeout_rst <= 0 ;
			end
		end
		
		
	
	end
end

 
always @ ( posedge local_clk or negedge reset_n  ) begin
	if ( !reset_n ) begin
		pending_hp_timer <= 0 ;
		credit_hp_timer <= 0 ;
		u0_recovery_timeout <= 0 ;
		port_config_timeout <= 0 ;
		ltssm_go_disabled <= 0 ;
	end
	else begin
		//if ( pending_hp_timer_act ) begin
		//	pending_hp_timer <= pending_hp_timer + 1 ;
		//	if ( pending_hp_timer_rst ) begin
		//		pending_hp_timer <= 0 ;
		//	end
		//	else if ( pending_hp_timer == T_PENDING_HP ) begin
		//		pending_hp_timer <= T_PENDING_HP ;
		//	end
		//end
		//else begin
		//	pending_hp_timer <= 0 ;
		//end

		//if ( credit_hp_timer_act ) begin
		//	credit_hp_timer <= credit_hp_timer + 1 ;
		//	if ( credit_hp_timer_rst ) begin
		//		credit_hp_timer <= 0 ;
		//	end
		//	else if ( credit_hp_timer == T_CREDIT_HP ) begin
		//		credit_hp_timer <= T_CREDIT_HP ;
		//	end
		//end
		//else begin
		//	credit_hp_timer <= 0 ;
		//end
		
		if ( u0_recovery_timeout_act ) begin
			u0_recovery_timeout <= u0_recovery_timeout + 1 ;
			if ( u0_recovery_timeout_rst ) begin
				u0_recovery_timeout <= 0 ;
			end
			else if ( u0_recovery_timeout == T_U0_RECOVERY ) begin
				u0_recovery_timeout <= T_U0_RECOVERY ;
			end
		end
		else begin
			u0_recovery_timeout <= 0 ;
		end
		
		//if ( u2_timeout_act ) begin
		//	u2_timeout <= u2_timeout + 1 ;
		//	if ( u2_timeout_rst ) begin
		//		u2_timeout <=  0 ;
		//	end
		//	else if ( u2_timeout == T_PORT_U2_TIMEOUT ) begin
		//		u2_timeout <= T_PORT_U2_TIMEOUT ;
		//		ltssm_go_u2 <= 1 ;
		//	end
		//	else begin
		//		ltssm_go_u2 <=  0 ;		
		//	end
		//end
		//else begin
		//	u2_timeout <= 0 ;
		//end
		

		
		//if ( port_config_timeout_act ) begin
		//	port_config_timeout <= port_config_timeout + 1 ;
		//	if ( port_config_timeout == T_PORT_CONFIG ) begin
		//		port_config_timeout <= T_PORT_CONFIG ;
		//		if ( recv_port_cmdcfg != 2'b11 ) begin
		//			ltssm_go_disabled <= 1 ;
		//		end
		//		else begin
		//			ltssm_go_disabled <= 0 ;
		//		end
		//	end
		//end	
		//else begin
		//	port_config_timeout <= 0 ;
		//end
	end
end



always @ ( posedge local_clk or negedge reset_n  ) begin
	if ( !reset_n ) begin
		tx_lup_act <= 0 ;
	end
	else begin	
		if ( u0l_timeout_act ) begin
			u0l_timeout <= u0l_timeout + 1 ;
			if ( u0l_timeout_rst ) begin
				u0l_timeout <= 0 ;
			end
			else if ( u0l_timeout == T_U0L_TIMEOUT ) begin
				u0l_timeout <= 0 ;
				tx_lup_act <= 1 ;
			end
			else begin
				tx_lup_act <=  0;				
			end
		end
		else begin
			u0l_timeout <= 0 ;
		end
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if (!reset_n) begin
		u2_timeout <= 0 ;
		ltssm_go_u2 <= 0 ;
	end
	else if ( u2_timeout_act ) begin
		u2_timeout <= u2_timeout + 1 ;
		if ( u2_timeout == T_PORT_U2_TIMEOUT ) begin
			u2_timeout <= T_PORT_U2_TIMEOUT ;
			ltssm_go_u2 <= 1 ;
		end
		else begin
			ltssm_go_u2 <=  0 ;		
		end
	end
	else begin
		u2_timeout <= 0 ;
		ltssm_go_u2 <= 0 ;
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if (!reset_n) begin
		ltssm_go_u2_d <= 0 ;
	end
	else begin
		ltssm_go_u2_d <= ltssm_go_u2 ;
	end
end


// managing go recovery

reg err_hp_seq_latch 			 ;
reg err_lgood_order_latch 		 ; 
reg err_lcrd_mismatch_latch  ;

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		err_hp_seq_latch <= 0 ;
		err_lgood_order_latch <= 0 ; 
		err_lcrd_mismatch_latch <= 0 ;
	end
	else if ( ltssm_go_recovery ) begin
		err_hp_seq_latch <= 0 ;
		err_lgood_order_latch <= 0 ; 
		err_lcrd_mismatch_latch <= 0 ;
	end
	else begin
		err_hp_seq_latch 				<= ( err_hp_seq ) ? 1 : err_hp_seq_latch ;
		err_lgood_order_latch 			<= ( err_lgood_order ) ? 1 : err_lgood_order_latch ; 
		err_lcrd_mismatch_latch 		<= ( err_lcrd_mismatch ) ? 1 : err_lcrd_mismatch_latch ;				
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		ltssm_go_recovery <= 0 ;
	end
	else if ( ltssm_enter_u0 ) begin
		ltssm_go_recovery <= 0 ; 
	end
	else if ( ltssm_exit_u0 ) begin
		ltssm_go_recovery <= 0 ;
	end
	else begin
		ltssm_go_recovery <= 0 ;
		if ( u0_recovery_timeout == T_U0_RECOVERY ) begin
			ltssm_go_recovery <= 1 ;
		end
		else if ( credit_hp_timer == T_CREDIT_HP &&  !tx_link_busy ) begin
			ltssm_go_recovery <= 1 ;
		end
		else if ( pending_hp_timer == T_PENDING_HP && !tx_link_busy ) begin
			ltssm_go_recovery <= 1 ;
		end	
		else if ( err_lbad_recv	 ) begin
			ltssm_go_recovery <= 1 ; 
		end
		else if ( (err_hp_seq_latch | err_lgood_order_latch | err_lcrd_mismatch_latch  ) && !tx_link_busy && !tx_lcmd_req && !tx_hp_req ) begin
			ltssm_go_recovery <= 1 ; 
		end
	end 

end

reg err_lbad_recv_latch ;
reg err_lbad_recv_latch_2 ;
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		err_lbad_recv_latch <= 0 ;
	end	
	else if ( err_lbad_recv )  begin
		err_lbad_recv_latch <= 1 ;
	end
	else if ( ltssm_exit_u0 ) begin
		err_lbad_recv_latch <= 0 ;
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		err_lbad_recv_latch_2 <= 0 ;
	end
	else if ( ltssm_exit_u0 ) begin
		err_lbad_recv_latch_2 <= err_lbad_recv_latch ;
	end
	else if ( prot_rx_tp_retry ) begin 
		err_lbad_recv_latch_2 <= 0 ;
	end
	else if ( resend_hp_act ) begin
		err_lbad_recv_latch_2 <= 0 ;
	end
end



//managing link error
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		wait_retry <= 0 ;
	end
	else if ( !wait_retry & tx_lbad_act ) begin
		wait_retry <= 1 ;
	end
	else if ( wait_retry & rx_retry ) begin
		wait_retry <= 0 ;
	end
	else if ( wait_retry & ltssm_current_state != LT_U0 ) begin
		wait_retry <= 0 ;
	end
end
	

// managing low power state  
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		ltssm_go_u[2:0] <= 0 ;
		set_device_low_power_state_ack <= 0 ;
	end
	else if ( ltssm_current_state == LT_U1 ) begin
		ltssm_go_u[2:0] <= 0 ; 
	end	
	else if ( ltssm_current_state == LT_U2 ) begin
		ltssm_go_u[2:0] <= 0 ; 
	end
	else if ( ltssm_current_state == LT_U3 ) begin
		ltssm_go_u[2:0] <= 0 ; 
	end
	else begin
		set_device_low_power_state_ack <= 0 ;
		if (  tx_lau_act ) begin
			ltssm_go_u[2:0]  <= {1'b0,lgo_latch[1:0]};
		end
		else if ( rx_lpma_act ) begin
			ltssm_go_u[2] <= 1 ;
			//ltssm_go_u[2] <= 0 ;
		end
		else if ( tx_lpma_act && send_lcmd_state == SEND_LCMD_DONE ) begin
			ltssm_go_u[2] <= 1 ; 
		end
		else if ( ltssm_go_u2 && !ltssm_go_u2_d  ) begin
			ltssm_go_u[2:0]  <= {1'b1,2'b10} ;		
		end
		else if ( set_device_low_power_state ) begin
			ltssm_go_u[2:0] <= {1'b0,2'b11} ;
			set_device_low_power_state_ack <= 1 ;
		end
	end
end

assign tx_lgo_act = set_device_low_power_state && set_device_low_power_state_ack ;


//managing resending HPs
wire res_mem_wr_en = ( ( tx_sel_d_2 == 1 || tx_sel_d_2 == 2 ) && outp_active ) ;
reg res_mem_rd_en  ;
wire [32+4-1:0] res_mem_wr_dat = {outp_data,outp_datak} ;
reg [10:0] res_mem_wr_addr; 
reg [10:0] res_mem_rd_addr; 
reg [10:0] res_mem_wr_cnt [0:3] ;
reg [1:0] res_mem_wr_pt ;
reg [1:0] res_mem_rd_pt ;
reg [2:0] hp_seq_mem [0:3] ;
reg [32 + 4 - 1 : 0 ] res_mem_0 [0:2047] ;	
reg [32 + 4 - 1 : 0 ] res_mem_1 [0:2047] ;	
reg [32 + 4 - 1 : 0 ] res_mem_2 [0:2047] ;	
reg [32 + 4 - 1 : 0 ] res_mem_3 [0:2047] ;	
reg [4:0] resend_hp_num ;
reg resend_hp_act ; 

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		res_mem_wr_addr  <= 0 ;
	end
	else if ( res_mem_wr_en ) begin
		res_mem_wr_addr <= res_mem_wr_addr + 1 ;
		if ( tx_sel_d_2 == 1 && tx_sel_d == 0  ) begin
			res_mem_wr_addr <= 0 ;
			res_mem_wr_cnt[res_mem_wr_pt] <= res_mem_wr_addr + 1;
		end
		else if ( tx_sel_d_2 == 2 && tx_sel_d == 0 ) begin
			res_mem_wr_addr <= 0 ;
			res_mem_wr_cnt[res_mem_wr_pt] <= res_mem_wr_addr + 1 ;
		end
	end
end


always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		res_mem_wr_pt <= 0 ;
	end	
	else if ( tx_sel_d_2 == 1 && tx_sel_d == 0 ) begin
		res_mem_wr_pt <= res_mem_wr_pt + 1 ;
	end
	else if ( tx_sel_d_2 == 2 && tx_sel_d == 0 ) begin
		res_mem_wr_pt <= res_mem_wr_pt + 1 ; 
	end
end
	


always @ ( posedge local_clk ) begin
	if ( res_mem_wr_en && res_mem_wr_pt == 0 ) begin
		res_mem_0[res_mem_wr_addr] <= res_mem_wr_dat ;
	end
end
always @ ( posedge local_clk ) begin
	if ( res_mem_wr_en && res_mem_wr_pt == 1 ) begin
		res_mem_1[res_mem_wr_addr] <= res_mem_wr_dat ;
	end
end
always @ ( posedge local_clk ) begin
	if ( res_mem_wr_en && res_mem_wr_pt == 2 ) begin
		res_mem_2[res_mem_wr_addr] <= res_mem_wr_dat ;
	end
end
always @ ( posedge local_clk ) begin
	if ( res_mem_wr_en && res_mem_wr_pt == 3 ) begin
		res_mem_3[res_mem_wr_addr] <= res_mem_wr_dat ;
	end
end

wire [2:0] ack_tx_hdr_seq_num_dec = ack_tx_hdr_seq_num - 1 ;
wire [2:0] tx_hdr_seq_num_dec = tx_hdr_seq_num - 1 ; 

reg [2:0] tx_hdr_seq_num_dec_latch ;
always @ ( posedge local_clk ) begin
	if ( err_lbad_recv )  begin
		tx_hdr_seq_num_dec_latch <= tx_hdr_seq_num_dec ;
	end
end


always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n  ) begin
		resend_hp_act <= 0 ;
	end
	else if ( err_lbad_recv_latch_2 && recv_u0_adv && queue_send_u0_adv ) begin
		resend_hp_act <= 1 ;
		if ( tx_hdr_seq_num_dec >= ack_tx_hdr_seq_num_dec ) begin
			resend_hp_num <= tx_hdr_seq_num_dec - ack_tx_hdr_seq_num_dec  ;
		end
		else begin
			resend_hp_num <= {1'b1,tx_hdr_seq_num_dec} - {1'b0,ack_tx_hdr_seq_num_dec}   ;
		end		
	end
	else begin
		resend_hp_act <= 0 ;
	end
end




always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n  ) begin
		res_state <= ST_RES_IDLE ;
	end
	else begin
		case ( res_state ) 
		ST_RES_IDLE: begin
			if ( resend_hp_act ) begin
				res_mem_rd_pt <= res_mem_wr_pt - resend_hp_num ;
				res_state <= ST_RES_REQ ;
			end
			res_mem_rd_addr <= 0 ;
			res_mem_rd_en <= 0 ;
			tx_res_req <= 0 ;
		end
		ST_RES_REQ: begin
			if ( tx_lgood_empty && tx_lcrd_empty  ) begin
				tx_res_req <= 1 ;
				res_state <= ST_RES_ACK;
			end
		end 
		ST_RES_ACK: begin
			if ( tx_res_req_ack ) begin
				tx_res_req <= 0 ;							
				res_mem_rd_en <= 1 ;
				res_mem_rd_addr <= 0 ;
				res_state <= ST_RES_SEND ;	
			end
		end 		
		ST_RES_SEND: begin
			res_mem_rd_addr <= res_mem_rd_addr + 1 ;
			if ( res_mem_rd_addr + 1 >= res_mem_wr_cnt[res_mem_rd_pt] ) begin
				res_mem_rd_addr <= 0 ;
				res_mem_rd_en <= 0 ;				
				res_state <= ST_RES_DONE ;
			end
		end
		ST_RES_DONE: begin
			res_mem_rd_pt <= res_mem_rd_pt + 1 ;
			if ( res_mem_rd_pt + 1 >= res_mem_wr_pt ) begin
				res_state <= ST_RES_IDLE ;
			end
			else begin
				res_state <= ST_RES_REQ ;
			end		
		end
		default:;
		endcase
	end
end



always @ ( posedge local_clk  ) begin
	res_mem_rd_dat_val <= res_mem_rd_en ;
	{ out_data_5 , out_datak_5 , out_active_5 } <=  { res_mem_rd_dat , res_mem_rd_dat_val } ;
end


always @ ( posedge local_clk  ) begin
	case ( res_mem_rd_pt )
	0:res_mem_rd_dat <= res_mem_0 [res_mem_rd_addr];
	1:res_mem_rd_dat <= res_mem_1 [res_mem_rd_addr];
	2:res_mem_rd_dat <= res_mem_2 [res_mem_rd_addr];
	3:res_mem_rd_dat <= res_mem_3 [res_mem_rd_addr];
	default:;
	endcase 
end




//debug
reg [3:0] in_active_low_cnt ;
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n  ) begin
		in_active_low_cnt <= 0 ;
	end
	else if ( ltssm_current_state == 16 && in_active == 0 ) begin
		in_active_low_cnt <= in_active_low_cnt + 1 ;
		if ( in_active_low_cnt[2] == 1 ) begin
			in_active_low_cnt <= in_active_low_cnt ;
		end
	end
	else if ( ltssm_current_state == 16 && in_active == 1 ) begin
		in_active_low_cnt <= 0 ;
	end
end	

wire in_active_too_many_low = in_active_low_cnt[2] ;

reg[7:0] enter_u0_cnt ;
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n  ) begin
		enter_u0_cnt <= 0 ;
	end
	else if ( ltssm_enter_u0 ) begin
		enter_u0_cnt <= enter_u0_cnt + 1 ;
		if( enter_u0_cnt[7] == 1 ) begin
			enter_u0_cnt <= enter_u0_cnt ;
		end
	end
end


reg [7:0] in_data_err_cnt ;
reg in_data_err ;
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n  ) begin
		in_data_err_cnt <= 0 ;
		in_data_err <= 0 ;
	end
	else if ( ltssm_current_state == 16  && !dpp_act ) begin
		if ( in_active && in_data == 0 ) begin
			in_data_err_cnt <= 0 ;
		end
		else if ( in_active && in_data != 0 ) begin
			in_data_err_cnt <= in_data_err_cnt + 1 ;
			if ( in_data_err_cnt > 100 ) begin
				in_data_err <= 1 ;
				in_data_err_cnt <= in_data_err_cnt ;
			end
		end
	end
end
	
	
reg link_err ;
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n  ) begin
		link_err <= 0 ;
	end
	else if ( rx_dpp_done && !dpp_crc_good ) begin
		link_err <= 1 ; 
	end
	else if ( err_lgood_order ) begin
		link_err <= 1 ; 
	end
	else if ( err_lcrd_mismatch ) begin
		link_err <= 1 ; 
	end
	else if ( err_lbad_recv ) begin
		link_err <= 1 ; 
	end
	else if ( err_hp_seq ) begin
		link_err <= 1 ; 
	end
	else if ( err_lbad ) begin
		link_err <= 1 ; 
	end
	else begin
		link_err <= 0 ;
	end
end			

reg err_lbad_reg ;
reg [2:0] rx_hdr_seq_num_reg ;
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n  ) begin
		err_lbad_reg <= 0 ;
	end
	else if ( err_lbad ) begin
		err_lbad_reg <= 1 ;
		rx_hdr_seq_num_reg <= rx_hdr_seq_num ;
	end
end
	
	



endmodule