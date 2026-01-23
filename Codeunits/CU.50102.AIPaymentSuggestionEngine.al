codeunit 50102 "AI Payment Suggestion Engine"
{

    procedure BuildPaymentSuggestions()
    var
        Summary: Record "AI Overdue Summary";
        Suggest: Record "AI Payment Suggestion";
    begin
        Suggest.DeleteAll();

        if Summary.FindSet() then
            repeat
                Suggest.Init();
                Suggest."Vendor No." := Summary."Vendor No.";
                Suggest."Vendor Name" := Summary."Vendor Name";
                Suggest."Suggested Amount" := Summary."Total Open Amount";

                case Summary.Priority of
                    1:
                        begin
                            Suggest.Priority := 1;
                            Suggest.Reason := 'Vendor severely overdue';
                            Suggest."Confidence Score" := 0.95;
                        end;
                    2:
                        begin
                            Suggest.Priority := 2;
                            Suggest.Reason := 'Vendor moderately overdue';
                            Suggest."Confidence Score" := 0.8;
                        end;
                    else begin
                        Suggest.Priority := 3;
                        Suggest.Reason := 'Vendor within normal terms';
                        Suggest."Confidence Score" := 0.65;
                    end;
                end;

                Suggest.Insert();
            until Summary.Next() = 0;
    end;
}
