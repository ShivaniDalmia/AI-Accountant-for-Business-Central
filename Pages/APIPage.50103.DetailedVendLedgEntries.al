page 50103 "AI Detld Vend Ledger Entries"
{
    PageType = API;
    Caption = 'AI Detailed Vendor Ledger Entries';

    APIPublisher = 'NinjaCentral';
    APIGroup = 'aiAccounting';
    APIVersion = 'v1.0';

    EntityName = 'aiDetailedVendorLedgerEntry';
    EntitySetName = 'aiDetailedVendorLedgerEntries';

    SourceTable = "Detailed Vendor Ledg. Entry";

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
                field(vendorLedgerEntryNo; Rec."Vendor Ledger Entry No.") { }
                field(documentNo; Rec."Document No.") { }
                field(documentType; Rec."Document Type") { }
                field(postingDate; Rec."Posting Date") { }
                field(entryType; Rec."Entry Type") { }
                field(amount; Rec.Amount) { }
                field(amountLCY; Rec."Amount (LCY)") { }
                field(currencyCode; Rec."Currency Code") { }
                field(appliedVendorLedgerEntryNo; Rec."Applied Vend. Ledger Entry No.") { }
            }
        }
    }
}
