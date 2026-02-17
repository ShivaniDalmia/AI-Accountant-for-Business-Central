table 50101 "AI Payment Suggestion"
{
    Caption = 'AI Payment Suggestion';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Vendor No."; Code[20]) { }
        field(2; "Vendor Name"; Text[100]) { }
        field(3; "Suggested Amount"; Decimal) { }
        field(4; Priority; Integer) { }
        field(5; Reason; Text[250]) { }
        field(6; "Confidence Score"; Decimal) { }
        field(7; "Currency Code"; Code[10]) { }
        field(8; "Payment Deadline"; Date) { }
        field(9; "Suggested Discount %"; Decimal) { }
        field(10; "Discount Amount"; Decimal) { }
        field(11; "Net Payment Amount"; Decimal) { }
        field(12; "Days to Pay"; Integer) { }
        field(13; "Invoice Count"; Integer) { }
        field(14; "Oldest Invoice Date"; Date) { }
        field(15; "Risk Mitigation Score"; Decimal) { }
        field(16; "Cash Flow Impact"; Decimal) { }
        field(17; "AI Reasoning"; Text[500]) { }
        field(18; "Score Breakdown"; Text[500]) { }
        field(19; "Alternative Suggestions"; Text[500]) { }
        field(20; "Generated At"; DateTime) { }
    }

    keys
    {
        key(PK; "Vendor No.") { Clustered = true; }
        key(SK; Priority, "Confidence Score") { }
    }
}
