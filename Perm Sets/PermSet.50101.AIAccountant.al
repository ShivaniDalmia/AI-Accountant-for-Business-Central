permissionset 50101 "AI Accountant"
{
    Assignable = true;

    Permissions =

        // =========================
        // API PAGES (THIS WAS MISSING)
        // =========================
        page "AI Vendor Ledger Entries" = X,
        page "AI Customer Ledger Entries" = X,
        
        // =========================
        // MASTER DATA
        // =========================
        tabledata Customer = R,
        tabledata Vendor = R,

        // =========================
        // CUSTOMER ACCOUNTING
        // =========================
        tabledata "Cust. Ledger Entry" = R,
        tabledata "Detailed Cust. Ledg. Entry" = R,

        // =========================
        // VENDOR ACCOUNTING
        // =========================
        tabledata "Vendor Ledger Entry" = R,
        tabledata "Detailed Vendor Ledg. Entry" = R,

        // =========================
        // GENERAL LEDGER
        // =========================
        tabledata "G/L Entry" = R,
        tabledata "VAT Entry" = R,

        // =========================
        // INVOICES (READ-ONLY)
        // =========================
        tabledata "Sales Invoice Header" = R,
        tabledata "Sales Invoice Line" = R,
        tabledata "Purch. Inv. Header" = R,
        tabledata "Purch. Inv. Line" = R,

        // =========================
        // FINANCE DEPENDENCIES
        // =========================
        tabledata Currency = R,
        tabledata "Payment Terms" = R,
        tabledata "Finance Charge Terms" = R,

        // =========================
        // DIMENSIONS (CRITICAL)
        // =========================
        tabledata "Dimension Set Entry" = R,
        tabledata "Dimension Value" = R,

        // =========================
        // SYSTEM (REQUIRED FOR APIs)
        // =========================
        tabledata User = R,
        tabledata "User Personalization" = R;
}
