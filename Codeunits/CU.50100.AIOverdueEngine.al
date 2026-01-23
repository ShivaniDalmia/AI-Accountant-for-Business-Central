codeunit 50100 "AI Overdue Engine"
{

    procedure CalculateOverdueSummary(var Summary: Record "AI Overdue Summary")
    var
        VendLedger: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        Today: Date;
        OverdueDays: Integer;
        MaxOverdue: Integer;
        TotalAmount: Decimal;
    begin
        Summary.DeleteAll();
        Today := WorkDate();

        VendLedger.SetRange(Open, true);
        if VendLedger.FindSet() then
            repeat
                if VendLedger."Remaining Amount" <= 0 then
                    continue;

                OverdueDays := Today - VendLedger."Due Date";
                if OverdueDays < 0 then
                    OverdueDays := 0;

                if not Summary.Get(VendLedger."Vendor No.") then begin
                    Summary.Init();
                    Summary."Vendor No." := VendLedger."Vendor No.";
                    if Vend.Get(VendLedger."Vendor No.") then
                        Summary."Vendor Name" := Vend.Name;
                end;

                Summary."Total Open Amount" += VendLedger."Remaining Amount";
                if (VendLedger."Due Date" < Summary."Oldest Due Date") or (Summary."Oldest Due Date" = 0D) then
                    Summary."Oldest Due Date" := VendLedger."Due Date";

                if OverdueDays > MaxOverdue then
                    MaxOverdue := OverdueDays;

                Summary."Max Overdue Days" := MaxOverdue;

                if OverdueDays > 60 then begin
                    Summary."Risk Level" := 'High';
                    Summary.Priority := 1;
                    Summary."Recommended Action" := 'Immediate payment recommended.';
                end else if OverdueDays > 30 then begin
                    Summary."Risk Level" := 'Medium';
                    Summary.Priority := 2;
                    Summary."Recommended Action" := 'Monitor closely.';
                end else begin
                    Summary."Risk Level" := 'Low';
                    Summary.Priority := 3;
                    Summary."Recommended Action" := 'On schedule.';
                end;

                Summary.Insert(true);
            until VendLedger.Next() = 0;
    end;
}
