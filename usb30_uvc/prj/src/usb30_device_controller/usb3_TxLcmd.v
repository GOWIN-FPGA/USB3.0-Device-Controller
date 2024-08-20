`include "usb3_macro_define.v"	
`ifdef SIM
module usb3_TXLcmd(
`else
module `getname(usb3_TXLcmd,`module_name)(
`endif
	input wire 		clk 
	,input wire 	rst_n
	
	,input wire 		tx_lcmd_act 
	,input wire [10:0]	tx_lcmd
	
	,input wire 		tx_lcmd_pop
	,output reg [10:0]	tx_lcmd_q
	
	,output reg 		tx_lcmd_empty
	
);


reg [2:0] rd_pt ;
reg [2:0] wr_pt ;
reg [10:0] mem [0:7] ;

//always @ ( posedge clk or negedge rst_n ) begin
always @ ( posedge clk  ) begin
	if ( !rst_n ) begin
		rd_pt <= 0 ;
		wr_pt <= 0 ;
		tx_lcmd_empty <= 1 ; 
	end
	else begin
		if ( tx_lcmd_act ) begin
			wr_pt <= wr_pt + 1 ;
		end
		
		if ( tx_lcmd_pop ) begin
			rd_pt <= rd_pt + 1 ;
		end 
		
		if ( wr_pt == rd_pt ) begin
			tx_lcmd_empty <= 1 ;
		end
		else begin
			tx_lcmd_empty <= 0 ; 
		end
		
	end
end

always @ ( posedge clk  ) begin	
	tx_lcmd_q <= mem [rd_pt] ; 
end


always @ ( posedge clk  ) begin
	if ( tx_lcmd_act ) begin
		mem [wr_pt] <= tx_lcmd ;
	end	
end
















endmodule