codeunit 50103 "AI Service Invoker"
{

    procedure AnalyzeVendorContext(Context: JsonObject): Text;
    begin
        exit('{"result": "mocked"}');
    end;

    procedure GetPaymentSuggestions(Context: JsonObject): Text;
    begin
        exit('{"result": "mocked"}');
    end;
}
