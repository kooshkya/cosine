module multiplier(input [15 : 0] a, input [15 : 0] b, output [15 : 0] result);
    wire [31 : 0] guardedres;
    wire [15 : 0] unsignedResult;
    wire [15 : 0] aShadow;
    wire [15 : 0] bShadow;
    wire sign;
    assign sign = a[15] ^ b[15];
    assign aShadow = (a[15]) ? ((~a) + 1) : a;
    assign bShadow = (b[15]) ? ((~b) + 1) : b;
    assign guardedres = aShadow * bShadow;
    assign unsignedResult = guardedres[26 : 11];
    assign result = (sign) ? ((~unsignedResult) + 1) : unsignedResult;
endmodule


// module multiplier_testbench;
//     reg [15:0] a;
//     reg [15:0] b;
//     wire [15:0] result;
//     multiplier mymult(a, b, result);

//     initial begin
//         $monitor("a: %b, b: %b, result: %b.%b", a, b, result[15:11], result[10:0]);
//     end
//     initial begin
//         a = {6'b000011, 10'b0};
//         b = a;
//         #5;
//         a = {5'b00001, 2'b11, 9'b0};
//         b = {5'b00011, 3'b001, 8'b0};
//         #5;
//     end
// endmodule