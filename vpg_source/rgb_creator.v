module rgb_creator(
    input [11:0] h_count,
    input [11:0] v_count,
    output reg [23:0] rgb_color);
    always @ (h_count or v_count)
    begin
        case ({v_count, h_count})
            24'h000000: begin rgb_color = 24'b000000000000000000000000; end
            24'h000001: begin rgb_color = 24'b000000000000000000000000; end
            24'h000002: begin rgb_color = 24'b000000000000000000000000; end
            24'h000003: begin rgb_color = 24'b000000000000000000000000; end
            24'h000004: begin rgb_color = 24'b000000000000000000000000; end
            24'h000005: begin rgb_color = 24'b000000000000000000000000; end
            24'h000006: begin rgb_color = 24'b000000000000000000000000; end
            default: begin rgb_color = 24'b111111111111111111111111; end
        endcase
    end
endmodule