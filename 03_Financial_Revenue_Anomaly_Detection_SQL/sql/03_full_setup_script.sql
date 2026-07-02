DROP SCHEMA IF EXISTS finance CASCADE;

CREATE SCHEMA finance;

CREATE TABLE finance.customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name TEXT NOT NULL,
    customer_type TEXT,
    industry TEXT,
    region TEXT,
    state TEXT,
    acquisition_channel TEXT,
    signup_date DATE,
    customer_status TEXT
);

CREATE TABLE finance.subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES finance.customers(customer_id),
    plan_name TEXT,
    billing_frequency TEXT,
    monthly_recurring_revenue NUMERIC(12,2),
    contract_start_date DATE,
    contract_end_date DATE,
    subscription_status TEXT,
    auto_renew BOOLEAN
);

CREATE TABLE finance.invoices (
    invoice_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES finance.customers(customer_id),
    subscription_id INT REFERENCES finance.subscriptions(subscription_id),
    invoice_date DATE,
    due_date DATE,
    invoice_amount NUMERIC(12,2),
    invoice_status TEXT,
    invoice_category TEXT
);

CREATE TABLE finance.payments (
    payment_id SERIAL PRIMARY KEY,
    invoice_id INT REFERENCES finance.invoices(invoice_id),
    payment_date DATE,
    payment_amount NUMERIC(12,2),
    payment_status TEXT,
    payment_processor TEXT,
    transaction_reference TEXT
);

CREATE TABLE finance.refunds (
    refund_id SERIAL PRIMARY KEY,
    invoice_id INT REFERENCES finance.invoices(invoice_id),
    refund_date DATE,
    refund_amount NUMERIC(12,2),
    refund_reason TEXT
);

CREATE TABLE finance.payment_disputes (
    dispute_id SERIAL PRIMARY KEY,
    invoice_id INT REFERENCES finance.invoices(invoice_id),
    dispute_date DATE,
    dispute_amount NUMERIC(12,2),
    dispute_reason TEXT,
    dispute_status TEXT
);

INSERT INTO finance.customers (
    customer_name,
    customer_type,
    industry,
    region,
    state,
    acquisition_channel,
    signup_date,
    customer_status
)
SELECT
    'Customer ' || gs AS customer_name,
    (ARRAY['Small Business','Mid Market','Enterprise','Strategic'])[(floor(random() * 4) + 1)::int] AS customer_type,
    (ARRAY['SaaS','Healthcare','Retail','Finance','Education','Manufacturing','Professional Services'])[(floor(random() * 7) + 1)::int] AS industry,
    (ARRAY['Northeast','Southeast','Midwest','Southwest','West'])[(floor(random() * 5) + 1)::int] AS region,
    (ARRAY['TN','FL','TX','GA','NC','IL','AZ','CO','CA','NY'])[(floor(random() * 10) + 1)::int] AS state,
    (ARRAY['Paid Search','Organic Search','Referral','LinkedIn','Outbound Sales','Partner'])[(floor(random() * 6) + 1)::int] AS acquisition_channel,
    DATE '2022-01-01' + (floor(random() * 1200))::int AS signup_date,
    CASE
        WHEN random() < 0.86 THEN 'Active'
        WHEN random() < 0.94 THEN 'At Risk'
        ELSE 'Churned'
    END AS customer_status
FROM generate_series(1, 10000) gs;

INSERT INTO finance.subscriptions (
    customer_id,
    plan_name,
    billing_frequency,
    monthly_recurring_revenue,
    contract_start_date,
    contract_end_date,
    subscription_status,
    auto_renew
)
WITH base AS (
    SELECT
        gs,
        (floor(random() * 10000) + 1)::int AS customer_id,
        DATE '2023-01-01' + (floor(random() * 700))::int AS contract_start_date,
        random() AS status_random
    FROM generate_series(1, 15000) gs
)
SELECT
    customer_id,
    (ARRAY['Starter','Professional','Business','Enterprise','Strategic'])[(floor(random() * 5) + 1)::int] AS plan_name,
    (ARRAY['Monthly','Quarterly','Annual'])[(floor(random() * 3) + 1)::int] AS billing_frequency,
    round((500 + random() * 45000)::numeric, 2) AS monthly_recurring_revenue,
    contract_start_date,
    contract_start_date + ((floor(random() * 18) + 6)::int * INTERVAL '1 month') AS contract_end_date,
    CASE
        WHEN status_random < 0.76 THEN 'Active'
        WHEN status_random < 0.88 THEN 'Renewal Risk'
        WHEN status_random < 0.95 THEN 'Expired'
        ELSE 'Cancelled'
    END AS subscription_status,
    CASE WHEN random() < 0.72 THEN TRUE ELSE FALSE END AS auto_renew
FROM base;

INSERT INTO finance.invoices (
    customer_id,
    subscription_id,
    invoice_date,
    due_date,
    invoice_amount,
    invoice_status,
    invoice_category
)
WITH base AS (
    SELECT
        gs,
        s.subscription_id,
        s.customer_id,
        DATE '2024-01-01' + (floor(random() * 548))::int AS invoice_date,
        s.monthly_recurring_revenue,
        random() AS status_random
    FROM generate_series(1, 80000) gs
    JOIN LATERAL (
        SELECT
            subscription_id,
            customer_id,
            monthly_recurring_revenue
        FROM finance.subscriptions
        ORDER BY random()
        LIMIT 1
    ) s ON TRUE
)
SELECT
    customer_id,
    subscription_id,
    invoice_date,
    invoice_date + 30 AS due_date,
    round((monthly_recurring_revenue * (0.75 + random() * 1.5))::numeric, 2) AS invoice_amount,
    CASE
        WHEN status_random < 0.70 THEN 'Paid'
        WHEN status_random < 0.84 THEN 'Open'
        WHEN status_random < 0.94 THEN 'Overdue'
        ELSE 'Written Off'
    END AS invoice_status,
    (ARRAY['Subscription','Implementation','Support','Training','Usage Fee'])[(floor(random() * 5) + 1)::int] AS invoice_category
FROM base;

INSERT INTO finance.payments (
    invoice_id,
    payment_date,
    payment_amount,
    payment_status,
    payment_processor,
    transaction_reference
)
WITH selected_invoices AS (
    SELECT
        i.invoice_id,
        i.invoice_date,
        i.due_date,
        i.invoice_amount,
        i.invoice_status,
        gs
    FROM generate_series(1, 58534) gs
    JOIN LATERAL (
        SELECT
            invoice_id,
            invoice_date,
            due_date,
            invoice_amount,
            invoice_status
        FROM finance.invoices
        ORDER BY random()
        LIMIT 1
    ) i ON TRUE
)
SELECT
    invoice_id,
    CASE
        WHEN random() < 0.80 THEN due_date - (floor(random() * 10))::int
        ELSE due_date + (floor(random() * 35))::int
    END AS payment_date,
    CASE
        WHEN random() < 0.88 THEN invoice_amount
        ELSE round((invoice_amount * (0.50 + random() * 0.50))::numeric, 2)
    END AS payment_amount,
    CASE
        WHEN random() < 0.96 THEN 'Successful'
        ELSE 'Failed'
    END AS payment_status,
    (ARRAY['Stripe','PayPal','ACH','Square','Bank Transfer'])[(floor(random() * 5) + 1)::int] AS payment_processor,
    'TXN-' || lpad(gs::text, 8, '0') AS transaction_reference
FROM selected_invoices;

INSERT INTO finance.refunds (
    invoice_id,
    refund_date,
    refund_amount,
    refund_reason
)
WITH selected_invoices AS (
    SELECT
        i.invoice_id,
        i.invoice_date,
        i.invoice_amount
    FROM generate_series(1, 10017) gs
    JOIN LATERAL (
        SELECT
            invoice_id,
            invoice_date,
            invoice_amount
        FROM finance.invoices
        ORDER BY random()
        LIMIT 1
    ) i ON TRUE
)
SELECT
    invoice_id,
    invoice_date + (floor(random() * 90) + 3)::int AS refund_date,
    round((invoice_amount * (0.05 + random() * 0.35))::numeric, 2) AS refund_amount,
    (ARRAY['Billing Error','Service Issue','Customer Cancellation','Duplicate Charge','Goodwill Credit'])[(floor(random() * 5) + 1)::int] AS refund_reason
FROM selected_invoices;

INSERT INTO finance.payment_disputes (
    invoice_id,
    dispute_date,
    dispute_amount,
    dispute_reason,
    dispute_status
)
WITH selected_invoices AS (
    SELECT
        i.invoice_id,
        i.invoice_date,
        i.invoice_amount
    FROM generate_series(1, 1475) gs
    JOIN LATERAL (
        SELECT
            invoice_id,
            invoice_date,
            invoice_amount
        FROM finance.invoices
        ORDER BY random()
        LIMIT 1
    ) i ON TRUE
)
SELECT
    invoice_id,
    invoice_date + (floor(random() * 120) + 5)::int AS dispute_date,
    round((invoice_amount * (0.10 + random() * 0.45))::numeric, 2) AS dispute_amount,
    (ARRAY['Chargeback','Contract Dispute','Service Quality','Unauthorized Payment','Invoice Error'])[(floor(random() * 5) + 1)::int] AS dispute_reason,
    (ARRAY['Open','Won','Lost','Under Review'])[(floor(random() * 4) + 1)::int] AS dispute_status
FROM selected_invoices;

CREATE OR REPLACE VIEW finance.vw_revenue_detail AS
WITH payment_summary AS (
    SELECT
        invoice_id,
        COUNT(*) AS payment_count,
        SUM(payment_amount) FILTER (WHERE payment_status = 'Successful') AS total_paid_amount,
        MAX(payment_date) FILTER (WHERE payment_status = 'Successful') AS latest_payment_date
    FROM finance.payments
    GROUP BY invoice_id
),

refund_summary AS (
    SELECT
        invoice_id,
        COUNT(*) AS refund_count,
        SUM(refund_amount) AS total_refund_amount
    FROM finance.refunds
    GROUP BY invoice_id
),

dispute_summary AS (
    SELECT
        invoice_id,
        COUNT(*) AS dispute_count,
        SUM(dispute_amount) AS total_dispute_amount
    FROM finance.payment_disputes
    GROUP BY invoice_id
)

SELECT
    i.invoice_id,
    i.invoice_date,
    DATE_TRUNC('month', i.invoice_date)::date AS invoice_month,
    i.due_date,
    i.invoice_amount,
    i.invoice_status,
    i.invoice_category,

    c.customer_id,
    c.customer_name,
    c.customer_type,
    c.industry,
    c.region,
    c.state,
    c.acquisition_channel,
    c.signup_date,
    c.customer_status,

    s.subscription_id,
    s.plan_name,
    s.billing_frequency,
    s.monthly_recurring_revenue,
    s.contract_start_date,
    s.contract_end_date,
    s.subscription_status,
    s.auto_renew,

    COALESCE(ps.payment_count, 0) AS payment_count,
    COALESCE(ps.total_paid_amount, 0) AS total_paid_amount,
    ps.latest_payment_date,

    COALESCE(rs.refund_count, 0) AS refund_count,
    COALESCE(rs.total_refund_amount, 0) AS total_refund_amount,

    COALESCE(ds.dispute_count, 0) AS dispute_count,
    COALESCE(ds.total_dispute_amount, 0) AS total_dispute_amount,

    ROUND(
        i.invoice_amount
        - COALESCE(rs.total_refund_amount, 0)
        - COALESCE(ds.total_dispute_amount, 0),
        2
    ) AS net_revenue,

    CASE
        WHEN i.invoice_status = 'Overdue' THEN TRUE
        ELSE FALSE
    END AS is_overdue,

    CASE
        WHEN ps.latest_payment_date IS NOT NULL
             AND ps.latest_payment_date > i.due_date
            THEN TRUE
        ELSE FALSE
    END AS paid_late_flag,

    CASE
        WHEN i.invoice_status = 'Overdue' THEN CURRENT_DATE - i.due_date
        WHEN ps.latest_payment_date IS NOT NULL THEN ps.latest_payment_date - i.due_date
        ELSE NULL
    END AS days_past_due

FROM finance.invoices i
JOIN finance.customers c
    ON i.customer_id = c.customer_id
JOIN finance.subscriptions s
    ON i.subscription_id = s.subscription_id
LEFT JOIN payment_summary ps
    ON i.invoice_id = ps.invoice_id
LEFT JOIN refund_summary rs
    ON i.invoice_id = rs.invoice_id
LEFT JOIN dispute_summary ds
    ON i.invoice_id = ds.invoice_id;

CREATE OR REPLACE VIEW finance.vw_monthly_revenue_anomaly AS
WITH monthly_revenue AS (
    SELECT
        invoice_month,
        COUNT(DISTINCT invoice_id) AS invoice_count,
        COUNT(DISTINCT customer_id) AS unique_customers,
        ROUND(SUM(invoice_amount), 2) AS gross_revenue,
        ROUND(SUM(total_paid_amount), 2) AS collected_revenue,
        ROUND(SUM(total_refund_amount), 2) AS refund_amount,
        ROUND(SUM(total_dispute_amount), 2) AS dispute_amount,
        ROUND(SUM(net_revenue), 2) AS net_revenue
    FROM finance.vw_revenue_detail
    GROUP BY invoice_month
),

revenue_with_change AS (
    SELECT
        *,
        LAG(net_revenue) OVER (ORDER BY invoice_month) AS previous_month_net_revenue,
        ROUND(
            AVG(net_revenue) OVER (
                ORDER BY invoice_month
                ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
            ),
            2
        ) AS prior_3_month_avg_net_revenue
    FROM monthly_revenue
)

SELECT
    invoice_month,
    invoice_count,
    unique_customers,
    gross_revenue,
    collected_revenue,
    refund_amount,
    dispute_amount,
    net_revenue,
    previous_month_net_revenue,
    prior_3_month_avg_net_revenue,

    CASE
        WHEN previous_month_net_revenue IS NULL OR previous_month_net_revenue = 0 THEN NULL
        ELSE ROUND(
            ((net_revenue - previous_month_net_revenue) / previous_month_net_revenue) * 100,
            2
        )
    END AS net_revenue_mom_change_percent,

    CASE
        WHEN prior_3_month_avg_net_revenue IS NULL THEN 'Insufficient History'
        WHEN net_revenue >= prior_3_month_avg_net_revenue * 1.12 THEN 'Positive Revenue Spike'
        WHEN net_revenue <= prior_3_month_avg_net_revenue * 0.88 THEN 'Negative Revenue Drop'
        ELSE 'Normal Revenue Movement'
    END AS revenue_anomaly_flag

FROM revenue_with_change;

CREATE OR REPLACE VIEW finance.vw_customer_revenue_risk AS
SELECT
    customer_id,
    customer_name,
    customer_type,
    industry,
    region,
    state,
    acquisition_channel,
    customer_status,

    COUNT(DISTINCT subscription_id) AS subscription_count,
    COUNT(DISTINCT invoice_id) AS invoice_count,

    ROUND(SUM(invoice_amount), 2) AS gross_revenue,
    ROUND(SUM(total_paid_amount), 2) AS collected_revenue,
    ROUND(SUM(total_refund_amount), 2) AS total_refunds,
    ROUND(SUM(total_dispute_amount), 2) AS total_disputes,
    ROUND(SUM(net_revenue), 2) AS net_revenue,

    COUNT(*) FILTER (WHERE invoice_status = 'Overdue') AS overdue_invoice_count,
    COUNT(*) FILTER (WHERE refund_count > 0) AS refund_invoice_count,
    COUNT(*) FILTER (WHERE dispute_count > 0) AS dispute_invoice_count,
    COUNT(*) FILTER (WHERE paid_late_flag = TRUE) AS late_payment_count,

    ROUND(
        (SUM(total_refund_amount) / NULLIF(SUM(invoice_amount), 0)) * 100,
        2
    ) AS refund_rate_percent,

    ROUND(
        (SUM(total_dispute_amount) / NULLIF(SUM(invoice_amount), 0)) * 100,
        2
    ) AS dispute_rate_percent,

    CASE
        WHEN COUNT(*) FILTER (WHERE invoice_status = 'Overdue') >= 3
          OR SUM(total_dispute_amount) > 25000
          OR (SUM(total_refund_amount) / NULLIF(SUM(invoice_amount), 0)) >= 0.20
            THEN 'High Financial Risk'
        WHEN COUNT(*) FILTER (WHERE invoice_status = 'Overdue') >= 1
          OR SUM(total_dispute_amount) > 5000
          OR (SUM(total_refund_amount) / NULLIF(SUM(invoice_amount), 0)) >= 0.10
            THEN 'Moderate Financial Risk'
        ELSE 'Low Financial Risk'
    END AS customer_financial_risk_status,

    DENSE_RANK() OVER (
        ORDER BY SUM(net_revenue) DESC
    ) AS net_revenue_rank

FROM finance.vw_revenue_detail
GROUP BY
    customer_id,
    customer_name,
    customer_type,
    industry,
    region,
    state,
    acquisition_channel,
    customer_status;

CREATE OR REPLACE VIEW finance.vw_refund_dispute_risk AS
SELECT
    customer_id,
    customer_name,
    customer_type,
    industry,
    region,

    COUNT(DISTINCT invoice_id) AS invoice_count,
    ROUND(SUM(invoice_amount), 2) AS gross_revenue,
    ROUND(SUM(total_refund_amount), 2) AS refund_amount,
    ROUND(SUM(total_dispute_amount), 2) AS dispute_amount,

    COUNT(*) FILTER (WHERE refund_count > 0) AS refund_invoice_count,
    COUNT(*) FILTER (WHERE dispute_count > 0) AS dispute_invoice_count,

    ROUND(
        (SUM(total_refund_amount) / NULLIF(SUM(invoice_amount), 0)) * 100,
        2
    ) AS refund_rate_percent,

    ROUND(
        (SUM(total_dispute_amount) / NULLIF(SUM(invoice_amount), 0)) * 100,
        2
    ) AS dispute_rate_percent,

    ROUND(
        ((SUM(total_refund_amount) + SUM(total_dispute_amount)) / NULLIF(SUM(invoice_amount), 0)) * 100,
        2
    ) AS total_revenue_exposure_percent,

    CASE
        WHEN ((SUM(total_refund_amount) + SUM(total_dispute_amount)) / NULLIF(SUM(invoice_amount), 0)) >= 0.25
            THEN 'High Exposure'
        WHEN ((SUM(total_refund_amount) + SUM(total_dispute_amount)) / NULLIF(SUM(invoice_amount), 0)) >= 0.12
            THEN 'Moderate Exposure'
        ELSE 'Low Exposure'
    END AS refund_dispute_risk_status

FROM finance.vw_revenue_detail
GROUP BY
    customer_id,
    customer_name,
    customer_type,
    industry,
    region
HAVING
    SUM(total_refund_amount) > 0
    OR SUM(total_dispute_amount) > 0;

CREATE OR REPLACE VIEW finance.vw_subscription_renewal_risk AS
SELECT
    s.subscription_id,
    s.customer_id,
    c.customer_name,
    c.customer_type,
    c.industry,
    c.region,
    c.customer_status,

    s.plan_name,
    s.billing_frequency,
    s.monthly_recurring_revenue,
    s.contract_start_date,
    s.contract_end_date,
    s.subscription_status,
    s.auto_renew,

    s.contract_end_date - CURRENT_DATE AS days_until_contract_end,

    COUNT(DISTINCT i.invoice_id) AS invoice_count,
    COUNT(DISTINCT i.invoice_id) FILTER (WHERE i.invoice_status = 'Overdue') AS overdue_invoice_count,
    ROUND(SUM(i.invoice_amount), 2) AS subscription_gross_revenue,
    ROUND(SUM(rd.net_revenue), 2) AS subscription_net_revenue,
    ROUND(SUM(rd.total_refund_amount), 2) AS subscription_refunds,
    ROUND(SUM(rd.total_dispute_amount), 2) AS subscription_disputes,

    CASE
        WHEN s.subscription_status IN ('Cancelled','Expired') THEN 'Lost Or Expired'
        WHEN s.contract_end_date <= CURRENT_DATE + INTERVAL '60 days'
             AND COUNT(DISTINCT i.invoice_id) FILTER (WHERE i.invoice_status = 'Overdue') >= 2
            THEN 'High Renewal Risk'
        WHEN s.contract_end_date <= CURRENT_DATE + INTERVAL '90 days'
             OR COUNT(DISTINCT i.invoice_id) FILTER (WHERE i.invoice_status = 'Overdue') >= 1
             OR s.auto_renew = FALSE
            THEN 'Monitor Renewal'
        ELSE 'Low Renewal Risk'
    END AS renewal_risk_status

FROM finance.subscriptions s
JOIN finance.customers c
    ON s.customer_id = c.customer_id
LEFT JOIN finance.invoices i
    ON s.subscription_id = i.subscription_id
LEFT JOIN finance.vw_revenue_detail rd
    ON i.invoice_id = rd.invoice_id
GROUP BY
    s.subscription_id,
    s.customer_id,
    c.customer_name,
    c.customer_type,
    c.industry,
    c.region,
    c.customer_status,
    s.plan_name,
    s.billing_frequency,
    s.monthly_recurring_revenue,
    s.contract_start_date,
    s.contract_end_date,
    s.subscription_status,
    s.auto_renew;

CREATE OR REPLACE VIEW finance.vw_duplicate_payment_detection AS
WITH duplicate_candidates AS (
    SELECT
        p.payment_id,
        p.invoice_id,
        i.customer_id,
        c.customer_name,
        p.payment_date,
        p.payment_amount,
        p.payment_processor,
        p.transaction_reference,

        COUNT(*) OVER (
            PARTITION BY
                p.invoice_id,
                p.payment_date,
                p.payment_amount,
                p.payment_processor
        ) AS duplicate_payment_count,

        SUM(p.payment_amount) OVER (
            PARTITION BY
                p.invoice_id,
                p.payment_date,
                p.payment_amount,
                p.payment_processor
        ) AS duplicate_payment_total_amount

    FROM finance.payments p
    JOIN finance.invoices i
        ON p.invoice_id = i.invoice_id
    JOIN finance.customers c
        ON i.customer_id = c.customer_id
    WHERE p.payment_status = 'Successful'
)

SELECT
    payment_id,
    invoice_id,
    customer_id,
    customer_name,
    payment_date,
    payment_amount,
    payment_processor,
    transaction_reference,
    duplicate_payment_count,
    duplicate_payment_total_amount,

    CASE
        WHEN duplicate_payment_count >= 2 THEN 'Potential Duplicate Payment'
        ELSE 'No Duplicate Detected'
    END AS duplicate_payment_flag

FROM duplicate_candidates
WHERE duplicate_payment_count >= 2;

CREATE OR REPLACE VIEW finance.vw_financial_validation_summary AS
WITH validation_checks AS (
    SELECT
        'Customer Count' AS metric_name,
        (SELECT COUNT(*)::numeric FROM finance.customers) AS raw_database_value,
        (SELECT COUNT(DISTINCT customer_id)::numeric FROM finance.vw_revenue_detail) AS reporting_view_value,
        'Review expected if some customers have no invoice activity' AS validation_note

    UNION ALL

    SELECT
        'Subscription Count',
        (SELECT COUNT(*)::numeric FROM finance.subscriptions),
        (SELECT COUNT(DISTINCT subscription_id)::numeric FROM finance.vw_revenue_detail),
        'Review expected if some subscriptions have no invoice activity'

    UNION ALL

    SELECT
        'Invoice Count',
        (SELECT COUNT(*)::numeric FROM finance.invoices),
        (SELECT COUNT(*)::numeric FROM finance.vw_revenue_detail),
        'Should match invoice level reporting view'

    UNION ALL

    SELECT
        'Payment Count',
        (SELECT COUNT(*)::numeric FROM finance.payments),
        (SELECT SUM(payment_count)::numeric FROM finance.vw_revenue_detail),
        'Should match total payments aggregated to invoices'

    UNION ALL

    SELECT
        'Refund Count',
        (SELECT COUNT(*)::numeric FROM finance.refunds),
        (SELECT SUM(refund_count)::numeric FROM finance.vw_revenue_detail),
        'Should match total refunds aggregated to invoices'

    UNION ALL

    SELECT
        'Dispute Count',
        (SELECT COUNT(*)::numeric FROM finance.payment_disputes),
        (SELECT SUM(dispute_count)::numeric FROM finance.vw_revenue_detail),
        'Should match total disputes aggregated to invoices'
)

SELECT
    metric_name,
    raw_database_value,
    reporting_view_value,
    raw_database_value - reporting_view_value AS difference,
    CASE
        WHEN raw_database_value = reporting_view_value THEN 'Pass'
        ELSE 'Review'
    END AS validation_status,
    validation_note
FROM validation_checks;
