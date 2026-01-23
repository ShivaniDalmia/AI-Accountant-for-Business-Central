table 50100 "AI Overdue Summary"
{
    Caption = 'AI Overdue Summary';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Vendor No."; Code[20]) { }
        field(2; "Vendor Name"; Text[100]) { }
        field(3; "Total Open Amount"; Decimal) { }
        field(4; "Oldest Due Date"; Date) { }
        field(5; "Max Overdue Days"; Integer) { }
        field(6; "Risk Level"; Text[30]) { }
        field(7; Priority; Integer) { }
        field(8; "Recommended Action"; Text[250]) { }
    }

    keys
    {
        key(PK; "Vendor No.") { Clustered = true; }
    }
}
