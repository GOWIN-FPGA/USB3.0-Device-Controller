`include "usb3_macro_define.v"
`ifdef SIM
module usb3_TxHp(
`else
module `getname(usb3_TxHp,`module_name) (
`endif	
	input wire clk 
	,input wire rst_n

	,input wire    		hp_wr
	,input wire [31:0]  hp_word_0
	,input wire [31:0]  hp_word_1
	,input wire [31:0]  hp_word_2
	
	,output reg			hp_empty 
	,input wire			hp_rd 
	,output reg	[31:0]	hp_word_0_q
	,output reg	[31:0]	hp_word_1_q
	,output reg	[31:0]	hp_word_2_q
	

);


reg [2:0] rd_pt ;
reg [2:0] wr_pt ;
reg [95:0] mem [0:7]  ;

always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		rd_pt <= 0 ;
		wr_pt <= 0 ;
		hp_empty <= 1 ; 
	end
	else begin
		if ( hp_wr ) begin
			wr_pt <= wr_pt + 1 ;
		end
		
		if ( hp_rd ) begin
			rd_pt <= rd_pt + 1 ;
		end 
		
		if ( wr_pt == rd_pt ) begin
			hp_empty <= 1 ;
		end
		else begin
			hp_empty <= 0 ; 
		end
		
	end
end

always @ ( posedge clk  ) begin	
	if ( hp_rd ) begin 
		{ hp_word_2_q , hp_word_1_q , hp_word_0_q } <= mem [rd_pt] ; 
	end
end


always @ ( posedge clk  ) begin
	if ( hp_wr ) begin
		mem [wr_pt] <= { hp_word_2 ,hp_word_1,hp_word_0 }  ;
	end	
end




endmodule