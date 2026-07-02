DROP SCHEMA IF EXISTS supply_chain CASCADE;

CREATE SCHEMA supply_chain;

CREATE TABLE supply_chain.suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name TEXT NOT NULL,
    supplier_region TEXT,
    supplier_category TEXT,
    average_lead_time_days INT,
    target_on_time_rate NUMERIC(5,2),
    supplier_rating NUMERIC(3,2),
    is_active BOOLEAN
);

CREATE TABLE supply_chain.warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    warehouse_name TEXT NOT NULL,
    city TEXT,
    state TEXT,
    region TEXT,
    capacity_units INT
);

CREATE TABLE supply_chain.products (
    product_id SERIAL PRIMARY KEY,
    sku TEXT NOT NULL,
    product_name TEXT NOT NULL,
    category TEXT,
    subcategory TEXT,
    supplier_id INT REFERENCES supply_chain.suppliers(supplier_id),
    unit_cost NUMERIC(10,2),
    list_price NUMERIC(10,2),
    reorder_point INT,
    safety_stock_units INT,
    target_stock_days INT,
    is_active BOOLEAN
);

CREATE TABLE supply_chain.inventory_snapshots (
    snapshot_id BIGSERIAL PRIMARY KEY,
    snapshot_date DATE,
    product_id INT REFERENCES supply_chain.products(product_id),
    warehouse_id INT REFERENCES supply_chain.warehouses(warehouse_id),
    on_hand_qty INT,
    reserved_qty INT,
    available_qty INT,
    reorder_point INT,
    safety_stock_qty INT,
    unit_cost NUMERIC(10,2),
    inventory_value NUMERIC(14,2),
    days_of_inventory NUMERIC(10,2),
    stock_status TEXT
);

CREATE TABLE supply_chain.purchase_orders (
    purchase_order_id SERIAL PRIMARY KEY,
    supplier_id INT REFERENCES supply_chain.suppliers(supplier_id),
    warehouse_id INT REFERENCES supply_chain.warehouses(warehouse_id),
    order_date DATE,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    po_status TEXT,
    priority TEXT,
    shipping_method TEXT
);

CREATE TABLE supply_chain.purchase_order_items (
    purchase_order_item_id SERIAL PRIMARY KEY,
    purchase_order_id INT REFERENCES supply_chain.purchase_orders(purchase_order_id),
    product_id INT REFERENCES supply_chain.products(product_id),
    quantity_ordered INT,
    quantity_received INT,
    unit_cost NUMERIC(10,2)
);

INSERT INTO supply_chain.suppliers (
    supplier_name,
    supplier_region,
    supplier_category,
    average_lead_time_days,
    target_on_time_rate,
    supplier_rating,
    is_active
)
SELECT
    'Supplier ' || gs AS supplier_name,
    (ARRAY['Northeast','Southeast','Midwest','Southwest','West'])[(floor(random() * 5) + 1)::int] AS supplier_region,
    (ARRAY['Domestic','International','Regional','Specialty'])[(floor(random() * 4) + 1)::int] AS supplier_category,
    (floor(random() * 20) + 5)::int AS average_lead_time_days,
    round((85 + random() * 10)::numeric, 2) AS target_on_time_rate,
    round((3 + random() * 2)::numeric, 2) AS supplier_rating,
    CASE WHEN random() < 0.93 THEN TRUE ELSE FALSE END AS is_active
FROM generate_series(1, 30) gs;

INSERT INTO supply_chain.warehouses (
    warehouse_name,
    city,
    state,
    region,
    capacity_units
)
VALUES
('Nashville Distribution Center', 'Nashville', 'TN', 'Southeast', 120000),
('Orlando Fulfillment Center', 'Orlando', 'FL', 'Southeast', 115000),
('Dallas Regional Warehouse', 'Dallas', 'TX', 'Southwest', 130000),
('Chicago Logistics Hub', 'Chicago', 'IL', 'Midwest', 140000),
('Phoenix Distribution Center', 'Phoenix', 'AZ', 'West', 125000),
('Denver Fulfillment Center', 'Denver', 'CO', 'West', 110000),
('Atlanta Regional Warehouse', 'Atlanta', 'GA', 'Southeast', 135000),
('Charlotte Logistics Hub', 'Charlotte', 'NC', 'Southeast', 145000),
('Columbus Storage Facility', 'Columbus', 'OH', 'Midwest', 105000),
('Jacksonville Import Center', 'Jacksonville', 'FL', 'Southeast', 150000);

INSERT INTO supply_chain.products (
    sku,
    product_name,
    category,
    subcategory,
    supplier_id,
    unit_cost,
    list_price,
    reorder_point,
    safety_stock_units,
    target_stock_days,
    is_active
)
SELECT
    'SKU-' || lpad(gs::text, 5, '0') AS sku,
    'Product ' || gs AS product_name,
    (ARRAY['Raw Materials','Finished Goods','Packaging','Equipment','Replacement Parts'])[(floor(random() * 5) + 1)::int] AS category,
    (ARRAY['Standard','Premium','Seasonal','Critical','Bulk'])[(floor(random() * 5) + 1)::int] AS subcategory,
    ((gs - 1) % 30) + 1 AS supplier_id,
    round((15 + random() * 450)::numeric, 2) AS unit_cost,
    round((30 + random() * 900)::numeric, 2) AS list_price,
    (floor(random() * 300) + 100)::int AS reorder_point,
    (floor(random() * 100) + 50)::int AS safety_stock_units,
    (floor(random() * 90) + 30)::int AS target_stock_days,
    CASE WHEN random() < 0.96 THEN TRUE ELSE FALSE END AS is_active
FROM generate_series(1, 250) gs;

INSERT INTO supply_chain.inventory_snapshots (
    snapshot_date,
    product_id,
    warehouse_id,
    on_hand_qty,
    reserved_qty,
    available_qty,
    reorder_point,
    safety_stock_qty,
    unit_cost,
    inventory_value,
    days_of_inventory,
    stock_status
)
WITH snapshot_dates AS (
    SELECT generate_series(
        DATE '2025-01-01',
        DATE '2025-06-30',
        INTERVAL '1 day'
    )::date AS snapshot_date
),

base_inventory AS (
    SELECT
        d.snapshot_date,
        p.product_id,
        w.warehouse_id,
        p.reorder_point,
        p.safety_stock_units,
        p.unit_cost,

        GREATEST(
            0,
            p.reorder_point
            + p.safety_stock_units
            + (floor(random() * 1200) - 300)::int
        ) AS on_hand_qty,

        (floor(random() * 150))::int AS reserved_qty,

        round((10 + random() * 220)::numeric, 2) AS days_of_inventory
    FROM snapshot_dates d
    CROSS JOIN supply_chain.products p
    CROSS JOIN supply_chain.warehouses w
),

calculated_inventory AS (
    SELECT
        snapshot_date,
        product_id,
        warehouse_id,
        on_hand_qty,
        reserved_qty,
        GREATEST(on_hand_qty - reserved_qty, 0) AS available_qty,
        reorder_point,
        safety_stock_units,
        unit_cost,
        round((GREATEST(on_hand_qty - reserved_qty, 0) * unit_cost)::numeric, 2) AS inventory_value,
        days_of_inventory
    FROM base_inventory
)

SELECT
    snapshot_date,
    product_id,
    warehouse_id,
    on_hand_qty,
    reserved_qty,
    available_qty,
    reorder_point,
    safety_stock_units AS safety_stock_qty,
    unit_cost,
    inventory_value,
    days_of_inventory,

    CASE
        WHEN available_qty <= safety_stock_units THEN 'Critical Stock'
        WHEN available_qty <= reorder_point THEN 'Reorder Needed'
        WHEN days_of_inventory >= 150 THEN 'Overstock'
        ELSE 'Healthy'
    END AS stock_status

FROM calculated_inventory;

INSERT INTO supply_chain.purchase_orders (
    supplier_id,
    warehouse_id,
    order_date,
    expected_delivery_date,
    actual_delivery_date,
    po_status,
    priority,
    shipping_method
)
WITH base_orders AS (
    SELECT
        (floor(random() * 30) + 1)::int AS supplier_id,
        (floor(random() * 10) + 1)::int AS warehouse_id,
        DATE '2025-01-01' + (floor(random() * 181))::int AS order_date,
        (ARRAY['Low','Medium','High','Urgent'])[(floor(random() * 4) + 1)::int] AS priority,
        (ARRAY['Standard Freight','Expedited Freight','Ground','Air','Ocean'])[(floor(random() * 5) + 1)::int] AS shipping_method,
        random() AS status_random
    FROM generate_series(1, 20000)
),

delivery_logic AS (
    SELECT
        b.supplier_id,
        b.warehouse_id,
        b.order_date,
        b.priority,
        b.shipping_method,
        b.status_random,
        s.average_lead_time_days,
        (floor(random() * 18) - 5)::int AS delivery_variance_days
    FROM base_orders b
    JOIN supply_chain.suppliers s
        ON b.supplier_id = s.supplier_id
)

SELECT
    supplier_id,
    warehouse_id,
    order_date,
    order_date + average_lead_time_days AS expected_delivery_date,

    CASE
        WHEN status_random < 0.04 THEN NULL
        WHEN status_random < 0.10 THEN NULL
        ELSE order_date + average_lead_time_days + delivery_variance_days
    END AS actual_delivery_date,

    CASE
        WHEN status_random < 0.04 THEN 'Cancelled'
        WHEN status_random < 0.10 THEN 'Open'
        WHEN delivery_variance_days > 0 THEN 'Delivered Late'
        ELSE 'Delivered'
    END AS po_status,

    priority,
    shipping_method
FROM delivery_logic;

INSERT INTO supply_chain.purchase_order_items (
    purchase_order_id,
    product_id,
    quantity_ordered,
    quantity_received,
    unit_cost
)
WITH po_lines AS (
    SELECT
        po.purchase_order_id,
        po.supplier_id,
        po.po_status,
        p.product_id,
        p.unit_cost,
        (floor(random() * 450) + 50)::int AS quantity_ordered,
        random() AS fill_random
    FROM supply_chain.purchase_orders po
    CROSS JOIN LATERAL generate_series(
        1,
        (floor(random() * 4 + po.purchase_order_id * 0) + 1)::int
    ) AS line_number
    JOIN LATERAL (
        SELECT
            product_id,
            unit_cost
        FROM supply_chain.products p
        WHERE p.supplier_id = po.supplier_id
        ORDER BY random()
        LIMIT 1
    ) p ON TRUE
)

SELECT
    purchase_order_id,
    product_id,
    quantity_ordered,

    CASE
        WHEN po_status = 'Cancelled' THEN 0
        WHEN po_status = 'Open' THEN 0
        ELSE floor(quantity_ordered * (0.75 + fill_random * 0.25))::int
    END AS quantity_received,

    unit_cost
FROM po_lines;

CREATE OR REPLACE VIEW supply_chain.vw_purchase_order_delivery_analysis AS
SELECT
    po.purchase_order_id,
    po.order_date,
    DATE_TRUNC('month', po.order_date)::date AS order_month,
    po.expected_delivery_date,
    po.actual_delivery_date,
    po.po_status,
    po.priority,
    po.shipping_method,

    s.supplier_id,
    s.supplier_name,
    s.supplier_region,
    s.supplier_category,
    s.average_lead_time_days,
    s.supplier_rating,

    w.warehouse_id,
    w.warehouse_name,
    w.city AS warehouse_city,
    w.state AS warehouse_state,
    w.region AS warehouse_region,

    COUNT(poi.purchase_order_item_id) AS line_item_count,
    SUM(poi.quantity_ordered) AS total_quantity_ordered,
    SUM(poi.quantity_received) AS total_quantity_received,

    ROUND(SUM(poi.quantity_ordered * poi.unit_cost), 2) AS total_po_value,
    ROUND(SUM(poi.quantity_received * poi.unit_cost), 2) AS received_value,

    ROUND(
        (SUM(poi.quantity_received)::numeric / NULLIF(SUM(poi.quantity_ordered), 0)) * 100,
        2
    ) AS fill_rate_percent,

    CASE
        WHEN po.actual_delivery_date IS NULL THEN NULL
        ELSE po.actual_delivery_date - po.expected_delivery_date
    END AS days_late,

    CASE
        WHEN po.po_status = 'Cancelled' THEN 'Cancelled'
        WHEN po.actual_delivery_date IS NULL THEN 'Not Delivered'
        WHEN po.actual_delivery_date <= po.expected_delivery_date THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,

    CASE
        WHEN po.po_status = 'Cancelled' THEN 'Cancelled'
        WHEN po.actual_delivery_date IS NULL THEN 'Open Risk'
        WHEN po.actual_delivery_date - po.expected_delivery_date >= 7 THEN 'High Delay Risk'
        WHEN po.actual_delivery_date - po.expected_delivery_date BETWEEN 1 AND 6 THEN 'Moderate Delay Risk'
        ELSE 'Low Risk'
    END AS delivery_risk_category

FROM supply_chain.purchase_orders po
JOIN supply_chain.suppliers s
    ON po.supplier_id = s.supplier_id
JOIN supply_chain.warehouses w
    ON po.warehouse_id = w.warehouse_id
LEFT JOIN supply_chain.purchase_order_items poi
    ON po.purchase_order_id = poi.purchase_order_id
GROUP BY
    po.purchase_order_id,
    po.order_date,
    po.expected_delivery_date,
    po.actual_delivery_date,
    po.po_status,
    po.priority,
    po.shipping_method,
    s.supplier_id,
    s.supplier_name,
    s.supplier_region,
    s.supplier_category,
    s.average_lead_time_days,
    s.supplier_rating,
    w.warehouse_id,
    w.warehouse_name,
    w.city,
    w.state,
    w.region;

CREATE OR REPLACE VIEW supply_chain.vw_supplier_performance AS
SELECT
    supplier_id,
    supplier_name,
    supplier_region,
    supplier_category,
    average_lead_time_days,
    supplier_rating,

    COUNT(*) AS total_purchase_orders,
    COUNT(*) FILTER (WHERE po_status = 'Delivered') AS delivered_orders,
    COUNT(*) FILTER (WHERE po_status = 'Delivered Late') AS late_orders,
    COUNT(*) FILTER (WHERE po_status = 'Open') AS open_orders,
    COUNT(*) FILTER (WHERE po_status = 'Cancelled') AS cancelled_orders,

    ROUND(SUM(total_po_value), 2) AS total_spend,
    ROUND(AVG(total_po_value), 2) AS avg_po_value,
    ROUND(AVG(fill_rate_percent), 2) AS avg_fill_rate_percent,

    ROUND(
        (
            COUNT(*) FILTER (WHERE delivery_status = 'On Time')::numeric
            / NULLIF(COUNT(*) FILTER (WHERE delivery_status IN ('On Time','Late')), 0)
        ) * 100,
        2
    ) AS on_time_delivery_rate_percent,

    ROUND(
        AVG(days_late) FILTER (WHERE days_late IS NOT NULL),
        2
    ) AS avg_days_late,

    CASE
        WHEN ROUND(
            (
                COUNT(*) FILTER (WHERE delivery_status = 'On Time')::numeric
                / NULLIF(COUNT(*) FILTER (WHERE delivery_status IN ('On Time','Late')), 0)
            ) * 100,
            2
        ) >= 90
        AND AVG(fill_rate_percent) >= 95
            THEN 'Strong Performer'

        WHEN ROUND(
            (
                COUNT(*) FILTER (WHERE delivery_status = 'On Time')::numeric
                / NULLIF(COUNT(*) FILTER (WHERE delivery_status IN ('On Time','Late')), 0)
            ) * 100,
            2
        ) < 75
        OR AVG(fill_rate_percent) < 90
            THEN 'Needs Review'

        ELSE 'Monitor'
    END AS supplier_performance_status

FROM supply_chain.vw_purchase_order_delivery_analysis
GROUP BY
    supplier_id,
    supplier_name,
    supplier_region,
    supplier_category,
    average_lead_time_days,
    supplier_rating;

CREATE OR REPLACE VIEW supply_chain.vw_inventory_health AS
WITH latest_snapshot AS (
    SELECT MAX(snapshot_date) AS latest_snapshot_date
    FROM supply_chain.inventory_snapshots
)

SELECT
    i.snapshot_date,
    i.product_id,
    p.sku,
    p.product_name,
    p.category,
    p.subcategory,

    s.supplier_id,
    s.supplier_name,
    s.supplier_region,

    i.warehouse_id,
    w.warehouse_name,
    w.city AS warehouse_city,
    w.state AS warehouse_state,
    w.region AS warehouse_region,
    w.capacity_units,

    i.on_hand_qty,
    i.reserved_qty,
    i.available_qty,
    i.reorder_point,
    i.safety_stock_qty,
    i.unit_cost,
    i.inventory_value,
    i.days_of_inventory,
    i.stock_status,

    CASE
        WHEN i.stock_status = 'Critical Stock' THEN 100
        WHEN i.stock_status = 'Reorder Needed' THEN 75
        WHEN i.stock_status = 'Overstock' THEN 60
        ELSE 25
    END AS inventory_risk_score,

    CASE
        WHEN i.stock_status IN ('Critical Stock','Reorder Needed') THEN TRUE
        ELSE FALSE
    END AS needs_reorder_review,

    CASE
        WHEN i.stock_status = 'Overstock' THEN TRUE
        ELSE FALSE
    END AS excess_inventory_flag

FROM supply_chain.inventory_snapshots i
JOIN latest_snapshot ls
    ON i.snapshot_date = ls.latest_snapshot_date
JOIN supply_chain.products p
    ON i.product_id = p.product_id
JOIN supply_chain.suppliers s
    ON p.supplier_id = s.supplier_id
JOIN supply_chain.warehouses w
    ON i.warehouse_id = w.warehouse_id;

CREATE OR REPLACE VIEW supply_chain.vw_stockout_risk AS
SELECT
    product_id,
    sku,
    product_name,
    category,
    subcategory,
    supplier_id,
    supplier_name,
    warehouse_id,
    warehouse_name,
    warehouse_region,

    available_qty,
    reorder_point,
    safety_stock_qty,
    days_of_inventory,
    inventory_value,
    stock_status,
    inventory_risk_score,

    CASE
        WHEN stock_status = 'Critical Stock' THEN 'Immediate Reorder Needed'
        WHEN stock_status = 'Reorder Needed' THEN 'Reorder Review Needed'
        WHEN stock_status = 'Overstock' THEN 'Excess Inventory Review'
        ELSE 'No Immediate Action'
    END AS recommended_action,

    CASE
        WHEN stock_status = 'Critical Stock' THEN 1
        WHEN stock_status = 'Reorder Needed' THEN 2
        WHEN stock_status = 'Overstock' THEN 3
        ELSE 4
    END AS action_priority_rank

FROM supply_chain.vw_inventory_health
WHERE stock_status IN ('Critical Stock','Reorder Needed','Overstock');

CREATE OR REPLACE VIEW supply_chain.vw_warehouse_inventory_summary AS
SELECT
    warehouse_id,
    warehouse_name,
    warehouse_city,
    warehouse_state,
    warehouse_region,
    capacity_units,

    COUNT(DISTINCT product_id) AS total_skus,
    SUM(available_qty) AS total_available_units,
    ROUND(SUM(inventory_value), 2) AS total_inventory_value,

    COUNT(*) FILTER (WHERE stock_status = 'Healthy') AS healthy_sku_count,
    COUNT(*) FILTER (WHERE stock_status = 'Critical Stock') AS critical_stock_sku_count,
    COUNT(*) FILTER (WHERE stock_status = 'Reorder Needed') AS reorder_needed_sku_count,
    COUNT(*) FILTER (WHERE stock_status = 'Overstock') AS overstock_sku_count,

    ROUND(
        (SUM(available_qty)::numeric / NULLIF(capacity_units, 0)) * 100,
        2
    ) AS capacity_used_percent,

    ROUND(AVG(days_of_inventory), 2) AS avg_days_of_inventory,

    CASE
        WHEN COUNT(*) FILTER (WHERE stock_status = 'Critical Stock') >= 25 THEN 'High Risk'
        WHEN COUNT(*) FILTER (WHERE stock_status IN ('Critical Stock','Reorder Needed')) >= 50 THEN 'Needs Review'
        WHEN COUNT(*) FILTER (WHERE stock_status = 'Overstock') >= 75 THEN 'Excess Inventory Review'
        ELSE 'Stable'
    END AS warehouse_inventory_status

FROM supply_chain.vw_inventory_health
GROUP BY
    warehouse_id,
    warehouse_name,
    warehouse_city,
    warehouse_state,
    warehouse_region,
    capacity_units;

CREATE OR REPLACE VIEW supply_chain.vw_supply_chain_validation_summary AS
WITH latest_snapshot AS (
    SELECT MAX(snapshot_date) AS latest_snapshot_date
    FROM supply_chain.inventory_snapshots
),

validation_checks AS (
    SELECT
        'Supplier Count' AS metric_name,
        (SELECT COUNT(*)::numeric FROM supply_chain.suppliers) AS raw_database_value,
        (SELECT COUNT(*)::numeric FROM supply_chain.vw_supplier_performance) AS reporting_view_value

    UNION ALL

    SELECT
        'Warehouse Count',
        (SELECT COUNT(*)::numeric FROM supply_chain.warehouses),
        (SELECT COUNT(*)::numeric FROM supply_chain.vw_warehouse_inventory_summary)

    UNION ALL

    SELECT
        'Product Count',
        (SELECT COUNT(*)::numeric FROM supply_chain.products),
        (SELECT COUNT(DISTINCT product_id)::numeric FROM supply_chain.vw_inventory_health)

    UNION ALL

    SELECT
        'Purchase Order Count',
        (SELECT COUNT(*)::numeric FROM supply_chain.purchase_orders),
        (SELECT COUNT(*)::numeric FROM supply_chain.vw_purchase_order_delivery_analysis)

    UNION ALL

    SELECT
        'Latest Inventory Rows',
        (
            SELECT COUNT(*)::numeric
            FROM supply_chain.inventory_snapshots i
            JOIN latest_snapshot ls
                ON i.snapshot_date = ls.latest_snapshot_date
        ),
        (SELECT COUNT(*)::numeric FROM supply_chain.vw_inventory_health)
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
