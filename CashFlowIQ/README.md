# CashFlowIQ

## Financial & Cash Flow Analytics Dashboard

CashFlowIQ is an end-to-end financial analytics project built to analyze sales,
revenue, collections, receivables, vendor obligations, operating expenses,
payroll, and estimated cash flow.

The project demonstrates a complete data analytics workflow:

Raw Financial Data → Data Quality Checks → Data Cleaning & Transformation
→ MySQL Database → SQL Business Analysis → Power BI Data Modeling
→ Interactive Dashboard → Business Insights

---

## 1. Project Objective

The objective of CashFlowIQ is to transform raw financial data into meaningful
business insights using Python, MySQL, SQL, and Power BI.

The project focuses on understanding:

- Revenue and sales performance
- Customer and product performance
- Payment and collection status
- Outstanding receivables
- Vendor invoice obligations
- Operating expenses
- Payroll trends
- Estimated cash flow
- Financial trends and business insights

---

## 2. Business Problem

Organizations generate financial data across multiple business functions such
as sales, customers, vendors, expenses, payroll, loans, and banking.

The challenge is to combine this data and provide a clear view of:

- How much revenue is being generated
- How much revenue has been collected
- How much revenue remains outstanding
- What vendor obligations exist
- How operating expenses are structured
- How payroll affects cash flow
- How financial performance changes over time

CashFlowIQ addresses these requirements through SQL analysis and an interactive
Power BI dashboard.

---

## 3. Technologies Used

### Python

Used for:

- Data quality checks
- Data validation
- Data cleaning
- Data transformation
- Missing-value analysis
- Date handling
- Preparing data for database loading

Libraries used include:

- Pandas
- NumPy

### MySQL

Used for:

- Database creation
- Table creation
- Data storage
- Data validation
- SQL analysis
- Business calculations
- Financial analysis

### SQL

Used for:

- Revenue analysis
- Monthly trends
- Payment status analysis
- Receivables analysis
- Customer analysis
- Product analysis
- Region analysis
- Vendor obligations analysis
- Operating expense analysis
- Payroll analysis
- Cash flow analysis
- Cross-functional business analysis

### Power BI

Used for:

- Data modeling
- KPI creation
- DAX measures
- Interactive dashboards
- Financial trend analysis
- Business visualization

---

## 4. Dataset

The project uses synthetic financial data created for analytical,
portfolio, and interview demonstration purposes.

The dataset does not represent the financial records of a real company.

The project contains the following tables:

1. Customers
2. Vendors
3. Products
4. Sales Invoices
5. Vendor Invoices
6. Operating Expenses
7. Payroll
8. Loans
9. Loan Payments
10. Bank Transactions
11. Inventory Snapshots

---

## 5. Data Quality & Cleaning

Python notebooks were used to perform data quality checks and prepare the
datasets before database analysis.

Key checks included:

- Record counts
- Column validation
- Data type validation
- Missing-value checks
- Payment-date validation
- Duplicate checks
- Date handling
- Financial field validation
- Table structure validation

The cleaned datasets were then loaded into MySQL.

---

## 6. MySQL Database

Database:

`cashflowiq`

The database contains 11 interconnected business tables covering:

- Customers
- Vendors
- Products
- Sales
- Vendor invoices
- Expenses
- Payroll
- Loans
- Loan payments
- Bank transactions
- Inventory

---

## 7. SQL Business Analysis

The SQL analysis contains multiple business-focused sections.

### Sales & Revenue Analysis

- Overall sales performance
- Monthly revenue trend
- Payment status analysis
- Outstanding receivables
- Customer-wise sales
- Product-wise sales
- Region-wise sales

### Vendor Analysis

- Vendor invoice obligations
- Vendor-wise obligations
- Obligation trends

### Expense & Payroll Analysis

- Operating expense structure
- Expense categories
- Payroll analysis
- Monthly payroll trends

### Cash Flow Analysis

- Revenue analysis
- Vendor obligations
- Non-payroll operating expenses
- Net payroll
- Estimated cash flow
- Financial performance by period

### Cross-Functional Analysis

The project also includes cross-functional SQL analysis combining
sales, customers, products, vendors, expenses, payroll, and other
financial information.

---

## 8. Power BI Dashboard

The final Power BI dashboard contains three main pages.

### Page 1 — KPI Dashboard

Key KPIs include:

- Total Revenue
- Total Discounts
- Net Payroll
- Collection Rate
- Vendor Obligations
- Total Invoices
- Total Customers
- Total Products
- Total Units Sold
- Estimated Cash Flow
- Outstanding Revenue
- Average Invoice Value
- Total Collected Revenue

### Page 2 — Sales & Revenue Analysis

Visuals include:

- Revenue by Region
- Monthly Revenue Trend
- Revenue by Customer Segment
- Revenue by Product Category
- Revenue by Product
- Payment Status Analysis
- Outstanding Revenue by Ageing Bucket
- Top 10 Customers by Revenue
- Top 10 Products by Revenue
- Vendor Obligations by Vendor

### Page 3 — Financial & Cash Flow Analysis

Visuals include:

- Estimated Cash Flow by Month
- Monthly Payroll Trend
- Monthly Vendor Obligations Trend
- Revenue vs Vendor Obligations by Month
- Operating Expenses by Category
- Monthly Outstanding Revenue Trend

---

## 9. Key Dashboard Metrics

The current dashboard shows approximately:

| KPI | Value |
|---|---:|
| Total Revenue | ₹45.48M |
| Total Discounts | ₹3.51M |
| Net Payroll | ₹16.52M |
| Collection Rate | 89.81% |
| Vendor Obligations | ₹7.95M |
| Total Invoices | 5,000 |
| Total Customers | 120 |
| Total Products | 60 |
| Total Units Sold | 29.6K |
| Estimated Cash Flow | ₹6.51M |
| Outstanding Revenue | ₹4.64M |
| Average Invoice Value | ₹9.10K |
| Total Collected Revenue | ₹40.85M |

---

## 10. Important Financial Note

Estimated cash flow is calculated using revenue together with vendor invoice
obligations, non-payroll operating expenses, and net payroll.

Vendor invoices represent recorded obligations and should not be interpreted
as verified cash payments.

Therefore, the cash flow metric in this project is an analytical estimate
rather than a bank-verified cash flow statement.

---

## 11. Project Structure

```text
CashFlowIQ/
│
├── Clean_Data/
│
├── Data/
│   ├── bank_transactions.csv
│   ├── customers.csv
│   ├── inventory_snapshots.csv
│   ├── loan_payments.csv
│   ├── loans.csv
│   ├── operating_expenses.csv
│   ├── payroll.csv
│   ├── products.csv
│   ├── sales_invoices.csv
│   ├── vendor_invoices.csv
│   └── vendors.csv
│
├── Documentation/
│   ├── Business_Insights.md
│   └── Business_Questions.md
│
├── PowerBI/
│   ├── CashFlowIQ_Dashboard.pbix
│   └── Finance_image.jpg
│
├── Python/
│   ├── 01_Data_Quality_Check.ipynb
│   └── 02_Data_Cleaning_Transformation.ipynb
│
├── SQL/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   └── 03_SQL_Business_Analysis.sql
│
└── README.md