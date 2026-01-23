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
                field(priority; Rec.Priority) { Caption = 'Priority'; }
                field(recommendedAction; Rec."Recommended Action") { Caption = 'Recommended Action'; }
            }
        }
    }
}
