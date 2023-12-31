module registerr(input clk, load, clear, inc, asyncclear, input[n - 1:0] data, output reg [n - 1:0] Q);
    parameter n = 16;

    always @ (posedge clk, posedge asyncclear) begin
        if (asyncclear) begin
            Q = 0;
        end
        else begin
            if (load) begin
                Q = data;
            end else if (inc) begin
                Q = Q + 1;
            end else if (clear) begin
                Q = 0;
            end
        end
        $display("registerr\ntime: %t\nQ is now %b and data is %b and load is %b\nasyncclear: %b\n\n", $time, Q, data, load, asyncclear);
    end
endmodule