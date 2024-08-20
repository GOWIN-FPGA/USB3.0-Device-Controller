`include "usb3_macro_define.v"	
`ifdef SIM
module usb3_ep (
`else
module `getname(usb3_ep,`module_name)(
`endif

	 input wire clk 
	,input wire rst_n

	,input	wire	[31:0]	buf_in_data
	,input	wire			buf_in_wren
	,output	reg				buf_in_ready
	,input	wire			buf_in_commit
	,input	wire	[10:0]	buf_in_commit_len
	,input  wire			buf_in_eob
	,output reg 	[4:0]	buf_in_nump
	
	,input wire				buf_out_dp_acked 
	,input wire				in_ep_rty

	
	,output	reg		[31:0]	buf_out_q
	,output	reg		[10:0]	buf_out_len
	,output	reg				buf_out_hasdata
	,input	wire			buf_out_arm
	,input  wire 			buf_out_rden
	,output reg 			buf_out_eob 
	,output reg		[4:0]	buf_out_nump


);

parameter ENDPT_BURST = 0 ;
parameter BUF_OUT_DP_ACKED_VAL = 1 ;


localparam A = 0 ;
localparam B = 1 ;
localparam C = 2 ;
localparam D = 3 ;
localparam E = 4 ;
localparam F = 5 ;
localparam G = 6 ;
localparam H = 7 ;
localparam I = 8 ;
localparam J = 9 ;
localparam K = 10 ;
localparam L = 11 ;
localparam M = 12 ;
localparam N = 13 ;
localparam O = 14 ;
localparam P = 15 ;

localparam a = 0 ;
localparam b = 1 ;
localparam c = 2 ;
localparam d = 3 ;
localparam e = 4 ;
localparam f = 5 ;
localparam g = 6 ;
localparam h = 7 ;
localparam i = 8 ;
localparam j = 9 ;
localparam k = 10 ;
localparam l = 11 ;
localparam m = 12 ;
localparam n = 13 ;
localparam o = 14 ;
localparam p = 15 ;


reg [3:0] buf_in_pt ;

reg buf_a_ready ;
reg buf_b_ready ;
reg buf_c_ready ;
reg	buf_d_ready	;
reg	buf_e_ready ;
reg	buf_f_ready ;
reg	buf_g_ready ;
reg	buf_h_ready ;
reg	buf_i_ready ;
reg	buf_j_ready ;
reg	buf_k_ready ;
reg	buf_l_ready ;
reg	buf_m_ready ;
reg	buf_n_ready ;
reg	buf_o_ready ;
reg	buf_p_ready ;

reg buf_ready_mem [0:15] ;

reg buf_a_hasdata ;
reg buf_b_hasdata ;
reg buf_c_hasdata ;
reg	buf_d_hasdata ;
reg	buf_e_hasdata ;
reg	buf_f_hasdata ;
reg	buf_g_hasdata ;
reg	buf_h_hasdata ;
reg	buf_i_hasdata ;
reg	buf_j_hasdata ;
reg	buf_k_hasdata ;
reg	buf_l_hasdata ;
reg	buf_m_hasdata ;
reg	buf_n_hasdata ;
reg	buf_o_hasdata ;
reg	buf_p_hasdata ;


reg [10:0] buf_a_len ;
reg [10:0] buf_b_len ;
reg [10:0] buf_c_len ;
reg [10:0] buf_d_len ;
reg [10:0] buf_e_len ;
reg [10:0] buf_f_len ;
reg [10:0] buf_g_len ;
reg [10:0] buf_h_len ;
reg [10:0] buf_i_len ;
reg [10:0] buf_j_len ;
reg [10:0] buf_k_len ;
reg [10:0] buf_l_len ;
reg [10:0] buf_m_len ;
reg [10:0] buf_n_len ;
reg [10:0] buf_o_len ;
reg [10:0] buf_p_len ;


reg	buf_a_eob	;	
reg	buf_b_eob   ;
reg	buf_c_eob   ;
reg	buf_d_eob   ;
reg	buf_e_eob   ;
reg	buf_f_eob   ;
reg	buf_g_eob   ;
reg	buf_h_eob   ;
reg	buf_i_eob   ;
reg	buf_j_eob   ;
reg	buf_k_eob   ;
reg	buf_l_eob   ;
reg	buf_m_eob   ;
reg	buf_n_eob   ;
reg	buf_o_eob   ;
reg	buf_p_eob   ;


reg	buf_a_wt_ack   ;	
reg	buf_b_wt_ack   ;
reg	buf_c_wt_ack   ;
reg	buf_d_wt_ack   ;
reg	buf_e_wt_ack   ;
reg	buf_f_wt_ack   ;
reg	buf_g_wt_ack   ;
reg	buf_h_wt_ack   ;
reg	buf_i_wt_ack   ;
reg	buf_j_wt_ack   ;
reg	buf_k_wt_ack   ;
reg	buf_l_wt_ack   ;
reg	buf_m_wt_ack   ;
reg	buf_n_wt_ack   ;
reg	buf_o_wt_ack   ;
reg	buf_p_wt_ack   ;



reg	[3:0] buf_out_pt ;
reg	[3:0] wt_ack_pt ;
reg [8:0] buf_in_addr ;
reg [8:0] buf_out_addr;

reg [3:0] buf_out_next_dp_ack_pt ;
always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		buf_out_next_dp_ack_pt <= 0 ;
	end
	else if ( buf_out_dp_acked ) begin
		buf_out_next_dp_ack_pt <= buf_out_next_dp_ack_pt + 1 ;
		if ( buf_out_next_dp_ack_pt + 1 >= ENDPT_BURST ) begin
			buf_out_next_dp_ack_pt <= 0 ;
		end
	end
end




always @  ( * ) begin
	buf_ready_mem [A]  <= buf_a_ready ;
	buf_ready_mem [B]  <= buf_b_ready ;
	buf_ready_mem [C]  <= buf_c_ready ;
	buf_ready_mem [D]  <= buf_d_ready ;
	buf_ready_mem [E]  <= buf_e_ready ;
	buf_ready_mem [F]  <= buf_f_ready ;
	buf_ready_mem [G]  <= buf_g_ready ;
	buf_ready_mem [H]  <= buf_h_ready ;
	buf_ready_mem [I]  <= buf_i_ready ;
	buf_ready_mem [J]  <= buf_j_ready ;
	buf_ready_mem [K]  <= buf_k_ready ;
	buf_ready_mem [L]  <= buf_l_ready ;
	buf_ready_mem [M]  <= buf_m_ready ;
	buf_ready_mem [N]  <= buf_n_ready ;
	buf_ready_mem [O]  <= buf_o_ready ;
	buf_ready_mem [P]  <= buf_p_ready ;
end

reg [15:0] buf_wt_ack_mem ;

always @  ( * ) begin
	buf_wt_ack_mem [A]  <= buf_a_wt_ack ;
	buf_wt_ack_mem [B]  <= buf_b_wt_ack ;
	buf_wt_ack_mem [C]  <= buf_c_wt_ack ;
	buf_wt_ack_mem [D]  <= buf_d_wt_ack ;
	buf_wt_ack_mem [E]  <= buf_e_wt_ack ;
	buf_wt_ack_mem [F]  <= buf_f_wt_ack ;
	buf_wt_ack_mem [G]  <= buf_g_wt_ack ;
	buf_wt_ack_mem [H]  <= buf_h_wt_ack ;
	buf_wt_ack_mem [I]  <= buf_i_wt_ack ;
	buf_wt_ack_mem [J]  <= buf_j_wt_ack ;
	buf_wt_ack_mem [K]  <= buf_k_wt_ack ;
	buf_wt_ack_mem [L]  <= buf_l_wt_ack ;
	buf_wt_ack_mem [M]  <= buf_m_wt_ack ;
	buf_wt_ack_mem [N]  <= buf_n_wt_ack ;
	buf_wt_ack_mem [O]  <= buf_o_wt_ack ;
	buf_wt_ack_mem [P]  <= buf_p_wt_ack ;
end


always @ ( * ) begin
	if ( BUF_OUT_DP_ACKED_VAL) begin
		buf_in_ready <= buf_ready_mem [buf_in_pt] && !buf_wt_ack_mem[buf_in_pt] ;
	end
	else begin
		buf_in_ready <= buf_ready_mem [buf_in_pt] ;	
	end
end



always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		buf_in_pt <= 0 ;
	end
	else if ( buf_in_ready && buf_in_commit ) begin
		if ( buf_in_pt >= ENDPT_BURST - 1 ) begin
			buf_in_pt <= 0 ;
		end
		else begin
			buf_in_pt <= buf_in_pt + 1 ;
		end
	end
end

//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_a_ready <= 1 ;                                                      
		buf_a_hasdata <= 0 ;                                                    
		buf_a_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == a ) begin           
		buf_a_ready <= 0 ;                                                      
		buf_a_hasdata <= 1 ;                                                    
		buf_a_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == a ) begin         
		buf_a_ready <= 1 ;                                                      
		buf_a_hasdata <= 0 ;                                                    
		buf_a_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == a ) begin           
		buf_a_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_b_ready <= 1 ;                                                      
		buf_b_hasdata <= 0 ;                                                    
		buf_b_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == b ) begin           
		buf_b_ready <= 0 ;                                                      
		buf_b_hasdata <= 1 ;                                                    
		buf_b_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == b ) begin         
		buf_b_ready <= 1 ;                                                      
		buf_b_hasdata <= 0 ;                                                    
		buf_b_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == b ) begin           
		buf_b_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_c_ready <= 1 ;                                                      
		buf_c_hasdata <= 0 ;                                                    
		buf_c_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == c ) begin           
		buf_c_ready <= 0 ;                                                      
		buf_c_hasdata <= 1 ;                                                    
		buf_c_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == c ) begin         
		buf_c_ready <= 1 ;                                                      
		buf_c_hasdata <= 0 ;                                                    
		buf_c_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == c ) begin           
		buf_c_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_d_ready <= 1 ;                                                      
		buf_d_hasdata <= 0 ;                                                    
		buf_d_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == d ) begin           
		buf_d_ready <= 0 ;                                                      
		buf_d_hasdata <= 1 ;                                                    
		buf_d_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == d ) begin         
		buf_d_ready <= 1 ;                                                      
		buf_d_hasdata <= 0 ;                                                    
		buf_d_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == d ) begin           
		buf_d_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_e_ready <= 1 ;                                                      
		buf_e_hasdata <= 0 ;                                                    
		buf_e_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == e ) begin           
		buf_e_ready <= 0 ;                                                      
		buf_e_hasdata <= 1 ;                                                    
		buf_e_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == e ) begin         
		buf_e_ready <= 1 ;                                                      
		buf_e_hasdata <= 0 ;                                                    
		buf_e_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == e ) begin           
		buf_e_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_f_ready <= 1 ;                                                      
		buf_f_hasdata <= 0 ;                                                    
		buf_f_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == f ) begin           
		buf_f_ready <= 0 ;                                                      
		buf_f_hasdata <= 1 ;                                                    
		buf_f_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == f ) begin         
		buf_f_ready <= 1 ;                                                      
		buf_f_hasdata <= 0 ;                                                    
		buf_f_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == f ) begin           
		buf_f_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_g_ready <= 1 ;                                                      
		buf_g_hasdata <= 0 ;                                                    
		buf_g_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == g ) begin           
		buf_g_ready <= 0 ;                                                      
		buf_g_hasdata <= 1 ;                                                    
		buf_g_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == g ) begin         
		buf_g_ready <= 1 ;                                                      
		buf_g_hasdata <= 0 ;                                                    
		buf_g_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == g ) begin           
		buf_g_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_h_ready <= 1 ;                                                      
		buf_h_hasdata <= 0 ;                                                    
		buf_h_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == h ) begin           
		buf_h_ready <= 0 ;                                                      
		buf_h_hasdata <= 1 ;                                                    
		buf_h_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == h ) begin         
		buf_h_ready <= 1 ;                                                      
		buf_h_hasdata <= 0 ;                                                    
		buf_h_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == h ) begin           
		buf_h_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_i_ready <= 1 ;                                                      
		buf_i_hasdata <= 0 ;                                                    
		buf_i_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == i ) begin           
		buf_i_ready <= 0 ;                                                      
		buf_i_hasdata <= 1 ;                                                    
		buf_i_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == i ) begin         
		buf_i_ready <= 1 ;                                                      
		buf_i_hasdata <= 0 ;                                                    
		buf_i_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == i ) begin           
		buf_i_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_j_ready <= 1 ;                                                      
		buf_j_hasdata <= 0 ;                                                    
		buf_j_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == j ) begin           
		buf_j_ready <= 0 ;                                                      
		buf_j_hasdata <= 1 ;                                                    
		buf_j_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == j ) begin         
		buf_j_ready <= 1 ;                                                      
		buf_j_hasdata <= 0 ;                                                    
		buf_j_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == j ) begin           
		buf_j_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_k_ready <= 1 ;                                                      
		buf_k_hasdata <= 0 ;                                                    
		buf_k_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == k ) begin           
		buf_k_ready <= 0 ;                                                      
		buf_k_hasdata <= 1 ;                                                    
		buf_k_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == k ) begin         
		buf_k_ready <= 1 ;                                                      
		buf_k_hasdata <= 0 ;                                                    
		buf_k_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == k ) begin           
		buf_k_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_l_ready <= 1 ;                                                      
		buf_l_hasdata <= 0 ;                                                    
		buf_l_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == l ) begin           
		buf_l_ready <= 0 ;                                                      
		buf_l_hasdata <= 1 ;                                                    
		buf_l_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == l ) begin         
		buf_l_ready <= 1 ;                                                      
		buf_l_hasdata <= 0 ;                                                    
		buf_l_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == l ) begin           
		buf_l_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_m_ready <= 1 ;                                                      
		buf_m_hasdata <= 0 ;                                                    
		buf_m_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == m ) begin           
		buf_m_ready <= 0 ;                                                      
		buf_m_hasdata <= 1 ;                                                    
		buf_m_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == m ) begin         
		buf_m_ready <= 1 ;                                                      
		buf_m_hasdata <= 0 ;                                                    
		buf_m_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == m ) begin           
		buf_m_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_n_ready <= 1 ;                                                      
		buf_n_hasdata <= 0 ;                                                    
		buf_n_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == n ) begin           
		buf_n_ready <= 0 ;                                                      
		buf_n_hasdata <= 1 ;                                                    
		buf_n_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == n ) begin         
		buf_n_ready <= 1 ;                                                      
		buf_n_hasdata <= 0 ;                                                    
		buf_n_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == n ) begin           
		buf_n_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_o_ready <= 1 ;                                                      
		buf_o_hasdata <= 0 ;                                                    
		buf_o_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == o ) begin           
		buf_o_ready <= 0 ;                                                      
		buf_o_hasdata <= 1 ;                                                    
		buf_o_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == o ) begin         
		buf_o_ready <= 1 ;                                                      
		buf_o_hasdata <= 0 ;                                                    
		buf_o_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == o ) begin           
		buf_o_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             
//======================================================						 
always @ ( posedge clk or negedge rst_n ) begin									 
	if (!rst_n) begin                                                            
		buf_p_ready <= 1 ;                                                      
		buf_p_hasdata <= 0 ;                                                    
		buf_p_wt_ack <= 0 ;                                                     
	end                                                                          
	else if ( buf_in_ready && buf_in_commit && buf_in_pt == p ) begin           
		buf_p_ready <= 0 ;                                                      
		buf_p_hasdata <= 1 ;                                                    
		buf_p_eob <= buf_in_eob ;                                               
	end                                                                          
	else if ( buf_out_hasdata && buf_out_arm && buf_out_pt == p ) begin         
		buf_p_ready <= 1 ;                                                      
		buf_p_hasdata <= 0 ;                                                    
		buf_p_wt_ack <= 1 ;                                                     
	end                                                                          
	else if ( buf_out_dp_acked && buf_out_next_dp_ack_pt == p ) begin           
		buf_p_wt_ack <= 0 ;                                                     
	end                                                                          
end	                                                                             




always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		buf_in_addr <= 0 ;
	end
	else if ( buf_in_ready && buf_in_commit ) begin
		buf_in_addr <= 0 ;
	end
	else if ( buf_in_ready && buf_in_wren ) begin
		buf_in_addr <= buf_in_addr + 1 ;
	end
end

reg [11:0] buf_in_offset_mem [0:15] ;
reg [11:0] buf_in_offset ;
reg [31:0] buf_a [0: ENDPT_BURST*256 - 1 ] ;
always @ ( posedge clk  ) begin
	if ( buf_in_ready && buf_in_wren  ) begin
		buf_a [buf_in_addr+buf_in_offset] <= buf_in_data ;
	end
end

always @ ( posedge clk  ) begin 
	buf_in_offset_mem[0]  <= 12'h0_00 ;
	buf_in_offset_mem[1]  <= 12'h1_00 ;
	buf_in_offset_mem[2]  <= 12'h2_00 ;
	buf_in_offset_mem[3]  <= 12'h3_00 ;
	buf_in_offset_mem[4]  <= 12'h4_00 ;
	buf_in_offset_mem[5]  <= 12'h5_00 ;
	buf_in_offset_mem[6]  <= 12'h6_00 ;
	buf_in_offset_mem[7]  <= 12'h7_00 ;
	buf_in_offset_mem[8]  <= 12'h8_00 ;
	buf_in_offset_mem[9]  <= 12'h9_00 ;
	buf_in_offset_mem[10] <= 12'ha_00 ;
	buf_in_offset_mem[11] <= 12'hb_00 ;
	buf_in_offset_mem[12] <= 12'hc_00 ;
	buf_in_offset_mem[13] <= 12'hd_00 ;
	buf_in_offset_mem[14] <= 12'he_00 ;
	buf_in_offset_mem[15] <= 12'hf_00 ;
end



always @ ( *  ) begin
	buf_in_offset <= buf_in_offset_mem[buf_in_pt] ;
end




reg buf_out_hasdata_mem [0:15] ;
always @ ( * ) begin
	buf_out_hasdata_mem[A]  <= buf_a_hasdata ;
	buf_out_hasdata_mem[B]  <= buf_b_hasdata ;
	buf_out_hasdata_mem[C]  <= buf_c_hasdata ;
	buf_out_hasdata_mem[D]  <= buf_d_hasdata ;
	buf_out_hasdata_mem[E]  <= buf_e_hasdata ;
	buf_out_hasdata_mem[F]  <= buf_f_hasdata ;
	buf_out_hasdata_mem[G]  <= buf_g_hasdata ;
	buf_out_hasdata_mem[H]  <= buf_h_hasdata ;
	buf_out_hasdata_mem[I]  <= buf_i_hasdata ;
	buf_out_hasdata_mem[J]  <= buf_j_hasdata ;
	buf_out_hasdata_mem[K]  <= buf_k_hasdata ;
	buf_out_hasdata_mem[L]  <= buf_l_hasdata ;
	buf_out_hasdata_mem[M]  <= buf_m_hasdata ;
	buf_out_hasdata_mem[N]  <= buf_n_hasdata ;
	buf_out_hasdata_mem[O]  <= buf_o_hasdata ;
	buf_out_hasdata_mem[P]  <= buf_p_hasdata ;
end

reg buf_out_eob_mem [0:15] ;
always @ ( * ) begin
	buf_out_eob_mem[A]  <= buf_a_eob ;
	buf_out_eob_mem[B]  <= buf_b_eob ;
	buf_out_eob_mem[C]  <= buf_c_eob ;
	buf_out_eob_mem[D]  <= buf_d_eob ;
	buf_out_eob_mem[E]  <= buf_e_eob ;
	buf_out_eob_mem[F]  <= buf_f_eob ;
	buf_out_eob_mem[G]  <= buf_g_eob ;
	buf_out_eob_mem[H]  <= buf_h_eob ;
	buf_out_eob_mem[I]  <= buf_i_eob ;
	buf_out_eob_mem[J]  <= buf_j_eob ;
	buf_out_eob_mem[K]  <= buf_k_eob ;
	buf_out_eob_mem[L]  <= buf_l_eob ;
	buf_out_eob_mem[M]  <= buf_m_eob ;
	buf_out_eob_mem[N]  <= buf_n_eob ;
	buf_out_eob_mem[O]  <= buf_o_eob ;
	buf_out_eob_mem[P]  <= buf_p_eob ;
end



reg [10:0] buf_out_len_mem [0:15] ;
always @ ( posedge clk ) begin
	if ( buf_in_ready && buf_in_commit  ) begin
		buf_out_len_mem[buf_in_pt] <= buf_in_commit_len ;
	end
end

always @ ( * ) begin
	buf_out_hasdata <= buf_out_hasdata_mem [buf_out_pt] | buf_wt_ack_mem[buf_out_pt] ;
	buf_out_len		<= buf_out_len_mem [buf_out_pt] ;
end

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		buf_out_addr <= 0 ;
	end
	else if ( buf_out_hasdata && buf_out_arm ) begin
		buf_out_addr <= 0 ;
	end
	else if ( buf_out_hasdata && buf_out_rden ) begin
		buf_out_addr <= buf_out_addr + 1 ;
	end
end

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		buf_out_pt <= A ;
	end
	else if ( buf_out_hasdata && buf_out_arm  ) begin
		if ( buf_out_pt >= ENDPT_BURST - 1 ) begin
			buf_out_pt <= A ;
		end
		else begin
			buf_out_pt <= buf_out_pt + 1 ;
		end
	end
	else if (  BUF_OUT_DP_ACKED_VAL == 1 && in_ep_rty ) begin
		buf_out_pt <= wt_ack_pt ;
	end	
end

always @ ( posedge clk or negedge rst_n ) begin
	if (!rst_n) begin
		wt_ack_pt <= A ;
	end
	else if ( buf_out_dp_acked && BUF_OUT_DP_ACKED_VAL == 1 ) begin
		if ( wt_ack_pt >= ENDPT_BURST - 1 ) begin
			wt_ack_pt <= A ;
		end
		else begin
			wt_ack_pt <= wt_ack_pt + 1 ;
		end
	end
end




reg [11:0] buf_out_offset ;

always @ ( posedge clk  ) begin
	if ( buf_out_rden ) begin
		buf_out_q <= buf_a[buf_out_addr + buf_out_offset ] ;
	end
end


always @ ( * ) begin
	buf_out_offset <= buf_in_offset_mem [buf_out_pt] ;
end


always @ ( posedge clk ) begin
	if ( buf_out_nump <= 1 ) begin
		buf_out_eob <= 1 ;
	end
	else if ( buf_out_eob_mem [buf_out_pt] == 1 ) begin
		buf_out_eob <= 1 ;
	end
	else begin
		buf_out_eob <= 0 ;
	end
end


always @ ( posedge clk ) begin

	buf_in_nump <= 	  buf_a_ready 
					+ buf_b_ready 
					+ buf_c_ready 
					+ buf_d_ready					
					+ buf_e_ready					
					+ buf_f_ready					
					+ buf_g_ready					
					+ buf_h_ready					
					+ buf_i_ready					
					+ buf_j_ready					
					+ buf_k_ready					
					+ buf_l_ready					
					+ buf_m_ready					
					+ buf_n_ready					
					+ buf_o_ready					
					+ buf_p_ready					
					- ( 16 - ENDPT_BURST )			
				;
				
	buf_out_nump <= 
						buf_a_hasdata 
					+   buf_b_hasdata 
					+ 	buf_c_hasdata 
					+	buf_d_hasdata
					+	buf_e_hasdata
					+	buf_f_hasdata
					+	buf_g_hasdata
					+	buf_h_hasdata
					+	buf_i_hasdata
					+	buf_j_hasdata
					+	buf_k_hasdata
					+	buf_l_hasdata
					+	buf_m_hasdata
					+	buf_n_hasdata
					+	buf_o_hasdata					
					+	buf_p_hasdata					
								
					;
					
end




endmodule