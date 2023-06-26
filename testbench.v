module testbench;
    reg clk, start, rst;
    reg [15 : 0] vSig;
    reg [15 : 0] XSig;
    wire done;
    wire [15 : 0] distance;
    CUD testCircuit(.clk(clk), .start(start), .rst(rst), .vSig(vSig), .XSig(XSig), .done(done), .distance(distance));

     always begin
        #5;
        clk = ~clk;
    end

    initial begin
        clk = 1'b1;
    end

    always @ (posedge done) begin
        $display("time: %t\nDone! distance is : %b.%b and %b\n", $time, distance[15:11], distance[10:0], distance);
    end

    initial begin  
        #1;
        vSig = 16'b0000100000000000;    // v = 1
        XSig = 16'b0000010000000000;    // x = 0.5
        start = 1'b1;
        #14;
        start = 1'b0;
        #196;


        vSig = 16'b1111010000000000;    // v = -1.5
        XSig = 16'b0000100101000110;    // x = 1.1592
        start = 1'b1;
        #14;
        start = 1'b0;
        #196;


        vSig = 16'b0101101011011001;    // v = -11.35
        XSig = 16'b0001100100100010;    // x = 3.141592
        start = 1'b1;
        #14;
        start = 1'b0;
        #196;

        vSig = 16'b0100001011001101;    // v = 8.35
        XSig = 16'b0000011001001000;    // x = 0.78515
        start = 1'b1;
        #14;
        start = 1'b0;
        #196;

        // 841
        vSig = 16'b1101100000000000;    // v = -5
        XSig = 16'b0000111101001001;    // x = 1.9106
        start = 1'b1;
        #14;
        start = 1'b0;
        #100;

        // 955

        rst = 1'b1;
        #1;
        rst = 1'b0;
        vSig = 16'b0100001011001101;    // v = 8.35
        XSig = 16'b0000100111011001;    // x = 1.2309
        start = 1'b1;
        #13;
        // 969
        start = 1'b0;
        #196;


        vSig = 16'b1101100000000000;    // v = -5
        XSig = 16'b0001001111111100;    // x = 2.498
        start = 1'b1;
        #14;
        start = 1'b0;
        #196;

        vSig = 16'b1101100000000000;    // v = -5
        XSig = 16'b1110110000000100;    // x = -2.498
        start = 1'b1;
        #14;
        start = 1'b0;
        #196;


        $finish;
    end

endmodule