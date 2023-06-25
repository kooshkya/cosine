module multiplier(input [15 : 0] a, input [15 : 0] b, output [15 : 0] result);
    wire [31 : 0] guardedres;
    assign guardedres = a * b;
    assign result = guardedres[26 : 11];
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