codeunit 50100 "AI Overdue Engine"
{
    trigger OnRun()
    var
        Summary: Record "AI Overdue Summary";
    begin
        CalculateOverdueSummary(Summary);
    end;

    procedure CalculateOverdueSummary(var Summary: Record "AI Overdue Summary")
    var
        VendLedger: Record "Vendor Ledger Entry";
        CurrentSummary: Record "AI Overdue Summary";
        VendorList: List of [Code[20]];
        VendorNoVar: Code[20];
    begin
        Summary.DeleteAll();

        // Get unique vendors with open invoices
        VendLedger.SetRange(Open, true);
        VendLedger.SetFilter("Remaining Amount", '>0');

        if VendLedger.FindSet() then begin
            repeat
                if VendorList.IndexOf(VendLedger."Vendor No.") = 0 then
                    VendorList.Add(VendLedger."Vendor No.");
            until VendLedger.Next() = 0;
        end;

        // Process each vendor
        foreach VendorNoVar in VendorList do begin
            ProcessVendor(VendorNoVar, CurrentSummary, VendLedger);
        end;
    end;

    local procedure ProcessVendor(VendorNo: Code[20]; var CurrentSummary: Record "AI Overdue Summary"; var VendLedger: Record "Vendor Ledger Entry")
    var
        Vend: Record Vendor;
        Today: Date;
        OverdueDays: Integer;
        MaxOverdue: Integer;
        InvoiceCount: Integer;
        TotalDaysOverdue: Decimal;
        TotalOpenAmount: Decimal;
        LastPaymentDate: Date;
        PaymentCount: Integer;
        TotalHistoricalAmount: Decimal;
        RiskScore: Decimal;
        PaymentPatternScore: Decimal;
        VendLedgerLocal: Record "Vendor Ledger Entry";
    begin
        Today := WorkDate();
        InvoiceCount := 0;
        TotalDaysOverdue := 0;
        MaxOverdue := 0;
        TotalOpenAmount := 0;

        CurrentSummary.Init();
        CurrentSummary."Vendor No." := VendorNo;

        if Vend.Get(VendorNo) then
            CurrentSummary."Vendor Name" := Vend.Name;

        GetVendorPaymentHistory(VendorNo, LastPaymentDate, PaymentCount, PaymentPatternScore);
        CurrentSummary."Last Payment Date" := LastPaymentDate;
        CurrentSummary."Payment Pattern Score" := PaymentPatternScore;

        TotalHistoricalAmount := GetVendorTotalHistoricalAmount(VendorNo);
        CurrentSummary."Total Historical Amount" := TotalHistoricalAmount;

        // Get all invoices for this vendor
        VendLedgerLocal.SetRange("Vendor No.", VendorNo);
        // Don't filter by Open - just get remaining amounts
        VendLedgerLocal.SetFilter("Remaining Amount", '<>0');

        if not VendLedgerLocal.FindSet() then begin
            // Insert empty record as marker if no ledger entries
            CurrentSummary."Total Open Amount" := 0;
            CurrentSummary.Insert(true);
            exit;
        end;

        // Get currency from first record
        CurrentSummary."Currency Code" := VendLedgerLocal."Currency Code";

        repeat
            OverdueDays := Today - VendLedgerLocal."Due Date";
            if OverdueDays < 0 then
                OverdueDays := 0;

            TotalOpenAmount := TotalOpenAmount + VendLedgerLocal."Remaining Amount";
            InvoiceCount += 1;
            TotalDaysOverdue += OverdueDays;

            if (VendLedgerLocal."Due Date" < CurrentSummary."Oldest Due Date") or (CurrentSummary."Oldest Due Date" = 0D) then
                CurrentSummary."Oldest Due Date" := VendLedgerLocal."Due Date";

            if OverdueDays > MaxOverdue then
                MaxOverdue := OverdueDays;
        until VendLedgerLocal.Next() = 0;

        if InvoiceCount > 0 then begin
            CurrentSummary."Max Overdue Days" := MaxOverdue;
            CurrentSummary."Invoice Count" := InvoiceCount;
            CurrentSummary."Average Days Overdue" := TotalDaysOverdue / InvoiceCount;
            CurrentSummary."Total Open Amount" := TotalOpenAmount;

            RiskScore := CalculateRiskScore(MaxOverdue, TotalOpenAmount,
                TotalHistoricalAmount, PaymentPatternScore, InvoiceCount);
            CurrentSummary."Risk Score" := RiskScore;

            if TotalHistoricalAmount > 0 then
                CurrentSummary."Overdue Percentage" := (TotalOpenAmount / TotalHistoricalAmount) * 100
            else
                CurrentSummary."Overdue Percentage" := 100;

            if LastPaymentDate > 0D then
                CurrentSummary."Days Since Last Payment" := Today - LastPaymentDate
            else
                CurrentSummary."Days Since Last Payment" := 999;

            CurrentSummary."Cash Impact Amount" := TotalOpenAmount * (RiskScore / 100);

            if PaymentPatternScore >= 0.8 then
                CurrentSummary."Payment Reliability" := 'Excellent'
            else if PaymentPatternScore >= 0.6 then
                CurrentSummary."Payment Reliability" := 'Good'
            else if PaymentPatternScore >= 0.4 then
                CurrentSummary."Payment Reliability" := 'Fair'
            else
                CurrentSummary."Payment Reliability" := 'Poor';

            AssignRiskLevelAndPriority(CurrentSummary, RiskScore, MaxOverdue, PaymentPatternScore);
            CurrentSummary."AI Analysis" := GenerateAIAnalysis(CurrentSummary, PaymentPatternScore);
            CurrentSummary."Generated At" := CurrentDateTime();

            CurrentSummary.Insert(true);
        end;
    end;

    local procedure GetVendorPaymentHistory(VendorNo: Code[20]; var LastPaymentDate: Date; var PaymentCount: Integer; var PatternScore: Decimal)
    var
        VendLedgerLocal: Record "Vendor Ledger Entry";
        OnTimePayments: Integer;
        LatePayments: Integer;
        TotalPayments: Integer;
    begin
        LastPaymentDate := 0D;
        PaymentCount := 0;
        PatternScore := 0.5; // Default to 0.5 (neutral)

        VendLedgerLocal.SetRange("Vendor No.", VendorNo);
        VendLedgerLocal.SetRange(Open, false);
        VendLedgerLocal.SetFilter("Document Type", '%1|%2', VendLedgerLocal."Document Type"::Invoice, VendLedgerLocal."Document Type"::"Credit Memo");

        if VendLedgerLocal.FindLast() then
            LastPaymentDate := VendLedgerLocal."Posting Date";

        if VendLedgerLocal.FindSet() then begin
            repeat
                PaymentCount += 1;

                // Simple logic: if paid within 30 days, it's on time
                if (VendLedgerLocal."Posting Date" + 30) >= VendLedgerLocal."Due Date" then
                    OnTimePayments += 1
                else
                    LatePayments += 1;

            until VendLedgerLocal.Next() = 0;

            TotalPayments := OnTimePayments + LatePayments;
            if TotalPayments > 0 then
                PatternScore := OnTimePayments / TotalPayments;
        end;
    end;

    local procedure GetVendorTotalHistoricalAmount(VendorNo: Code[20]): Decimal
    var
        VendLedgerLocal: Record "Vendor Ledger Entry";
        TotalAmount: Decimal;
    begin
        VendLedgerLocal.SetRange("Vendor No.", VendorNo);
        if VendLedgerLocal.FindSet() then
            repeat
                TotalAmount += VendLedgerLocal."Original Amount";
            until VendLedgerLocal.Next() = 0;
        exit(TotalAmount);
    end;

    local procedure CalculateRiskScore(OverdueDays: Integer; OpenAmount: Decimal; HistoricalAmount: Decimal; PaymentPattern: Decimal; InvoiceCount: Integer): Decimal
    var
        DaysComponent: Decimal;
        AmountComponent: Decimal;
        PatternComponent: Decimal;
        VolumeComponent: Decimal;
        RiskScore: Decimal;
    begin
        // Days Overdue Component (0-40 points)
        if OverdueDays >= 90 then
            DaysComponent := 40
        else if OverdueDays >= 60 then
            DaysComponent := 30
        else if OverdueDays >= 30 then
            DaysComponent := 15
        else if OverdueDays >= 15 then
            DaysComponent := 8
        else
            DaysComponent := 0;

        // Amount Component (0-30 points) - based on open amount vs historical
        if HistoricalAmount > 0 then
            if (OpenAmount / HistoricalAmount) >= 0.5 then
                AmountComponent := 30
            else if (OpenAmount / HistoricalAmount) >= 0.3 then
                AmountComponent := 20
            else if (OpenAmount / HistoricalAmount) >= 0.1 then
                AmountComponent := 10
            else
                AmountComponent := 3;

        // Payment Pattern Component (0-20 points)
        PatternComponent := (1 - PaymentPattern) * 20;

        // Volume Component (0-10 points) - more invoices = spread risk
        if InvoiceCount >= 10 then
            VolumeComponent := 0
        else if InvoiceCount >= 5 then
            VolumeComponent := 3
        else if InvoiceCount >= 2 then
            VolumeComponent := 6
        else
            VolumeComponent := 10;

        RiskScore := DaysComponent + AmountComponent + PatternComponent + VolumeComponent;

        // Cap at 100
        if RiskScore > 100 then
            RiskScore := 100;

        exit(RiskScore);
    end;

    local procedure AssignRiskLevelAndPriority(var Summary: Record "AI Overdue Summary"; RiskScore: Decimal; OverdueDays: Integer; PaymentPattern: Decimal)
    begin
        // Critical Risk
        if RiskScore >= 80 then begin
            Summary."Risk Level" := 'Critical';
            Summary.Priority := 1;
            Summary."Recommended Action" := 'URGENT: Immediate legal/collection action recommended. Potential write-off risk.';
        end
        // High Risk
        else if RiskScore >= 60 then begin
            Summary."Risk Level" := 'High';
            Summary.Priority := 2;
            Summary."Recommended Action" := 'High risk. Immediate contact with vendor and payment plan required.';
        end
        // Medium Risk
        else if RiskScore >= 40 then begin
            Summary."Risk Level" := 'Medium';
            Summary.Priority := 3;
            Summary."Recommended Action" := 'Monitor closely. Send payment reminder and discuss payment terms.';
        end
        // Low Risk
        else if RiskScore >= 20 then begin
            Summary."Risk Level" := 'Low';
            Summary.Priority := 4;
            Summary."Recommended Action" := 'Routine follow-up. Vendor has good payment history.';
        end
        // Very Low Risk
        else begin
            Summary."Risk Level" := 'Very Low';
            Summary.Priority := 5;
            Summary."Recommended Action" := 'On schedule. Continue normal vendor relationship.';
        end;
    end;

    local procedure GenerateAIAnalysis(Summary: Record "AI Overdue Summary"; PaymentPattern: Decimal): Text
    var
        Analysis: Text;
    begin
        Analysis := 'Analysis: ';

        // Days analysis
        if Summary."Max Overdue Days" >= 90 then
            Analysis += 'CRITICAL - Oldest invoice is ' + Format(Summary."Max Overdue Days") + ' days overdue. '
        else if Summary."Max Overdue Days" >= 60 then
            Analysis += 'Invoice is ' + Format(Summary."Max Overdue Days") + ' days overdue. '
        else if Summary."Max Overdue Days" >= 30 then
            Analysis += 'Invoice is ' + Format(Summary."Max Overdue Days") + ' days overdue. ';

        // Amount analysis
        Analysis += 'Total open: ' + Format(Summary."Total Open Amount") + '. ';

        // Pattern analysis
        if PaymentPattern >= 0.8 then
            Analysis += 'Vendor historically pays on time. '
        else if PaymentPattern >= 0.5 then
            Analysis += 'Vendor has mixed payment history. '
        else
            Analysis += 'Vendor often pays late. ';

        // Recommendation
        case Summary.Priority of
            1:
                Analysis += 'IMMEDIATE action required - legal review recommended.';
            2:
                Analysis += 'Escalate to management - payment plan negotiation advised.';
            3:
                Analysis += 'Send formal payment reminder and check vendor credit status.';
            else
                Analysis += 'Continue routine monitoring.';
        end;

        exit(CopyStr(Analysis, 1, 500));
    end;
}

