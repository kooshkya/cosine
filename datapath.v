module datapath(input clk, input [2 : 0] state, input [15:0] vSig, input [15:0] XSig, output done, output [15 : 0] distance);
    wire StandBy, Alert, StartCalculation, AccumulateTerms, CalculateDistance;
    assign StandBy = 3'd0;
    assign Alert = 3'd1;
    assign StartCalculation = 3'd2;
    assign AccumulateTerms = 3'd3;
    assign CalculateDistance = 3'd4;

    wire [15 : 0] adderA;
    wire [15 : 0] adderB;
    wire [15 : 0] adderResult;
    adder myadder();



    wire [15 : 0] multiplierA;
    wire [15 : 0] multiplierB;
    wire [15 : 0] multiplierResult;
    buffer B1 (.incoming(XSig), .cs(StartCalculation), .outgoing(multiplierA [15 : 0]));
    buffer B2 (.incoming(XSig), .cs(StartCalculation), .outgoing(multiplierB [15 : 0]));
    buffer B3 (.incoming(VContent), .cs(CalculateDistance), .outgoing(multiplierA [15 : 0]));
    buffer B4 (.incoming(expressionContent), .cs(CalculateDistance), .outgoing(multiplierA [15 : 0]));
    
    multiplier mymultiplier(.result(multiplierResult));

    wire doneRegisterLoad;
    assign doneRegisterLoad = CalculateDistance;
    defparam Done.n = 1;
    register Done (.clk(clk), .load(CalculateDistance), .clear(1'b0), .inc(1'b0), .asyncclear(StartCalculation), .data(1'b1), .Q(done));
    wire [15 : 0] VContent;
    register V (.clk(clk), .load(StartCalculation), .clear(1'b0), .inc(1'b0), .asyncclear(1'b0), .data(vSig), .Q(VContent));
    register X2 (.clk(clk), .load(StartCalculation), .clear(1'b0), .inc(1'b0), .asyncclear(1'b0), .data(multiplierResult));

    wire expressionAndTermLoad;
    or(expressionAndTermLoad, StartCalculation, AccumulateTerms);
    wire [15 : 0] expressionData;
    multiplexer exprDataMux (.I0(16'b0), .I1(adderResult [15 : 0]), .select(AccumulateTerms), .out(expressionData));
    wire [15 : 0] expressionContent;
    register expression (.clk(clk), .load(expressionAndTermLoad), .clear(1'b0), .inc(1'b0),
         .asyncclear(1'b0), .data(expressionData), .Q(expressionContent));

    wire [15 : 0] termData;
    multiplexer termDataMux (.I0({5'b1, 11'b0}), .I1(multiplierResult), .select(AccumulateTerms), .out(termData));
    wire [15 : 0] termContent;
    register term (.clk(clk), .load(expressionAndTermLoad), .clear(1'b0),
         .inc(1'b0), .asyncclear(1'b0), .data(termData), .Q(termContent));

    register distanceRegister (.clk(clk), .load(CalculateDistance), .clear(1'b0),
        .inc(1'b0), .asyncclear(1'b0), .data(multiplierResult), .Q(distance));

endmodule