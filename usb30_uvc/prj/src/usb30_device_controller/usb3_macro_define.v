`define SIM

`define getname(oriName,tmodule_name) \~oriName.tmodule_name

`define module_name USB30_Device_Controller_Top  

`define ENDPT1_IN
`define ENDPT1_IN_TYPE 		2'b10
`define ENDPT1_IN_BURST  	5'd1
`define ENDPT1_IN_MAX		10'd64

`define ENDPT2_IN
`define ENDPT2_IN_TYPE 		2'b01 
`define ENDPT2_IN_BURST  	5'd16 
`define ENDPT2_IN_MAX		10'd1024 

//`define ENDPT3_IN
//`define ENDPT3_IN_TYPE 		2'b01 
//`define ENDPT3_IN_BURST  	5'd1 
//`define ENDPT3_IN_MAX		10'd1024 
//
//`define ENDPT4_IN
//`define ENDPT4_IN_TYPE 		2'b01 
//`define ENDPT4_IN_BURST  	5'd1
//`define ENDPT4_IN_MAX		10'd1024 
//
//`define ENDPT5_IN
//`define ENDPT5_IN_TYPE 		2'b01 
//`define ENDPT5_IN_BURST  	5'd1 
//`define ENDPT5_IN_MAX		10'd1024 
//
//`define ENDPT6_IN
//`define ENDPT6_IN_TYPE 		2'b01 
//`define ENDPT6_IN_BURST  	5'd1 
//`define ENDPT6_IN_MAX		10'd1024 
//
//`define ENDPT7_IN
//`define ENDPT7_IN_TYPE 		2'b01 
//`define ENDPT7_IN_BURST  	5'd1 
//`define ENDPT7_IN_MAX		10'd1024 
//
//`define ENDPT8_IN
//`define ENDPT8_IN_TYPE 		2'b01 
//`define ENDPT8_IN_BURST  	5'd1 
//`define ENDPT8_IN_MAX		10'd1024 
//
//`define ENDPT9_IN
//`define ENDPT9_IN_TYPE 		2'b01 
//`define ENDPT9_IN_BURST  	5'd1 
//`define ENDPT9_IN_MAX		10'd1024 
//
//`define ENDPT10_IN
//`define ENDPT10_IN_TYPE 	2'b01 
//`define ENDPT10_IN_BURST  	5'd1 
//`define ENDPT10_IN_MAX		10'd1024 
//
//`define ENDPT11_IN
//`define ENDPT11_IN_TYPE 	2'b01 
//`define ENDPT11_IN_BURST  	5'd1 
//`define ENDPT11_IN_MAX		10'd1024 
//
//`define ENDPT12_IN
//`define ENDPT12_IN_TYPE 	2'b01 
//`define ENDPT12_IN_BURST  	5'd1
//`define ENDPT12_IN_MAX		10'd1024 
//
//`define ENDPT13_IN
//`define ENDPT13_IN_TYPE 	2'b01 
//`define ENDPT13_IN_BURST  	5'd1 
//`define ENDPT13_IN_MAX		10'd1024 
//
//`define ENDPT14_IN
//`define ENDPT14_IN_TYPE 	2'b01 
//`define ENDPT14_IN_BURST  	5'd1 
//`define ENDPT14_IN_MAX		10'd1024 
//
//`define ENDPT15_IN
//`define ENDPT15_IN_TYPE 	2'b01 
//`define ENDPT15_IN_BURST  	5'd1 
//`define ENDPT15_IN_MAX		10'd1024 
//
//
//`define ENDPT1_OUT
//`define ENDPT1_OUT_TYPE 	2'b01
//`define ENDPT1_OUT_BURST  	5'd1
//`define ENDPT1_OUT_MAX		10'd1024 

//`define ENDPT2_OUT
//`define ENDPT2_OUT_TYPE 	2'b01 
//`define ENDPT2_OUT_BURST  	5'd16
//`define ENDPT2_OUT_MAX		10'd1024 

//`define ENDPT3_OUT
//`define ENDPT3_OUT_TYPE 	2'b01 
//`define ENDPT3_OUT_BURST  	5'd1 
//`define ENDPT3_OUT_MAX		10'd1024 
//
//`define ENDPT4_OUT
//`define ENDPT4_OUT_TYPE 	2'b01 
//`define ENDPT4_OUT_BURST  	5'd1 
//`define ENDPT4_OUT_MAX		10'd1024 
//
//`define ENDPT5_OUT
//`define ENDPT5_OUT_TYPE 	2'b01 
//`define ENDPT5_OUT_BURST  	5'd1 
//`define ENDPT5_OUT_MAX		10'd1024 
//
//`define ENDPT6_OUT
//`define ENDPT6_OUT_TYPE 	2'b01 
//`define ENDPT6_OUT_BURST  	5'd1 
//`define ENDPT6_OUT_MAX		10'd1024 
//
//`define ENDPT7_OUT
//`define ENDPT7_OUT_TYPE 	2'b01 
//`define ENDPT7_OUT_BURST  	5'd1
//`define ENDPT7_OUT_MAX		10'd1024 
//
//`define ENDPT8_OUT
//`define ENDPT8_OUT_TYPE 	2'b01 
//`define ENDPT8_OUT_BURST  	5'd1 
//`define ENDPT8_OUT_MAX		10'd1024 
//
//`define ENDPT9_OUT
//`define ENDPT9_OUT_TYPE 	2'b01 
//`define ENDPT9_OUT_BURST  	5'd1 
//`define ENDPT9_OUT_MAX		10'd1024 
//
//`define ENDPT10_OUT
//`define ENDPT10_OUT_TYPE 	2'b01 
//`define ENDPT10_OUT_BURST  	5'd1 
//`define ENDPT10_OUT_MAX		10'd1024 
//
//`define ENDPT11_OUT
//`define ENDPT11_OUT_TYPE 	2'b01 
//`define ENDPT11_OUT_BURST  	5'd1 
//`define ENDPT11_OUT_MAX		10'd1024 
//
//`define ENDPT12_OUT
//`define ENDPT12_OUT_TYPE 	2'b01 
//`define ENDPT12_OUT_BURST  	5'd1 
//`define ENDPT12_OUT_MAX		10'd1024 
//
//`define ENDPT13_OUT
//`define ENDPT13_OUT_TYPE 	2'b01 
//`define ENDPT13_OUT_BURST  	5'd1 
//`define ENDPT13_OUT_MAX		10'd1024 
//
//`define ENDPT14_OUT
//`define ENDPT14_OUT_TYPE 	2'b01 
//`define ENDPT14_OUT_BURST  	5'd1 
//`define ENDPT14_OUT_MAX		10'd1024 
//
//`define ENDPT15_OUT
//`define ENDPT15_OUT_TYPE 	2'b01 
//`define ENDPT15_OUT_BURST  	5'd1 
//`define ENDPT15_OUT_MAX		10'd1024 

