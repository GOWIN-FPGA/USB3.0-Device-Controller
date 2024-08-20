`include "UVCDefine.v" 
module DataTransfer
(
	 input wire	clk
	,input wire	rst_n
	
	,input wire [7:0]	current_config_value
	
	,input wire 		set_interface
	,input wire [15:0]	set_interface_num 
	,input wire [15:0] 	set_interface_alt_setting
	,input wire 	  	host_requests_data_from_endpt
	,input wire [3:0] 	host_requests_endpt_num      

	
	,input wire				itp_recieved

	,output reg				cam_active 
	,input wire				cam_de_active
	,input wire 			yuv_fifo_empty 
	,input wire	[15:0]		yuv_fifo_num 
	,input wire [31:0] 		yuv_data 
	,output reg				yuv_data_pop 

	//  ep1 IN 
	,output	reg		[31:0]	ep1_in_buf_data
	,output	reg				ep1_in_buf_wren
	,input	wire			ep1_in_buf_ready
	,output	reg				ep1_in_buf_data_commit
	,output	reg		[10:0]	ep1_in_buf_data_commit_len
	
	// ep2 IN 
	,output	reg		[31:0]	ep2_in_buf_data
	,output	reg				ep2_in_buf_wren
	,input	wire			ep2_in_buf_ready
	,output	reg 			ep2_in_buf_data_commit
	,output	reg 	[10:0]	ep2_in_buf_data_commit_len
	,output reg				ep2_in_buf_eob 



);

localparam SERIAL_STATE = 8'h20 ;


// ========================================== ep1 IN 
reg wr_ep1_act_d ;
reg wr_ep1_pkt_act_d ;
reg wr_ep1_act ;
reg wr_ep1_pkt_act ;
reg [7:0] wr_ep1_pkt_act_cnt ;
reg [7:0] wr_ep1_pt ;
reg [31:0] wr_ep1_pkt_dat ;

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		wr_ep1_act_d <= 0 ;
		wr_ep1_pkt_act_d <= 0 ;
	end
	else begin
		wr_ep1_act_d <= wr_ep1_act ;
		wr_ep1_pkt_act_d <= wr_ep1_pkt_act ;
	end
end

wire wr_ep1_act_r = !wr_ep1_act_d & wr_ep1_act ;
wire wr_ep1_pkt_act_f = wr_ep1_pkt_act_d & !wr_ep1_pkt_act ;

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		wr_ep1_act <= 0 ;
	end
	else if ( ep1_in_buf_data_commit ) begin
		wr_ep1_act <= 0 ;
	end	
	else if ( current_config_value == 1 && ep1_in_buf_ready ) begin
		//wr_ep1_act <= 1 ;
	end
end
	
always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		wr_ep1_pkt_act <= 0 ;
		wr_ep1_pkt_act_cnt <= 0 ;
		ep1_in_buf_wren <= 0 ;
		ep1_in_buf_data_commit <= 0 ;
	end
	else if ( wr_ep1_act_r ) begin
		wr_ep1_pkt_act <= 1 ;
		wr_ep1_pkt_act_cnt <= 0 ;
	end
	else if ( wr_ep1_pkt_act ) begin
		ep1_in_buf_wren <= 1 ;
		ep1_in_buf_data <= wr_ep1_pkt_dat ;
		wr_ep1_pkt_act_cnt <= wr_ep1_pkt_act_cnt + 1 ;
		if ( wr_ep1_pkt_act_cnt == 2 ) begin
			wr_ep1_pkt_act <= 0 ;
		end
	end
	else if ( wr_ep1_pkt_act_f ) begin
		ep1_in_buf_wren <= 0 ;
		ep1_in_buf_data_commit <= 1 ;
		ep1_in_buf_data_commit_len <= 10 ;	
	end
	else begin
		ep1_in_buf_data_commit <= 0 ; 
	end
end
	
always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		wr_ep1_pt <= 0 ;
	end
	else if ( wr_ep1_pkt_act ) begin
		wr_ep1_pt <= wr_ep1_pt + 1 ;
	end
	else begin
		wr_ep1_pt <= 0 ;
	end
end

wire [31:0] SerialState_noti [0:2] ;
assign SerialState_noti [0] = {8'b10100001,SERIAL_STATE,16'b0} ;
assign SerialState_noti [1] = {16'b0,8'd2,8'b0} ;
assign SerialState_noti [2] = 0 ;
	
always @ ( * ) begin
	wr_ep1_pkt_dat <= SerialState_noti[wr_ep1_pt] ;
end 	

// ========================================== ep2 IN
// 15fps , 5,038,848 pixels , 2bytes per pixels  ; bandwith = 15 * 5,038,848 * 2  = 151,165,440 Bps ;
// bandwith / 8000 = 151,165,440 / 8000 = 18895.68 = 18896 B/uframe  ; 18896 / 1024 = 18.4 = 19 pkts / frame 
// send 9727 pixels at most per transfer ; that's 2 bytes header and 19454 bytes payload ; 19454B > 18896B , should be enougth ;

localparam A = 0 ;
localparam B = 1 ;

localparam ST_IDLE = 2'd0 ;
localparam ST_WR_PAYLOAD = 2'd1;
localparam ST_WR_PAYLOAD_COMMIT = 2'd2;
localparam ST_WR_PAYLOAD_COMMIT_1 = 2'd3;
reg [1:0] state ; 

localparam ST_WR_IDLE = 3'd0 ;
localparam ST_WR_PKT_1 = 3'd1 ;
localparam ST_WR_PKT_2 = 3'd2 ;
localparam ST_WR_PKT_3 = 3'd3 ;
localparam ST_WR_PKT_COMMIT = 3'd4 ;
localparam ST_RD_PAYLOAD_COMMIT = 3'd5 ;
reg [2:0] wr_state ;


reg [15:0] payload_len ;
reg intf_set ;
reg host_requests_data;
reg [31:0] yuv_data_latch;
wire [15:0] payload_header ;
reg fid_toggle;
reg eof;
reg [23:0] yuv_data_cnt;
reg wr_payload_commit ;
reg payload_fifo_wr_en ;
reg payload_fifo_wr_en_d ;
reg payload_fifo_rd_en ;
wire payload_fifo_ready ;
reg [15:0] yuv_data_pop_cnt;
reg [15:0] yuv_fifo_num_latch;
reg [31:0] payload_fifo_wr_data;
reg [15:0] payload_fifo_wr_en_cnt ;
reg [15:0] wr_payload_commit_len ;
reg  rd_payload_pt ;
reg  rd_payload_commit ;
reg  wr_payload_pt ;
reg  payload_fifo_a_ready ;
reg  payload_fifo_a_has_data ;
reg  [15:0] payload_fifo_a_has_data_len ;
reg  payload_fifo_b_ready ;
reg  payload_fifo_b_has_data ;
reg  [15:0] payload_fifo_b_has_data_len ;
wire [15:0] payload_fifo_has_data_len ;
reg  [16:0] wr_payload_len_cnt ;
reg  [10:0] ep2_in_buf_wr_cnt ;
reg  [10:0] wr_pkt_len ;
reg  [10:0] payload_fifo_rd_cnt ;
wire [31:0] payload_fifo_rd_data_a ;
wire [31:0] payload_fifo_rd_data_b ;
wire [31:0] payload_fifo_rd_data ;
wire [23:0] last_payload_pixel_num ;
reg [23:0] sent_payload_pixel_num; 
reg [23:0] yuv_fifo_pixel_num ;		
reg [23:0] total_pixel_num ;	
reg yuv_data_pop_d ;	 
reg ep2_in_buf_wren_d ; 
reg wr_payload_act ;
reg  wait_for_req_data ;
reg  cam_de_act ;

always @ ( posedge clk or  negedge rst_n ) begin
	if ( !rst_n ) begin
		intf_set  <= 0 ;
	end
	else if ( set_interface ) begin
		if ( set_interface_num == 1 && set_interface_alt_setting == 1 ) begin
			intf_set <= 1 ;
		end
		else if ( set_interface_num == 1 && set_interface_alt_setting == 0 ) begin
			intf_set <= 0 ;
		end
	end
end

always @ ( posedge clk or  negedge rst_n ) begin
	if ( !rst_n ) begin
		host_requests_data  <= 0 ;
	end
	else if ( host_requests_data_from_endpt && host_requests_endpt_num == 2 ) begin
		host_requests_data <= 1 ;
	end
	else begin
		host_requests_data <= 0 ;
	end
end


always @ ( posedge clk or  negedge rst_n ) begin
	if ( !rst_n ) begin
		cam_active <= 0 ;
	end
	else if ( !cam_active ) begin
		if ( host_requests_data ) begin
			cam_active <= 1 ;
		end
	end
	else if ( cam_active ) begin
		if ( cam_de_active ) begin
			cam_active <= 0 ;
		end
	end
end


always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		payload_fifo_wr_en_d <= 0 ;
		yuv_data_pop_d <= 0 ;
		ep2_in_buf_wren_d <= 0 ;	
	end
	else begin
		payload_fifo_wr_en_d <= payload_fifo_wr_en ;
		yuv_data_pop_d <= yuv_data_pop ;
		ep2_in_buf_wren_d <= ep2_in_buf_wren ;	
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		yuv_data_latch <= 0 ;
	end
	else if ( yuv_data_pop_d ) begin
		yuv_data_latch <= yuv_data ;
	end
end





assign payload_header [7:0] = 2 					; //	Header Length
assign payload_header [8]	= fid_toggle  			; //	FID: Frame Identifier 
assign payload_header [9]   = eof					; //	EOF: End of Frame
assign payload_header [10]  = 0						; //	PTS: Presentation Time Stamp
assign payload_header [11]  = 0						; // 	SCR: Source Clock Reference
assign payload_header [12]  = 0						; //	RES: Reserved
assign payload_header [13]  = 0						; //	STI: Still Image
assign payload_header [14]  = 0						; //	ERR: Error Bit
assign payload_header [15]  = 1						; // 	EOH: End of Header


assign last_payload_pixel_num 	= total_pixel_num - sent_payload_pixel_num ;

always @ ( * ) begin
	sent_payload_pixel_num <= {yuv_data_cnt[23:0],1'b0} ;
	yuv_fifo_pixel_num <= {7'b0,yuv_fifo_num[15:0],1'b0} ;
	//total_pixel_num <= 24'd5_038_848 ;
	total_pixel_num <= `pixel_num ;
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		wr_payload_act <= 0 ; 
	end
	else if ( !wr_payload_act && cam_active ) begin
		if ( payload_fifo_ready &&  last_payload_pixel_num ==  `last_pixel_num && yuv_fifo_pixel_num >= `last_pixel_num ) begin
			wr_payload_act <= 1 ;
			eof <= 1 ; 
			payload_len <= { last_payload_pixel_num[14:0] , 1'b0 } + 2 ; 
			yuv_fifo_num_latch <= last_payload_pixel_num[23:1]  ; 
		end
		//else if ( payload_fifo_ready && yuv_fifo_pixel_num >= 16'd9438 ) begin
		else if ( payload_fifo_ready && yuv_fifo_pixel_num >= `normal_pixel_num ) begin
			wr_payload_act <= 1 ;
			payload_len <= `normal_pixel_num * 2  + 2 ;
			yuv_fifo_num_latch <= `normal_pixel_num / 2 ;
			eof <= 0 ;
		end	
	end
	else if ( state == ST_WR_PAYLOAD_COMMIT_1 ) begin
		wr_payload_act <= 0 ;
		eof <= 0 ;
	end
end




always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		state <= ST_IDLE ;
		wr_payload_commit <= 0 ;
		yuv_data_pop <= 0 ;
	end
	else begin
		case ( state ) 
		ST_IDLE:begin
			if ( wr_payload_act ) begin
				state <= ST_WR_PAYLOAD ;
				yuv_data_pop <= 1 ;
				yuv_data_pop_cnt <= 0 ; 
			end
		end
		ST_WR_PAYLOAD:begin 
			yuv_data_pop_cnt <= yuv_data_pop_cnt + 1 ;
			if ( yuv_data_pop_cnt + 1 >= yuv_fifo_num_latch ) begin
				yuv_data_pop <= 0 ;
				yuv_data_pop_cnt <= 0 ;
				state <= ST_WR_PAYLOAD_COMMIT ;
			end
		end		
		ST_WR_PAYLOAD_COMMIT:begin
			if ( !payload_fifo_wr_en ) begin
				wr_payload_commit <= 1 ;
				wr_payload_commit_len <= payload_len ;
				state <= ST_WR_PAYLOAD_COMMIT_1 ;
			end
		end
		ST_WR_PAYLOAD_COMMIT_1:begin
			wr_payload_commit <= 0 ;
			state <= ST_IDLE ;
		end
		default:begin end
		endcase 
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		yuv_data_cnt <= 0 ;
		fid_toggle <= 0 ;
	end
	else if ( state == ST_WR_PAYLOAD_COMMIT && !payload_fifo_wr_en ) begin
		yuv_data_cnt <= yuv_data_cnt + yuv_fifo_num_latch ;
		if ( eof ) begin
			fid_toggle <= !fid_toggle;
			yuv_data_cnt <= 0 ;
		end	
		else if ( !cam_active ) begin
			fid_toggle <= !fid_toggle;
			yuv_data_cnt <= 0 ;
		end
	end
	else if ( state == ST_IDLE && cam_de_active ) begin
		fid_toggle <= !fid_toggle;
		yuv_data_cnt <= 0 ;		
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		payload_fifo_wr_en <= 0 ;
	end
	else if ( yuv_data_pop ) begin
		payload_fifo_wr_en <= 1 ;
	end
	else if ( yuv_data_pop_d && !yuv_data_pop  ) begin
		payload_fifo_wr_en <= 1 ;
	end
	else begin
		payload_fifo_wr_en <= 0 ;
	end
end

				
always @ ( * ) begin
	if ( !payload_fifo_wr_en_d && payload_fifo_wr_en ) begin
		payload_fifo_wr_data <= { swap16(payload_header[15:0]) , swap16(yuv_data[15:0]) }  ;
	end
	else begin
		payload_fifo_wr_data <= { swap16(yuv_data_latch[31:16]) , swap16(yuv_data[15:0]) } ; 
	end
end


always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		rd_payload_pt <= A ;	
	end
	else if ( rd_payload_commit ) begin 
		rd_payload_pt <= !rd_payload_pt ;
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		wr_payload_pt <= A ;	
	end
	else if ( wr_payload_commit ) begin 
		wr_payload_pt <= !wr_payload_pt ;
	end
end
	
always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		payload_fifo_a_ready <= 1 ;
		payload_fifo_a_has_data <= 0 ;
	end
	else if ( rd_payload_commit && rd_payload_pt == A ) begin
		payload_fifo_a_ready <= 1 ;
		payload_fifo_a_has_data <= 0 ;
	end	
	else if ( wr_payload_commit && wr_payload_pt == A ) begin 
		payload_fifo_a_ready <= 0  ;
		payload_fifo_a_has_data <= 1 ;
		payload_fifo_a_has_data_len <= wr_payload_commit_len ;
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		payload_fifo_b_ready <= 1 ;
		payload_fifo_b_has_data <= 0 ;
	end
	else if ( rd_payload_commit && rd_payload_pt == B ) begin
		payload_fifo_b_ready <= 1 ;
		payload_fifo_b_has_data <= 0 ;
	end	
	else if ( wr_payload_commit && wr_payload_pt == B ) begin 
		payload_fifo_b_ready <= 0  ;
		payload_fifo_b_has_data <= 1 ;
		payload_fifo_b_has_data_len <= wr_payload_commit_len ;
	end
end

assign payload_fifo_ready = ( wr_payload_pt == A ) ? payload_fifo_a_ready : payload_fifo_b_ready ; 
assign payload_fifo_has_data = ( rd_payload_pt == A  ) ? payload_fifo_a_has_data : payload_fifo_b_has_data ;
assign payload_fifo_has_data_len = ( rd_payload_pt == A  ) ? payload_fifo_a_has_data_len : payload_fifo_b_has_data_len ;

payload_fifo payload_fifo_a (
	.Data( payload_fifo_wr_data ), //input [31:0] Data
	.WrClk(clk), //input WrClk
	.RdClk(clk), //input RdClk
	.WrEn( ( wr_payload_pt == A ) ? payload_fifo_wr_en : 1'b0 ), //input WrEn
	.RdEn( ( rd_payload_pt == A ) ? payload_fifo_rd_en : 1'b0 ), //input RdEn
	.Q( payload_fifo_rd_data_a ), //output [31:0] Q
	.Empty(payload_fifo_a_empty), //output Empty
	.Full(payload_fifo_a_full) //output Full
);

payload_fifo payload_fifo_b (
	.Data( payload_fifo_wr_data ), //input [31:0] Data
	.WrClk(clk), //input WrClk
	.RdClk(clk), //input RdClk
	.WrEn( ( wr_payload_pt == B ) ? payload_fifo_wr_en : 1'b0 ), //input WrEn
	.RdEn( ( rd_payload_pt == B ) ? payload_fifo_rd_en : 1'b0 ), //input RdEn
	.Q( payload_fifo_rd_data_b ), //output [31:0] Q
	.Empty(payload_fifo_b_empty), //output Empty
	.Full(payload_fifo_b_full) //output Full
);

assign payload_fifo_rd_data = rd_payload_pt == A ? payload_fifo_rd_data_a : payload_fifo_rd_data_b ;

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		wr_state <= ST_WR_IDLE ;
		payload_fifo_rd_en <= 0 ;
		rd_payload_commit <= 0 ;
		wr_payload_len_cnt <= 0 ; 
		ep2_in_buf_eob <= 0 ;
	end
	else begin
		case ( wr_state ) 
		ST_WR_IDLE:begin
		
			if ( payload_fifo_has_data  ) begin	
				wr_state <= ST_WR_PKT_1 ;		
				wr_payload_len_cnt <= 0 ;
			end
		end
		ST_WR_PKT_1:begin
			
			if (  ep2_in_buf_ready ) begin
	
				wr_pkt_len <= ( payload_fifo_has_data_len - wr_payload_len_cnt >= 1024 ) ? 1024 : payload_fifo_has_data_len - wr_payload_len_cnt ;
				
				payload_fifo_rd_en <= 1 ;
	
				payload_fifo_rd_cnt <= 0 ;
				
				wr_state <= ST_WR_PKT_2 ;
			
			end
			
		end
		ST_WR_PKT_2: begin
		 
			
			payload_fifo_rd_cnt <= payload_fifo_rd_cnt + 4 ;
			
			if ( payload_fifo_rd_cnt + 4 >= wr_pkt_len ) begin
				payload_fifo_rd_cnt <= payload_fifo_rd_cnt;
				payload_fifo_rd_en <= 0 ;
				wr_state <= ST_WR_PKT_COMMIT ;
			end
			
			if ( wr_pkt_len + wr_payload_len_cnt >= payload_fifo_has_data_len ) begin
				ep2_in_buf_eob <= 1 ;
			end
			else begin
				ep2_in_buf_eob <= 0 ;
			end
		
		end
		ST_WR_PKT_COMMIT:begin
			if ( ep2_in_buf_data_commit ) begin 
				wr_payload_len_cnt <= wr_payload_len_cnt + wr_pkt_len ;
				if ( ep2_in_buf_eob ) begin
					wr_state <= ST_RD_PAYLOAD_COMMIT ;
					rd_payload_commit <= 1 ;
				end
				else begin
					wr_state <= ST_WR_PKT_1 ;
				end
			end
		end
		ST_RD_PAYLOAD_COMMIT:begin
			rd_payload_commit <= 0 ;
			wr_state <= ST_WR_IDLE ;
		end
		default:begin end
		endcase 
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		ep2_in_buf_wren <= 0 ;
	end
	else begin 
		ep2_in_buf_wren <= payload_fifo_rd_en ;
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		ep2_in_buf_data_commit <= 0 ;
	end
	else if ( ep2_in_buf_wren_d && !ep2_in_buf_wren ) begin
		ep2_in_buf_data_commit <= 1 ;
		ep2_in_buf_data_commit_len <= wr_pkt_len ;
	end
	else begin
		ep2_in_buf_data_commit <= 0 ;
	end
end


always @ ( * ) begin
	ep2_in_buf_data <= payload_fifo_rd_data ;
end



function [15:0] swap16 ;

input [15:0] A ;
	
	begin
		swap16 = {A[7:0],A[15:8]} ;
	end

endfunction	







endmodule