# CashFlowIQ – Business Insights & Key Findings

## 1. Project Overview

CashFlowIQ is a financial and cash flow analytics project designed to analyze revenue, collections, outstanding receivables, vendor obligations, operating expenses, payroll costs, and cash flow.

The project uses MySQL for business analysis and Power BI for interactive dashboard visualization.

---

## 2. Business Questions

The project addresses the following business questions:

1. What is the total revenue generated?
2. How does revenue change month by month?
3. How much revenue has been collected?
4. How much revenue is still outstanding?
5. What is the overall collection rate?
6. Which customer segments contribute the most revenue?
7. Which products generate the highest revenue?
8. Which regions generate the highest revenue?
9. Which customers contribute the highest revenue?
10. What are the major operating expense categories?
11. How does payroll cost change over time?
12. What are the monthly vendor obligations?
13. How does revenue compare with vendor obligations?
14. How does outstanding revenue change over time?
15. What is the estimated cash flow of the business?

---

## 3. Key Financial Metrics

| Metric | Result |
|---|---:|
| Total Revenue | ₹45.48M |
| Total Collected Revenue | ₹40.85M |
| Outstanding Revenue | ₹4.64M |
| Collection Rate | 89.81% |
| Vendor Obligations | ₹7.95M |
| Non-payroll Operating Expenses | ₹14.50M |
| Net Payroll | ₹16.52M |
| Estimated Cash Flow | ₹6.51M |

---

## 4. Revenue Insights

- Total net revenue generated was approximately ₹45.48M.
- The dashboard shows the monthly revenue trend across the available period.
- Revenue is analyzed by region, customer segment, product category, customers, and products.
- The regional analysis shows differences in revenue contribution across West, South, North, and East regions.
- Customer and product analysis helps identify the highest revenue contributors.

---

## 5. Collection & Receivables Insights

- Total collected revenue was approximately ₹40.85M.
- Outstanding revenue was approximately ₹4.64M.
- The overall collection rate was 89.81%.
- Outstanding revenue is analyzed using ageing buckets to understand receivable exposure.
- Monthly outstanding revenue trends help track changes in receivables over time.

---

## 6. Expense & Payroll Insights

- Non-payroll operating expenses were approximately ₹14.50M.
- Payroll was analyzed separately using net payroll of approximately ₹16.52M.
- Payroll is also analyzed through a monthly trend to understand changes in payroll costs.
- Operating expenses are analyzed by categories such as Rent, Marketing, Professional Services, Software, Utilities, Travel, and Insurance.
- Payroll is kept separate from non-payroll operating expenses in the final cash flow calculation to avoid double counting.

---

## 7. Vendor Obligation Insights

- Total vendor invoice obligations were approximately ₹7.95M.
- Vendor obligations are analyzed by vendor and by month.
- The dashboard provides a monthly vendor obligations trend.
- Vendor-level analysis helps identify vendors with higher invoice obligations.

---

## 8. Cash Flow Insights

The project estimates cash flow using:

**Revenue − Vendor Obligations − Non-payroll Operating Expenses − Net Payroll**

The resulting estimated cash flow is approximately:

**₹6.51M**

This metric is intended as an analytical estimate based on the available project data.

Vendor invoices represent business obligations and should not be interpreted as verified actual cash payments.

---

## 9. Dashboard Analysis

The Power BI dashboard contains three pages:

### Page 1 – Financial & Cash Flow KPIs

Key financial indicators include:

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

### Page 2 – Sales & Revenue Analysis

The dashboard includes:

- Revenue by Region
- Monthly Revenue Trend
- Revenue by Customer Segment
- Revenue by Product
- Revenue by Product Category
- Payment Status Analysis
- Outstanding Revenue by Ageing Bucket
- Top 10 Customers by Revenue
- Top 10 Products by Revenue
- Vendor Obligations by Vendor

### Page 3 – Financial & Cash Flow Analysis

The dashboard includes:

- Estimated Cash Flow by Month
- Operating Expenses by Category
- Monthly Payroll Trend
- Monthly Vendor Obligations Trend
- Revenue vs Vendor Obligations by Month
- Monthly Outstanding Revenue Trend

---

## 10. Tools & Technologies

- MySQL
- SQL
- Python
- Power BI
- Power Query
- DAX
- Excel
- Jupyter Notebook
- VS Code

---

## 11. Data Limitation

Vendor invoice amounts represent invoice obligations. The dataset does not contain a separate verified vendor payment transaction table.

Therefore, vendor obligations are used as an analytical proxy in the estimated cash flow calculation.

The estimated cash flow should therefore be interpreted as a business analysis estimate rather than a bank-verified cash balance.

---

## 12. Conclusion

CashFlowIQ provides an end-to-end view of financial performance by combining revenue, collections, receivables, vendor obligations, operating expenses, payroll, and estimated cash flow analysis.

The project demonstrates the use of SQL for business analysis and Power BI for interactive financial reporting and visualization.