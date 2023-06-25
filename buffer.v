module buffer(input [n - 1 : 0] incoming, input cs, output [n - 1 : 0] outgoing);
    parameter n = 16;
    assign outgoing = (cs) ? incoming : 50'bz;
endmodule


module buffer_tb;
    reg [15:0] incoming;
    reg cs;
    wire [15:0] outgoing;
    buffer b (incoming, cs, outgoing);
    initial begin
        $monitor("inc: %b, cs: %b, out: %b, out[5] : %b", incoming, cs, outgoing, outgoing[5]);
        incoming = 16'h5555;
        cs = 1;
        #5;
        cs = 0;
        #5;
    end
endmodule