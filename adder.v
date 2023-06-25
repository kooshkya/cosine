module adder(input [n - 1 : 0] a, input [n - 1 : 0] b, output [n - 1 : 0] result);
    parameter n = 16;
    assign result = a + b;
endmodule


// module adder_testbench;
//     reg [15:0] a;
//     reg [15:0] b;
//     wire [15:0] result;
//     adder myadder(a, b, result);

//     initial begin
//         $monitor("a: %b, b: %b, result: %b.%b", a, b, result[15:11], result[10:0]);
//     end
//     initial begin
//         a = {6'b000011, 10'b0};
//         b = a;
//         #5;
//         a = 16'hffff;
//         b = a;
//         #5;
//     end
// endmodule