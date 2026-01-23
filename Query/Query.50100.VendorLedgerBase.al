query 50100 "AI Vendor Ledger Base"
{
    Caption = 'AI Vendor Ledger Base';
    QueryType = Normal;

    elements
    {
        dataitem(VendorLedger; "Vendor Ledger Entry")
        {
            column(Vendor_No; "Vendor No.") { }
            column(Vendor_Name; "Vendor Name") { }
            column(Due_Date; "Due Date") { }
            column(Remaining_Amount; "Remaining Amount") { }
            column(Open; Open) { }
        }
    }
}
