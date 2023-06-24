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
  input				[11:0]	v_active_14,
  input				[11:0]	v_active_24,
  input				[11:0]	v_active_34,
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
reg	[7:0]		pixel_x;
reg	[11:0]	v_count;
reg				h_act;
reg				h_act_d;
reg				v_act;
reg				v_act_d;
reg				pre_vga_de;
wire				h_max, hs_end, hr_start, hr_end;
wire				v_max, vs_end, vr_start, vr_end;
wire				v_act_14, v_act_24, v_act_34;
reg				boarder;
reg	[3:0]		color_mode;

//reg	[23:0] rgb_color;
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
assign v_act_14 = v_count == v_active_14;
assign v_act_24 = v_count == v_active_24;
assign v_act_34 = v_count == v_active_34;

initial begin
	$readmemh("data.txt", memory);
end

//integer file;
//
//initial begin
//	$fopen(file, "data.txt", "r");
//end

//horizontal control signals
always @ (posedge clk or negedge reset_n)
	if (!reset_n)
	begin
		h_act_d	<=	1'b0;
		h_count	<=	12'b0;
		pixel_x	<=	8'b0;
		vga_hs	<=	1'b1;
		h_act		<=	1'b0;
	end
	else
	begin
		h_act_d	<=	h_act;

		if (h_max)
			h_count	<=	12'b0;
		else
			h_count	<=	h_count + 12'b1;

		//if (h_act_d)
		pixel_x	<=	pixel_x + 8'b1;
		//else
		//	pixel_x	<=	8'b0;

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
		v_act_d		<=	1'b0;
		v_count		<=	12'b0;
		vga_vs		<=	1'b1;
		v_act			<=	1'b0;
		color_mode	<=	4'b0;
	end
	else
	begin
		if (h_max)
		begin
			v_act_d	  <=	v_act;

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

			//if (vr_start)
			//	color_mode[0] <=	1'b1;
			//else if (v_act_14)
			//	color_mode[0] <=	1'b0;
//
			//if (v_act_14)
			//	color_mode[1] <=	1'b1;
			//else if (v_act_24)
			//	color_mode[1] <=	1'b0;
//
			//if (v_act_24)
			//	color_mode[2] <=	1'b1;
			//else if (v_act_34)
			//	color_mode[2] <=	1'b0;
//
			//if (v_act_34)
			//	color_mode[3] <=	1'b1;
			//else if (vr_end)
			//	color_mode[3] <=	1'b0;
		end
	end

//pattern generator and display enable
always @(posedge clk or negedge reset_n)
begin
	if (!reset_n)
	begin
		vga_de		<=	1'b0;
		pre_vga_de	<=	1'b0;
		boarder		<=	1'b0;
	end
	else
	begin
		// ====================
		// deta sync
		vga_de		<=	pre_vga_de;
		pre_vga_de	<=	v_act && h_act;
		// ====================

		//if ((!h_act_d&&h_act) || hr_end || (!v_act_d&&v_act) || vr_end)
		//	boarder	<=	1'b1;
		//else
		//	boarder	<=	1'b0;
//
		//if (boarder)
		//	{vga_r, vga_g, vga_b} <= {8'hFF,8'hFF,8'hFF};
		//else
		//	case (color_mode)
		//		4'b0001	:	{vga_r, vga_g, vga_b}	<=	{pixel_x,8'h00,8'h00};
		//		4'b0010	:	{vga_r, vga_g, vga_b}	<=	{8'h00,pixel_x,8'h00};
		//		4'b0100	:	{vga_r, vga_g, vga_b}	<=	{8'h00,8'h00,pixel_x};
		//		4'b1000	:	{vga_r, vga_g, vga_b}	<=	{pixel_x,pixel_x,pixel_x};
		//		default	:	{vga_r, vga_g, vga_b}	<=	{8'h00,8'h00,8'h00};
		//	endcase
		//read_r <= $fscanf(file, "%d", read_r);
		//read_g <= $fscanf(file, "%d", read_g);
		//read_b <= $fscanf(file, "%d", read_b);
		//rgb_creator(h_count, v_count, read_r, read_g, read_b);

		// reg [23:0] memory [0:108*192-1];
		// vやhが足りないので、10×10は同じデータを格納
		{vga_r, vga_g, vga_b}	<= memory[(v_count-v_start)/10*192 + (h_count-h_start)/10];

		// data.txtの中身を読み込む v_count*1920+h_count行目
		//$fscanf(file, "%d", rgb_color);
		//{vga_r, vga_g, vga_b}	<= rgb_color;

		//{vga_r, vga_g, vga_b}	<=	{8'h00,8'h00,8'h00};
	end
end

// 最後にファイルを閉じる


endmodule