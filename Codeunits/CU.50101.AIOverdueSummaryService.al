codeunit 50101 "AI Overdue Summary Service"
{

    procedure BuildVendorSummary()
    var
        Engine: Codeunit "AI Overdue Engine";
        Summary: Record "AI Overdue Summary";
    begin
        Engine.CalculateOverdueSummary(Summary);
    end;
}
