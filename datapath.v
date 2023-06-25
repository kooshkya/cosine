module datapath(input clk, input [2 : 0] state, input [15:0] v, input [15:0] XSig, output done, output [15 : 0] distance);
    wire StandBy, Alert, StartCalculation, AccumulateTerms, CalculateDistance;
    assign StandBy = 3'd0;
    assign Alert = 3'd1;
    assign StartCalculation = 3'd2;
    assign AccumulateTerms = 3'd3;
    assign CalculateDistance = 3'd4;


    adder myadder();



    wire [15 : 0] multiplierA;
    wire [15 : 0] multiplierB;
    wire [15 : 0] multiplierResult;
    buffer B1 (.incoming(XSig), .cs(StartCalculation), .outgoing(MultiplierA));
    buffer B2 (.incoming(XSig), .cs(StartCalculation), .outgoing(MultiplierB));
    multiplier mymultiplier(.result(multiplierResult));

    wire doneRegisterLoad;
    assign doneRegisterLoad = CalculateDistance;
    defparam Done.n = 1;
    register Done (.clk(clk), .load(CalculateDistance), .clear(1'b0), .inc(1'b0), .asyncclear(StartCalculation), .data(1'b1), .Q(done));
    register V (.clk(clk), .load(StartCalculation), .clear(1'b0), .inc(1'b0), asyncclear(1'b0), .data(v));
    register X2 (.clk(clk), .load(StartCalculation), .clear(1'b0), .inc(1'b0), asyncclear(1'b0), .data(multiplierResult));

    wire expressionLoad;
    or(expressionLoad, StartCalculation, AccumulateTerms);
    wire [15 : 0] expressionData;
    multiplexer exprDataMux (.I0(16'b0), .I1(adderResult), .select(AccumulateTerms), .output(expressionData));
    register expression (.clk(clk), .load(), .clear(1'b0), .inc(1'b0), asyncclear(1'b0), .data(expressionData));

    register distance (.clk(clk), .load(), .clear(1'b0), .inc(1'b0), asyncclear(1'b0), .data(expressionData))
   
endmodule