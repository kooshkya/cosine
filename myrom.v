module myrom (input [2 : 0] select, output reg [15 : 0] data);
    always @ (*) begin
        if (select == 3'b000) begin
            data = 16'b1111110000000000;
        end else if (select == 3'b001) begin
            data = 16'b1111111101010101;
        end else if (select == 3'b010) begin
            data = 16'b1111111110111100;
        end else if (select == 3'b011) begin
            data = 16'b1111111111011011;
        end else if (select == 3'b100) begin
            data = 16'b1111111111101001;
        end else if (select == 3'b101) begin
            data = 16'b1111111111110000;
        end else  if (select == 3'b110) begin
            data = 16'b1111111111110101;
        end
    end
endmodule