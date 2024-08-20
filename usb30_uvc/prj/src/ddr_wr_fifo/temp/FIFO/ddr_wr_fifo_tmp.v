//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.10 (64-bit)
//Part Number: GW5AST-LV138FPG676AES
//Device: GW5AST-138
//Device Version: B
//Created Time: Thu Jul 11 15:12:23 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	ddr_wr_fifo your_instance_name(
		.Data(Data), //input [287:0] Data
		.Reset(Reset), //input Reset
		.WrClk(WrClk), //input WrClk
		.RdClk(RdClk), //input RdClk
		.WrEn(WrEn), //input WrEn
		.RdEn(RdEn), //input RdEn
		.Wnum(Wnum), //output [9:0] Wnum
		.Rnum(Rnum), //output [9:0] Rnum
		.Q(Q), //output [287:0] Q
		.Empty(Empty), //output Empty
		.Full(Full) //output Full
	);

//--------Copy end-------------------
