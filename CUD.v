// note to self: you have forgotten completely to multiply x^2 by term before updating term.
module CUD;
    reg rst;
    reg clk, start;
    wire stop, done;
    reg [15 : 0] vSig;
    reg [15 : 0] XSig;
    wire [15 : 0] distance;
    wire [3 : 0] state;
    controlUnit CU (.clk(clk), .start(start), .stop(stop), .state(state), .rst(rst));
    datapath DP (.clk(clk), .state(state), .vSig(vSig), .XSig(XSig), .done(done), .stop(stop), .distance(distance));

    always begin
        #5;
        clk = ~clk;
    end

    initial begin
        clk = 1'b1;
        $monitor("time: %t\nclk: %b\nstart: %b, vSig: %b.%b, xSig: %b.%b\nstate: %b, stop: %b\ndone: %b distance: %b.%b\n\n", $time, clk, start, vSig[15 : 11], vSig[10 : 0],
            XSig[15 : 11], XSig[10 : 0], state, stop, done, distance[15 : 11], distance[10 : 0]);
        $monitoroff;
    end

    always @ (posedge done) begin
        $display("Done! distance is : %b.%b and %b\n", distance[15:11], distance[10:0], distance);
    end

    initial begin  
        #1;
        vSig = 16'b0000100000000000;    // v = 1
        XSig = 16'b0000010000000000;    // x = 0.5
        start = 1'b1;
        #14;
        start = 1'b0;
        #196;
        rst = 1'b1;
        #10;
        rst = 1'b0;
        vSig = 16'b1111010000000000;    // v = -1.5
        XSig = 16'b0000100101000110;    // x = 1.1592
        start = 1'b1;
        #14;
        start = 1'b0;
        #196;
        rst = 1'b1;
        #10;
        rst = 1'b0;
        vSig = 16'b0101101011011001;    // v = -11.35
        XSig = 16'b0001100100100010;    // x = 3.141592
        start = 1'b1;
        #14;
        start = 1'b0;
        #196;
        $finish;
    end
endmodule