`include "UVCDefine.v" 
module PixelGen(
	input wire clk 
	,input wire rst_n
	
	,input wire cam_active 
	,input wire itp_recieved 
	,input wire yuv_fifo_full 
	,output reg 	 cam_de_active 
	,input wire [12:0] yuv_fifo_wr_num 
	
	,output reg [31:0] yuv_data 
	,output reg 	   yuv_data_val
	,output wire	   yuv_fifo_rst
);


reg yuv_gen_start;
reg [15:0] hight_cnt ;
reg [15:0] yuv_gen_num ;
reg yuv_gen_active ;
reg [15:0] yuv_gen_active_cnt ;
reg [15:0] rolling_cnt ;
reg cam_active_d ;


always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		cam_active_d <= 0 ;
	end
	else begin
		cam_active_d <= cam_active ;
	end
end

assign yuv_fifo_rst = !cam_active ;

reg yuv_fifo_almost_full ;
always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		yuv_fifo_almost_full <= 0 ;
	end
	else if ( yuv_fifo_wr_num >= (`width/2) * 2  ) begin
		yuv_fifo_almost_full <= 1 ;
	end
	else begin
		yuv_fifo_almost_full <= 0 ;
	end
end
	

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		yuv_gen_start <= 0 ;
		hight_cnt <= 0 ;
		rolling_cnt <= 0 ;
	end
	else if ( cam_active ) begin
		if (  !yuv_gen_start && !yuv_gen_active && !yuv_fifo_almost_full ) begin
			yuv_gen_start <= 1 ;  
			
			hight_cnt <= hight_cnt + 1 ;
			if ( hight_cnt + 1 >= `hidth ) begin
				hight_cnt <= 0 ;
				rolling_cnt <= rolling_cnt + 2 ;
				if ( rolling_cnt + 2 >= `width ) begin
					rolling_cnt <= 0 ;
				end								
			end
		
			yuv_gen_num <= `width / 2 ;
		
			
		end
		else begin
			yuv_gen_start <= 0 ;
		end
	end
	else begin
		yuv_gen_start <= 0 ;
	end	
end

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		yuv_gen_active <= 0 ;
		cam_de_active <= 0 ;
	end
	else if ( yuv_gen_start ) begin
		if ( yuv_fifo_full ) begin
			cam_de_active <= 1 ;
		end
		else begin
			yuv_gen_active <= 1 ;
			yuv_gen_active_cnt <= 0 ;	
		end
	end
	else if ( yuv_gen_active ) begin
		yuv_gen_active_cnt <= yuv_gen_active_cnt + 1 ;
		if ( yuv_gen_active_cnt + 1 >= yuv_gen_num ) begin
			yuv_gen_active_cnt <= 0 ;
			yuv_gen_active <= 0 ;
		end
	end
	else begin
		cam_de_active <= 0 ;
	end
end


reg [15:0] pixels_index ;
always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		yuv_data_val <= 0 ;
		pixels_index <= 0 ;
		yuv_data <= 0 ;
	end
	else if ( yuv_gen_active ) begin
		yuv_data_val <= 1 ;
		pixels_index <= pixels_index + 2 ;
		// RED GREEN BLUE color bars
		//if ( pixels_index + 2 >= 2592 ) begin
		if ( pixels_index + 2 >= `width ) begin
			pixels_index <= 0 ;
		end
		if ( pixels_index >= rolling_cnt ) begin
			//if ( pixels_index - rolling_cnt <= 864  ) begin
			if ( pixels_index - rolling_cnt <= (`width/3)  ) begin
				yuv_data <= 32'h70_10_D0_10 ;
			end
			//else if (  pixels_index - rolling_cnt <= 864 * 2 ) begin
			else if (  pixels_index - rolling_cnt <=  (`width/3)  * 2 ) begin
				yuv_data <= 32'h00_00_00_00 ;
			end
			else begin
				yuv_data <= 32'hDC_20_60_20 ;
			end
		end
		else begin
			//if ( rolling_cnt - pixels_index <= 864 ) begin
			if ( rolling_cnt - pixels_index <=  (`width/3)  ) begin
				yuv_data <= 32'hDC_20_60_20 ;
			end		
			//else if (  rolling_cnt - pixels_index <= 864 * 2 ) begin
			else if (  rolling_cnt - pixels_index <=  (`width/3)  * 2 ) begin
				yuv_data <= 32'h00_00_00_00 ;
			end
			else begin
				yuv_data <= 32'h70_10_D0_10 ;
			end			
		end
	end
	else begin
		yuv_data_val <= 0 ;
		if ( !cam_active ) begin
			pixels_index <= 0 ;
		end
	end
end
	


endmodule 