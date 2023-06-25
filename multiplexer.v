module multiplexer (input [n - 1 : 0] I0, input [n - 1 : 0] I1, input select, output reg [n - 1 : 0] out);
    parameter n = 16;
    always @ (*) begin
        out = (select) ? I1 : I0;
    end
endmodule

module multiplexer_tb;
    reg [15 : 0] I0;
    reg [15 : 0] I1;
    reg select;
    wire [15 : 0] out;

    multiplexer m (I0, I1, select, out);

    initial begin
        $monitor("I0: %b, I1: %b\nselect: %b\nout: %b", I0, I1, select, out);
        I0 = 16'b0;
        I1 = 16'hFFFF;
        select = 0;
        #5;
        select = 1;
        #5;
        I0 = 16'h5555;
        select = 0;
        #5;
    end

endmodule