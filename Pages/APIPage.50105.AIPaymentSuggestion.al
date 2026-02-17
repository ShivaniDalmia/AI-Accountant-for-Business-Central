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
                field(netPaymentAmount; Rec."Net Payment Amount") { Caption = 'Net Payment Amount'; }
                field(priority; Rec.Priority) { Caption = 'Priority'; }
                field(reason; Rec.Reason) { Caption = 'Reason'; }
                field(confidenceScore; Rec."Confidence Score") { Caption = 'Confidence Score'; }
                field(currencyCode; Rec."Currency Code") { Caption = 'Currency Code'; }
                field(paymentDeadline; Rec."Payment Deadline") { Caption = 'Payment Deadline'; }
                field(daysToPay; Rec."Days to Pay") { Caption = 'Days to Pay'; }
                field(suggestedDiscount; Rec."Suggested Discount %") { Caption = 'Suggested Discount %'; }
                field(discountAmount; Rec."Discount Amount") { Caption = 'Discount Amount'; }
                field(invoiceCount; Rec."Invoice Count") { Caption = 'Invoice Count'; }
                field(oldestInvoiceDate; Rec."Oldest Invoice Date") { Caption = 'Oldest Invoice Date'; }
                field(riskMitigationScore; Rec."Risk Mitigation Score") { Caption = 'Risk Mitigation Score'; }
                field(cashFlowImpact; Rec."Cash Flow Impact") { Caption = 'Cash Flow Impact'; }
                field(aiReasoning; Rec."AI Reasoning") { Caption = 'AI Reasoning'; }
                field(scoreBreakdown; Rec."Score Breakdown") { Caption = 'Score Breakdown'; }
                field(alternativeSuggestions; Rec."Alternative Suggestions") { Caption = 'Alternative Suggestions'; }
                field(generatedAt; Rec."Generated At") { Caption = 'Generated At'; }
            }
        }
    }
}
