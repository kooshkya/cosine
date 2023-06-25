module controlUnit(input clk, start, stop, output reg [2 : 0] state);
    initial begin
        state = 3'b0;
    end

    always @ (posedge clk) begin
        if (state == 3'b0) begin    // state: stand by
            if (start == 1'b1) begin
                state = 3'b001;
            end
        end else if (state == 3'b1) begin   // state: alert
            if (start == 0) begin
                state = 3'd2;
            end
        end else if (state == 3'd2) begin   // state: startCalculation
            state = 3'd3;
        end else if (state == 3'd3) begin   // state: accumulateTerms
            if (stop == 1'b1)
                state = 3'd4;
        end else if (state == 3'd4) begin   // state: calculateDistance
            state = 3'd0;
        end
    end

endmodule