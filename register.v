module register(input clk, load, clear, inc, asyncclear, input[n - 1:0] data, output reg [n - 1:0] Q);
    parameter n = 16;

    always @ (posedge clk, posedge asyncclear) begin
        if (asyncclear) begin
            Q = 0;
        end
        else begin
            if (load) begin
                Q = #1 data;
            end else if (inc) begin
                Q = #1 Q + 1;
            end else if (clear) begin
                Q = #1 0;
            end
        end
    end
endmodule