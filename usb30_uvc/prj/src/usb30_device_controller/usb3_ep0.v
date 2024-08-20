`include "usb3_macro_define.v"	
`ifdef SIM
module usb3_ep0(
`else
module `getname(usb3_ep0,`module_name)(
`endif

 input	wire			slow_clk
,input	wire			local_clk
,input	wire			reset_n

,input wire	[4:0]	ltssm_state

,input	wire	[31:0]	buf_in_data
,input	wire			buf_in_wren
,output	wire			buf_in_ready
,input	wire			buf_in_commit
,input	wire	[10:0]	buf_in_commit_len

,output	wire	[31:0]	buf_out_q
,output	wire	[10:0]	buf_out_len
,output	wire			buf_out_hasdata
,input	wire			buf_out_arm
,input  wire 			buf_out_rden


,output	reg				reset_dp_seq

,input wire 			buf_out_dp_acked
,input wire				in_ep_rty				

,output	reg				err_setup_pkt

,output reg				set_device_low_power_state
,input wire				set_device_low_power_state_ack  


// external interface 
,input	wire	[31:0]	ep0_in_buf_data
,input	wire			ep0_in_buf_wren
,output	wire			ep0_in_buf_ready
,input	wire			ep0_in_buf_commit
,input	wire	[10:0]	ep0_in_buf_commit_len

	
,output wire	[31:0]	ep0_out_buf_data		 	
,output wire	[10:0]	ep0_out_buf_len		
,output wire			ep0_out_buf_hasdata	
,input wire				ep0_out_buf_ack
,input wire				ep0_out_buf_rden 	 	


// requests

,output reg			request_active 	
,output reg	[7:0]	bmRequestType	
,output reg	[7:0]	bRequest		
,output reg	[15:0]	wValue			
,output reg	[15:0]	wIndex			
,output reg	[15:0]	wLength			
 			
								
,output reg				set_address 
,output reg		[6:0]	dev_address 
,input wire				set_address_ack 

,input wire	enter_status_stage 
,input wire	ep0_stall 
											

);

`include "usb3_const.vh"


localparam [7:0]REQ_GET_STATUS		= 8'h0,
				REQ_CLEAR_FEAT		= 8'h1,
				REQ_SET_FEAT		= 8'h3,
				REQ_SET_ADDR		= 8'h5,
				REQ_GET_DESCR		= 8'h6,
				REQ_SET_DESCR		= 8'h7,
				REQ_GET_CONFIG		= 8'h8,
				REQ_SET_CONFIG		= 8'h9,
				REQ_SET_INTERFACE	= 8'hB,
				REQ_SYNCH_FRAME		= 8'h12,
				REQ_SET_SEL			= 8'd48,
				REQ_GET_INTERFACE	= 8'd10,
				REQ_GET_CONFIGURATION = 8'd8,
				REQ_SET_IOSDELAY 	= 8'd49;

localparam HOST_TO_DEVICE =  0 ;
localparam DEVICE_TO_HOST =  1 ;
localparam [1:0] SETUP_TYPE_STANDARD	= 2'h0 ;

reg parse_setup_pkt ;
reg setup_in_ready ;
reg buf_in_commit_d ;
reg pass_data_to_user ;
wire ep0_out_buf_ready ;
reg parse_setup_pkt_d;
reg rd_setup_pkt;
reg [1:0] rd_cnt ;
reg rd_setup_pkt_dval ;
reg rd_setup_pkt_dval_d ;
reg [63:0] packet_setup ;
reg packet_setup_latch_act; 
reg [63:0] packet_setup_latch ; 
reg setup_pkt_parsed  ; 
reg need_data_from_user  ; 
reg [6:0] descrip_addr_offset  ; 
reg [6:0] descrip_total_len ;
reg pass_request_to_user ;
reg [15:0] rx_datapkt_len ;
reg [6:0 ] descrip_len ;
reg [7:0] setup_rd_addr ;
wire[31:0] setup_rd_data; 
wire [31:0] ep0_in_buf_out_q ;
wire [10:0] ep0_in_buf_out_len ;
wire		ep0_in_buf_out_hasdata ;
wire [31:0] desc_dat ;
reg set_address_act ;
reg [7:0] buf_in_addr ;
reg [7:0] buf_out_addr ;
reg set_device_suspend ;
reg set_device_suspend_act ;
reg set_device_suspend_act_delay ;

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		buf_in_addr <= 0 ;
	end
	else if ( buf_in_commit ) begin
		buf_in_addr <= 0 ;
	end
	else if ( buf_in_wren ) begin
		buf_in_addr <= buf_in_addr + 1 ;
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		buf_out_addr <= 0 ;
	end
	else if ( buf_out_arm ) begin
		buf_out_addr <= 0 ;
	end
	else if ( buf_out_rden ) begin
		buf_out_addr <= buf_out_addr + 1 ;
	end
end
	


//managing  setup stage  
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		parse_setup_pkt <= 0 ;
	end
	else begin
		setup_in_ready <= 1 ;
		buf_in_commit_d <= buf_in_commit ;
		if ( buf_in_commit && !buf_in_commit_d && !pass_data_to_user  && ltssm_state == LT_U0 ) begin
			parse_setup_pkt <= 1 ;
		end
		else begin
			parse_setup_pkt <=  0 ;
		end
	end
end

// mux setup data , user data 
wire [7:0] 	setup_wr_addr =  (pass_data_to_user) ? 0 : buf_in_addr 	;
wire [31:0] setup_wr_data =  (pass_data_to_user) ? 0 : buf_in_data 	;
wire 		setup_wr_en   =  (pass_data_to_user) ? 0 : buf_in_wren 	;

wire [7:0] 	datapkt_wr_addr 	= ( pass_data_to_user ) ? buf_in_addr : 0 ;
wire 		datapkt_wr_en   	= ( pass_data_to_user ) ? buf_in_wren : 0 ;
wire [31:0] datapkt_wr_data 	= ( pass_data_to_user ) ? buf_in_data : 0 ;
wire 		datapkt_commit  	= ( pass_data_to_user ) ? buf_in_commit : 0 ;
wire [10:0] datapkt_commit_len 	= ( pass_data_to_user ) ? buf_in_commit_len : 0 ;
 

assign buf_in_ready  =  (pass_data_to_user) ? ep0_out_buf_ready : setup_in_ready  ;

`ifdef SIM
usb3_ep0in_ram
`else
`getname(usb3_ep0in_ram,`module_name)
`endif
iu3ep0i (
	.clk 		( local_clk ),
	.wr_dat_w 	( setup_wr_data ),
	.rd_adr 	( setup_rd_addr ),
	.wr_adr 	( setup_wr_addr ),
	.wr_we 		( setup_wr_en   ),
	.rd_dat_r 	( setup_rd_data )
);




`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep0_OUT(

	.clk				(local_clk	)		
	,.rst_n				(reset_n	)
	
	,.buf_in_data		 ( datapkt_wr_data  )
	,.buf_in_wren		 ( datapkt_wr_en  	)
	,.buf_in_ready		 ( ep0_out_buf_ready)
	,.buf_in_commit		 ( datapkt_commit   )
	,.buf_in_commit_len	 ( datapkt_commit_len   )
	,.buf_in_nump		 ( )

	,.buf_out_dp_acked	 ( )	
	,.in_ep_rty			 ( )
	
	,.buf_out_q		     (ep0_out_buf_data		 		)
	,.buf_out_len		 (ep0_out_buf_len				)
	,.buf_out_hasdata	 (ep0_out_buf_hasdata			)
	,.buf_out_arm	     (ep0_out_buf_ack	 			)
	,.buf_out_rden		 (ep0_out_buf_rden				)
	,.buf_out_eob 		 (								)
	,.buf_out_nump	     (								)


);
defparam usb3_ep0_OUT.ENDPT_BURST = 1 ;
defparam usb3_ep0_OUT.BUF_OUT_DP_ACKED_VAL = 0 ;


//parse setup pkt
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		parse_setup_pkt_d <= 0 ;
		rd_setup_pkt <= 0 ;
		rd_cnt <= 0 ;
		setup_rd_addr <= 0 ;
	end
	else if ( !parse_setup_pkt_d && parse_setup_pkt ) begin
		rd_setup_pkt <= 1 ;
		setup_rd_addr <= 0 ;
	end
	else if ( rd_setup_pkt ) begin
		rd_cnt <= rd_cnt + 1 ;
		setup_rd_addr <= setup_rd_addr + 1 ;
		if ( rd_cnt == 1 ) begin
			rd_cnt <= 0 ;
			rd_setup_pkt <= 0 ;
		end
	end	
end


always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		rd_setup_pkt_dval <= 0 ;
		rd_setup_pkt_dval_d <= 0 ;
	end
	else begin 
		rd_setup_pkt_dval <= rd_setup_pkt ;
		rd_setup_pkt_dval_d <= rd_setup_pkt_dval ;
	end
end

always @ ( posedge local_clk  ) begin
	if ( rd_setup_pkt_dval ) begin
		packet_setup <= { packet_setup[31:0] , setup_rd_data[31:0] } ;
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		packet_setup_latch_act <= 0 ;
	end
	else if ( !rd_setup_pkt_dval && rd_setup_pkt_dval_d ) begin
		packet_setup_latch <= packet_setup ;
		packet_setup_latch_act <= 1 ;
	end
	else begin
		packet_setup_latch_act <= 0 ;
	end
end

wire	[7:0]	packet_setup_reqtype = packet_setup_latch[63:56];	
wire			packet_setup_dir	= packet_setup_reqtype[7];
wire	[1:0]	packet_setup_type	= packet_setup_reqtype[6:5];
wire	[4:0]	packet_setup_recpt	= packet_setup_reqtype[4:0];
wire	[7:0]	packet_setup_req	= packet_setup_latch[55:48];
wire	[15:0]	packet_setup_wval	= {packet_setup_latch[39:32], packet_setup_latch[47:40]};
wire	[15:0]	packet_setup_widx	= {packet_setup_latch[23:16], packet_setup_latch[31:24]};
wire	[15:0]	packet_setup_wlen	= {packet_setup_latch[7:0], packet_setup_latch[15:8]};

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		pass_data_to_user <= 0 ;
		need_data_from_user <= 0 ;
		setup_pkt_parsed <= 0 ;
		dev_address <= 0 ;
		set_device_suspend <= 0 ;
	end	
	else if ( packet_setup_latch_act ) begin
		setup_pkt_parsed <= 1 ;
		if ( packet_setup_type == SETUP_TYPE_STANDARD ) begin
			if ( packet_setup_req == REQ_GET_DESCR ) begin
				need_data_from_user 	<= 1 ;
				pass_request_to_user    <= 1 ;
			end	
			else if ( packet_setup_req == REQ_SET_ADDR ) begin
				set_address_act <= 1 ;
				dev_address <= packet_setup_wval[6:0] ;	
				need_data_from_user <= 0 ;
				pass_request_to_user <= 0 ;
			end
			else if ( packet_setup_req == REQ_CLEAR_FEAT ) begin
				reset_dp_seq <= 1 ;
				pass_request_to_user <= 1 ;
			end
			else if ( packet_setup_req == REQ_GET_INTERFACE ) begin
				pass_request_to_user <= 1 ;
				need_data_from_user <= 1 ;
			end
			else if ( packet_setup_req == REQ_GET_STATUS ) begin
				pass_request_to_user <= 1 ;
				need_data_from_user <= 1 ;
			end	
			else if ( packet_setup_req == REQ_SET_CONFIG  ) begin
				pass_request_to_user <= 1 ;	
				need_data_from_user <= 0 ;
			end
			else if ( packet_setup_req == REQ_GET_CONFIG ) begin
				pass_request_to_user <= 1 ;	
				need_data_from_user <= 1 ;			
			end
			else if ( packet_setup_req == REQ_SET_FEAT  ) begin
				if ( packet_setup_wval == 0 && wIndex == 16'h0100 ) begin
					//set_device_suspend <= 1 ;
				end
				else begin
					pass_request_to_user <= 1 ; 
					need_data_from_user <= 0 ;
				end
			end
			else if ( packet_setup_req == REQ_SET_INTERFACE ) begin
				pass_request_to_user <= 1 ; 
				need_data_from_user <= 0 ;				
			end
			else if ( packet_setup_req == REQ_SET_SEL ) begin
				pass_request_to_user <= 1 ; 
				need_data_from_user <= 0 ;	
				pass_data_to_user <= 1 ;
			end
			else if ( packet_setup_req == REQ_SET_IOSDELAY ) begin
				pass_request_to_user <= 1 ;
				need_data_from_user <= 0 ;
				pass_data_to_user <= 0 ;
			end
			else if ( packet_setup_dir == DEVICE_TO_HOST && packet_setup_wlen > 0 ) begin
				pass_request_to_user <= 1 ;
				need_data_from_user <= 1 ; 
				pass_data_to_user <= 0 ;
			end
			else if ( packet_setup_dir == HOST_TO_DEVICE && packet_setup_wlen > 0 ) begin
				pass_request_to_user <= 1 ; 
				need_data_from_user <= 0 ; 
				pass_data_to_user <= 1 ;
			end
			else begin
				pass_request_to_user <= 1 ;
				need_data_from_user <= 0 ; 
				pass_data_to_user <= 0 ; 			
			end
		end
		else begin
			pass_request_to_user <= 1 ;
			if ( packet_setup_dir == DEVICE_TO_HOST && packet_setup_wlen > 0 ) begin
				need_data_from_user <= 1 ; 
				pass_data_to_user <= 0 ;
			end
			else if ( packet_setup_dir == HOST_TO_DEVICE && packet_setup_wlen > 0 ) begin
				need_data_from_user <= 0 ; 
				pass_data_to_user <= 1 ;			
			end
			else begin
				need_data_from_user <= 0 ; 
				pass_data_to_user <= 0 ; 
			end
		end		
	end
	else if ( enter_status_stage || ep0_stall ) begin
		need_data_from_user <= 0 ; 
		pass_data_to_user <= 0 ; 		
	end
	else begin
		setup_pkt_parsed <= 0 ;
		pass_request_to_user <= 0 ;
		reset_dp_seq <= 0 ;
		set_address_act <= 0 ;
		set_device_suspend <= 0 ;
	end
end

reg [7:0] clk_cnt ;

always @ ( posedge local_clk or negedge reset_n ) begin
	if (!reset_n) begin
		clk_cnt <= 0 ;
	end
	else if ( set_device_suspend_act_delay ) begin
		clk_cnt <= clk_cnt + 1 ;
	end
	else begin
		clk_cnt <= 0 ;
	end
end
always @ ( posedge local_clk or negedge reset_n ) begin
	if (!reset_n) begin
		set_device_suspend_act <= 0 ;
		set_device_suspend_act_delay <= 0 ;
	end
	else if ( enter_status_stage ) begin
		set_device_suspend_act <= 0 ;
		set_device_suspend_act_delay <= 1 ;
	end
	else if ( set_device_suspend ) begin
		set_device_suspend_act <= 1 ;
	end
	else if ( set_device_suspend_act_delay && clk_cnt == 8'hff ) begin
		set_device_suspend_act_delay <= 0 ;
	end	
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if (!reset_n) begin
		set_device_low_power_state <= 0 ;
	end
	else if ( set_device_low_power_state_ack ) begin
		set_device_low_power_state <= 0 ;
	end
	else if ( set_device_suspend_act_delay && clk_cnt == 8'hff  ) begin
		set_device_low_power_state <= 1 ;
	end
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		request_active 	<= 0 ;
	end
	else if ( pass_request_to_user ) begin
		request_active 	<= 1 ;
	end
	else begin
		request_active 	<= 0 ;	
	end
end

always @ ( * ) begin
	bmRequestType	<= packet_setup_reqtype ;
	bRequest		<= packet_setup_req  ;
	wValue			<= packet_setup_wval ;
	wIndex			<= packet_setup_widx ;
	wLength			<= packet_setup_wlen ;	
end

always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		set_address <= 0 ;
	end
	else if ( set_address_act ) begin
		set_address <= 1 ;
	end
	else if ( set_address_ack ) begin
		set_address <= 0 ;
	end
end
// managing rx data pkt
always @ ( posedge local_clk or negedge reset_n ) begin
	if ( !reset_n ) begin
		rx_datapkt_len <= 0 ; 
	end
	else if ( setup_pkt_parsed ) begin
		rx_datapkt_len <= 0 ; 
	end
	else if ( pass_data_to_user  && datapkt_commit ) begin
		rx_datapkt_len <= rx_datapkt_len + datapkt_commit_len  ;
	end	
end



`ifdef SIM
usb3_ep
`else
`getname(usb3_ep,`module_name)
`endif 
usb3_ep0_IN(

	.clk				(local_clk	)		
	,.rst_n				(reset_n	)

	,.buf_in_data		 ( ep0_in_buf_data          )
	,.buf_in_wren		 ( ep0_in_buf_wren          )
	,.buf_in_ready		 ( ep0_in_buf_ready         )
	,.buf_in_commit		 ( ep0_in_buf_commit        )
	,.buf_in_commit_len	 ( ep0_in_buf_commit_len    )
	,.buf_in_nump		 ( buf_in_nump				)
	
	,.buf_out_dp_acked	 (buf_out_dp_acked 			)
	,.in_ep_rty			 (in_ep_rty)	
	
	,.buf_out_q		     (ep0_in_buf_out_q		 	)
	,.buf_out_len		 (ep0_in_buf_out_len		)
	,.buf_out_hasdata	 (ep0_in_buf_out_hasdata	)
	,.buf_out_arm	     (ep0_in_buf_out_arm	 	)
	,.buf_out_rden		 (ep0_in_buf_out_rden		)
	,.buf_out_eob 		 (							)
	,.buf_out_nump	     (							)


);

defparam usb3_ep0_IN.ENDPT_BURST = 1 ;

assign  buf_out_q 	= ep0_in_buf_out_q  ;
assign  buf_out_len	= ep0_in_buf_out_len ; 
assign  buf_out_hasdata =  ep0_in_buf_out_hasdata  ;

assign  ep0_in_buf_out_arm  = buf_out_arm  ;
assign  ep0_in_buf_out_rden = buf_out_rden  ;




//debug
reg [7:0] req_cnt ;
always @ ( posedge local_clk or negedge reset_n ) begin
	if (!reset_n) begin
		req_cnt <= 0 ;
	end
	else if  ( setup_pkt_parsed  ) begin
		req_cnt <= req_cnt + 1 ; 
	end
end

endmodule