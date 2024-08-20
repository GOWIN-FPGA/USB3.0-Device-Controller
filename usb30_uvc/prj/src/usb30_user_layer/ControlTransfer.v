`timescale 1ns/1ns
`include "UVCDefine.v"

module ControlTransfer 
#(
	parameter SELF_POWERED = 1'b1 
)
(
	input wire 	clk 
	,input wire rst_n

	// requests
	,input wire			request_active 	
	,input wire	[7:0]	bmRequestType	
	,input wire	[7:0]	bRequest		
	,input wire	[15:0]	wValue			
	,input wire	[15:0]	wIndex			
	,input wire	[15:0]	wLength	

	// ep0 IN  
	,output	reg	[31:0]	ep0_in_buf_data
	,output	reg			ep0_in_buf_wren
	,input	wire		ep0_in_buf_ready
	,output	reg			ep0_in_buf_data_commit
	,output	reg	[10:0]	ep0_in_buf_data_commit_len		

	// ep0 OUT	
	,input wire	[31:0]	ep0_out_buf_data		 	
	,input wire	[10:0]	ep0_out_buf_len		
	,input wire			ep0_out_buf_has_data	
	,output reg			ep0_out_buf_rden
	,output reg			ep0_out_buf_data_ack		

	,output wire [7:0]  current_config_value
	,output reg 		set_interface
	,output reg [15:0]	set_interface_num 
	,output reg [15:0]  set_interface_alt_setting





);

`include "usb_descrip.vh"

localparam STANDARD = 2'b00 ;
localparam CLASS	= 2'b01 ;

localparam [7:0]	STANDARD_GET_STATUS			= 8'h0;
localparam [7:0]	STANDARD_CLEAR_FEAT			= 8'h1;
localparam [7:0]	STANDARD_SET_FEAT			= 8'h3;
localparam [7:0]	STANDARD_GET_DESCR			= 8'h6;
localparam [7:0]	STANDARD_SET_DESCR			= 8'h7;
localparam [7:0]	STANDARD_GET_CONFIG			= 8'h8;
localparam [7:0]	STANDARD_SET_CONFIG			= 8'h9;
localparam [7:0]	STANDARD_SET_INTERFACE		= 8'hB;
localparam [7:0]	STANDARD_SYNCH_FRAME		= 8'h12;
localparam [7:0]	STANDARD_SET_SEL			= 8'd48;
localparam [7:0]	STANDARD_GET_INTERFACE		= 8'd10;
localparam [7:0]	STANDARD_GET_CONFIGURATION 	= 8'd8;
localparam [7:0]	STANDARD_SET_IOS_DELAY		= 8'd49;
localparam [7:0]	STANDARD_SYNC_FRAME			= 8'd12;

localparam [7:0] 	STANDARD_STATUS 	= 8'h00 ;
localparam [7:0] 	RECIPIENT_DEVICE 	= 8'h00 ;
localparam [7:0] 	RECIPIENT_INTF	 	= 8'h01 ;
localparam [7:0] 	RECIPIENT_ENDPT	 	= 8'h02 ;

/*              add your own requests here    */ 
localparam [7:0] SET_LINE_CODING = 8'h20 ;
localparam [7:0] GET_LINE_CODING = 8'h21 ;
localparam [7:0] SET_CONTROL_LINE_STATE = 8'h22 ;

localparam [7:0] SET_CUR = 8'h01 ;
localparam [7:0] GET_CUR = 8'h81 ;
localparam [7:0] GET_MIN = 8'h82 ;
localparam [7:0] GET_MAX = 8'h83 ;


localparam [7:0] VS_PROBE_CONTROL = 8'h01 ;



reg wr_desc_pkt_act_d;
reg wr_ep0_act_d;
reg wr_desc_act_d;
reg wr_resp_pkt_act_d;
reg rd_ep0_pkt_act_d;
reg wr_desc_pkt_act;
reg wr_ep0_act;
reg wr_desc_act;
reg wr_resp_pkt_act;
reg rd_ep0_pkt_act;
reg wr_desc_req;
reg get_interface;
reg [15:0] wr_desc_len ;
reg [DESCR_USB3_ROM_ADD_W-1:0] descr_offset ;
reg get_status ;
reg set_config ;
reg [15:0] set_config_value ;
reg get_config ;
reg set_feature ;
reg set_sel ;
reg set_iso_delay ; 
reg [15:0] set_iso_delay_value ;
reg sync_frame ;
reg [15:0] sync_frame_endpt ;
reg [15:0] wr_desc_len_latch ;
reg wr_resp_act; 
reg [15:0] wr_resp_len_latch ;
reg [10:0] wr_ep0_len_cnt ;
reg [10:0] wr_ep0_len ;
reg [DESCR_USB3_ROM_ADD_W-1:0] descr_rd_addr ;
reg [31:0] resp_data_q;
reg 	set_sel_act;
reg 	sync_frame_act;
reg  ep0_out_buf_data_val ;
reg [9:0]ep0_out_buf_data_inx;
reg [7:0]u1_sel;
reg [7:0]u1_pel;
reg [15:0] u2_sel;
reg [15:0] u2_pel;
reg [15:0] frame_num;
reg rd_ep0_act;
reg [10:0] rd_ep0_len_latch;
reg [10:0] rd_ep0_len_cnt;
reg 	 rd_ep0_act_d;
reg get_descr ;
reg get_uart_config ;
reg [3:0] resp_rd_addr ;
reg wr_resp_act_d ;
reg [31:0]  baud_rate  ;
reg	[7:0]	stop_bit   ;
reg	[7:0]   parity     ;
reg set_uart_config ;
reg set_uart_config_act;
reg u1_enable ;
reg u2_enable ;
reg remoke_wakeup ;
reg LTM_enable ;
reg set_current ;
reg get_current ;
reg get_maximun ;
reg get_minimun ;
reg set_current_act ;
reg set_dev_attributes;
reg set_dev_attributes_d;

reg [15:0] bmHint ;
reg [7:0] bFormatIndex ;
reg [7:0] bFrameIndex ;
reg [31:0] dwFrameInterval ;
reg [15:0] wKeyFrameRate ;
reg [15:0] wPFrameRate ;
reg [15:0] wCompQuality ;
reg [15:0] wCompWindowSize ;
reg [15:0] wDelay ;
reg [31:0] dwMaxVideoFrameSize ;
reg [31:0] dwMaxPayloadTransferSize ;
reg [31:0] dwClockFrequency ;
reg [7:0] bmFramingInfo ;
reg [7:0] bPreferedVersion ;
reg [7:0] bMinVersion ;
reg [7:0] bMaxVersion ;

reg [15:0] bmHint_set ;
reg [7:0] bFormatIndex_set ;
reg [7:0] bFrameIndex_set ;
reg [31:0] dwFrameInterval_set ;
reg [15:0] wKeyFrameRate_set ;
reg [15:0] wPFrameRate_set ;
reg [15:0] wCompQuality_set ;
reg [15:0] wCompWindowSize_set ;
reg [15:0] wDelay_set ;
reg [31:0] dwMaxVideoFrameSize_set ;
reg [31:0] dwMaxPayloadTransferSize_set ;
reg [31:0] dwClockFrequency_set ;
reg [7:0] bmFramingInfo_set ;
reg [7:0] bPreferedVersion_set ;
reg [7:0] bMinVersion_set ;
reg [7:0] bMaxVersion_set ;

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		wr_desc_pkt_act_d <= 0 ;
		wr_ep0_act_d <= 0 ;
		wr_desc_act_d <= 0 ;
		wr_resp_pkt_act_d <= 0 ;
		rd_ep0_pkt_act_d <= 0 ;
		rd_ep0_act_d <= 0 ;
		wr_resp_act_d <= 0 ;
		set_dev_attributes_d <= 0 ;
	end
	else begin
		wr_desc_pkt_act_d <= wr_desc_pkt_act ;
		wr_ep0_act_d <= wr_ep0_act ;
		wr_desc_act_d <= wr_desc_act ;
		wr_resp_pkt_act_d <= wr_resp_pkt_act ;
		rd_ep0_pkt_act_d <= rd_ep0_pkt_act ;
		rd_ep0_act_d <= rd_ep0_act ;
		wr_resp_act_d <= wr_resp_act ;
		set_dev_attributes_d <= set_dev_attributes ;
	end
	
end

// managing set-up pkts
always @ ( posedge clk  or negedge rst_n ) begin
	if ( !rst_n ) begin
		get_descr <= 0 ;
		get_interface <= 0 ;
		get_status <= 0 ;
		set_config <= 0 ;
		get_config <= 0 ;
		set_feature <= 0 ;
		set_interface <= 0 ;
		set_sel <= 0 ;
		set_iso_delay <= 0 ;
		u1_enable <= 0 ;
		u2_enable <= 0 ;
		remoke_wakeup <= 0 ;
		LTM_enable <= 0 ;
		/*              add your own requests here    */ 
		set_current <= 0 ;
		get_current <= 0 ;
		get_maximun <= 0 ;
		get_minimun <= 0 ; 
	end
	else if ( request_active ) begin
		case ( bmRequestType[6:5] ) 
		STANDARD:begin
			case ( bRequest )
			STANDARD_GET_DESCR:begin
				get_descr <= 1 ;
			end
			STANDARD_CLEAR_FEAT:begin
				show_time();
				$display("host clear feature \n");
			end
			STANDARD_GET_INTERFACE:begin
				get_interface <= 1 ;
				show_time();
				$display("host get interface \n");
			end
			STANDARD_GET_STATUS:begin
				get_status <= 1 ;
				show_time();
				$display("host get status \n");
			end
			STANDARD_SET_CONFIG:begin
				set_config <= 1 ;
				set_config_value <= wValue ;
				show_time();
				$display("host set configuration \n");	
				$display("configuration value = %d \n" , wValue );					
			end
			STANDARD_GET_CONFIG:begin
				get_config <= 1 ;
				show_time(); 
				$display("host get configuration \n");					
			end
			STANDARD_SET_FEAT:begin
				set_feature <= 1 ;
				if ( wValue == 48 && wIndex[7:0] == RECIPIENT_DEVICE ) begin
					u1_enable <= 1 ;
				end
				else if ( wValue == 49 && wIndex[7:0] == RECIPIENT_DEVICE ) begin
					u2_enable <= 1 ;
				end
				else if ( wValue == 0 && wIndex[7:0] == RECIPIENT_DEVICE  ) begin
					remoke_wakeup <= wIndex[9] ;
				end
				else if ( wValue == 50 && wIndex[7:0] == RECIPIENT_DEVICE ) begin
					LTM_enable <= 1 ;
				end
				show_time();
				$display("host set feature \n");
			end
			STANDARD_SET_INTERFACE:begin
				set_interface <= 1 ;
				set_interface_num <= wIndex ;
				set_interface_alt_setting <= wValue ;
				show_time();
				$display("host set interface \n");
				$display("interface number = %d \n" , wIndex );
				$display("interface setting = %d \n" , wValue );
			end
			STANDARD_SET_SEL:begin
				set_sel <= 1 ;
				show_time();
				$display("host set sel \n");
			end
			STANDARD_SET_IOS_DELAY:begin
				set_iso_delay <= 1 ;
				set_iso_delay_value <= wValue ;
				show_time();
				$display("host set iso delay \n");
			end
			STANDARD_SYNC_FRAME:begin
				sync_frame <= 1 ;
				sync_frame_endpt <= wIndex ;
				show_time();
				$display("host sync frame , endpt number =%d" , wIndex ) ;
			end
			default:begin end
			endcase 
		end

		CLASS: begin
			case ( bRequest )
		/*              add your own requests here    */ 			
			SET_CUR: begin
			// set current attribute 
				set_current <= 1  ;
			end
			GET_CUR: begin
			// get current attribute 
				get_current <= 1 ;
			end
			GET_MAX: begin
				get_maximun <= 1 ;
			end
			GET_MIN: begin
				get_minimun <= 1 ;
			end
			default:begin end
			endcase 
		end
	
		default:begin 
		
		end
		endcase 
	end
	else begin
		get_descr <= 0 ;
		get_interface <= 0 ;
		get_status <= 0 ;
		set_config <= 0 ;
		get_config <= 0 ;
		set_feature <= 0 ;
		set_interface <= 0 ;
		set_sel <= 0 ;
		set_iso_delay <= 0 ;
		sync_frame <= 0 ;
		/*              add your own requests here    */  
		set_current <= 0 ;
		get_current <= 0 ;
		get_maximun <= 0 ;
		get_minimun <= 0 ;	
	end
end


always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		wr_desc_req <= 0 ;		
	end
	else if ( get_descr ) begin
		case ( wValue[15:8] ) 
		1:begin
		//DEVICE
			wr_desc_req	<= 	1 ;
			wr_desc_len <=	DESCR_USB3_DEVICE_LEN ;
			descr_offset <= DESCR_USB3_DEVICE ;
			show_time();
			$display("host requests for Device descriptor \n");
		end
		2:begin
		//CONFIGURATION
			wr_desc_req	<= 	1 ;
			wr_desc_len <=	DESCR_USB3_CONFIG_LEN ;				
			descr_offset <= DESCR_USB3_CONFIG ;
			show_time();
			$display("host requests for Config descriptor \n"); 
		end
		3:begin
		//STRING
			case ( wValue [7:0] )
			0:begin
			//STRING 0 
				wr_desc_req	<= 	1 ;
				wr_desc_len <=	DESCR_USB3_STR0_LEN ;						
				descr_offset <= DESCR_USB3_STR0 ;
			end
			1:begin
			//STRING 1
				wr_desc_req	<= 	1 ;
				wr_desc_len <=	DESCR_USB3_STR1_LEN ;						
				descr_offset <= DESCR_USB3_STR1 ;	
			end
			2:begin
			//STRING 1
				wr_desc_req	<= 	1 ;
				wr_desc_len <=	DESCR_USB3_STR2_LEN ;						
				descr_offset <= DESCR_USB3_STR2 ;	
			end			
			238:begin
			//STRING 238
				//wr_desc_req	<= 	1 ;
				wr_desc_len <=	DESCR_USB3_MSFT_LEN ;						
				descr_offset <= DESCR_USB3_MSFT ;
			end
			default:begin 
				wr_desc_req <= 0 ;
			end
			endcase 
		end
		//4:begin
		////INTERFACE
		//end
		//5:begin
		////ENDPOINT
		//end
		//8:begin
		////INTERFACE_POWER1
		//end
		//9:begin
		////OTG
		//end
		//10:begin
		////DEBUG
		//end
		//11:begin
		////INTERFACE_ASSOCIATION
		//end
		15:begin
		//BOS
			wr_desc_req	<= 	1 ;
			wr_desc_len <=	DESCR_USB3_BOS_LEN ;					
			descr_offset <= DESCR_USB3_BOS ;
			show_time();
			$display("host requests for Bos descriptor \n");
		end
		//16:begin
		////DEVICE CAPABILITY
		//end
		//48:begin
		////SUPERSPEED_USB_ENDPOINT_COMPANION
		//end
		//49:begin
		////SUPERSPEEDPLUS_ISOCHRONOUS_ENDPOINT_COMPANION
		//end
		default:begin 
			wr_desc_req <= 0 ;
		end
		endcase 
	end
	else begin
		wr_desc_req <= 0 ;
	end
end


// managing response data pkts

// write descriptors
always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		wr_desc_act <= 0 ;
		wr_desc_pkt_act <= 0 ;
	end
	else if ( wr_desc_req ) begin
		wr_desc_act <= 1 ;		
		wr_desc_len_latch <= ( wr_desc_len > wLength ) ? wLength : wr_desc_len ;
	end
	else if ( wr_desc_act ) begin 
		if ( wr_desc_pkt_act && ep0_in_buf_data_commit ) begin
			wr_desc_len_latch <= wr_desc_len_latch - ep0_in_buf_data_commit_len ;
			wr_desc_pkt_act <= 0 ;
		end
		else if ( wr_desc_len_latch > 0 ) begin
			wr_desc_pkt_act <= 1 ;
		end
		else begin
			wr_desc_act <= 0 ; 
		end
	end
end
		
// responsing requests
always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		wr_resp_act <= 0 ;
		wr_resp_pkt_act <= 0 ;
	end
	else if ( get_interface ) begin
		wr_resp_act <= 1 ;
		wr_resp_len_latch <= wLength ;
	end
	else if ( get_status ) begin
		wr_resp_act <= 1 ;
		wr_resp_len_latch <= wLength ;	
	end
	else if ( get_config ) begin
		wr_resp_act <= 1 ;
		wr_resp_len_latch <= wLength ;
	end
	/*              add your own requests here    */ 	
	else if ( get_current ) begin
		wr_resp_act <= 1 ;
		wr_resp_len_latch <= wLength ;
	end
	else if ( get_maximun ) begin
		wr_resp_act <= 1 ;
		wr_resp_len_latch <= wLength ;
	end
	else if ( get_minimun ) begin
		wr_resp_act <= 1 ;
		wr_resp_len_latch <= wLength ;		
	end
	else if ( wr_resp_act ) begin
		if ( wr_resp_pkt_act && ep0_in_buf_data_commit ) begin
			wr_resp_len_latch <= wr_resp_len_latch - ep0_in_buf_data_commit_len ;
			wr_resp_pkt_act <= 0 ;
		end
		else if ( wr_resp_len_latch > 0 ) begin
			wr_resp_pkt_act <= 1 ;
		end
		else begin
			wr_resp_act <= 0 ;
		end
	end
end	



always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin		
		wr_ep0_len_cnt <= 0 ;
		wr_ep0_act <= 0 ;
	end
	else if ( !wr_desc_pkt_act_d && wr_desc_pkt_act ) begin
		wr_ep0_act <= 1 ;
		wr_ep0_len <= ( wr_desc_len_latch >= 512 ) ?  512 : wr_desc_len_latch ;
	end
	else if ( !wr_resp_pkt_act_d && wr_resp_pkt_act ) begin
		wr_ep0_act <= 1 ; 
		wr_ep0_len <= ( wr_resp_len_latch >= 512 ) ? 512 : wr_resp_len_latch ;
	end
	else if ( wr_ep0_act && ep0_in_buf_ready ) begin
		wr_ep0_len_cnt <= wr_ep0_len_cnt + 4 ;
		if ( wr_ep0_len_cnt + 4 >= wr_ep0_len  ) begin
			wr_ep0_act <= 0 ;
			wr_ep0_len_cnt <= 0 ;
		end
	end
end	



always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		ep0_in_buf_wren <= 0 ;
	end
	else if ( wr_ep0_act && ep0_in_buf_ready ) begin
		ep0_in_buf_wren <= 1 ;
	end
	else if ( wr_ep0_act_d && !wr_ep0_act ) begin
		ep0_in_buf_wren 		<= 0 ; 
		ep0_in_buf_data_commit		<= 1 ;
		ep0_in_buf_data_commit_len	<= wr_ep0_len ;
	end
	else begin
		ep0_in_buf_wren <= 0 ;
		ep0_in_buf_data_commit <= 0 ;
	end
end


always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		descr_rd_addr <= 0 ;
	end
	else if ( wr_desc_act_d && !wr_desc_act ) begin
		descr_rd_addr <= 0 ;
	end
	else if ( wr_desc_act && wr_ep0_act ) begin
		descr_rd_addr <= descr_rd_addr + 1 ;
	end
end


reg [31:0] mem[0:127];
reg [31:0 ]descr_data_q ;
always @( posedge clk ) begin
	descr_data_q <= mem[descr_rd_addr + descr_offset];
end

initial begin
	$readmemh("./../prj/src/usb30_user_layer/usb3_descrip_rom.init", mem);
end

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		resp_rd_addr <= 0 ;
	end
	else if ( wr_resp_act_d && !wr_resp_act ) begin
		resp_rd_addr <= 0 ;
	end
	else if ( wr_resp_pkt_act && wr_ep0_act ) begin
		resp_rd_addr <= resp_rd_addr + 1 ;
	end
end


always @ ( posedge clk ) begin 
	if ( wr_resp_act  ) begin
		if ( bmRequestType[6:5] == STANDARD ) begin
			if ( bRequest [7:0] == STANDARD_GET_CONFIG ) begin
				case ( resp_rd_addr ) 
				0: resp_data_q <= {set_config_value[7:0],24'b0};
				default:begin
				end
				endcase 
			end
			else if ( bRequest [7:0] == STANDARD_GET_STATUS ) begin
				if ( wValue [7:0] ==  STANDARD_STATUS )  begin
					case ( resp_rd_addr ) 
					0: resp_data_q <= { 3'b0,LTM_enable,u2_enable,u1_enable,remoke_wakeup,SELF_POWERED[0] , 24'b0 } ;
					default: begin
					end
					endcase 
				end
			end			
			else begin
				resp_data_q <= 32'hff_ff_ff_ff ;
			end		
		end
		/*              add your own requests here    */
		else if ( bmRequestType[6:5] == CLASS ) begin
			if ( bRequest [7:0] == GET_CUR && wValue [15:8] == VS_PROBE_CONTROL ) begin
				case ( resp_rd_addr ) 
				0: resp_data_q <= { swap16(bmHint) , bFormatIndex , bFrameIndex } ;
				1: resp_data_q <= swap32 (dwFrameInterval) ;
				2: resp_data_q <= { swap16(wKeyFrameRate) , swap16(wPFrameRate) } ;
				3: resp_data_q <= { swap16(wCompQuality) , swap16(wCompWindowSize) } ;
				4: resp_data_q <= { swap16(wDelay) , swap16(dwMaxVideoFrameSize[15:0]) }  ;
				5: resp_data_q <= { swap16(dwMaxVideoFrameSize[31:16]) , swap16(dwMaxPayloadTransferSize[15:0]) }  ; 
				6: resp_data_q <= { swap16(dwMaxPayloadTransferSize[31:16]), swap16(dwClockFrequency[15:0]) }  ;
				7: resp_data_q <= { swap16(dwClockFrequency[31:16]) , bmFramingInfo , bPreferedVersion } ;
				8: resp_data_q <= { bMinVersion , bMaxVersion , 16'b0 } ;
				default: begin end
				endcase 
			end
			else if ( bRequest [7:0] == GET_MAX && wValue [15:8] == VS_PROBE_CONTROL ) begin
				case ( resp_rd_addr ) 				
				0: resp_data_q <= { swap16(bmHint) , bFormatIndex , bFrameIndex } ;
				1: resp_data_q <= swap32 (dwFrameInterval) ;
				2: resp_data_q <= { swap16(wKeyFrameRate) , swap16(wPFrameRate) } ;
				3: resp_data_q <= { swap16(wCompQuality) , swap16(wCompWindowSize) } ;
				4: resp_data_q <= { swap16(wDelay) , swap16(dwMaxVideoFrameSize[15:0]) }  ;
				5: resp_data_q <= { swap16(dwMaxVideoFrameSize[31:16]) , swap16(dwMaxPayloadTransferSize[15:0]) }  ; 
				6: resp_data_q <= { swap16(dwMaxPayloadTransferSize[31:16]), swap16(dwClockFrequency[15:0]) }  ;
				7: resp_data_q <= { swap16(dwClockFrequency[31:16]) , bmFramingInfo , bPreferedVersion } ;
				8: resp_data_q <= { bMinVersion , bMaxVersion , 16'b0 } ;	
				default: begin end
				endcase 				
			end
			else if ( bRequest [7:0] == GET_MIN && wValue [15:8] == VS_PROBE_CONTROL ) begin
				case ( resp_rd_addr ) 				
				0: resp_data_q <= { swap16(bmHint) , bFormatIndex , bFrameIndex } ;
				1: resp_data_q <= swap32 (dwFrameInterval) ;
				2: resp_data_q <= { swap16(wKeyFrameRate) , swap16(wPFrameRate) } ;
				3: resp_data_q <= { swap16(wCompQuality) , swap16(wCompWindowSize) } ;
				4: resp_data_q <= { swap16(wDelay) , swap16(dwMaxVideoFrameSize[15:0]) }  ;
				5: resp_data_q <= { swap16(dwMaxVideoFrameSize[31:16]) , swap16(dwMaxPayloadTransferSize[15:0]) }  ; 
				6: resp_data_q <= { swap16(dwMaxPayloadTransferSize[31:16]), swap16(dwClockFrequency[15:0]) }  ;
				7: resp_data_q <= { swap16(dwClockFrequency[31:16]) , bmFramingInfo , bPreferedVersion } ;
				8: resp_data_q <= { bMinVersion , bMaxVersion , 16'b0 } ;	
				default: begin end
				endcase 				
			end			
		end
	end

end

always @ ( * ) begin
	case ({wr_desc_act,wr_resp_act})
	2'b10:begin
		ep0_in_buf_data <= descr_data_q ;
	end
	2'b01:begin
		ep0_in_buf_data <= resp_data_q ;
	end
	default:begin
		ep0_in_buf_data <= 0 ;
	end
	endcase 
end   






// managing received data pkts

wire [31:0] ep0_out_buf_data_swap = swap32 ( ep0_out_buf_data ) ;
wire [7:0] ep0_out_buf_data_swap_B0 = ep0_out_buf_data_swap[7:0] ; 
wire [7:0] ep0_out_buf_data_swap_B1 = ep0_out_buf_data_swap[15:8] ; 
wire [7:0] ep0_out_buf_data_swap_B2 = ep0_out_buf_data_swap[23:16] ; 
wire [7:0] ep0_out_buf_data_swap_B3 = ep0_out_buf_data_swap[31:24] ; 

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		ep0_out_buf_data_val <= 0 ;
	end
	else begin
		ep0_out_buf_data_val <= ep0_out_buf_rden ;
	end
end
 
always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		set_sel_act <= 0 ;
		sync_frame_act <= 0 ;
		set_current_act <= 0 ;
		
		u1_sel <= 0 ;
		u1_pel <= 0 ;
		u2_sel <= 0 ;
		u2_pel <= 0 ;
		
		set_dev_attributes 				<= 0 ;
		bmHint_set 						<= 0 ;
		bFormatIndex_set 	            <= 0 ;
		bFrameIndex_set 	            <= 0 ;
		dwFrameInterval_set             <= 0 ;
		wKeyFrameRate_set 			    <= 0 ;
		wPFrameRate_set 			    <= 0 ;
		wCompQuality_set                <= 0 ;
		wCompWindowSize_set             <= 0 ;
		wDelay_set                      <= 0 ;
		dwMaxVideoFrameSize_set         <= 0 ;
		dwMaxPayloadTransferSize_set    <= 0 ;
		dwClockFrequency_set            <= 0 ;
		bmFramingInfo_set               <= 0 ;
		bPreferedVersion_set            <= 0 ;
		bMinVersion_set                 <= 0 ;
		bMaxVersion_set 		        <= 0 ;
	end
	else if ( set_sel ) begin
		set_sel_act <= 1 ;
	end
	else if ( sync_frame ) begin
		sync_frame_act <= 1 ;
	end
	else if ( set_current ) begin
		set_current_act <= 1 ;
		set_dev_attributes <= 0 ;
	end
	else if (  ep0_out_buf_data_val) begin
		if ( set_sel_act ) begin
			case ( ep0_out_buf_data_inx ) 
			0:begin
				u1_sel <= ep0_out_buf_data_swap[7:0];
				u1_pel <= ep0_out_buf_data_swap[15:8];
				u2_sel <= ep0_out_buf_data_swap[31:16];				
			end
			1:begin
				u2_pel <= ep0_out_buf_data_swap[31:0]; 
			end
			default: begin end 
			endcase 
			if ( ep0_out_buf_data_inx == 1 ) begin
				set_sel_act <= 0 ;
			end
		end
		/* add your own requests here */
		else if ( set_current_act ) begin
			case ( ep0_out_buf_data_inx ) 
			0:begin
				bmHint_set 	 		<= {ep0_out_buf_data_swap_B1,ep0_out_buf_data_swap_B0} ;
				bFormatIndex_set 	<= ep0_out_buf_data_swap_B2 ;
				bFrameIndex_set 	<= ep0_out_buf_data_swap_B3 ;
			end
			1:begin
				dwFrameInterval_set <= ep0_out_buf_data_swap ;
			end
			2:begin
				wKeyFrameRate_set <= {ep0_out_buf_data_swap_B1,ep0_out_buf_data_swap_B0} ;
				wPFrameRate_set   <= {ep0_out_buf_data_swap_B3,ep0_out_buf_data_swap_B2} ;
			end
			3:begin
				wCompQuality_set 	<= {ep0_out_buf_data_swap_B1,ep0_out_buf_data_swap_B0} ;
				wCompWindowSize_set <= {ep0_out_buf_data_swap_B3,ep0_out_buf_data_swap_B2} ;
			end
			4:begin
				wDelay_set 						 <= {ep0_out_buf_data_swap_B1,ep0_out_buf_data_swap_B0} ;
				dwMaxVideoFrameSize_set[15:0] 	 <= {ep0_out_buf_data_swap_B3,ep0_out_buf_data_swap_B2} ;
			end
			5:begin
				dwMaxVideoFrameSize_set			[31:16] <= {ep0_out_buf_data_swap_B1,ep0_out_buf_data_swap_B0} ;
				dwMaxPayloadTransferSize_set	[15:0]  <= {ep0_out_buf_data_swap_B3,ep0_out_buf_data_swap_B2} ;
			end
			6:begin
				dwMaxPayloadTransferSize_set [31:16] <= {ep0_out_buf_data_swap_B1,ep0_out_buf_data_swap_B0} ;
				dwClockFrequency_set		 [15:0]  <= {ep0_out_buf_data_swap_B3,ep0_out_buf_data_swap_B2} ;
			end
			7:begin
				dwClockFrequency_set [31:16] <= {ep0_out_buf_data_swap_B1,ep0_out_buf_data_swap_B0} ;
				bmFramingInfo_set <= ep0_out_buf_data_swap_B2 ;
				bPreferedVersion_set <= ep0_out_buf_data_swap_B3 ;
			end
			8:begin
				bMinVersion_set <=  ep0_out_buf_data_swap_B0 ;
				bMaxVersion_set <=  ep0_out_buf_data_swap_B1 ;
			end
			default:begin end
			endcase
			if ( ep0_out_buf_data_inx == 8 ) begin
				set_current_act <= 0 ;
				set_dev_attributes <= 1 ;
			end 
		end
		else if ( sync_frame_act ) begin
			case ( ep0_out_buf_data_inx ) 
			0:frame_num <= ep0_out_buf_data_swap[15:0] ;
			default:begin end
			endcase
			if ( ep0_out_buf_data_inx == 1 ) begin
				sync_frame_act <= 0 ;
			end				
		end
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		rd_ep0_act <= 0 ;
	end
	else if ( rd_ep0_act ) begin
		if ( ep0_out_buf_data_ack ) begin
			rd_ep0_act <= 0 ;
		end
	end
	else if ( ep0_out_buf_has_data ) begin
		rd_ep0_act <= 1 ;
		rd_ep0_len_latch <= ep0_out_buf_len ;
	end
	else begin
		rd_ep0_act <= 0 ;
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		rd_ep0_pkt_act <= 0 ;
		rd_ep0_len_cnt <= 0 ;
	end	
	else if ( !rd_ep0_act_d && rd_ep0_act ) begin
		rd_ep0_pkt_act <= 1 ;
		rd_ep0_len_cnt <= 0 ;
	end
	else if ( rd_ep0_pkt_act ) begin
		rd_ep0_len_cnt <= rd_ep0_len_cnt + 4 ;
		if ( rd_ep0_len_cnt + 4 >= rd_ep0_len_latch ) begin
			rd_ep0_pkt_act <= 0 ;
		end
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		ep0_out_buf_rden <= 0 ; 
		ep0_out_buf_data_ack <= 0 ;
	end
	else if ( rd_ep0_pkt_act ) begin
		ep0_out_buf_rden <= 1 ;
	end
	else if ( rd_ep0_pkt_act_d && !rd_ep0_pkt_act ) begin
		ep0_out_buf_rden <= 0 ;
		ep0_out_buf_data_ack <= 1 ;
	end
	else begin
		ep0_out_buf_rden <= 0 ;
		ep0_out_buf_data_ack <= 0 ;	
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		ep0_out_buf_data_inx <= 0 ;
	end
	else if ( ep0_out_buf_data_val ) begin
		ep0_out_buf_data_inx <= ep0_out_buf_data_inx + 1 ;
	end
	else begin
		ep0_out_buf_data_inx <= 0 ;
	end
end
	
	
// managing device's attributes
always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		bmHint <= 0 ;
		bFormatIndex <= 1 ;	// format 1 
		bFrameIndex <= 1 ;	// frame  1 
		//dwFrameInterval <= 666666 ; // 15 fps
		dwFrameInterval <= `frame_interval ; // 15 fps
		wKeyFrameRate <= 0 ; // None 
		wPFrameRate <= 0 ; // None 
		wCompQuality <= 0 ; // None 
		wCompWindowSize <= 0 ; // None 
		wDelay <= 0 ; // no latency 
		//dwMaxVideoFrameSize <= 32'd10_077_696 ; // 2592 x 1944 x 2  = 10,077,696 ( bytes per vedio frame  )
		dwMaxVideoFrameSize <= `MaxVideoFrameSize ; // 2592 x 1944 x 2  = 10,077,696 ( bytes per vedio frame  )
		//dwMaxPayloadTransferSize <= 32'd18_896 ; // dwMaxVideoFrameSize * 15 fps  / 8000 uframes =  18,896 ( bytes per usb uframe  )
		dwMaxPayloadTransferSize <= `MaxPayloadTransferSize ; // dwMaxVideoFrameSize * 15 fps  / 8000 uframes =  18,896 ( bytes per usb uframe  )
		dwClockFrequency <= 32'd125_000_000 ; // 125Mhz
		bmFramingInfo <= 0 ; // None
		bPreferedVersion <= 0 ; // None
		bMinVersion <= 0 ; // None
		bMaxVersion <= 0 ; // None
	end
	else if ( !set_dev_attributes_d && set_dev_attributes ) begin
		bmHint 						<= bmHint_set; 														
		bFormatIndex 				<= bFormatIndex_set; 			
		bFrameIndex 				<= bFrameIndex_set ;			
		dwFrameInterval 			<= dwFrameInterval_set; 		
		wKeyFrameRate 				<= wKeyFrameRate_set ;			
		wPFrameRate 	 			<= wPFrameRate_set 	;		
		wCompQuality 				<= wCompQuality_set ;			
		wCompWindowSize 			<= wCompWindowSize_set 	;	
		wDelay 						<= wDelay_set 		;			
		dwMaxVideoFrameSize 		<= dwMaxVideoFrameSize_set 	;
		dwMaxPayloadTransferSize 	<= dwMaxPayloadTransferSize;
		dwClockFrequency 			<= dwClockFrequency_set		;
		bmFramingInfo 				<= bmFramingInfo_set 	;		
		bPreferedVersion 			<= bPreferedVersion_set ;		
		bMinVersion 				<= bMinVersion_set 		;	
		bMaxVersion 				<= bMaxVersion_set 		;	
	end
end





 	
assign current_config_value = set_config_value[7:0] ;	
	
	
function [31:0] swap32 ;

input [31:0] A  ;

	begin
		swap32 = {A[7:0],A[15:8],A[23:16],A[31:24]};
	end

endfunction

function [15:0] swap16 ;

input [15:0] A ;
	
	begin
		swap16 = {A[7:0],A[15:8]} ;
	end

endfunction
	

	
	
	
task show_time ;
	begin
		$display("at time %t ns\n",$realtime/100);
	end
endtask


endmodule 

