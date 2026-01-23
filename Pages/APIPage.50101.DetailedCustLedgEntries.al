page 50101 "AI Detld Cust Ledger Entries"
{
    PageType = API;
    Caption = 'AI Detailed Customer Ledger Entries';

    APIPublisher = 'NinjaCentral';
    APIGroup = 'aiAccounting';
    APIVersion = 'v1.0';

    EntityName = 'aiDetailedCustomerLedgerEntry';
    EntitySetName = 'aiDetailedCustomerLedgerEntries';

    SourceTable = "Detailed Cust. Ledg. Entry";

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
                field(custLedgerEntryNo; Rec."Cust. Ledger Entry No.") { }
                field(documentNo; Rec."Document No.") { }
                field(documentType; Rec."Document Type") { }
                field(postingDate; Rec."Posting Date") { }
                field(entryType; Rec."Entry Type") { }
                field(amount; Rec.Amount) { }
                field(amountLCY; Rec."Amount (LCY)") { }
                field(currencyCode; Rec."Currency Code") { }
                field(appliedCustLedgerEntryNo; Rec."Applied Cust. Ledger Entry No.") { }
            }
        }
    }
}
