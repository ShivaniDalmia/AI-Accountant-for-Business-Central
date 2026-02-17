codeunit 50101 "AI Overdue Summary Service"
{
    /// <summary>
    /// Builds comprehensive vendor summary with AI analysis
    /// This is the main service that orchestrates the entire AI Accountant workflow
    /// </summary>
    procedure BuildVendorSummary()
    var
        Engine: Codeunit "AI Overdue Engine";
        PaymentEngine: Codeunit "AI Payment Suggestion Engine";
        Summary: Record "AI Overdue Summary";
        ServiceInvoker: Codeunit "AI Service Invoker";
    begin
        // Step 1: Calculate overdue summary with advanced analysis
        Engine.CalculateOverdueSummary(Summary);

        // Step 2: Generate payment suggestions based on summary
        PaymentEngine.BuildPaymentSuggestions();

        // Optional: If you have AI integration, generate additional analysis
        // The ServiceInvoker codeunit can be extended to call actual AI services
    end;

    /// <summary>
    /// Generates enriched vendor analysis for AI consumption
    /// Returns JSON context with all vendor intelligence
    /// </summary>
    procedure GenerateAIContext(VendorNo: Code[20]): Text
    var
        Summary: Record "AI Overdue Summary";
        Suggestion: Record "AI Payment Suggestion";
        ServiceInvoker: Codeunit "AI Service Invoker";
        Context: JsonObject;
    begin
        if Summary.Get(VendorNo) then begin
            Context := ServiceInvoker.BuildVendorContext(Summary);
            exit(Format(Context));
        end;
        exit('{"error": "Vendor not found"}');
    end;

    /// <summary>
    /// Gets payment suggestions for a specific vendor in JSON format
    /// </summary>
    procedure GetPaymentAdvice(VendorNo: Code[20]): Text
    var
        Summary: Record "AI Overdue Summary";
        Suggestion: Record "AI Payment Suggestion";
        ServiceInvoker: Codeunit "AI Service Invoker";
        Context: JsonObject;
    begin
        if Summary.Get(VendorNo) then
            if Suggestion.Get(VendorNo) then begin
                Context := ServiceInvoker.BuildPaymentContext(Summary, Suggestion);
                exit(Format(Context));
            end;
        exit('{"error": "Data not found"}');
    end;

    /// <summary>
    /// Refreshes all vendor data and analysis
    /// Should be run periodically (daily recommended)
    /// </summary>
    procedure RefreshAllVendorAnalysis()
    var
        Engine: Codeunit "AI Overdue Engine";
        PaymentEngine: Codeunit "AI Payment Suggestion Engine";
        Summary: Record "AI Overdue Summary";
    begin
        // Clear existing analysis
        Summary.DeleteAll();

        // Recalculate from scratch
        BuildVendorSummary();
    end;
}

