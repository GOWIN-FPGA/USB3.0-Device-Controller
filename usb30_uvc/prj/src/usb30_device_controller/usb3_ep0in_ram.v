`include "usb3_macro_define.v"	
`ifdef SIM
module usb3_ep0in_ram(
`else
module `getname(usb3_ep0in_ram,`module_name)(
`endif
	input clk,
	input wr_we,
	input [7:0] wr_adr,
	input [31:0] wr_dat_w,
	input [7:0] rd_adr,
	output reg [31:0] rd_dat_r

);

reg [31:0] mem[0:1];
reg [9:0] rd_adr_i;
always @(posedge clk) begin
	if (wr_we)
		mem[wr_adr] <= wr_dat_w;
end

//always @(posedge clk) begin
//	rd_adr_i <= rd_adr;
//	rd_dat_r = mem[rd_adr_i];
//end
always @(posedge clk) begin
	rd_dat_r = mem[rd_adr];
end


endmodule
