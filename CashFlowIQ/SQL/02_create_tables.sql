

CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_segment VARCHAR(50),
    region VARCHAR(50),
    credit_terms_days INT
);


CREATE TABLE IF NOT EXISTS vendors (
    vendor_id VARCHAR(20) PRIMARY KEY,
    vendor_name VARCHAR(100),
    vendor_category VARCHAR(50),
    payment_terms_days INT
);

CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_cost DECIMAL(12,2),
    selling_price DECIMAL(12,2)
);

-- SALES INVOICES
CREATE TABLE IF NOT EXISTS sales_invoices (
    invoice_id VARCHAR(20) PRIMARY KEY,
    invoice_date DATE,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INT,
    discount_pct DECIMAL(5,2),
    unit_price DECIMAL(12,2),
    gross_amount DECIMAL(14,2),
    discount_amount DECIMAL(14,2),
    net_invoice_amount DECIMAL(14,2),
    due_date DATE,
    payment_date DATE,
    payment_status VARCHAR(20),
    days_to_pay INT,
    days_late INT,
    invoice_month VARCHAR(7),
    ageing_bucket VARCHAR(30)
);

-- VENDOR INVOICES
CREATE TABLE IF NOT EXISTS vendor_invoices (
    vendor_invoice_id VARCHAR(20) PRIMARY KEY,
    invoice_date DATE,
    vendor_id VARCHAR(20),
    expense_category VARCHAR(50),
    invoice_amount DECIMAL(14,2),
    due_date DATE,
    payment_date DATE,
    payment_status VARCHAR(20),
    days_to_pay INT,
    days_late INT,
    invoice_month VARCHAR(7),
    ageing_bucket VARCHAR(30)
);

-- =========================================================
-- VENDOR INVOICES
-- =========================================================

CREATE TABLE IF NOT EXISTS vendor_invoices (
    vendor_invoice_id VARCHAR(20) PRIMARY KEY,
    invoice_date DATE,
    vendor_id VARCHAR(20),
    expense_category VARCHAR(50),
    invoice_amount DECIMAL(14,2),
    due_date DATE,
    payment_date DATE,
    payment_status VARCHAR(20),
    days_to_pay INT,
    days_late INT,
    invoice_month VARCHAR(7),
    ageing_bucket VARCHAR(30)
);


-- =========================================================
-- OPERATING EXPENSES
-- =========================================================

CREATE TABLE IF NOT EXISTS operating_expenses (
    expense_id VARCHAR(20) PRIMARY KEY,
    expense_date DATE,
    expense_category VARCHAR(50),
    amount DECIMAL(14,2),
    expense_month VARCHAR(7)
);


-- =========================================================
-- PAYROLL
-- =========================================================

CREATE TABLE IF NOT EXISTS payroll (
    payroll_id VARCHAR(20) PRIMARY KEY,
    pay_date DATE,
    gross_payroll DECIMAL(14,2),
    tax_and_deductions DECIMAL(14,2),
    net_payroll DECIMAL(14,2)
);


-- =========================================================
-- LOANS
-- =========================================================

CREATE TABLE IF NOT EXISTS loans (
    loan_id VARCHAR(20) PRIMARY KEY,
    loan_type VARCHAR(50),
    principal_amount DECIMAL(14,2),
    annual_interest_rate DECIMAL(6,2),
    start_date DATE,
    tenure_months INT
);


-- =========================================================
-- LOAN PAYMENTS
-- =========================================================

CREATE TABLE IF NOT EXISTS loan_payments (
    loan_payment_id VARCHAR(20) PRIMARY KEY,
    loan_id VARCHAR(20),
    payment_date DATE,
    principal_paid DECIMAL(14,2),
    interest_paid DECIMAL(14,2),
    total_payment DECIMAL(14,2),
    payment_status VARCHAR(20)
);


-- =========================================================
-- BANK TRANSACTIONS
-- =========================================================

CREATE TABLE IF NOT EXISTS bank_transactions (
    bank_txn_id VARCHAR(20) PRIMARY KEY,
    transaction_date DATE,
    transaction_type VARCHAR(30),
    reference_id VARCHAR(30),
    amount DECIMAL(14,2)
);


-- =========================================================
-- INVENTORY SNAPSHOTS
-- =========================================================

CREATE TABLE IF NOT EXISTS inventory_snapshots (
    inventory_snapshot_id VARCHAR(20) PRIMARY KEY,
    snapshot_date DATE,
    product_id VARCHAR(20),
    units_on_hand INT,
    inventory_value DECIMAL(14,2)
);

