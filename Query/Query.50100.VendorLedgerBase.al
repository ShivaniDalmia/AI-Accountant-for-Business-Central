query 50100 "AI Vendor Ledger Base"
{
    Caption = 'AI Vendor Ledger Base';
    QueryType = Normal;

    elements
    {
        dataitem(VendorLedger; "Vendor Ledger Entry")
        {
            column(EntryNo; "Entry No.") { }
            column(Vendor_No; "Vendor No.") { }
            column(Vendor_Name; "Vendor Name") { }
            column(Document_No; "Document No.") { }
            column(Document_Type; "Document Type") { }
            column(Posting_Date; "Posting Date") { }
            column(Due_Date; "Due Date") { }
            column(Remaining_Amount; "Remaining Amount") { }
            column(Original_Amount; "Original Amount") { }
            column(Open; Open) { }
            column(Currency_Code; "Currency Code") { }
            column(External_Document_No; "External Document No.") { }

            filter(OpenOnly; Open)
            {
            }
        }
    }
}
