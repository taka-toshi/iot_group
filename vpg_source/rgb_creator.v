module rgb_creator(
    input [11:0] h_count,
    input [11:0] v_count,
    output reg [7:0] read_r,
    output reg [7:0] read_g,
    output reg [7:0] read_b);
    always @ (h_count or v_count)
    begin
        case ({v_count, h_count})
            12'h000: begin // 12'h000 means v_count = 0, h_count = 0
                read_r = 8'b11111111;
                read_g = 8'b00000000;
                read_b = 8'b00000000;
            end
            12'h10E: begin
                read_r = 8'b00000000;
                read_g = 8'b11111111;
                read_b = 8'b00000000;
            end
            12'h21C: begin
                read_r = 8'b00000000;
                read_g = 8'b00000000;
                read_b = 8'b11111111;
            end
            12'h32A: begin
                read_r = 8'b11111111;
                read_g = 8'b11111111;
                read_b = 8'b00000000; // yellow
            end
            default: begin
                read_r = 8'b11111111;
                read_g = 8'b11111111;
                read_b = 8'b11111111;
            end
        endcase
    end
endmodule