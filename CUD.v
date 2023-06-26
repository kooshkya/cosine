module CUD(input clk, start, rst, input [15 : 0] vSig, input [15 : 0] XSig, output done, output [15 : 0] distance);
    wire stop;
    wire [3 : 0] state;
    controlUnit CU (.clk(clk), .start(start), .stop(stop), .state(state), .rst(rst));
    datapath DP (.clk(clk), .state(state), .vSig(vSig), .XSig(XSig), .done(done), .stop(stop), .distance(distance));
endmodule