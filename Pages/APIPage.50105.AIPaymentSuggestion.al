page 50105 "AI Payment Suggestion API"
{
    PageType = API;
    Caption = 'AI Payment Suggestion';
    APIPublisher = 'ninjacentral';
    APIGroup = 'aiAccounting';
    APIVersion = 'v1.0';
    EntityName = 'aiPaymentSuggestion';
    EntitySetName = 'AIPaymentSuggestions';
    SourceTable = "AI Payment Suggestion";
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(vendorNo; Rec."Vendor No.") { Caption = 'Vendor No.'; }
                field(vendorName; Rec."Vendor Name") { Caption = 'Vendor Name'; }
                field(suggestedAmount; Rec."Suggested Amount") { Caption = 'Suggested Amount'; }
                field(priority; Rec.Priority) { Caption = 'Priority'; }
                field(reason; Rec.Reason) { Caption = 'Reason'; }
                field(confidenceScore; Rec."Confidence Score") { Caption = 'Confidence Score'; }
            }
        }
    }
}
