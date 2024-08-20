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
