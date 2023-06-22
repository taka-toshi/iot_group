module rgb_creator(
    input [11:0] h_count,
    input [11:0] v_count,
    output reg [7:0] read_r,
    output reg [7:0] read_g,
    output reg [7:0] read_b);
    always @ (h_count or v_count)
    begin
        if (v_count >= 0 && v_count <= 269 && h_count >= 0 && h_count <= 1920)
        begin
            read_r = 8'b11111111;
            read_g = 8'b00000000;
            read_b = 8'b00000000;
        end
        else if (v_count >= 270 && v_count <= 539 && h_count >= 0 && h_count <= 1920)
        begin
            read_r = 8'b00000000;
            read_g = 8'b11111111;
            read_b = 8'b00000000;
        end
        else if (v_count >= 540 && v_count <= 809 && h_count >= 0 && h_count <= 1920)
        begin
            read_r = 8'b00000000;
            read_g = 8'b00000000;
            read_b = 8'b11111111;
        end
        else if (v_count >= 810 && v_count <= 1079 && h_count >= 0 && h_count <= 1920)
        begin
            read_r = 8'b11111111;
            read_g = 8'b11111111;
            read_b = 8'b00000000; // yellow
        end
        else
        begin
            read_r = 8'b00000000;
            read_g = 8'b00000000;
            read_b = 8'b00000000;
        end
    end
endmodule