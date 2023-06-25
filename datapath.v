module datapath(input clk, input [2 : 0] state, input [15:0] vSig, input [15:0] XSig, output done, stop, output [15 : 0] distance);
    wire StandBy, Alert, StartCalculation, AccumulateTerms, CalculateDistance;
    assign StandBy = (state == 3'd0);
    assign Alert = (state == 3'd1);
    assign StartCalculation = (state == 3'd2);
    assign AccumulateTerms = (state == 3'd3);
    assign CalculateDistance = (state == 3'd4);

    wire [15 : 0] adderA;
    wire [15 : 0] adderB;
    wire [15 : 0] adderResult;
    assign adderA = expressionContent;
    assign adderB = termContent;
    adder myadder(.a(adderA), .b(adderB), .result(adderResult));

    wire [15 : 0] VContent;
    wire [15 : 0] expressionContent;
    wire [15 : 0] expressionData;
    wire expressionAndTermLoad;
    wire [15 : 0] termData;
    wire [15 : 0] termContent;
    wire [15 : 0] counterContent;

    wire [15 : 0] coefficient;


    wire [15 : 0] multiplierA;
    wire [15 : 0] multiplierB;
    wire [15 : 0] multiplierResult;
    buffer B1 (.incoming(XSig), .cs(StartCalculation), .outgoing(multiplierA));
    buffer B2 (.incoming(XSig), .cs(StartCalculation), .outgoing(multiplierB));
    buffer B3 (.incoming(VContent), .cs(CalculateDistance), .outgoing(multiplierA));
    buffer B4 (.incoming(expressionContent), .cs(CalculateDistance), .outgoing(multiplierB));
    buffer B5 (.incoming(termContent), .cs(AccumulateTerms), .outgoing(multiplierA));
    buffer B6 (.incoming(coefficient), .cs(AccumulateTerms), .outgoing(multiplierB));
    
    multiplier mymultiplier(.a(multiplierA), .b(multiplierB), .result(multiplierResult));

    wire doneRegisterLoad;
    assign doneRegisterLoad = CalculateDistance;
    defparam Done.n = 1;
    register Done (.clk(clk), .load(CalculateDistance), .clear(1'b0), .inc(1'b0), .asyncclear(StartCalculation), .data(1'b1), .Q(done));
    register V (.clk(clk), .load(StartCalculation), .clear(1'b0), .inc(1'b0), .asyncclear(1'b0), .data(vSig), .Q(VContent));
    register X2 (.clk(clk), .load(StartCalculation), .clear(1'b0), .inc(1'b0), .asyncclear(1'b0), .data(multiplierResult));
    register counter (.clk(clk), .load(StartCalculation), .clear(1'b0),
        .inc(AccumulateTerms), .asyncclear(1'b0), .data(16'b0), .Q(counterContent));
    or(expressionAndTermLoad, StartCalculation, AccumulateTerms);

    multiplexer exprDataMux (.I0(16'b0), .I1(adderResult), .select(AccumulateTerms), .out(expressionData));
    registerr expression (.clk(clk), .load(expressionAndTermLoad), .clear(1'b0), .inc(1'b0),
         .asyncclear(1'b0), .data(expressionData), .Q(expressionContent));

    multiplexer termDataMux (.I0({5'b00001, 11'b0}), .I1(multiplierResult), .select(AccumulateTerms), .out(termData));
    register term (.clk(clk), .load(expressionAndTermLoad), .clear(1'b0),
         .inc(1'b0), .asyncclear(1'b0), .data(termData), .Q(termContent));

    register distanceRegister (.clk(clk), .load(CalculateDistance), .clear(1'b0),
        .inc(1'b0), .asyncclear(1'b0), .data(multiplierResult), .Q(distance));

    myrom therom (counterContent[2 : 0], coefficient);

    assign stop = (counterContent[3 : 0] == 4'b1000) ? 1'b1 : 1'b0;

    // always @ (clk) begin
    //     $display("time: %t\nmultiplierA: %b, multiplierB: %b, multiplierResult: %b\nexpressionContent: %b\n\n",
    //          $time, multiplierA, multiplierB, multiplierResult, expressionContent);
    //     $display("adderA: %b, adderB: %b, adderResult: %b\n\n",
    //         adderA, adderB, adderResult);
    // end
    always @ (clk) begin

        $display("time: %t\nexpressionContent: %b, termContent: %b, addResult: %b\n\n", $time, expressionContent, termContent, adderResult);
    end
endmodule