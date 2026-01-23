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

              
            }
        }
    }

    
}
