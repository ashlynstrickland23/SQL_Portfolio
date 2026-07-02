DROP SCHEMA IF EXISTS retail CASCADE;

CREATE SCHEMA retail;

CREATE TABLE retail.customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    city TEXT,
    state TEXT,
    region TEXT,
    customer_segment TEXT,
    loyalty_tier TEXT,
    acquisition_channel TEXT,
    signup_date DATE,
    is_active BOOLEAN
);

CREATE TABLE retail.suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name TEXT NOT NULL,
    supplier_region TEXT,
    average_lead_time_days INT,
    supplier_rating NUMERIC(3,2)
);

CREATE TABLE retail.warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    warehouse_name TEXT NOT NULL,
    city TEXT,
    state TEXT,
    region TEXT
);

CREATE TABLE retail.products (
    product_id SERIAL PRIMARY KEY,
    sku TEXT NOT NULL,
    product_name TEXT NOT NULL,
    brand TEXT,
    category TEXT,
    subcategory TEXT,
    supplier_id INT REFERENCES retail.suppliers(supplier_id),
    list_price NUMERIC(10,2),
    unit_cost NUMERIC(10,2),
    is_active BOOLEAN
);

CREATE TABLE retail.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES retail.customers(customer_id),
    warehouse_id INT REFERENCES retail.warehouses(warehouse_id),
    order_date DATE,
    ship_date DATE,
    delivery_date DATE,
    order_status TEXT,
    sales_channel TEXT,
    payment_method TEXT,
    order_priority TEXT,
    promo_code TEXT,
    shipping_method TEXT,
    shipping_cost NUMERIC(10,2)
);

CREATE TABLE retail.order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES retail.orders(order_id),
    product_id INT REFERENCES retail.products(product_id),
    quantity INT,
    unit_price NUMERIC(10,2),
    unit_cost NUMERIC(10,2),
    discount_amount NUMERIC(10,2)
);

CREATE TABLE retail.returns (
    return_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES retail.orders(order_id),
    return_date DATE,
    return_reason TEXT,
    refund_amount NUMERIC(10,2)
);

INSERT INTO retail.suppliers (
    supplier_name,
    supplier_region,
    average_lead_time_days,
    supplier_rating
)
SELECT
    'Supplier ' || gs,
    (ARRAY['Northeast','Southeast','Midwest','Southwest','West'])[(floor(random() * 5) + 1)::int],
    (floor(random() * 20) + 3)::int,
    round((3 + random() * 2)::numeric, 2)
FROM generate_series(1, 20) gs;

INSERT INTO retail.warehouses (
    warehouse_name,
    city,
    state,
    region
)
VALUES
('Nashville Distribution Center', 'Nashville', 'TN', 'Southeast'),
('Orlando Fulfillment Center', 'Orlando', 'FL', 'Southeast'),
('Dallas Regional Warehouse', 'Dallas', 'TX', 'Southwest'),
('Chicago Logistics Hub', 'Chicago', 'IL', 'Midwest'),
('Phoenix Distribution Center', 'Phoenix', 'AZ', 'West'),
('Denver Fulfillment Center', 'Denver', 'CO', 'West'),
('Atlanta Regional Warehouse', 'Atlanta', 'GA', 'Southeast'),
('Charlotte Logistics Hub', 'Charlotte', 'NC', 'Southeast');

INSERT INTO retail.customers (
    customer_name,
    email,
    phone,
    city,
    state,
    region,
    customer_segment,
    loyalty_tier,
    acquisition_channel,
    signup_date,
    is_active
)
SELECT
    'Customer ' || gs AS customer_name,
    'customer' || gs || '@example.com' AS email,
    '555-' || lpad((floor(random() * 10000000))::text, 7, '0') AS phone,
    location.city,
    location.state,
    location.region,
    (ARRAY['Consumer','Small Business','Corporate','Enterprise'])[(floor(random() * 4) + 1)::int] AS customer_segment,
    (ARRAY['Bronze','Silver','Gold','Platinum'])[(floor(random() * 4) + 1)::int] AS loyalty_tier,
    (ARRAY['Paid Search','Organic Search','Social Media','Email Campaign','Referral','Direct'])[(floor(random() * 6) + 1)::int] AS acquisition_channel,
    DATE '2023-01-01' + (floor(random() * 900))::int AS signup_date,
    CASE WHEN random() < 0.92 THEN TRUE ELSE FALSE END AS is_active
FROM generate_series(1, 5000) gs
CROSS JOIN LATERAL (
    SELECT *
    FROM (
        VALUES
        ('Nashville', 'TN', 'Southeast'),
        ('Orlando', 'FL', 'Southeast'),
        ('Tampa', 'FL', 'Southeast'),
        ('Atlanta', 'GA', 'Southeast'),
        ('Dallas', 'TX', 'Southwest'),
        ('Austin', 'TX', 'Southwest'),
        ('Charlotte', 'NC', 'Southeast'),
        ('Raleigh', 'NC', 'Southeast'),
        ('Chicago', 'IL', 'Midwest'),
        ('Denver', 'CO', 'West'),
        ('Phoenix', 'AZ', 'West'),
        ('Miami', 'FL', 'Southeast')
    ) AS locations(city, state, region)
    ORDER BY random()
    LIMIT 1
) location;

INSERT INTO retail.products (
    sku,
    product_name,
    brand,
    category,
    subcategory,
    supplier_id,
    list_price,
    unit_cost,
    is_active
)
SELECT
    'SKU-' || lpad(gs::text, 5, '0') AS sku,
    'Product ' || gs AS product_name,
    (ARRAY['Northline','EverPro','MetroGoods','SummitCo','BluePeak','PrimeWorks'])[(floor(random() * 6) + 1)::int] AS brand,
    (ARRAY['Technology','Furniture','Office Supplies','Home Goods','Outdoor','Accessories'])[(floor(random() * 6) + 1)::int] AS category,
    (ARRAY['Premium','Standard','Budget','Seasonal','Commercial'])[(floor(random() * 5) + 1)::int] AS subcategory,
    (floor(random() * 20) + 1)::int AS supplier_id,
    round((10 + random() * 990)::numeric, 2) AS list_price,
    round((5 + random() * 500)::numeric, 2) AS unit_cost,
    CASE WHEN random() < 0.95 THEN TRUE ELSE FALSE END AS is_active
FROM generate_series(1, 100) gs;

INSERT INTO retail.orders (
    customer_id,
    warehouse_id,
    order_date,
    ship_date,
    delivery_date,
    order_status,
    sales_channel,
    payment_method,
    order_priority,
    promo_code,
    shipping_method,
    shipping_cost
)
SELECT
    (floor(random() * 5000) + 1)::int AS customer_id,
    (floor(random() * 8) + 1)::int AS warehouse_id,
    order_date,
    order_date + (floor(random() * 4) + 1)::int AS ship_date,
    order_date + (floor(random() * 8) + 3)::int AS delivery_date,
    (ARRAY['Completed','Completed','Completed','Completed','Completed','Cancelled','Returned'])[(floor(random() * 7) + 1)::int] AS order_status,
    (ARRAY['Online','Retail Store','Partner','Wholesale','Marketplace'])[(floor(random() * 5) + 1)::int] AS sales_channel,
    (ARRAY['Credit Card','ACH','PayPal','Invoice','Gift Card'])[(floor(random() * 5) + 1)::int] AS payment_method,
    (ARRAY['Low','Medium','High','Urgent'])[(floor(random() * 4) + 1)::int] AS order_priority,
    (ARRAY['NONE','SAVE10','WELCOME15','FREESHIP','VIP20'])[(floor(random() * 5) + 1)::int] AS promo_code,
    (ARRAY['Standard','Two Day','Overnight','Freight'])[(floor(random() * 4) + 1)::int] AS shipping_method,
    round((5 + random() * 45)::numeric, 2) AS shipping_cost
FROM (
    SELECT 
        DATE '2024-01-01' + (floor(random() * 545))::int AS order_date
    FROM generate_series(1, 50000)
) d;

INSERT INTO retail.order_items (
    order_id,
    product_id,
    quantity,
    unit_price,
    unit_cost,
    discount_amount
)
SELECT
    o.order_id,
    p.product_id,
    (floor(random() * 5) + 1)::int AS quantity,
    p.list_price AS unit_price,
    p.unit_cost AS unit_cost,
    round((random() * 25)::numeric, 2) AS discount_amount
FROM retail.orders o
CROSS JOIN LATERAL generate_series(
    1,
    (floor(random() * 3 + o.order_id * 0) + 1)::int
) AS item_number
JOIN retail.products p
    ON p.product_id = (floor(random() * 100 + o.order_id * 0 + item_number * 0) + 1)::int;

INSERT INTO retail.returns (
    order_id,
    return_date,
    return_reason,
    refund_amount
)
SELECT
    o.order_id,
    o.delivery_date + (floor(random() * 20) + 1)::int AS return_date,
    (ARRAY['Damaged Item','Wrong Item','Customer Changed Mind','Late Delivery','Quality Issue'])[(floor(random() * 5) + 1)::int] AS return_reason,
    round((20 + random() * 500)::numeric, 2) AS refund_amount
FROM retail.orders o
WHERE o.order_status = 'Returned'
   OR random() < 0.04;

CREATE OR REPLACE VIEW retail.vw_order_detail AS
SELECT
    o.order_id,
    oi.order_item_id,
    o.order_date,
    DATE_TRUNC('month', o.order_date)::date AS order_month,
    o.ship_date,
    o.delivery_date,
    o.order_status,
    o.sales_channel,
    o.payment_method,
    o.order_priority,
    o.promo_code,
    o.shipping_method,
    o.shipping_cost,

    c.customer_id,
    c.customer_name,
    c.city AS customer_city,
    c.state AS customer_state,
    c.region AS customer_region,
    c.customer_segment,
    c.loyalty_tier,
    c.acquisition_channel,
    c.signup_date,
    c.is_active AS customer_is_active,

    p.product_id,
    p.sku,
    p.product_name,
    p.brand,
    p.category,
    p.subcategory,

    s.supplier_id,
    s.supplier_name,
    s.supplier_region,

    w.warehouse_id,
    w.warehouse_name,
    w.city AS warehouse_city,
    w.state AS warehouse_state,
    w.region AS warehouse_region,

    oi.quantity,
    oi.unit_price,
    oi.unit_cost,
    oi.discount_amount,

    ROUND(oi.quantity * oi.unit_price, 2) AS gross_sales,
    ROUND((oi.quantity * oi.unit_price) - oi.discount_amount, 2) AS net_sales,
    ROUND(oi.quantity * oi.unit_cost, 2) AS total_cost,
    ROUND(((oi.quantity * oi.unit_price) - oi.discount_amount) - (oi.quantity * oi.unit_cost), 2) AS profit,

    CASE 
        WHEN ((oi.quantity * oi.unit_price) - oi.discount_amount) = 0 THEN NULL
        ELSE ROUND(
            (
                (((oi.quantity * oi.unit_price) - oi.discount_amount) - (oi.quantity * oi.unit_cost))
                / ((oi.quantity * oi.unit_price) - oi.discount_amount)
            ) * 100,
            2
        )
    END AS profit_margin_percent,

    CASE 
        WHEN rt.return_id IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS is_returned,

    rt.return_reason
FROM retail.order_items oi
JOIN retail.orders o
    ON oi.order_id = o.order_id
JOIN retail.customers c
    ON o.customer_id = c.customer_id
JOIN retail.products p
    ON oi.product_id = p.product_id
LEFT JOIN retail.suppliers s
    ON p.supplier_id = s.supplier_id
LEFT JOIN retail.warehouses w
    ON o.warehouse_id = w.warehouse_id
LEFT JOIN retail.returns rt
    ON o.order_id = rt.order_id;

CREATE OR REPLACE VIEW retail.vw_customer_segmentation AS
WITH order_level AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        order_status,
        BOOL_OR(is_returned) AS is_returned,
        SUM(net_sales) AS order_net_sales,
        SUM(profit) AS order_profit
    FROM retail.vw_order_detail
    GROUP BY
        customer_id,
        order_id,
        order_date,
        order_status
),

customer_metrics AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        c.state,
        c.region,
        c.customer_segment,
        c.loyalty_tier,
        c.acquisition_channel,
        c.signup_date,
        c.is_active,

        COUNT(ol.order_id) AS total_orders,
        COUNT(ol.order_id) FILTER (WHERE ol.order_status = 'Completed') AS completed_orders,
        COUNT(ol.order_id) FILTER (WHERE ol.is_returned = TRUE) AS returned_orders,

        ROUND(
            COALESCE(SUM(ol.order_net_sales) FILTER (WHERE ol.order_status = 'Completed'), 0),
            2
        ) AS lifetime_revenue,

        ROUND(
            COALESCE(SUM(ol.order_profit) FILTER (WHERE ol.order_status = 'Completed'), 0),
            2
        ) AS lifetime_profit,

        ROUND(
            COALESCE(AVG(ol.order_net_sales) FILTER (WHERE ol.order_status = 'Completed'), 0),
            2
        ) AS average_order_value,

        MIN(ol.order_date) AS first_order_date,
        MAX(ol.order_date) AS last_order_date,

        (
            (SELECT MAX(order_date) FROM retail.orders) - MAX(ol.order_date)
        ) AS days_since_last_order
    FROM retail.customers c
    LEFT JOIN order_level ol
        ON c.customer_id = ol.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name,
        c.city,
        c.state,
        c.region,
        c.customer_segment,
        c.loyalty_tier,
        c.acquisition_channel,
        c.signup_date,
        c.is_active
),

rfm_scoring AS (
    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY days_since_last_order DESC NULLS FIRST
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY completed_orders ASC
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY lifetime_revenue ASC
        ) AS monetary_score
    FROM customer_metrics
)

SELECT
    *,
    recency_score + frequency_score + monetary_score AS rfm_total_score,

    CASE
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4
            THEN 'Champions'
        WHEN recency_score >= 4 AND frequency_score >= 3
            THEN 'Loyal Customers'
        WHEN recency_score <= 2 AND monetary_score >= 4
            THEN 'At Risk High Value'
        WHEN recency_score <= 2 AND frequency_score <= 2
            THEN 'Inactive Customers'
        WHEN monetary_score >= 4
            THEN 'High Value Customers'
        WHEN frequency_score >= 4
            THEN 'Frequent Buyers'
        ELSE 'Standard Customers'
    END AS rfm_customer_group
FROM rfm_scoring;

CREATE OR REPLACE VIEW retail.vw_monthly_sales_trends AS
WITH monthly_sales AS (
    SELECT
        order_month,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT customer_id) AS unique_customers,
        ROUND(SUM(net_sales), 2) AS total_revenue,
        ROUND(SUM(profit), 2) AS total_profit,
        ROUND(AVG(net_sales), 2) AS average_item_revenue
    FROM retail.vw_order_detail
    WHERE order_status = 'Completed'
    GROUP BY order_month
),

monthly_with_previous AS (
    SELECT
        *,
        LAG(total_revenue) OVER (ORDER BY order_month) AS previous_month_revenue,
        LAG(total_profit) OVER (ORDER BY order_month) AS previous_month_profit
    FROM monthly_sales
)

SELECT
    order_month,
    total_orders,
    unique_customers,
    total_revenue,
    total_profit,
    average_item_revenue,
    previous_month_revenue,

    CASE
        WHEN previous_month_revenue IS NULL OR previous_month_revenue = 0 THEN NULL
        ELSE ROUND(
            ((total_revenue - previous_month_revenue) / previous_month_revenue) * 100,
            2
        )
    END AS revenue_mom_growth_percent,

    CASE
        WHEN previous_month_profit IS NULL OR previous_month_profit = 0 THEN NULL
        ELSE ROUND(
            ((total_profit - previous_month_profit) / previous_month_profit) * 100,
            2
        )
    END AS profit_mom_growth_percent

FROM monthly_with_previous;

CREATE OR REPLACE VIEW retail.vw_product_profitability AS
WITH product_sales AS (
    SELECT
        product_id,
        sku,
        product_name,
        brand,
        category,
        subcategory,

        COUNT(*) AS total_order_lines,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT customer_id) AS unique_customers,
        SUM(quantity) AS total_units_sold,

        ROUND(SUM(gross_sales), 2) AS gross_sales,
        ROUND(SUM(discount_amount), 2) AS total_discounts,
        ROUND(SUM(net_sales), 2) AS net_sales,
        ROUND(SUM(total_cost), 2) AS total_cost,
        ROUND(SUM(profit), 2) AS profit,

        COUNT(*) FILTER (WHERE is_returned = TRUE) AS returned_order_lines
    FROM retail.vw_order_detail
    WHERE order_status = 'Completed'
    GROUP BY
        product_id,
        sku,
        product_name,
        brand,
        category,
        subcategory
)

SELECT
    *,
    ROUND((profit / NULLIF(net_sales, 0)) * 100, 2) AS profit_margin_percent,
    ROUND((returned_order_lines::numeric / NULLIF(total_order_lines, 0)) * 100, 2) AS return_rate_percent,

    DENSE_RANK() OVER (ORDER BY net_sales DESC) AS revenue_rank,
    DENSE_RANK() OVER (ORDER BY profit DESC) AS profit_rank,
    DENSE_RANK() OVER (ORDER BY returned_order_lines DESC) AS return_volume_rank

FROM product_sales;

CREATE OR REPLACE VIEW retail.vw_customer_cohort_retention AS
WITH completed_customer_months AS (
    SELECT DISTINCT
        customer_id,
        order_month
    FROM retail.vw_order_detail
    WHERE order_status = 'Completed'
),

customer_cohorts AS (
    SELECT
        customer_id,
        MIN(order_month) AS cohort_month
    FROM completed_customer_months
    GROUP BY customer_id
),

cohort_activity AS (
    SELECT
        cc.cohort_month,
        ccm.order_month AS activity_month,
        (
            (DATE_PART('year', ccm.order_month)::int - DATE_PART('year', cc.cohort_month)::int) * 12
            +
            (DATE_PART('month', ccm.order_month)::int - DATE_PART('month', cc.cohort_month)::int)
        ) AS months_since_first_order,
        ccm.customer_id
    FROM completed_customer_months ccm
    JOIN customer_cohorts cc
        ON ccm.customer_id = cc.customer_id
),

cohort_counts AS (
    SELECT
        cohort_month,
        activity_month,
        months_since_first_order,
        COUNT(DISTINCT customer_id) AS retained_customers
    FROM cohort_activity
    GROUP BY
        cohort_month,
        activity_month,
        months_since_first_order
),

cohort_sizes AS (
    SELECT
        cohort_month,
        retained_customers AS cohort_size
    FROM cohort_counts
    WHERE months_since_first_order = 0
)

SELECT
    cc.cohort_month,
    cc.activity_month,
    cc.months_since_first_order,
    cs.cohort_size,
    cc.retained_customers,
    ROUND(
        (cc.retained_customers::numeric / NULLIF(cs.cohort_size, 0)) * 100,
        2
    ) AS retention_rate_percent
FROM cohort_counts cc
JOIN cohort_sizes cs
    ON cc.cohort_month = cs.cohort_month;

CREATE OR REPLACE VIEW retail.vw_rfm_segment_summary AS
SELECT
    rfm_customer_group,

    COUNT(*) AS customer_count,
    COUNT(*) FILTER (WHERE is_active = TRUE) AS active_customer_count,
    COUNT(*) FILTER (WHERE is_active = FALSE) AS inactive_customer_count,

    SUM(total_orders) AS total_orders,
    SUM(completed_orders) AS completed_orders,
    SUM(returned_orders) AS returned_orders,

    ROUND(SUM(lifetime_revenue), 2) AS total_revenue,
    ROUND(SUM(lifetime_profit), 2) AS total_profit,
    ROUND(AVG(lifetime_revenue), 2) AS avg_lifetime_revenue,
    ROUND(AVG(average_order_value), 2) AS avg_order_value,

    ROUND(AVG(days_since_last_order), 2) AS avg_days_since_last_order,

    ROUND(
        (SUM(returned_orders)::numeric / NULLIF(SUM(total_orders), 0)) * 100,
        2
    ) AS return_rate_percent,

    DENSE_RANK() OVER (
        ORDER BY SUM(lifetime_revenue) DESC
    ) AS revenue_rank

FROM retail.vw_customer_segmentation
GROUP BY rfm_customer_group;

CREATE OR REPLACE VIEW retail.vw_dashboard_validation_summary AS
WITH validation_checks AS (
    SELECT
        'Customer Count' AS metric_name,
        (SELECT COUNT(*)::numeric FROM retail.customers) AS raw_database_value,
        (SELECT COUNT(*)::numeric FROM retail.vw_customer_segmentation) AS reporting_view_value

    UNION ALL

    SELECT
        'Order Count',
        (SELECT COUNT(*)::numeric FROM retail.orders),
        (SELECT COUNT(DISTINCT order_id)::numeric FROM retail.vw_order_detail)

    UNION ALL

    SELECT
        'Order Item Count',
        (SELECT COUNT(*)::numeric FROM retail.order_items),
        (SELECT COUNT(*)::numeric FROM retail.vw_order_detail)

    UNION ALL

    SELECT
        'Completed Order Count',
        (SELECT COUNT(*)::numeric FROM retail.orders WHERE order_status = 'Completed'),
        (SELECT COUNT(DISTINCT order_id)::numeric FROM retail.vw_order_detail WHERE order_status = 'Completed')

    UNION ALL

    SELECT
        'Return Count',
        (SELECT COUNT(DISTINCT order_id)::numeric FROM retail.returns),
        (SELECT COUNT(DISTINCT order_id)::numeric FROM retail.vw_order_detail WHERE is_returned = TRUE)
)

SELECT
    metric_name,
    raw_database_value,
    reporting_view_value,
    raw_database_value - reporting_view_value AS difference,
    CASE
        WHEN raw_database_value = reporting_view_value THEN 'Pass'
        ELSE 'Review'
    END AS validation_status
FROM validation_checks;
