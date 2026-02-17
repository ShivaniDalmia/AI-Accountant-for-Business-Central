page 50104 "AI Vendor Overdue Summary API"
{
    PageType = API;
    Caption = 'AI Vendor Overdue Summary';
    APIPublisher = 'ninjacentral';
    APIGroup = 'aiAccounting';
    APIVersion = 'v1.0';
    EntityName = 'aiVendorOverdueSummary';
    EntitySetName = 'AIVendorOverdueSummary';
    SourceTable = "AI Overdue Summary";
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(vendorNo; Rec."Vendor No.") { Caption = 'Vendor No.'; }
                field(vendorName; Rec."Vendor Name") { Caption = 'Vendor Name'; }
                field(totalOpenAmount; Rec."Total Open Amount") { Caption = 'Total Open Amount'; }
                field(oldestDueDate; Rec."Oldest Due Date") { Caption = 'Oldest Due Date'; }
                field(maxOverdueDays; Rec."Max Overdue Days") { Caption = 'Max Overdue Days'; }
                field(riskLevel; Rec."Risk Level") { Caption = 'Risk Level'; }
                field(riskScore; Rec."Risk Score") { Caption = 'Risk Score'; }
                field(priority; Rec.Priority) { Caption = 'Priority'; }
                field(recommendedAction; Rec."Recommended Action") { Caption = 'Recommended Action'; }
                field(invoiceCount; Rec."Invoice Count") { Caption = 'Invoice Count'; }
                field(averageDaysOverdue; Rec."Average Days Overdue") { Caption = 'Average Days Overdue'; }
                field(currencyCode; Rec."Currency Code") { Caption = 'Currency Code'; }
                field(lastPaymentDate; Rec."Last Payment Date") { Caption = 'Last Payment Date'; }
                field(daysSinceLastPayment; Rec."Days Since Last Payment") { Caption = 'Days Since Last Payment'; }
                field(paymentPatternScore; Rec."Payment Pattern Score") { Caption = 'Payment Pattern Score'; }
                field(cashImpactAmount; Rec."Cash Impact Amount") { Caption = 'Cash Impact Amount'; }
                field(overduePercentage; Rec."Overdue Percentage") { Caption = 'Overdue Percentage'; }
                field(totalHistoricalAmount; Rec."Total Historical Amount") { Caption = 'Total Historical Amount'; }
                field(paymentReliability; Rec."Payment Reliability") { Caption = 'Payment Reliability'; }
                field(aiAnalysis; Rec."AI Analysis") { Caption = 'AI Analysis'; }
                field(generatedAt; Rec."Generated At") { Caption = 'Generated At'; }
            }
        }
    }
}

