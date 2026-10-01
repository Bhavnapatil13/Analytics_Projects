-- ==========================================
-- CASHFLOWIQ - SQL BUSINESS ANALYSIS
-- ==========================================
-- Project: CashFlowIQ
-- Purpose: Financial and Cash Flow Business Analysis
-- Database: cashflowiq
-- Tool: MySQL
-- ==========================================
USE cashflowiq;

-- Verify database
SELECT DATABASE() AS current_database;

-- Verify tables
SHOW TABLES;

-- ==========================================
-- 1. SALES INVOICE STRUCTURE
-- ==========================================

DESCRIBE sales_invoices;

SELECT * FROM sales_invoices
LIMIT 5;

-- ==========================================
-- 2. SALES & REVENUE ANALYSIS
-- ==========================================

-- 2.1 Overall Sales Performance

SELECT
    COUNT(*) AS total_invoices,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(gross_amount), 2) AS gross_revenue,
    ROUND(SUM(discount_amount), 2) AS total_discount,
    ROUND(SUM(net_invoice_amount), 2) AS net_revenue,
    ROUND(AVG(net_invoice_amount), 2) AS average_invoice_value
FROM sales_invoices;


-- 2.2 Monthly Revenue Trend

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS invoice_month,
    COUNT(*) AS total_invoices,
    SUM(quantity) AS units_sold,
    ROUND(SUM(net_invoice_amount), 2) AS net_revenue
FROM sales_invoices
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY invoice_month;

-- 2.3 Payment Status Analysis

SELECT
    payment_status,
    COUNT(*) AS total_invoices,
    ROUND(SUM(net_invoice_amount), 2) AS total_amount,
    ROUND(AVG(net_invoice_amount), 2) AS average_invoice_value
FROM sales_invoices
GROUP BY payment_status
ORDER BY total_amount DESC;

-- 2.4 Outstanding Receivables by Ageing

SELECT
    CASE
        WHEN DATEDIFF(CURDATE(), due_date) <= 0 THEN 'Not Due'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 1 AND 30 THEN '1-30 Days'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 31 AND 60 THEN '31-60 Days'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 61 AND 90 THEN '61-90 Days'
        ELSE '90+ Days'
    END AS ageing_bucket,
    COUNT(*) AS outstanding_invoices,
    ROUND(SUM(net_invoice_amount), 2) AS outstanding_amount
FROM sales_invoices
WHERE payment_status = 'Outstanding'
GROUP BY
    CASE
        WHEN DATEDIFF(CURDATE(), due_date) <= 0 THEN 'Not Due'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 1 AND 30 THEN '1-30 Days'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 31 AND 60 THEN '31-60 Days'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 61 AND 90 THEN '61-90 Days'
        ELSE '90+ Days'
    END
ORDER BY outstanding_amount DESC;

-- 2.5 Customer-wise Sales Analysis

SELECT
    customer_id,
    COUNT(*) AS total_invoices,
    SUM(quantity) AS total_units_purchased,
    ROUND(SUM(net_invoice_amount), 2) AS total_revenue,
    ROUND(AVG(net_invoice_amount), 2) AS average_invoice_value
FROM sales_invoices
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 20;

-- 2.6 Product-wise Sales Analysis

SELECT
    product_id,
    COUNT(*) AS total_invoices,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(net_invoice_amount), 2) AS total_revenue,
    ROUND(AVG(net_invoice_amount), 2) AS average_invoice_value
FROM sales_invoices
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 20;

-- 2.7 Region-wise Sales Analysis

SELECT
    c.region,
    COUNT(DISTINCT s.customer_id) AS total_customers,
    COUNT(*) AS total_invoices,
    SUM(s.quantity) AS total_units_sold,
    ROUND(SUM(s.net_invoice_amount), 2) AS total_revenue
FROM sales_invoices s
JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY c.region
ORDER BY total_revenue DESC;

-- 2.8 Vendor Payables Analysis

SELECT
    v.vendor_id,
    v.vendor_name,
    v.vendor_category,
    COUNT(vi.vendor_invoice_id) AS total_invoices,
    ROUND(SUM(vi.invoice_amount), 2) AS total_payable,
    ROUND(AVG(vi.invoice_amount), 2) AS average_invoice_value
FROM vendor_invoices vi
JOIN vendors v
    ON vi.vendor_id = v.vendor_id
GROUP BY
    v.vendor_id,
    v.vendor_name,
    v.vendor_category
ORDER BY total_payable DESC
LIMIT 20;

-- 2.9 Operating Expenses Structure

DESCRIBE operating_expenses;

SELECT *
FROM operating_expenses
LIMIT 5;

-- 2.9.1 Expense Category Analysis

SELECT
    expense_category,
    COUNT(*) AS total_expense_transactions,
    ROUND(SUM(amount), 2) AS total_expense,
    ROUND(AVG(amount), 2) AS average_expense
FROM operating_expenses
GROUP BY expense_category
ORDER BY total_expense DESC;

-- 2.9.2 Monthly Expense Trend

SELECT
    DATE_FORMAT(expense_date, '%Y-%m') AS expense_month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_expense,
    ROUND(AVG(amount), 2) AS average_expense
FROM operating_expenses
GROUP BY DATE_FORMAT(expense_date, '%Y-%m')
ORDER BY expense_month;

-- 2.9.3 Annual Expense Analysis

SELECT
    YEAR(expense_date) AS expense_year,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_expense,
    ROUND(AVG(amount), 2) AS average_expense
FROM operating_expenses
GROUP BY YEAR(expense_date)
ORDER BY expense_year;

-- ==========================================
-- 2.10 PAYROLL ANALYSIS
-- ==========================================

DESCRIBE payroll;

SELECT *
FROM payroll
LIMIT 5;


-- 2.10.1 Payroll Summary

SELECT
    COUNT(*) AS total_payroll_records,
    ROUND(SUM(gross_payroll), 2) AS total_gross_payroll,
    ROUND(SUM(tax_and_deductions), 2) AS total_tax_deductions,
    ROUND(SUM(net_payroll), 2) AS total_net_payroll,
    ROUND(AVG(net_payroll), 2) AS average_net_payroll
FROM payroll;

-- 2.10.2 Monthly Payroll Trend

SELECT
    DATE_FORMAT(pay_date, '%Y-%m') AS pay_month,
    COUNT(*) AS payroll_records,
    ROUND(SUM(gross_payroll), 2) AS gross_payroll,
    ROUND(SUM(tax_and_deductions), 2) AS total_deductions,
    ROUND(SUM(net_payroll), 2) AS net_payroll
FROM payroll
GROUP BY DATE_FORMAT(pay_date, '%Y-%m')
ORDER BY pay_month;

-- 2.10.3 Payroll Deduction Analysis

SELECT
    ROUND(SUM(gross_payroll), 2) AS total_gross_payroll,
    ROUND(SUM(tax_and_deductions), 2) AS total_deductions,
    ROUND(SUM(net_payroll), 2) AS total_net_payroll,
    ROUND(
        (SUM(tax_and_deductions) / SUM(gross_payroll)) * 100,
        2
    ) AS deduction_rate_pct,
    ROUND(AVG(tax_and_deductions), 2) AS average_deduction
FROM payroll;

--"I analyzed payroll costs and calculated the overall deduction rate to understand how much of the company's
--gross payroll was reduced by taxes and other deductions."

-- 2.10.4 Yearly Payroll Analysis

SELECT
    YEAR(pay_date) AS payroll_year,
    COUNT(*) AS payroll_records,
    ROUND(SUM(gross_payroll), 2) AS gross_payroll,
    ROUND(SUM(tax_and_deductions), 2) AS total_deductions,
    ROUND(SUM(net_payroll), 2) AS net_payroll
FROM payroll
GROUP BY YEAR(pay_date)
ORDER BY payroll_year;

-- 2.11 Cross-Functional Business Analysis
-- 2.11.1 Monthly Revenue vs Operating Expenses

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS month,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
),

monthly_expenses AS (
    SELECT
        DATE_FORMAT(expense_date, '%Y-%m') AS month,
        ROUND(SUM(amount), 2) AS total_expenses
    FROM operating_expenses
    GROUP BY DATE_FORMAT(expense_date, '%Y-%m')
)

SELECT
    s.month,
    s.total_revenue,
    COALESCE(e.total_expenses, 0) AS total_expenses,
    ROUND(
        s.total_revenue - COALESCE(e.total_expenses, 0),
        2
    ) AS operating_surplus,
    ROUND(
        (
            (s.total_revenue - COALESCE(e.total_expenses, 0))
            / s.total_revenue
        ) * 100,
        2
    ) AS operating_margin_pct
FROM monthly_sales s
LEFT JOIN monthly_expenses e
    ON s.month = e.month
ORDER BY s.month;

-- 2.11.2 Revenue, Expenses and Payroll Analysis

WITH yearly_sales AS (
    SELECT
        YEAR(invoice_date) AS year,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY YEAR(invoice_date)
),

yearly_expenses AS (
    SELECT
        YEAR(expense_date) AS year,
        ROUND(
            SUM(
                CASE
                    WHEN expense_category <> 'Payroll'
                    THEN amount
                    ELSE 0
                END
            ),
            2
        ) AS total_operating_expenses
    FROM operating_expenses
    GROUP BY YEAR(expense_date)
),

yearly_payroll AS (
    SELECT
        YEAR(pay_date) AS year,
        ROUND(SUM(net_payroll), 2) AS total_payroll
    FROM payroll
    GROUP BY YEAR(pay_date)
)

SELECT
    s.year,
    s.total_revenue,
    COALESCE(e.total_operating_expenses, 0) AS operating_expenses,
    COALESCE(p.total_payroll, 0) AS net_payroll,

    ROUND(
        s.total_revenue
        - COALESCE(e.total_operating_expenses, 0)
        - COALESCE(p.total_payroll, 0),
        2
    ) AS estimated_operating_profit

FROM yearly_sales s

LEFT JOIN yearly_expenses e
    ON s.year = e.year

LEFT JOIN yearly_payroll p
    ON s.year = p.year

ORDER BY s.year;

-- Important observation
-- 2026 contains partial-year data, so it should not be interpreted as a full-year profitability result.
-- This analysis compares revenue with non-payroll operating expenses and net payroll
-- to estimate operating profit.

-- 2.11.3 Customer Revenue Contribution

WITH customer_sales AS (
    SELECT
        customer_id,
        ROUND(SUM(net_invoice_amount), 2) AS customer_revenue
    FROM sales_invoices
    GROUP BY customer_id
),

total_sales AS (
    SELECT
        SUM(net_invoice_amount) AS total_revenue
    FROM sales_invoices
)

SELECT
    cs.customer_id,
    cs.customer_revenue,
    ROUND(
        (cs.customer_revenue / ts.total_revenue) * 100,
        2
    ) AS revenue_contribution_pct
FROM customer_sales cs
CROSS JOIN total_sales ts
ORDER BY cs.customer_revenue DESC
LIMIT 20;

-- 2.11.4 Vendor Invoice Concentration

WITH vendor_obligations AS (
    SELECT
        vendor_id,
        ROUND(SUM(invoice_amount), 2) AS total_obligation
    FROM vendor_invoices
    GROUP BY vendor_id
),

total_obligations AS (
    SELECT
        ROUND(SUM(invoice_amount), 2) AS total_vendor_obligations
    FROM vendor_invoices
)

SELECT
    vo.vendor_id,
    v.vendor_name,
    v.vendor_category,
    vo.total_obligation,
    ROUND(
        (vo.total_obligation / t.total_vendor_obligations) * 100,
        2
    ) AS obligation_contribution_pct
FROM vendor_obligations vo
JOIN vendors v
    ON vo.vendor_id = v.vendor_id
CROSS JOIN total_obligations t
ORDER BY vo.total_obligation DESC
LIMIT 20;

-- 2.11.5 Monthly Profitability Analysis

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS month,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
),

monthly_expenses AS (
    SELECT
        DATE_FORMAT(expense_date, '%Y-%m') AS month,
        ROUND(
            SUM(
                CASE
                    WHEN expense_category <> 'Payroll'
                    THEN amount
                    ELSE 0
                END
            ),
            2
        ) AS operating_expenses
    FROM operating_expenses
    GROUP BY DATE_FORMAT(expense_date, '%Y-%m')
),

monthly_payroll AS (
    SELECT
        DATE_FORMAT(pay_date, '%Y-%m') AS month,
        ROUND(SUM(net_payroll), 2) AS payroll
    FROM payroll
    GROUP BY DATE_FORMAT(pay_date, '%Y-%m')
)

SELECT
    s.month,
    s.total_revenue,
    COALESCE(e.operating_expenses, 0) AS operating_expenses,
    COALESCE(p.payroll, 0) AS net_payroll,

    ROUND(
        s.total_revenue
        - COALESCE(e.operating_expenses, 0)
        - COALESCE(p.payroll, 0),
        2
    ) AS operating_profit,

    ROUND(
        (
            s.total_revenue
            - COALESCE(e.operating_expenses, 0)
            - COALESCE(p.payroll, 0)
        ) / s.total_revenue * 100,
        2
    ) AS operating_margin_pct

FROM monthly_sales s

LEFT JOIN monthly_expenses e
    ON s.month = e.month

LEFT JOIN monthly_payroll p
    ON s.month = p.month

ORDER BY s.month;

--"How did you calculate operating profit?"
--"I calculated operating profit by subtracting operating expenses and net payroll from monthly revenue."
--Operating Margin % = Operating Profit / Revenue × 100

-- 2.11.6 Monthly Estimated Cash Outflow Analysis

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS month,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
),

monthly_vendor_obligations AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS month,
        ROUND(SUM(invoice_amount), 2) AS vendor_obligations
    FROM vendor_invoices
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
),

monthly_expenses AS (
    SELECT
        DATE_FORMAT(expense_date, '%Y-%m') AS month,
        ROUND(
            SUM(
                CASE
                    WHEN expense_category <> 'Payroll'
                    THEN amount
                    ELSE 0
                END
            ),
            2
        ) AS operating_expenses
    FROM operating_expenses
    GROUP BY DATE_FORMAT(expense_date, '%Y-%m')
),

monthly_payroll AS (
    SELECT
        DATE_FORMAT(pay_date, '%Y-%m') AS month,
        ROUND(SUM(net_payroll), 2) AS payroll
    FROM payroll
    GROUP BY DATE_FORMAT(pay_date, '%Y-%m')
)

SELECT
    r.month,
    r.total_revenue,
    COALESCE(v.vendor_obligations, 0) AS vendor_obligations,
    COALESCE(e.operating_expenses, 0) AS operating_expenses,
    COALESCE(p.payroll, 0) AS net_payroll,

    ROUND(
        COALESCE(v.vendor_obligations, 0)
        + COALESCE(e.operating_expenses, 0)
        + COALESCE(p.payroll, 0),
        2
    ) AS estimated_cash_outflow,

    ROUND(
        r.total_revenue
        - COALESCE(v.vendor_obligations, 0)
        - COALESCE(e.operating_expenses, 0)
        - COALESCE(p.payroll, 0),
        2
    ) AS estimated_cash_flow

FROM monthly_revenue r

LEFT JOIN monthly_vendor_obligations v
    ON r.month = v.month

LEFT JOIN monthly_expenses e
    ON r.month = e.month

LEFT JOIN monthly_payroll p
    ON r.month = p.month

ORDER BY r.month;

--Notice that net cash flow is negative in these months, even when your earlier profitability analysis showed some months with positive operating profit.
--That's because this analysis includes vendor invoice obligations in addition to operating expenses and payroll.
--So this is a useful interview point:
--"I compared monthly revenue with vendor obligations, operating expenses, and payroll to identify months where total outflows exceeded revenue."

-- 2.11.7 Customer Payment & Revenue Analysis

SELECT
    payment_status,
    COUNT(*) AS total_invoices,
    COUNT(DISTINCT customer_id) AS unique_customers,

    ROUND(SUM(net_invoice_amount), 2) AS total_revenue,

    ROUND(AVG(net_invoice_amount), 2) AS average_invoice_value,

    ROUND(
        (SUM(net_invoice_amount) /
        (SELECT SUM(net_invoice_amount) FROM sales_invoices)) * 100,
        2
    ) AS revenue_contribution_pct

FROM sales_invoices

GROUP BY payment_status

ORDER BY total_revenue DESC;    

--"Approximately 89.81% of invoice revenue is associated with paid invoices, while 10.19% remains outstanding. 
--Although outstanding invoices represent only about 10% of revenue, their average invoice value is slightly higher than paid invoices, 
--so the outstanding amount should be monitored for collection."

-- 2.11.8 Vendor Payment Concentration by Category

WITH category_payments AS (
    SELECT
        v.vendor_category,
        ROUND(SUM(vi.invoice_amount), 2) AS total_payable
    FROM vendor_invoices vi
    JOIN vendors v
        ON vi.vendor_id = v.vendor_id
    GROUP BY v.vendor_category
),

total_payments AS (
    SELECT
        SUM(total_payable) AS overall_payable
    FROM category_payments
)

SELECT
    cp.vendor_category,
    cp.total_payable,

    ROUND(
        (cp.total_payable / tp.overall_payable) * 100,
        2
    ) AS payable_contribution_pct

FROM category_payments cp
CROSS JOIN total_payments tp

ORDER BY cp.total_payable DESC;

--"I grouped vendor invoices by category and calculated each category's contribution to total payable amounts. 
--Professional Services and Technology together account for nearly half of the total vendor payable exposure."

--The business question is:
--Which customers have the highest outstanding invoice value, and what percentage of their total revenue is still outstanding?

-- 2.11.9 Customer Outstanding Exposure Analysis

SELECT
    s.customer_id,

    COUNT(*) AS total_invoices,

    COUNT(
        CASE
            WHEN s.payment_status = 'Outstanding'
            THEN 1
        END
    ) AS outstanding_invoices,

    ROUND(
        SUM(s.net_invoice_amount),
        2
    ) AS total_customer_revenue,

    ROUND(
        SUM(
            CASE
                WHEN s.payment_status = 'Outstanding'
                THEN s.net_invoice_amount
                ELSE 0
            END
        ),
        2
    ) AS outstanding_amount,

    ROUND(
        (
            SUM(
                CASE
                    WHEN s.payment_status = 'Outstanding'
                    THEN s.net_invoice_amount
                    ELSE 0
                END
            )
            / SUM(s.net_invoice_amount)
        ) * 100,
        2
    ) AS outstanding_revenue_pct

FROM sales_invoices s

GROUP BY s.customer_id

HAVING outstanding_amount > 0

ORDER BY outstanding_amount DESC

LIMIT 20;

-- 2.11.10 Vendor Category Obligation vs Revenue Analysis

WITH vendor_category_obligations AS (
    SELECT
        v.vendor_category,
        ROUND(SUM(vi.invoice_amount), 2) AS total_vendor_obligation
    FROM vendor_invoices vi
    JOIN vendors v
        ON vi.vendor_id = v.vendor_id
    GROUP BY v.vendor_category
),

total_revenue AS (
    SELECT
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
)

SELECT
    vco.vendor_category,
    vco.total_vendor_obligation,
    tr.total_revenue,

    ROUND(
        (vco.total_vendor_obligation / tr.total_revenue) * 100,
        2
    ) AS obligation_to_revenue_pct

FROM vendor_category_obligations vco

CROSS JOIN total_revenue tr

ORDER BY vco.total_vendor_obligation DESC;

-- "I grouped vendor invoices by vendor category and calculated
-- total vendor invoice obligations for each category.
-- I then compared each category's obligation against overall revenue
-- to understand the relative cost exposure of different vendor categories."

-- 2.11.11 Monthly Vendor Invoice Trend

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS invoice_month,
    COUNT(*) AS total_invoices,
    ROUND(SUM(invoice_amount), 2) AS total_vendor_obligation,
    ROUND(AVG(invoice_amount), 2) AS average_invoice_value
FROM vendor_invoices
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY invoice_month;

--"I grouped vendor invoices by month and calculated the invoice count, total vendor payment, and average invoice value.
--This helped identify months with higher vendor cash requirements and changes in average invoice size."

-- 2.11.12 Vendor Invoice Concentration by Vendor

WITH vendor_obligations AS (
    SELECT
        vendor_id,
        ROUND(SUM(invoice_amount), 2) AS total_obligation
    FROM vendor_invoices
    GROUP BY vendor_id
),

total_obligations AS (
    SELECT
        SUM(invoice_amount) AS total_vendor_obligations
    FROM vendor_invoices
)

SELECT
    vo.vendor_id,
    v.vendor_name,
    v.vendor_category,
    vo.total_obligation,

    ROUND(
        (vo.total_obligation / t.total_vendor_obligations) * 100,
        2
    ) AS obligation_contribution_pct

FROM vendor_obligations vo

JOIN vendors v
    ON vo.vendor_id = v.vendor_id

CROSS JOIN total_obligations t

ORDER BY vo.total_obligation DESC

LIMIT 20;

-- 2.11.13 Monthly Customer Payment Status Analysis

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS payment_month,
    payment_status,

    COUNT(*) AS total_invoices,

    COUNT(DISTINCT customer_id) AS unique_customers,

    ROUND(SUM(net_invoice_amount), 2) AS total_revenue,

    ROUND(AVG(net_invoice_amount), 2) AS average_invoice_value

FROM sales_invoices

GROUP BY
    DATE_FORMAT(invoice_date, '%Y-%m'),
    payment_status

ORDER BY
    payment_month,
    payment_status;


--"I analyzed customer payment status at a monthly level by separating paid and outstanding invoices. 
--I calculated invoice count, unique customers, revenue, and average invoice value to understand collection patterns and 
--identify months with higher outstanding exposure."    

-- 2.11.14 Monthly Outstanding Revenue Rate

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS payment_month,

    ROUND(SUM(net_invoice_amount), 2) AS total_revenue,

    ROUND(
        SUM(
            CASE
                WHEN payment_status = 'Outstanding'
                THEN net_invoice_amount
                ELSE 0
            END
        ),
        2
    ) AS outstanding_revenue,

    ROUND(
        (
            SUM(
                CASE
                    WHEN payment_status = 'Outstanding'
                    THEN net_invoice_amount
                    ELSE 0
                END
            )
            / SUM(net_invoice_amount)
        ) * 100,
        2
    ) AS outstanding_revenue_pct

FROM sales_invoices

GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')

ORDER BY payment_month;

-- 2.11.15 Monthly Revenue Collection Rate

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS payment_month,

    ROUND(SUM(net_invoice_amount), 2) AS total_revenue,

    ROUND(
        SUM(
            CASE
                WHEN payment_status = 'Paid'
                THEN net_invoice_amount
                ELSE 0
            END
        ),
        2
    ) AS collected_revenue,

    ROUND(
        (
            SUM(
                CASE
                    WHEN payment_status = 'Paid'
                    THEN net_invoice_amount
                    ELSE 0
                END
            )
            / SUM(net_invoice_amount)
        ) * 100,
        2
    ) AS collection_rate_pct

FROM sales_invoices

GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')

ORDER BY payment_month;

-- 2.11.16 Monthly Revenue Growth

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS payment_month,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
)

SELECT
    payment_month,
    total_revenue,

    LAG(total_revenue) OVER (
        ORDER BY payment_month
    ) AS previous_month_revenue,

    ROUND(
        (
            (total_revenue -
             LAG(total_revenue) OVER (
                 ORDER BY payment_month
             ))
            /
            LAG(total_revenue) OVER (
                ORDER BY payment_month
            )
        ) * 100,
        2
    ) AS revenue_growth_pct

FROM monthly_revenue

ORDER BY payment_month;

-- 2.11.17 Monthly Revenue & Collection Performance

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS payment_month,

    ROUND(SUM(net_invoice_amount), 2) AS total_revenue,

    ROUND(
        SUM(
            CASE
                WHEN payment_status = 'Paid'
                THEN net_invoice_amount
                ELSE 0
            END
        ),
        2
    ) AS collected_revenue,

    ROUND(
        SUM(
            CASE
                WHEN payment_status = 'Outstanding'
                THEN net_invoice_amount
                ELSE 0
            END
        ),
        2
    ) AS outstanding_revenue,

    ROUND(
        (
            SUM(
                CASE
                    WHEN payment_status = 'Paid'
                    THEN net_invoice_amount
                    ELSE 0
                END
            )
            / SUM(net_invoice_amount)
        ) * 100,
        2
    ) AS collection_rate_pct

FROM sales_invoices

GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')

ORDER BY payment_month;

-- 2.11.18 Monthly Revenue vs Operating Cost

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS month,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
),

monthly_expenses AS (
    SELECT
        DATE_FORMAT(expense_date, '%Y-%m') AS month,
        ROUND(
            SUM(
                CASE
                    WHEN expense_category <> 'Payroll'
                    THEN amount
                    ELSE 0
                END
            ),
            2
        ) AS operating_expenses
    FROM operating_expenses
    GROUP BY DATE_FORMAT(expense_date, '%Y-%m')
),

monthly_payroll AS (
    SELECT
        DATE_FORMAT(pay_date, '%Y-%m') AS month,
        ROUND(SUM(net_payroll), 2) AS payroll
    FROM payroll
    GROUP BY DATE_FORMAT(pay_date, '%Y-%m')
)

SELECT
    r.month,
    r.total_revenue,
    COALESCE(e.operating_expenses, 0) AS operating_expenses,
    COALESCE(p.payroll, 0) AS net_payroll,

    ROUND(
        r.total_revenue
        - COALESCE(e.operating_expenses, 0)
        - COALESCE(p.payroll, 0),
        2
    ) AS operating_profit,

    ROUND(
        (
            r.total_revenue
            - COALESCE(e.operating_expenses, 0)
            - COALESCE(p.payroll, 0)
        ) / r.total_revenue * 100,
        2
    ) AS operating_margin_pct

FROM monthly_revenue r

LEFT JOIN monthly_expenses e
    ON r.month = e.month

LEFT JOIN monthly_payroll p
    ON r.month = p.month

ORDER BY r.month;

-- Operating Profit = Revenue − Non-payroll Operating Expenses − Net Payroll
-- If asked "What did you analyze?", say:
-- "I combined monthly revenue, non-payroll operating expenses, and net payroll
-- using CTEs and joins. I then calculated operating profit and operating margin
-- to evaluate monthly profitability and understand how operating costs affected revenue."


-- 2.11.19 Monthly Estimated Cash Flow Trend

-- Revenue − Vendor Invoice Obligations − Non-payroll Operating Expenses − Net Payroll
-- = Estimated Cash Flow

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS month,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
),

monthly_vendor_obligations AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS month,
        ROUND(SUM(invoice_amount), 2) AS vendor_obligations
    FROM vendor_invoices
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
),

monthly_expenses AS (
    SELECT
        DATE_FORMAT(expense_date, '%Y-%m') AS month,
        ROUND(
            SUM(
                CASE
                    WHEN expense_category <> 'Payroll'
                    THEN amount
                    ELSE 0
                END
            ),
            2
        ) AS operating_expenses
    FROM operating_expenses
    GROUP BY DATE_FORMAT(expense_date, '%Y-%m')
),

monthly_payroll AS (
    SELECT
        DATE_FORMAT(pay_date, '%Y-%m') AS month,
        ROUND(SUM(net_payroll), 2) AS payroll
    FROM payroll
    GROUP BY DATE_FORMAT(pay_date, '%Y-%m')
)

SELECT
    r.month,
    r.total_revenue,
    COALESCE(v.vendor_obligations, 0) AS vendor_obligations,
    COALESCE(e.operating_expenses, 0) AS operating_expenses,
    COALESCE(p.payroll, 0) AS payroll,

    ROUND(
        r.total_revenue
        - COALESCE(v.vendor_obligations, 0)
        - COALESCE(e.operating_expenses, 0)
        - COALESCE(p.payroll, 0),
        2
    ) AS estimated_cash_flow

FROM monthly_revenue r

LEFT JOIN monthly_vendor_obligations v
    ON r.month = v.month

LEFT JOIN monthly_expenses e
    ON r.month = e.month

LEFT JOIN monthly_payroll p
    ON r.month = p.month

ORDER BY r.month;

-- 2.11.20 Monthly Cumulative Revenue Analysis

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS month,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
)

SELECT
    month,
    total_revenue,

    ROUND(
        SUM(total_revenue) OVER (
            ORDER BY month
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue

FROM monthly_revenue

ORDER BY month;

-- 2.11.21 3-Month Moving Average Revenue

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS month,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
)

SELECT
    month,
    total_revenue,

    ROUND(
        AVG(total_revenue) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_moving_avg

FROM monthly_revenue

ORDER BY month;

-- 2.11.22 Top Customers by Revenue

WITH customer_revenue AS (
    SELECT
        customer_id,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY customer_id
)

SELECT
    customer_id,
    total_revenue,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM customer_revenue

ORDER BY total_revenue DESC

LIMIT 20;

-- 2.11.23 Customer Revenue Contribution & Cumulative Contribution

WITH customer_revenue AS (
    SELECT
        customer_id,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY customer_id
),

ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,

        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        SUM(total_revenue) OVER () AS company_revenue,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue

    FROM customer_revenue
)

SELECT
    customer_id,
    total_revenue,
    revenue_rank,

    ROUND(
        (total_revenue / company_revenue) * 100,
        2
    ) AS revenue_contribution_pct,

    ROUND(
        (cumulative_revenue / company_revenue) * 100,
        2
    ) AS cumulative_revenue_pct

FROM ranked_customers

ORDER BY revenue_rank;

-- 2.11.24 Product Revenue Ranking

WITH product_revenue AS (
    SELECT
        product_id,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue,
        SUM(quantity) AS total_units_sold
    FROM sales_invoices
    GROUP BY product_id
)

SELECT
    product_id,
    total_revenue,
    total_units_sold,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,

    ROUND(
        (
            total_revenue /
            SUM(total_revenue) OVER ()
        ) * 100,
        2
    ) AS revenue_contribution_pct

FROM product_revenue

ORDER BY revenue_rank
LIMIT 20;

-- 2.11.25 Product Revenue Contribution + Cumulative Contribution

WITH product_revenue AS (
    SELECT
        product_id,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY product_id
),

ranked_products AS (
    SELECT
        product_id,
        total_revenue,

        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        SUM(total_revenue) OVER () AS company_revenue,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue

    FROM product_revenue
)

SELECT
    product_id,
    total_revenue,
    revenue_rank,

    ROUND(
        (total_revenue / company_revenue) * 100,
        2
    ) AS revenue_contribution_pct,

    ROUND(
        (cumulative_revenue / company_revenue) * 100,
        2
    ) AS cumulative_revenue_pct

FROM ranked_products

ORDER BY revenue_rank;

-- 2.11.26 Monthly Product Revenue Analysis

SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
    product_id,
    COUNT(*) AS total_invoices,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(net_invoice_amount), 2) AS total_revenue

FROM sales_invoices

GROUP BY
    DATE_FORMAT(invoice_date, '%Y-%m'),
    product_id

ORDER BY
    sales_month,
    total_revenue DESC;


-- 2.11.27 Top Products by Units Sold

WITH product_sales AS (
    SELECT
        product_id,
        SUM(quantity) AS total_units_sold,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY product_id
)

SELECT
    product_id,
    total_units_sold,
    total_revenue,

    RANK() OVER (
        ORDER BY total_units_sold DESC
    ) AS units_sold_rank

FROM product_sales

ORDER BY units_sold_rank
LIMIT 20;


-- 2.11.28 Customer Purchase Frequency

SELECT
    customer_id,
    COUNT(*) AS total_invoices,
    SUM(quantity) AS total_units_purchased,
    ROUND(SUM(net_invoice_amount), 2) AS total_revenue,
    ROUND(AVG(net_invoice_amount), 2) AS average_invoice_value,

    CASE
        WHEN COUNT(*) >= 50 THEN 'High Frequency'
        WHEN COUNT(*) >= 25 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS purchase_frequency

FROM sales_invoices

GROUP BY customer_id

ORDER BY total_invoices DESC;

-- 2.11.29 Customer Revenue Segmentation

WITH customer_revenue AS (
    SELECT
        customer_id,
        ROUND(SUM(net_invoice_amount), 2) AS total_revenue
    FROM sales_invoices
    GROUP BY customer_id
)

SELECT
    customer_id,
    total_revenue,

    CASE
        WHEN total_revenue >= 400000 THEN 'High Value'
        WHEN total_revenue >= 200000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment

FROM customer_revenue

ORDER BY total_revenue DESC;


-- 2.11.30 Customer Segment Summary

WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(net_invoice_amount) AS total_revenue
    FROM sales_invoices
    GROUP BY customer_id
),

customer_segments AS (
    SELECT
        customer_id,
        total_revenue,
        CASE
            WHEN total_revenue >= 400000 THEN 'High Value'
            WHEN total_revenue >= 200000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_revenue
)

SELECT
    customer_segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS segment_revenue,
    ROUND(AVG(total_revenue), 2) AS average_customer_revenue,
    ROUND(
        SUM(total_revenue) / (SELECT SUM(total_revenue) FROM customer_revenue) * 100,
        2
    ) AS revenue_contribution_pct

FROM customer_segments

GROUP BY customer_segment

ORDER BY segment_revenue DESC;


-- 2.11.31 Vendor Category Analysis

WITH category_summary AS (
    SELECT
        v.vendor_category,
        COUNT(DISTINCT v.vendor_id) AS total_vendors,
        COUNT(vi.vendor_invoice_id) AS total_invoices,
        SUM(vi.invoice_amount) AS total_payable,
        AVG(vi.invoice_amount) AS average_invoice_value
    FROM vendor_invoices vi
    JOIN vendors v
        ON vi.vendor_id = v.vendor_id
    GROUP BY v.vendor_category
)

SELECT
    vendor_category,
    total_vendors,
    total_invoices,
    ROUND(total_payable, 2) AS total_payable,
    ROUND(average_invoice_value, 2) AS average_invoice_value,
    ROUND(
        total_payable / SUM(total_payable) OVER () * 100,
        2
    ) AS payable_contribution_pct

FROM category_summary

ORDER BY total_payable DESC;


-- 2.11.32 Vendor Invoice Ageing Analysis

SELECT
    CASE
        WHEN payment_status = 'Paid' THEN 'Paid'
        WHEN DATEDIFF(CURDATE(), due_date) <= 0 THEN 'Not Due'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 1 AND 30 THEN '1-30 Days Overdue'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 31 AND 60 THEN '31-60 Days Overdue'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 61 AND 90 THEN '61-90 Days Overdue'
        ELSE '90+ Days Overdue'
    END AS ageing_bucket,

    COUNT(*) AS total_invoices,

    ROUND(SUM(invoice_amount), 2) AS total_invoice_amount,

    ROUND(AVG(invoice_amount), 2) AS average_invoice_amount

FROM vendor_invoices

GROUP BY
    CASE
        WHEN payment_status = 'Paid' THEN 'Paid'
        WHEN DATEDIFF(CURDATE(), due_date) <= 0 THEN 'Not Due'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 1 AND 30 THEN '1-30 Days Overdue'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 31 AND 60 THEN '31-60 Days Overdue'
        WHEN DATEDIFF(CURDATE(), due_date) BETWEEN 61 AND 90 THEN '61-90 Days Overdue'
        ELSE '90+ Days Overdue'
    END

ORDER BY total_invoice_amount DESC;


-- 2.11.33 Overall CashFlowIQ KPI Summary
-- Note: total_operating_expenses_including_payroll is shown separately
-- for reference and is not used in the final estimated cash flow calculation.

SELECT

    (
        SELECT ROUND(SUM(net_invoice_amount), 2)
        FROM sales_invoices
    ) AS total_revenue,

    (
        SELECT ROUND(SUM(net_invoice_amount), 2)
        FROM sales_invoices
        WHERE payment_status = 'Paid'
    ) AS collected_revenue,

    (
        SELECT ROUND(SUM(net_invoice_amount), 2)
        FROM sales_invoices
        WHERE payment_status = 'Outstanding'
    ) AS outstanding_revenue,

    (
        SELECT ROUND(
            SUM(
                CASE
                    WHEN payment_status = 'Paid'
                    THEN net_invoice_amount
                    ELSE 0
                END
            ) / SUM(net_invoice_amount) * 100,
            2
        )
        FROM sales_invoices
    ) AS collection_rate_pct,

    (
        SELECT ROUND(SUM(invoice_amount), 2)
        FROM vendor_invoices
    ) AS total_vendor_obligations,

    (
        SELECT ROUND(SUM(amount), 2)
        FROM operating_expenses
    ) AS total_operating_expenses_including_payroll,

    (
        SELECT ROUND(SUM(net_payroll), 2)
        FROM payroll
    ) AS total_net_payroll;


-- 2.11.34 Final CashFlowIQ Management Summary
-- Note: Cash flow is estimated using vendor invoice obligations,
-- non-payroll operating expenses, and net payroll.
-- Vendor invoices represent obligations, not verified cash payments.

SELECT
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(collected_revenue, 2) AS collected_revenue,
    ROUND(outstanding_revenue, 2) AS outstanding_revenue,
    ROUND(collection_rate_pct, 2) AS collection_rate_pct,
    ROUND(total_vendor_obligations, 2) AS vendor_obligations,
    ROUND(non_payroll_operating_expenses, 2) AS operating_expenses,
    ROUND(total_net_payroll, 2) AS net_payroll,

    ROUND(
        total_revenue
        - total_vendor_obligations
        - non_payroll_operating_expenses
        - total_net_payroll,
        2
    ) AS estimated_cash_flow,

    ROUND(
        non_payroll_operating_expenses / total_revenue * 100,
        2
    ) AS operating_expense_pct,

    ROUND(
        total_net_payroll / total_revenue * 100,
        2
    ) AS payroll_cost_pct,

    ROUND(
        total_vendor_obligations / total_revenue * 100,
        2
    ) AS vendor_obligation_pct

FROM (
    SELECT

        (SELECT SUM(net_invoice_amount)
         FROM sales_invoices) AS total_revenue,

        (SELECT SUM(net_invoice_amount)
         FROM sales_invoices
         WHERE payment_status = 'Paid') AS collected_revenue,

        (SELECT SUM(net_invoice_amount)
         FROM sales_invoices
         WHERE payment_status = 'Outstanding') AS outstanding_revenue,

        (SELECT
            SUM(
                CASE
                    WHEN payment_status = 'Paid'
                    THEN net_invoice_amount
                    ELSE 0
                END
            )
            / SUM(net_invoice_amount) * 100
         FROM sales_invoices) AS collection_rate_pct,

        (SELECT SUM(invoice_amount)
         FROM vendor_invoices) AS total_vendor_obligations,

        (SELECT SUM(amount)
         FROM operating_expenses
         WHERE expense_category <> 'Payroll') AS non_payroll_operating_expenses,

        (SELECT SUM(net_payroll)
         FROM payroll) AS total_net_payroll
) AS kpi_summary;    