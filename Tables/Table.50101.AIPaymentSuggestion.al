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
    }

    keys
    {
        key(PK; "Vendor No.") { Clustered = true; }
    }
}
