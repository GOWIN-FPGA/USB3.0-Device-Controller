//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.9.03 (64-bit) 
//Created Time: 2024-04-25 14:42:42
create_clock -name sys_clk -period 20 -waveform {0 10} [get_ports {sys_clk}]
create_clock -name pclk -period 8 -waveform {0 4} [get_nets {pclk}]
create_clock -name Inst_SerDes_Top/upar_clk_i -period 16.667 -waveform {0 8.334} [get_nets {SerDes_Top_inst/upar_arbiter_wrap_SerDes_Top_inst_drp_clk_o[5]}]
set_false_path -from [get_clocks {pclk}] -to [get_clocks {Inst_SerDes_Top/upar_clk_i}] 
set_false_path -from [get_clocks {Inst_SerDes_Top/upar_clk_i}] -to [get_clocks {pclk}] 
