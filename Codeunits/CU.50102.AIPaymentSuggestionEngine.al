codeunit 50102 "AI Payment Suggestion Engine"
{
    procedure BuildPaymentSuggestions()
    var
        Summary: Record "AI Overdue Summary";
        Suggest: Record "AI Payment Suggestion";
        VendLedger: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
    begin
        Suggest.DeleteAll();

        if Summary.FindSet() then
            repeat
                Suggest.Init();
                Suggest."Vendor No." := Summary."Vendor No.";
                Suggest."Vendor Name" := Summary."Vendor Name";
                Suggest."Currency Code" := Summary."Currency Code";
                Suggest."Invoice Count" := Summary."Invoice Count";
                
                // Get oldest invoice date
                VendLedger.SetRange("Vendor No.", Summary."Vendor No.");
                VendLedger.SetRange(Open, true);
                if VendLedger.FindFirst() then
                    Suggest."Oldest Invoice Date" := VendLedger."Due Date";

                // Calculate suggested payment amounts with discount analysis
                CalculatePaymentSuggestion(Summary, Suggest);

                // Calculate risk mitigation score
                CalculateRiskMitigation(Summary, Suggest);

                // Generate AI reasoning
                Suggest."AI Reasoning" := GeneratePaymentReasoning(Summary, Suggest);
                
                // Suggest alternatives
                Suggest."Alternative Suggestions" := GenerateAlternatives(Summary, Suggest);
                
                Suggest."Generated At" := CurrentDateTime();
                Suggest.Insert();
            until Summary.Next() = 0;
    end;

    local procedure CalculatePaymentSuggestion(Summary: Record "AI Overdue Summary"; var Suggest: Record "AI Payment Suggestion")
    var
        Today: Date;
        DaysToDeadline: Integer;
        DiscountPercentage: Decimal;
        FullPaymentDays: Integer;
    begin
        Today := WorkDate();
        Suggest."Suggested Amount" := Summary."Total Open Amount";

        // Determine payment deadline based on risk level
        case Summary."Risk Level" of
            'Critical':
                DaysToDeadline := 7;
            'High':
                DaysToDeadline := 14;
            'Medium':
                DaysToDeadline := 21;
            'Low':
                DaysToDeadline := 30;
            else
                DaysToDeadline := 45;
        end;

        Suggest."Payment Deadline" := Today + DaysToDeadline;
        Suggest."Days to Pay" := DaysToDeadline;

        // Suggest early payment discount for cash flow improvement
        // Discount strategy based on risk and cash flow impact
        DiscountPercentage := CalculateSuggestedDiscount(Summary, DaysToDeadline);
        Suggest."Suggested Discount %" := DiscountPercentage;

        if DiscountPercentage > 0 then begin
            Suggest."Discount Amount" := Round(Summary."Total Open Amount" * (DiscountPercentage / 100), 0.01);
            Suggest."Net Payment Amount" := Summary."Total Open Amount" - Suggest."Discount Amount";
        end else begin
            Suggest."Discount Amount" := 0;
            Suggest."Net Payment Amount" := Summary."Total Open Amount";
        end;

        // Priority assignment
        AssignPaymentPriority(Summary, Suggest);

        // Confidence score based on risk score and payment pattern
        CalculateConfidenceScore(Summary, Suggest);

        // Cash flow impact
        Suggest."Cash Flow Impact" := Summary."Cash Impact Amount";
    end;

    local procedure CalculateSuggestedDiscount(Summary: Record "AI Overdue Summary"; DaysToDeadline: Integer): Decimal
    var
        DiscountPercent: Decimal;
    begin
        DiscountPercent := 0;

        // Offer discounts based on overdue severity and payment pattern
        if Summary."Risk Level" = 'Critical' then begin
            if Summary."Payment Reliability" = 'Good' then
                DiscountPercent := 2.5  // 2/10 early pay discount
            else if Summary."Payment Reliability" = 'Excellent' then
                DiscountPercent := 3.5
            else
                DiscountPercent := 1.5;
        end else if Summary."Risk Level" = 'High' then begin
            if Summary."Payment Reliability" = 'Good' then
                DiscountPercent := 1.5
            else if Summary."Payment Reliability" = 'Excellent' then
                DiscountPercent := 2.0;
        end;

        // Reduce discount if payment pattern is poor
        if Summary."Payment Reliability" = 'Poor' then
            DiscountPercent := DiscountPercent * 0.5;

        exit(DiscountPercent);
    end;

    local procedure AssignPaymentPriority(Summary: Record "AI Overdue Summary"; var Suggest: Record "AI Payment Suggestion")
    begin
        case Summary."Risk Level" of
            'Critical':
                begin
                    Suggest.Priority := 1;
                    Suggest.Reason := 'CRITICAL: Vendor severely overdue - ' + Format(Summary."Max Overdue Days") + ' days. Immediate payment required to avoid legal action.';
                end;
            'High':
                begin
                    Suggest.Priority := 2;
                    Suggest.Reason := 'HIGH PRIORITY: Vendor overdue with poor payment pattern. Priority payment recommended.';
                end;
            'Medium':
                begin
                    Suggest.Priority := 3;
                    Suggest.Reason := 'MEDIUM: Vendor moderately overdue. Negotiate payment plan or early settlement with discount.';
                end;
            'Low':
                begin
                    Suggest.Priority := 4;
                    Suggest.Reason := 'LOW: Vendor within acceptable timeframe. Standard collection procedures apply.';
                end;
            else begin
                Suggest.Priority := 5;
                Suggest.Reason := 'ROUTINE: Vendor has good payment history. Follow normal payment terms.';
            end;
        end;
    end;

    local procedure CalculateConfidenceScore(Summary: Record "AI Overdue Summary"; var Suggest: Record "AI Payment Suggestion")
    var
        ConfScore: Decimal;
        PaymentFactor: Decimal;
        RiskFactor: Decimal;
        VolumeFactor: Decimal;
    begin
        // Base confidence from payment reliability
        case Summary."Payment Reliability" of
            'Excellent':
                PaymentFactor := 0.95;
            'Good':
                PaymentFactor := 0.85;
            'Fair':
                PaymentFactor := 0.70;
            'Poor':
                PaymentFactor := 0.50;
        end;

        // Risk adjustment
        RiskFactor := 1 - (Summary."Risk Score" / 100);
        if RiskFactor < 0.3 then
            RiskFactor := 0.3;

        // Volume factor (more invoices = more confidence in data)
        VolumeFactor := 0.70 + (Summary."Invoice Count" / 20); // Increases with invoice count
        if VolumeFactor > 1.0 then
            VolumeFactor := 1.0;

        ConfScore := (PaymentFactor * 0.4) + (RiskFactor * 0.4) + (VolumeFactor * 0.2);

        Suggest."Confidence Score" := Round(ConfScore, 0.01);
        if Suggest."Confidence Score" > 1.0 then
            Suggest."Confidence Score" := 1.0;
    end;

    local procedure CalculateRiskMitigation(Summary: Record "AI Overdue Summary"; var Suggest: Record "AI Payment Suggestion")
    var
        MitigationScore: Decimal;
    begin
        // Risk mitigation improves with:
        // 1. Paying sooner
        // 2. Paying with discount (shows commitment)
        // 3. Better payment history
        // 4. Smaller overdue amounts

        MitigationScore := 0.5; // Base score

        // Payment reliability improvement
        case Summary."Payment Reliability" of
            'Excellent':
                MitigationScore += 0.3;
            'Good':
                MitigationScore += 0.2;
            'Fair':
                MitigationScore += 0.1;
        end;

        // Early payment potential
        if Suggest."Suggested Discount %" > 0 then
            MitigationScore += 0.15;

        // Risk level impact
        if Summary."Risk Level" = 'Critical' then
            MitigationScore := MitigationScore * 0.8; // Critical situations harder to mitigate

        if MitigationScore > 1.0 then
            MitigationScore := 1.0;

        Suggest."Risk Mitigation Score" := Round(MitigationScore, 0.01);
    end;

    local procedure GeneratePaymentReasoning(Summary: Record "AI Overdue Summary"; Suggest: Record "AI Payment Suggestion"): Text
    var
        Reasoning: Text;
        SeverityText: Text;
    begin
        Reasoning := 'Payment Analysis: ';

        // Severity assessment
        if Summary."Max Overdue Days" >= 90 then
            SeverityText := 'SEVERE - ' + Format(Summary."Max Overdue Days") + ' days overdue. '
        else if Summary."Max Overdue Days" >= 60 then
            SeverityText := 'Significant - ' + Format(Summary."Max Overdue Days") + ' days overdue. '
        else if Summary."Max Overdue Days" >= 30 then
            SeverityText := 'Moderate - ' + Format(Summary."Max Overdue Days") + ' days overdue. '
        else
            SeverityText := 'Minor - ' + Format(Summary."Max Overdue Days") + ' days overdue. ';

        Reasoning += SeverityText;

        // Amount analysis
        Reasoning += 'Amount: ' + Format(Suggest."Net Payment Amount", 0, '<Currency><Decimals,0>') + '. ';

        // Discount opportunity
        if Suggest."Suggested Discount %" > 0 then
            Reasoning += 'Early settlement discount of ' + Format(Suggest."Suggested Discount %", 0, '<Standard>') + '% available (' 
                + Format(Suggest."Discount Amount", 0, '<Currency><Decimals,0>') + ' savings). ';

        // Historical context
        if Summary."Payment Reliability" = 'Excellent' then
            Reasoning += 'Vendor has excellent payment history - recommend settlement offer. '
        else if Summary."Payment Reliability" = 'Good' then
            Reasoning += 'Vendor has good track record - flexible terms may encourage timely payment. '
        else if Summary."Payment Reliability" = 'Poor' then
            Reasoning += 'Vendor has poor payment history - firm payment deadline essential. ';

        // Recommendation
        Reasoning += 'Suggest payment within ' + Format(Suggest."Days to Pay") + ' days.';

        exit(CopyStr(Reasoning, 1, 500));
    end;

    local procedure GenerateAlternatives(Summary: Record "AI Overdue Summary"; Suggest: Record "AI Payment Suggestion"): Text
    var
        Alternatives: Text;
    begin
        Alternatives := 'Alternatives: ';

        if Summary."Risk Level" in ['Critical', 'High'] then begin
            Alternatives += '1) Request partial payment of 50% immediately for critical invoices. '
                + '2) Negotiate extended terms with payment schedule. '
                + '3) Consider legal action if vendor disputes amount.';
        end else if Summary."Risk Level" = 'Medium' then begin
            Alternatives += '1) Offer 1/10 net 30 discount for immediate payment. '
                + '2) Establish formal payment plan over 3 months. '
                + '3) Place vendor on partial COD basis.';
        end else begin
            Alternatives += '1) Maintain current terms - vendor is reliable. '
                + '2) Consider expanding credit terms based on performance. '
                + '3) Explore early settlement discounts to improve cash position.';
        end;

        exit(CopyStr(Alternatives, 1, 500));
    end;
}

