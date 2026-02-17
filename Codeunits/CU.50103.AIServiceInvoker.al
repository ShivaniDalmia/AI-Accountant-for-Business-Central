codeunit 50103 "AI Service Invoker"
{
    // This codeunit prepares context for AI analysis and can be extended
    // to integrate with actual AI services (OpenAI, Azure OpenAI, etc.)
    var
        LineBreak: Text;

    procedure AnalyzeVendorContext(Context: JsonObject): Text;
    var
        ResponseJson: JsonObject;
        Response: Text;
    begin
        // In a production environment, this would send to an AI service
        // For now, it returns the context formatted for AI analysis

        Response := BuildAnalysisPrompt(Context);
        exit(Response);
    end;

    procedure GetPaymentSuggestions(Context: JsonObject): Text;
    var
        Response: Text;
    begin
        // Builds structured context for AI to make payment suggestions
        Response := BuildPaymentSuggestionPrompt(Context);
        exit(Response);
    end;

    procedure GenerateVendorAnalysis(Summary: Record "AI Overdue Summary"): Text
    var
        Context: JsonObject;
        Analysis: Text;
    begin
        Context := BuildVendorContext(Summary);
        Analysis := AnalyzeVendorContext(Context);
        exit(Analysis);
    end;

    procedure GeneratePaymentAdvice(Summary: Record "AI Overdue Summary"; Suggestion: Record "AI Payment Suggestion"): Text
    var
        Context: JsonObject;
        Advice: Text;
    begin
        Context := BuildPaymentContext(Summary, Suggestion);
        Advice := GetPaymentSuggestions(Context);
        exit(Advice);
    end;

    procedure BuildVendorContext(Summary: Record "AI Overdue Summary"): JsonObject
    var
        Context: JsonObject;
        VendorData: JsonObject;
        RiskData: JsonObject;
        VendLedger: Record "Vendor Ledger Entry";
        InvoiceArray: JsonArray;
        InvoiceObj: JsonObject;
    begin
        // Build vendor information
        VendorData.Add('vendorNo', Summary."Vendor No.");
        VendorData.Add('vendorName', Summary."Vendor Name");
        VendorData.Add('currencyCode', Summary."Currency Code");
        VendorData.Add('totalOpenAmount', Summary."Total Open Amount");
        VendorData.Add('invoiceCount', Summary."Invoice Count");
        VendorData.Add('totalHistoricalAmount', Summary."Total Historical Amount");

        // Build risk profile
        RiskData.Add('riskScore', Summary."Risk Score");
        RiskData.Add('riskLevel', Summary."Risk Level");
        RiskData.Add('maxOverdueDays', Summary."Max Overdue Days");
        RiskData.Add('averageDaysOverdue', Summary."Average Days Overdue");
        RiskData.Add('overduePercentage', Summary."Overdue Percentage");
        RiskData.Add('paymentReliability', Summary."Payment Reliability");
        RiskData.Add('paymentPatternScore', Summary."Payment Pattern Score");
        RiskData.Add('lastPaymentDate', Format(Summary."Last Payment Date"));
        RiskData.Add('daysSinceLastPayment', Summary."Days Since Last Payment");

        // Build invoice details
        VendLedger.SetRange("Vendor No.", Summary."Vendor No.");
        VendLedger.SetRange(Open, true);
        if VendLedger.FindSet() then
            repeat
                InvoiceObj.Add('documentNo', VendLedger."Document No.");
                InvoiceObj.Add('dueDate', Format(VendLedger."Due Date"));
                InvoiceObj.Add('daysOverdue', (WorkDate() - VendLedger."Due Date"));
                InvoiceObj.Add('originalAmount', VendLedger."Original Amount");
                InvoiceObj.Add('remainingAmount', VendLedger."Remaining Amount");
                InvoiceObj.Add('documentType', Format(VendLedger."Document Type"));
                InvoiceArray.Add(InvoiceObj);
            until VendLedger.Next() = 0;

        Context.Add('vendor', VendorData);
        Context.Add('riskProfile', RiskData);
        Context.Add('invoices', InvoiceArray);
        Context.Add('contextGeneratedAt', Format(CurrentDateTime(), 0, '<Standard>'));

        exit(Context);
    end;

    procedure BuildPaymentContext(Summary: Record "AI Overdue Summary"; Suggestion: Record "AI Payment Suggestion"): JsonObject
    var
        Context: JsonObject;
        PaymentData: JsonObject;
        RecommendationData: JsonObject;
    begin
        // Build payment scenario
        PaymentData.Add('vendorNo', Suggestion."Vendor No.");
        PaymentData.Add('vendorName', Suggestion."Vendor Name");
        PaymentData.Add('suggestedAmount', Suggestion."Suggested Amount");
        PaymentData.Add('netPaymentAmount', Suggestion."Net Payment Amount");
        PaymentData.Add('discountPercentage', Suggestion."Suggested Discount %");
        PaymentData.Add('discountAmount', Suggestion."Discount Amount");
        PaymentData.Add('paymentDeadline', Format(Suggestion."Payment Deadline"));
        PaymentData.Add('daysToPay', Suggestion."Days to Pay");

        // Build recommendation basis
        RecommendationData.Add('priority', Suggestion.Priority);
        RecommendationData.Add('riskMitigationScore', Suggestion."Risk Mitigation Score");
        RecommendationData.Add('confidenceScore', Suggestion."Confidence Score");
        RecommendationData.Add('riskLevel', Summary."Risk Level");
        RecommendationData.Add('paymentReliability', Summary."Payment Reliability");
        RecommendationData.Add('invoiceCount', Summary."Invoice Count");
        RecommendationData.Add('averageDaysOverdue', Summary."Average Days Overdue");
        RecommendationData.Add('historicalData', Summary."Total Historical Amount");

        Context.Add('paymentSuggestion', PaymentData);
        Context.Add('recommendation', RecommendationData);
        Context.Add('analysis', Suggestion."AI Reasoning");
        Context.Add('alternatives', Suggestion."Alternative Suggestions");
        Context.Add('contextGeneratedAt', Format(CurrentDateTime(), 0, '<Standard>'));

        exit(Context);
    end;

    local procedure BuildAnalysisPrompt(Context: JsonObject): Text
    var
        Prompt: Text;
        VendorJson: JsonToken;
        RiskJson: JsonToken;
        InvoicesJson: JsonToken;
    begin
        // Build a structured prompt for AI analysis
        Prompt := 'Analyze the following vendor payment situation and provide insights:' + '';
        Prompt += '';

        if Context.Get('vendor', VendorJson) then begin
            Prompt += 'VENDOR INFORMATION: ' + ConvertJsonToString(VendorJson.AsObject()) + '' + '';
        end;

        if Context.Get('riskProfile', RiskJson) then begin
            Prompt += 'RISK ASSESSMENT: ' + ConvertJsonToString(RiskJson.AsObject()) + '' + '';
        end;

        if Context.Get('invoices', InvoicesJson) then begin
            Prompt += 'OUTSTANDING INVOICES: ' + ConvertJsonToString(InvoicesJson.AsArray()) + '' + '';
        end;

        Prompt += 'Based on this data:' + '';
        Prompt += '1. Assess the overall risk level and payment probability' + '';
        Prompt += '2. Identify patterns in payment behavior' + '';
        Prompt += '3. Recommend specific actions to improve collection' + '';
        Prompt += '4. Estimate recovery probability' + '';

        exit(Prompt);
    end;

    local procedure BuildPaymentSuggestionPrompt(Context: JsonObject): Text
    var
        Prompt: Text;
        PaymentJson: JsonToken;
        RecommJson: JsonToken;
    begin
        Prompt := 'Based on the following payment situation, provide detailed payment strategy:' + '';
        Prompt += '';

        if Context.Get('paymentSuggestion', PaymentJson) then
            Prompt += 'PAYMENT SCENARIO: ' + ConvertJsonToString(PaymentJson.AsObject()) + '' + '';

        if Context.Get('recommendation', RecommJson) then
            Prompt += 'CONTEXT: ' + ConvertJsonToString(RecommJson.AsObject()) + '' + '';

        Prompt += 'Provide:' + '';
        Prompt += '1. Assessment of suggested payment amount' + '';
        Prompt += '2. Optimal payment timing strategy' + '';
        Prompt += '3. Discount negotiation recommendations' + '';
        Prompt += '4. Risk mitigation through this payment' + '';
        Prompt += '5. Alternative payment arrangements if needed' + '';

        exit(Prompt);
    end;

    local procedure ConvertJsonToString(JsonObj: JsonObject): Text
    begin
        exit(Format(JsonObj));
    end;

    local procedure ConvertJsonToString(JsonArr: JsonArray): Text
    begin
        exit(Format(JsonArr));
    end;
}

