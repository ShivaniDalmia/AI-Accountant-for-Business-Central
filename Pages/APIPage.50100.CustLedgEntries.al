page 50100 "AI Customer Ledger Entries"
{
    PageType = API;
    Caption = 'AI Customer Ledger Entries';
    APIPublisher = 'NinjaCentral';
    APIGroup = 'aiAccounting';
    APIVersion = 'v1.0';
    EntityName = 'aiCustomerLedgerEntry';
    EntitySetName = 'aiCustomerLedgerEntries';
    SourceTable = "Cust. Ledger Entry";
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
                field(customerNo; Rec."Customer No.") { }
                field(documentNo; Rec."Document No.") { }
                field(documentType; Rec."Document Type") { }
                field(postingDate; Rec."Posting Date") { }
                field(dueDate; Rec."Due Date") { }
                field(open; Rec.Open) { }
                field(originalAmount; Rec."Original Amount") { }
                field(remainingAmount; Rec."Remaining Amount") { }
                field(currencyCode; Rec."Currency Code") { }
                field(appliesToId; Rec."Applies-to ID") { }
                field(description; Rec.Description) { }
                field(daysOverdue; GetCustDaysOverdue(Rec)) { }
                field(isOverdue; CustIsOverdue(Rec)) { }
                field(percentageOfOriginal; GetCustPercentageRemaining(Rec)) { }
            }
        }
    }

    local procedure GetCustDaysOverdue(var CustLedger: Record "Cust. Ledger Entry"): Integer
    begin
        if CustLedger.Open and (CustLedger."Due Date" < WorkDate()) then
            exit(WorkDate() - CustLedger."Due Date")
        else
            exit(0);
    end;

    local procedure CustIsOverdue(var CustLedger: Record "Cust. Ledger Entry"): Boolean
    begin
        exit(CustLedger.Open and (CustLedger."Due Date" < WorkDate()));
    end;

    local procedure GetCustPercentageRemaining(var CustLedger: Record "Cust. Ledger Entry"): Decimal
    begin
        if CustLedger."Original Amount" <> 0 then
            exit((CustLedger."Remaining Amount" / CustLedger."Original Amount") * 100)
        else
            exit(0);
    end;
}
