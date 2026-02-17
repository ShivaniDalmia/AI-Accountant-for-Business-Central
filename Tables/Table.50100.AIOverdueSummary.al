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
        field(9; "Invoice Count"; Integer) { }
        field(10; "Average Days Overdue"; Decimal) { }
        field(11; "Currency Code"; Code[10]) { }
        field(12; "Last Payment Date"; Date) { }
        field(13; "Days Since Last Payment"; Integer) { }
        field(14; "Payment Pattern Score"; Decimal) { }
        field(15; "Cash Impact Amount"; Decimal) { }
        field(16; "Risk Score"; Decimal) { }
        field(17; "Overdue Percentage"; Decimal) { }
        field(18; "Total Historical Amount"; Decimal) { }
        field(19; "Payment Reliability"; Text[20]) { }
        field(20; "AI Analysis"; Text[500]) { }
        field(21; "Generated At"; DateTime) { }
    }

    keys
    {
        key(PK; "Vendor No.") { Clustered = true; }
        key(SK; Priority, "Risk Score") { }
    }
}
