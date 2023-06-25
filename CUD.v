module CUD;
    reg rst;
    reg clk, start;
    wire stop, done;
    reg [15 : 0] vSig;
    reg [15 : 0] XSig;
    wire [15 : 0] distance;
    wire [2 : 0] state;
    controlUnit CU (.clk(clk), .start(start), .stop(stop), .state(state));
    datapath DP (.clk(clk), .state(state), .vSig(vSig), .XSig(XSig), .done(done), .stop(stop), .distance(distance));

    always begin
        #5;
        clk = ~clk;
    end

    initial begin
        clk = 1'b1;
        $monitor("time: %t\nclk: %b\nstart: %b, vSig: %b.%b, xSig: %b.%b\nstate: %b, stop: %b\ndistance: %b.%b\n\n", $time, clk, start, vSig[15 : 11], vSig[10 : 0],
            XSig[15 : 11], XSig[10 : 0], state, stop, distance[15 : 11], distance[10 : 0]);
    end

    initial begin  
        #1;
        vSig = 16'b0000100000000000;
        XSig = 16'b0000100001100001;
        start = 1'b1;
        #14;
        start = 1'b0;
        #200;
        $finish;
    end
endmodule