module datapath(input clk, input [3 : 0] state, input [15:0] vSig, input [15:0] XSig, output done, stop, output [15 : 0] distance);
    wire StandBy, Alert, StartCalculation, AccumulateTerms, Remult, CalculateDistance;
    comparator StandByComp(.a(state), .b(4'd0), .E(StandBy));
    comparator AlertComp(.a(state), .b(4'd1), .E(Alert));
    comparator StartCalculationComp(.a(state), .b(4'd2), .E(StartCalculation));
    comparator AccumulateTermsComp(.a(state), .b(4'd3), .E(AccumulateTerms));
    comparator CalculateDistanceComp(.a(state), .b(4'd4), .E(CalculateDistance));
    comparator RemultComp(.a(state), .b(4'd5), .E(Remult));
   

    wire [15 : 0] VContent;
    wire [15 : 0] expressionContent;
    wire [15 : 0] expressionData;
    wire expressionLoad, termLoad;
    wire [15 : 0] termData;
    wire [15 : 0] termContent;
    wire [15 : 0] counterContent;
    wire [15 : 0] X2Content;

    wire [15 : 0] coefficient;

    wire [15 : 0] adderResult;
    adder myadder(.a(expressionContent), .b(termContent), .result(adderResult));


    wire [15 : 0] multiplierA;
    wire [15 : 0] multiplierB;
    wire [15 : 0] multiplierResult;
    buffer B1 (.incoming(XSig), .cs(StartCalculation), .outgoing(multiplierA));
    buffer B2 (.incoming(XSig), .cs(StartCalculation), .outgoing(multiplierB));
    buffer B3 (.incoming(VContent), .cs(CalculateDistance), .outgoing(multiplierA));
    buffer B4 (.incoming(expressionContent), .cs(CalculateDistance), .outgoing(multiplierB));
    buffer B5 (.incoming(termContent), .cs(AccumulateTerms), .outgoing(multiplierA));
    buffer B6 (.incoming(coefficient), .cs(AccumulateTerms), .outgoing(multiplierB));
    buffer B7 (.incoming(termContent), .cs(Remult), .outgoing(multiplierA));
    buffer B8 (.incoming(X2Content), .cs(Remult), .outgoing(multiplierB));
    
    multiplier mymultiplier(.a(multiplierA), .b(multiplierB), .result(multiplierResult));

    defparam Done.n = 1;
    register Done (.clk(clk), .load(CalculateDistance), .clear(1'b0), .inc(1'b0), .asyncclear(StartCalculation), .data(1'b1), .Q(done));
    register V (.clk(clk), .load(StartCalculation), .clear(1'b0), .inc(1'b0), .asyncclear(1'b0), .data(vSig), .Q(VContent));
    register X2 (.clk(clk), .load(StartCalculation), .clear(1'b0), .inc(1'b0), .asyncclear(1'b0), .data(multiplierResult), .Q(X2Content));
    register counter (.clk(clk), .load(StartCalculation), .clear(1'b0),
        .inc(AccumulateTerms), .asyncclear(1'b0), .data(16'b0), .Q(counterContent));

    or(expressionLoad, StartCalculation, AccumulateTerms);
    multiplexer exprDataMux (.I0(16'b0), .I1(adderResult), .select(AccumulateTerms), .out(expressionData));
    register expression (.clk(clk), .load(expressionLoad), .clear(1'b0), .inc(1'b0),
         .asyncclear(1'b0), .data(expressionData), .Q(expressionContent));

    or(termLoad, StartCalculation, AccumulateTerms, Remult);
    multiplexer termDataMux (.I0(multiplierResult), .I1({5'b00001, 11'b0}), .select(StartCalculation), .out(termData));
    register term (.clk(clk), .load(termLoad), .clear(1'b0),
         .inc(1'b0), .asyncclear(1'b0), .data(termData), .Q(termContent));

    register distanceRegister (.clk(clk), .load(CalculateDistance), .clear(1'b0),
        .inc(1'b0), .asyncclear(1'b0), .data(multiplierResult), .Q(distance));

    myrom therom (counterContent[2 : 0], coefficient);

    comparator CounterStop(.a(counterContent), .b(16'd8), .E(stop));
    defparam CounterStop.n = 16;

    // always @ (clk) begin
    //     $display("time: %t\nmultiplierA: %b, multiplierB: %b, multiplierResult: %b\nexpressionContent: %b\n\n",
    //          $time, multiplierA, multiplierB, multiplierResult, expressionContent);
    //     $display("adderA: %b, adderB: %b, adderResult: %b\n\n",
    //         adderA, adderB, adderResult);
    // end
    // always @ (clk) begin
    //     $display("time: %t\nexpressionContent: %b, termContent: %b, addResult: %b\n\n", $time, expressionContent, termContent, adderResult);
    // end
    // always @ (clk) begin
    //     $display("time: %t\nstate: %d, count: %d\n", $time, state, counterContent);
    // end
endmodule