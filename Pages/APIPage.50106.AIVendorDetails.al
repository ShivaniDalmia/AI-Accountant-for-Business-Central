page 50106 "AI Vendor Details API"
{
    PageType = API;
    Caption = 'AI Vendor Details';
    APIPublisher = 'ninjacentral';
    APIGroup = 'aiAccounting';
    APIVersion = 'v1.0';
    EntityName = 'aiVendorDetail';
    EntitySetName = 'aiVendorDetails';
    SourceTable = Vendor;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(vendorNo; Rec."No.") { Caption = 'Vendor No.'; }
                field(name; Rec.Name) { Caption = 'Name'; }
                field(city; Rec.City) { Caption = 'City'; }
                field(country; Rec."Country/Region Code") { Caption = 'Country/Region'; }
                field(phoneNo; Rec."Phone No.") { Caption = 'Phone No.'; }
                field(email; Rec."E-Mail") { Caption = 'Email'; }
                field(contactPerson; Rec.Contact) { Caption = 'Contact Person'; }
                field(paymentTermsCode; Rec."Payment Terms Code") { Caption = 'Payment Terms Code'; }
                field(paymentMethodCode; Rec."Payment Method Code") { Caption = 'Payment Method Code'; }
                field(currencyCode; Rec."Currency Code") { Caption = 'Currency Code'; }
                field(blocked; Rec.Blocked) { Caption = 'Blocked'; }
                field(vendorPostingGroup; Rec."Vendor Posting Group") { Caption = 'Vendor Posting Group'; }
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group") { Caption = 'Gen. Bus. Posting Group'; }
                field(taxAreaCode; Rec."Tax Area Code") { Caption = 'Tax Area Code'; }
            }
        }
    }
}
