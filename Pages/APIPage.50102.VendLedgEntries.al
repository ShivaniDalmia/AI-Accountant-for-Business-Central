page 50102 "AI Vendor Ledger Entries"
{
    PageType = API;
    Caption = 'AI Vendor Ledger Entries';

    APIPublisher = 'NinjaCentral';
    APIGroup = 'aiAccounting';
    APIVersion = 'v1.0';

    EntityName = 'aiVendorLedgerEntry';
    EntitySetName = 'aiVendorLedgerEntries';

    SourceTable = "Vendor Ledger Entry";

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(entryNo; Rec."Entry No.") { }
                field(vendorNo; Rec."Vendor No.") { }
                field(vendorName; Rec."Vendor Name") { }
                field(documentNo; Rec."Document No.") { }
                field(documentType; Rec."Document Type") { }
                field(postingDate; Rec."Posting Date") { }
                field(dueDate; Rec."Due Date") { }
                field(open; Rec.Open) { }
                field(originalAmount; Rec."Original Amount") { }
                field(remainingAmount; Rec."Remaining Amount") { }
                field(currencyCode; Rec."Currency Code") { }
                field(appliesToId; Rec."Applies-to ID") { }
                field(externalDocumentNo; Rec."External Document No.") { }
                field(daysOverdue; GetVendDaysOverdue(Rec)) { }
                field(isOverdue; VendIsOverdue(Rec)) { }
                field(percentageOfOriginal; GetVendPercentageRemaining(Rec)) { }
            }
        }
    }

    local procedure GetVendDaysOverdue(var VendLedger: Record "Vendor Ledger Entry"): Integer
    begin
        if VendLedger.Open and (VendLedger."Due Date" < WorkDate()) then
            exit(WorkDate() - VendLedger."Due Date")
        else
            exit(0);
    end;

    local procedure VendIsOverdue(var VendLedger: Record "Vendor Ledger Entry"): Boolean
    begin
        exit(VendLedger.Open and (VendLedger."Due Date" < WorkDate()));
    end;

    local procedure GetVendPercentageRemaining(var VendLedger: Record "Vendor Ledger Entry"): Decimal
    begin
        if VendLedger."Original Amount" <> 0 then
            exit((VendLedger."Remaining Amount" / VendLedger."Original Amount") * 100)
        else
            exit(0);
    end;
}

