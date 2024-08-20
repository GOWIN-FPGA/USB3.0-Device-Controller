`include "UVCDefine.v"

module ddr3_controller 
#(
	 parameter APP_DATA_WIDTH = 256 
	,parameter ADDR_WIDTH	  = 28  
	,parameter APP_MASK_WIDTH = 32 
	,parameter CAM_FIFO_RD_NUM_WIDTH = 13 
	,parameter YUV_FIFO_WR_NUM_WIDTH = 16 
	,parameter DDR_FIFO_RD_NUM_WIDTH = 10
	,parameter DDR_FIFO_WR_NUM_WIDTH = 10 
)
(
	 input wire 	clk 
	,input wire		rst_n
	
	,input wire 					cmd_ready
    ,input wire 					rd_data_valid
    ,input wire 					wr_data_rdy
    ,input wire [APP_DATA_WIDTH-1:0]rd_data
	,input wire 					rd_data_end
    ,input wire 					init_calib_complete

    ,output reg         				cmd_en
    ,output reg	[2:0] 					cmd
    ,output reg [ADDR_WIDTH-1:0] 		addr 
    ,output wire[APP_DATA_WIDTH-1:0]	wr_data 
    ,output reg 						wr_data_en
    ,output reg    						wr_data_end
    ,output wire[APP_MASK_WIDTH-1:0] 	wr_data_mask 
    ,output wire						burst
    ,output wire						sr_req
    ,output wire						ref_req
	
	
	,input wire 	[CAM_FIFO_RD_NUM_WIDTH-1:0] cam_fifo_rd_num 
	,input wire		[YUV_FIFO_WR_NUM_WIDTH-1:0] yuv_fifo_wr_num  
	
	,output reg cam_fifo_rd_en 
	,input wire [31:0] cam_fifo_rd_dat 
	
	,output reg yuv_fifo_wr_en 
	,output reg [31:0] yuv_fifo_wr_dat 
	
);

localparam ST_IDLE   = 2'b00;
localparam ST_WR_CAM = 2'b01;
localparam ST_RD_CAM = 2'b10;
reg [1:0]  state ;


localparam ST_DDR_IDLE = 3'd0 ;
localparam ST_DDR_WR_1 = 3'd1 ;
localparam ST_DDR_WR_2 = 3'd2 ;
localparam ST_DDR_RD_1 = 3'd3 ;
localparam ST_DDR_RD_2 = 3'd4 ;
localparam ST_DDR_DONE = 3'd5 ;
reg [2:0] ddr_state ;



localparam DDR_WR_CMD = 3'b000 ; 
localparam DDR_RD_CMD = 3'b001 ; 

wire [27:0] ddr_segment_mem [0:3] ;

assign ddr_segment_mem[0] = 28'b0 + 0 * `width * `hidth / 2 ; 
assign ddr_segment_mem[1] = 28'b0 + 1 * `width * `hidth / 2 ;
assign ddr_segment_mem[2] = 28'b0 + 2 * `width * `hidth / 2 ;
assign ddr_segment_mem[3] = 28'b0 + 3 * `width * `hidth / 2 ;


	
wire [DDR_FIFO_RD_NUM_WIDTH-1:0] ddr_rd_fifo_depth ;
assign ddr_rd_fifo_depth[DDR_FIFO_RD_NUM_WIDTH-1] = 1 ;
assign ddr_rd_fifo_depth[DDR_FIFO_RD_NUM_WIDTH-2:0] = 0 ;

wire [DDR_FIFO_WR_NUM_WIDTH-1:0] ddr_wr_fifo_depth ;
assign ddr_wr_fifo_depth[DDR_FIFO_WR_NUM_WIDTH-1] = 1 ;
assign ddr_wr_fifo_depth[DDR_FIFO_WR_NUM_WIDTH-2:0] = 0 ;		

wire [YUV_FIFO_WR_NUM_WIDTH-1:0] yuv_fifo_depth ;
assign yuv_fifo_depth[YUV_FIFO_WR_NUM_WIDTH-1] = 1 ;
assign yuv_fifo_depth[YUV_FIFO_WR_NUM_WIDTH-2:0] = 0 ;	

reg cam_fifo_rd_dat_val ;
reg cam_fifo_rd_dat_val_last ;
reg cam_fifo_rd_en_last ;
reg rd_ddr_rd_fifo_act_d ;
reg cam_fifo_rd_act ;
reg cam_fifo_rd_act_last ;
reg rd_ddr_rd_fifo_act ;
reg [15:0] cam_fifo_rd_cnt ;
wire [DDR_FIFO_WR_NUM_WIDTH-1:0]ddr_wr_fifo_wr_num ;
wire [DDR_FIFO_WR_NUM_WIDTH-1:0]ddr_wr_fifo_rd_num ;
reg [2:0]ddr_wr_dat_pt ;
reg [31+8*32:0]ddr_wr_fifo_wr_dat; 
wire [31+8*32:0]ddr_wr_fifo_rd_dat; 
wire [31+7*32:0]ddr_rd_fifo_rd_dat; 
reg ddr_wr_fifo_wr_en; 
reg [1:0] wr_pt ;
reg [1:0] rd_pt ;
reg [23:0] rd_pix_num_cnt;
reg [23:0] wr_pix_num_cnt;
reg wr_ddr_req ;
reg [15:0] wr_ddr_dat_num ;
reg [ADDR_WIDTH-1:0]  wr_ddr_addr ;
reg [ADDR_WIDTH-1:0]  rd_ddr_addr ;
wire [DDR_FIFO_RD_NUM_WIDTH-1:0]  ddr_rd_fifo_wr_num ;
wire [DDR_FIFO_RD_NUM_WIDTH-1:0]  ddr_rd_fifo_rd_num ;
reg rd_ddr_req;
reg [15:0] rd_ddr_dat_num;
reg wr_ddr_req_ack;
reg rd_ddr_req_ack;
reg [15:0] ddr_fifo_rd_cnt;
reg [15:0] ddr_wr_cnt;
reg [15:0] ddr_rd_cnt;
reg ddr_wr_fifo_rd_en;
reg [15:0] rd_ddr_rd_fifo_act_cnt ;
reg [2:0] ddr_rd_fifo_rd_dat_pt ;
reg rd_pix_en;
reg [15:0] rd_data_valid_cnt ;


always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		cam_fifo_rd_dat_val <= 0 ;
		cam_fifo_rd_dat_val_last <= 0 ;
		cam_fifo_rd_en <= 0 ;
		cam_fifo_rd_en_last <= 0 ;
		rd_ddr_rd_fifo_act_d <= 0 ;
	end	
	else begin
		cam_fifo_rd_en <= cam_fifo_rd_act ;
		cam_fifo_rd_dat_val <= cam_fifo_rd_en ;
		cam_fifo_rd_en_last <= cam_fifo_rd_act_last ;
		cam_fifo_rd_dat_val_last <= cam_fifo_rd_en_last ;
		rd_ddr_rd_fifo_act_d <= rd_ddr_rd_fifo_act ;
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		cam_fifo_rd_act <= 0 ;
		cam_fifo_rd_cnt <= 0 ;
		cam_fifo_rd_act_last <= 0 ;
	end
	else if ( !cam_fifo_rd_act && cam_fifo_rd_num >= `width / 2 && ddr_wr_fifo_depth - ddr_wr_fifo_wr_num >= (`width/2 ) / 8 ) begin
		cam_fifo_rd_act <= 1 ;
		cam_fifo_rd_act_last <= 0 ;
	end
	else if ( cam_fifo_rd_act ) begin
		cam_fifo_rd_cnt <= cam_fifo_rd_cnt + 1 ;
		if ( cam_fifo_rd_cnt + 1 >= `width / 2 ) begin
			cam_fifo_rd_cnt <= 0 ;
			cam_fifo_rd_act <= 0 ;
			cam_fifo_rd_act_last <= 0 ;
		end	
		else if ( cam_fifo_rd_cnt + 1 >= `width / 2 - 1 ) begin
			cam_fifo_rd_act_last <= 1 ;		
		end		
	end
	else begin
		cam_fifo_rd_act_last <= 0 ;
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		ddr_wr_dat_pt <= 0 ;
	end
	else if ( cam_fifo_rd_dat_val_last ) begin
		ddr_wr_dat_pt <= 0 ;
	end
	else if ( cam_fifo_rd_dat_val ) begin
		ddr_wr_dat_pt <= ddr_wr_dat_pt + 1 ;
		if ( ddr_wr_dat_pt + 1 >= 8 ) begin
			ddr_wr_dat_pt <= 0 ;
		end		
	end
end

always @ ( posedge clk  ) begin
	if ( cam_fifo_rd_dat_val ) begin
		case ( ddr_wr_dat_pt ) 
		0:ddr_wr_fifo_wr_dat[31+32*0:0+32*0] <= cam_fifo_rd_dat ;
		1:ddr_wr_fifo_wr_dat[31+32*1:0+32*1] <= cam_fifo_rd_dat ;
		2:ddr_wr_fifo_wr_dat[31+32*2:0+32*2] <= cam_fifo_rd_dat ;
		3:ddr_wr_fifo_wr_dat[31+32*3:0+32*3] <= cam_fifo_rd_dat ;
		4:ddr_wr_fifo_wr_dat[31+32*4:0+32*4] <= cam_fifo_rd_dat ;	
		5:ddr_wr_fifo_wr_dat[31+32*5:0+32*5] <= cam_fifo_rd_dat ;	
		6:ddr_wr_fifo_wr_dat[31+32*6:0+32*6] <= cam_fifo_rd_dat ;	
		7:ddr_wr_fifo_wr_dat[31+32*7:0+32*7] <= cam_fifo_rd_dat ;	
		default:;
		endcase 
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		ddr_wr_fifo_wr_en <= 0 ;
	end
	else if ( cam_fifo_rd_dat_val && ddr_wr_dat_pt == 7 ) begin
		ddr_wr_fifo_wr_en <= 1 ;
		ddr_wr_fifo_wr_dat[31+32*8:0+32*8] <= 32'h00_00_00_00 ;
	end	
	else if ( cam_fifo_rd_dat_val_last ) begin
		ddr_wr_fifo_wr_en <= 1 ;
		case ( ddr_wr_dat_pt ) 
		0:ddr_wr_fifo_wr_dat[31+32*8:0+32*8] <= 32'h00_00_00_0F ;
		1:ddr_wr_fifo_wr_dat[31+32*8:0+32*8] <= 32'h00_00_00_FF ;
		2:ddr_wr_fifo_wr_dat[31+32*8:0+32*8] <= 32'h00_00_0F_FF ;
		3:ddr_wr_fifo_wr_dat[31+32*8:0+32*8] <= 32'h00_00_FF_FF ;
		4:ddr_wr_fifo_wr_dat[31+32*8:0+32*8] <= 32'h00_0F_FF_FF ;	
		5:ddr_wr_fifo_wr_dat[31+32*8:0+32*8] <= 32'h00_FF_FF_FF ;	
		6:ddr_wr_fifo_wr_dat[31+32*8:0+32*8] <= 32'h0F_FF_FF_FF ;	
		7:ddr_wr_fifo_wr_dat[31+32*8:0+32*8] <= 32'hFF_FF_FF_FF ;
		default:;
		endcase
	end
	else begin
		ddr_wr_fifo_wr_en <= 0 ;
	end
end

ddr_wr_fifo ddr_wr_fifo_inst(
	.Data(ddr_wr_fifo_wr_dat), //input [287:0] Data
	.Reset(!rst_n), //input Reset
	.WrClk(clk), //input WrClk
	.RdClk(clk), //input RdClk
	.WrEn(ddr_wr_fifo_wr_en), //input WrEn
	.RdEn(ddr_wr_fifo_rd_en), //input RdEn
	.Rnum(ddr_wr_fifo_rd_num), //output [9:0] Rnum	
	.Wnum(ddr_wr_fifo_wr_num), //output [9:0] Wnum	
	.Q(ddr_wr_fifo_rd_dat), //output [287:0] Q
	.Empty(), //output Empty
	.Full() //output Full
);
	



always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		state <= ST_IDLE ;
		wr_pt <= 0 ;
		rd_pt <= 0 ;
		wr_pix_num_cnt <= 0 ;
		rd_pix_num_cnt <= 0 ;
		rd_pix_en <= 0 ;
	end
	else begin
		case ( state ) 
		ST_IDLE:begin
			if ( {ddr_wr_fifo_rd_num,3'b000} >= `width / 2 ) begin
				wr_ddr_req <= 1 ;				
				wr_ddr_dat_num <= (`width/2) / 8 ;
				wr_ddr_addr <= ddr_segment_mem[wr_pt] + wr_pix_num_cnt[23:1] ;	
				state <= ST_WR_CAM ;				
			end
			else if ( rd_pix_en && ddr_rd_fifo_depth - ddr_rd_fifo_wr_num >= (`width/2) / 8 ) begin
				rd_ddr_req <= 1 ;
				rd_ddr_dat_num <= (`width/2) / 8 ;
				rd_ddr_addr <= ddr_segment_mem[rd_pt] + rd_pix_num_cnt[23:1] ;
				state <= ST_RD_CAM ;
			end
		end
		ST_WR_CAM:begin
			if ( wr_ddr_req_ack ) begin
				state <= ST_IDLE ;
				wr_ddr_req <= 0 ;
				wr_pix_num_cnt <= wr_pix_num_cnt + `width ;
				wr_ddr_addr <= 0 ;
				if ( wr_pix_num_cnt + `width >= `width * `hidth ) begin
					wr_pix_num_cnt <= 0 ;
					rd_pix_en <= 1 ;
					if ( wr_pt + 1 != rd_pt ) begin
						wr_pt <= wr_pt + 1 ;
						if ( wr_pt + 1 >= 4 ) begin
							wr_pt <= 0 ;
						end
					end
				end
			end
		end
		ST_RD_CAM:begin
			if ( rd_ddr_req_ack ) begin
				state <= ST_IDLE ;
				rd_ddr_req <= 0 ;
				rd_pix_num_cnt <= rd_pix_num_cnt + `width ;
				rd_ddr_addr <= 0 ;
				if ( rd_pix_num_cnt + `width >= `width * `hidth ) begin
					rd_pix_num_cnt <= 0 ;
					if ( rd_pt + 1 != wr_pt ) begin
						rd_pt <= rd_pt + 1 ;
						if ( rd_pt + 1 >= 4 ) begin
							rd_pt <= 0 ;
						end
					end
				end
			end
		end
		
		default:;
		endcase 
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		ddr_state <= ST_DDR_IDLE ;
		cmd <= 0 ;
		cmd_en <= 0 ;
		wr_data_en <= 0 ;
		ddr_wr_fifo_rd_en <= 0 ;
		addr <= 0 ;
	end
	else begin
		case ( ddr_state ) 
		ST_DDR_IDLE:begin
			if ( init_calib_complete ) begin
				if ( wr_ddr_req ) begin
					ddr_state <= ST_DDR_WR_1 ;
					ddr_fifo_rd_cnt <= 0 ;
					ddr_wr_cnt <= 0 ;
				end
				else if ( rd_ddr_req ) begin
					ddr_state <= ST_DDR_RD_1 ;
					ddr_rd_cnt <= 0 ;
				end
			end
		end
		ST_DDR_WR_1:begin
			wr_data_en <= 0 ;
			wr_data_end <= 0 ;					
			if ( cmd_ready ) begin
				cmd  	<= DDR_WR_CMD ;
				cmd_en	<= 1 ;
				addr 	<= wr_ddr_addr + {ddr_wr_cnt,3'b000} ;
				ddr_wr_fifo_rd_en <= 1 ;
				ddr_fifo_rd_cnt <= ddr_fifo_rd_cnt + 1 ;			
				ddr_state <= ST_DDR_WR_2 ;	
			end
		end
		ST_DDR_WR_2:begin
			ddr_wr_fifo_rd_en <= 0 ;
			cmd_en <= 0 ;		
			if ( wr_data_rdy ) begin
				wr_data_en <= 1 ;
				wr_data_end <= 1 ;	
				ddr_wr_cnt <= ddr_wr_cnt + 1 ;	
				if ( ddr_fifo_rd_cnt >= wr_ddr_dat_num ) begin
					wr_ddr_req_ack <= 1 ;					
					ddr_state <= ST_DDR_DONE ;
				end
				else begin
					ddr_state <= ST_DDR_WR_1 ;
				end				
			end
		end
		ST_DDR_RD_1:begin
			cmd_en <= 0 ;
			if ( cmd_ready ) begin
				cmd  	<= DDR_RD_CMD ;
				cmd_en	<= 1 ;
				addr 	<= rd_ddr_addr + {ddr_rd_cnt,3'b000} ;	
				ddr_rd_cnt <= ddr_rd_cnt + 1 ;
			end
			if ( ddr_rd_cnt  >= (`width/2) / 8 )  begin
				cmd_en <= 0 ;
				ddr_state <= ST_DDR_RD_2 ;
			end			
		end
		ST_DDR_RD_2:begin		
			if ( rd_data_valid_cnt >= (`width/2) / 8  ) begin
				rd_ddr_req_ack <= 1 ;
				ddr_state <= ST_DDR_DONE ;
			end
		end
		ST_DDR_DONE:begin
			wr_data_en <= 0 ;
			wr_data_end <= 0 ;		
		
			wr_ddr_req_ack <= 0 ;
			rd_ddr_req_ack <= 0 ;
			ddr_state <= ST_DDR_IDLE ;
		end
		default:;
		endcase 
	end
end


always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		rd_data_valid_cnt <= 0 ;
	end
	else if ( rd_ddr_req_ack ) begin
		rd_data_valid_cnt <= 0 ;
	end
	else if ( rd_data_valid ) begin
		rd_data_valid_cnt <= rd_data_valid_cnt + 1 ;
	end
end
	



assign wr_data = ddr_wr_fifo_rd_dat [31+32*7:0] ; 
assign wr_data_mask = ddr_wr_fifo_rd_dat [31+32*8:0+32*8] ;

	
ddr_rd_fifo ddr_rd_fifo_inst(
	.Data(rd_data), //input [255:0] Data
	.Reset(!rst_n), //input Reset	
	.WrClk(clk), //input WrClk
	.RdClk(clk), //input RdClk
	.WrEn(rd_data_valid), //input WrEn
	.RdEn(ddr_rd_fifo_rd_en), //input RdEn
	.Wnum(ddr_rd_fifo_wr_num), //output [9:0] Wnum
	.Rnum(ddr_rd_fifo_rd_num), //output [9:0] Rnum
	.Q(ddr_rd_fifo_rd_dat), //output [255:0] Q
	.Empty(), //output Empty
	.Full() //output Full
);


always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		rd_ddr_rd_fifo_act <= 0 ;
	end
	else if ( !rd_ddr_rd_fifo_act && ddr_rd_fifo_rd_num >= (`width/2) / 8 && yuv_fifo_depth - yuv_fifo_wr_num >= `width/2 ) begin
		rd_ddr_rd_fifo_act <= 1 ;
		rd_ddr_rd_fifo_act_cnt <= 0 ;
	end
	else if ( rd_ddr_rd_fifo_act ) begin
		rd_ddr_rd_fifo_act_cnt <= rd_ddr_rd_fifo_act_cnt + 1 ;
		if ( rd_ddr_rd_fifo_act_cnt + 1 >=  ( (`width/2) / 8 ) * 8 ) begin
			rd_ddr_rd_fifo_act_cnt <= 0 ;
			rd_ddr_rd_fifo_act <= 0 ;
		end
	end
end

assign ddr_rd_fifo_rd_en = rd_ddr_rd_fifo_act & rd_ddr_rd_fifo_act_cnt[2:0] == 0 ;

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		ddr_rd_fifo_rd_dat_pt <= 0 ;
	end
	else if ( rd_ddr_rd_fifo_act_d ) begin
		ddr_rd_fifo_rd_dat_pt <= ddr_rd_fifo_rd_dat_pt + 1 ;
		if ( ddr_rd_fifo_rd_dat_pt + 1 >= 8 ) begin
			ddr_rd_fifo_rd_dat_pt <= 0 ;
		end
	end
	else begin
		ddr_rd_fifo_rd_dat_pt <= 0 ;
	end
end
	
	

always @ ( posedge clk or negedge rst_n ) begin 
	if ( !rst_n ) begin
		yuv_fifo_wr_en <= 0 ;
	end
	else if ( rd_ddr_rd_fifo_act_d ) begin
		yuv_fifo_wr_en <= 1 ;
		case ( ddr_rd_fifo_rd_dat_pt ) 
		0:yuv_fifo_wr_dat <= ddr_rd_fifo_rd_dat[31+32*0:0+32*0]; 
		1:yuv_fifo_wr_dat <= ddr_rd_fifo_rd_dat[31+32*1:0+32*1];
		2:yuv_fifo_wr_dat <= ddr_rd_fifo_rd_dat[31+32*2:0+32*2];
		3:yuv_fifo_wr_dat <= ddr_rd_fifo_rd_dat[31+32*3:0+32*3];
		4:yuv_fifo_wr_dat <= ddr_rd_fifo_rd_dat[31+32*4:0+32*4];
		5:yuv_fifo_wr_dat <= ddr_rd_fifo_rd_dat[31+32*5:0+32*5];
		6:yuv_fifo_wr_dat <= ddr_rd_fifo_rd_dat[31+32*6:0+32*6];
		7:yuv_fifo_wr_dat <= ddr_rd_fifo_rd_dat[31+32*7:0+32*7];
		default:;
		endcase 
	end
	else begin
		yuv_fifo_wr_en <= 0 ;
	end
end



assign	burst	= 0 ; 
assign	sr_req  = 0 ;
assign	ref_req = 0 ;








endmodule