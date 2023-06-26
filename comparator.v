module comparator(input [n - 1 : 0] a, input [n - 1 : 0] b, output E);
    parameter n = 4;
    
    assign E = (a == b);
endmodule