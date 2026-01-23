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
                field(documentNo; Rec."Document No.") { }
                field(documentType; Rec."Document Type") { }
                field(postingDate; Rec."Posting Date") { }
                field(dueDate; Rec."Due Date") { }
                field(open; Rec.Open) { }
                field(originalAmount; Rec."Original Amount") { }
                field(remainingAmount; Rec."Remaining Amount") { }
                field(currencyCode; Rec."Currency Code") { }
                field(appliesToId; Rec."Applies-to ID") { }
              

            }
        }
    }

}
