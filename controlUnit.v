module controlUnit(input clk, start, stop, rst, output reg [3 : 0] state);
    initial begin
        state = 4'b0;
    end


    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            state = 4'b0;
        end else begin
            if (state == 4'b0) begin    // state: stand by
                if (start == 1'b1) begin
                    state = 4'b001;
                end
            end else if (state == 4'b1) begin   // state: alert
                if (start == 0) begin
                    state = 4'd2;
                end
            end else if (state == 4'd2) begin   // state: startCalculation
                state = 4'd3;
            end else if (state == 4'd3) begin   // state: accumulateTerms
                if (stop == 1'b1) begin
                    state = 4'd4;
                end else begin
                    state = 4'd5;
                end
            end else if (state == 4'd4) begin   // state: calculateDistance
                state = 3'd0;
            end else if (state == 4'd5) begin   // state: remult
                state = 4'd3;
            end
        end
    end

endmodule