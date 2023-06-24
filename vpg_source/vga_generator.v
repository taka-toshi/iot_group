// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc.
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development
//   Kits made by Terasic.  Other use of this code, including the selling
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use
//   or functionality of this code.
//
// --------------------------------------------------------------------
//
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------

module vga_generator(
  input							clk,
  input							reset_n,
  input				[11:0]	h_total,
  input				[11:0]	h_sync,
  input				[11:0]	h_start,
  input				[11:0]	h_end,
  input				[11:0]	v_total,
  input				[11:0]	v_sync,
  input				[11:0]	v_start,
  input				[11:0]	v_end,
  output	reg				vga_hs,
  output	reg				vga_vs,
  output	reg				vga_de,
  output	reg	[7:0]		vga_r,
  output	reg	[7:0]		vga_g,
  output	reg	[7:0]		vga_b
);

//=======================================================
//  Signal declarations
//=======================================================
reg	[11:0]	h_count;
reg	[11:0]	v_count;
reg				h_act;
reg				v_act;
reg				pre_vga_de;
wire			h_max, hs_end, hr_start, hr_end;
wire			v_max, vs_end, vr_start, vr_end;

reg	[23:0]	rgb_data;
reg [23:0] memory [0:108*192-1];

//=======================================================
//  Structural coding
//=======================================================
assign h_max = h_count == h_total;
assign hs_end = h_count >= h_sync;
assign hr_start = h_count == h_start;
assign hr_end = h_count == h_end;
assign v_max = v_count == v_total;
assign vs_end = v_count >= v_sync;
assign vr_start = v_count == v_start;
assign vr_end = v_count == v_end;

initial begin
	$readmemh("data.txt", memory);
end

//integer file;
//initial begin
//	$fopen(file, "data.txt", "r");
//end

//horizontal control signals
always @ (posedge clk or negedge reset_n)
	if (!reset_n)
	begin
		h_count	<=	12'b0;
		vga_hs	<=	1'b1;
		h_act		<=	1'b0;
	end
	else
	begin
		if (h_max)
			h_count	<=	12'b0;
		else
			h_count	<=	h_count + 12'b1;

		// ====================
		// horizontal sync
		if (hs_end && !h_max)
			vga_hs	<=	1'b1;
		else
			vga_hs	<=	1'b0;
		// ====================

		if (hr_start)
			h_act		<=	1'b1;
		else if (hr_end)
			h_act		<=	1'b0;
	end

//vertical control signals
always@(posedge clk or negedge reset_n)
	if(!reset_n)
	begin
		v_count		<=	12'b0;
		vga_vs		<=	1'b1;
		v_act			<=	1'b0;
	end
	else
	begin
		if (h_max)
		begin
			if (v_max)
				v_count	<=	12'b0;
			else
				v_count	<=	v_count + 12'b1;

			// ====================
			// vertical sync
			if (vs_end && !v_max)
				vga_vs	<=	1'b1;
			else
				vga_vs	<=	1'b0;
			// ====================

			if (vr_start)
				v_act <=	1'b1;
			else if (vr_end)
				v_act <=	1'b0;
		end
	end

//pattern generator and display enable
always @(posedge clk or negedge reset_n)
begin
	if (!reset_n)
	begin
		vga_de		<=	1'b0;
		pre_vga_de	<=	1'b0;
	end
	else
	begin
		// ====================
		// deta sync
		vga_de		<=	pre_vga_de;
		pre_vga_de	<=	v_act && h_act;
		// ====================

		// reg [23:0] memory [0:108*192-1];
		// vやhが足りないので、10×10は同じデータを格納
		rgb_data	<= memory[(v_count-v_start)/10*192 + (h_count-h_start)/10];
		{vga_r, vga_g, vga_b}	<= rgb_data;
	end
end

endmodule