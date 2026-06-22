-- ==========================================
-- CORE ANALYTICS PIPELINE ENGINE
-- ==========================================

WITH product_margins AS (
    SELECT 
        product_id,
        product_name,
        category,
        unit_price,
        unit_cost,
        (unit_price - unit_cost) AS unit_margin,
        ROUND(((unit_price - unit_cost) / NULLIF(unit_price, 0)) * 100, 2) AS margin_percentage
    FROM inventory_products
),

sales_velocity AS (
    SELECT 
        product_id,
        SUM(quantity_sold) AS total_units_sold_30d,
        -- Using MySQL syntax for a 30-day daily average calculation
        ROUND(SUM(quantity_sold) / 30.0, 2) AS daily_velocity
    FROM retail_sales
    -- MySQL specific interval subtraction function
    WHERE sale_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    GROUP BY product_id
),

inventory_status AS (
    SELECT 
        product_id,
        current_stock_level,
        reorder_point
    FROM current_inventory
)

SELECT 
    pm.product_id,
    pm.product_name,
    pm.category,
    pm.margin_percentage,
    inv.current_stock_level,
    COALESCE(sv.daily_velocity, 0) AS daily_sales_velocity,
    
    CASE 
        WHEN COALESCE(sv.daily_velocity, 0) = 0 THEN 999 
        ELSE ROUND(inv.current_stock_level / sv.daily_velocity, 1)
    END AS days_of_supply,
    
    CASE 
        WHEN COALESCE(sv.daily_velocity, 0) = 0 THEN 'Healthy (No Sales)'
        -- Casted to a DECIMAL framework for precise evaluation in MySQL logic
        WHEN (inv.current_stock_level / NULLIF(sv.daily_velocity, 0)) < 14.0 THEN 'CRITICAL STOCKOUT RISK'
        WHEN (inv.current_stock_level / NULLIF(sv.daily_velocity, 0)) BETWEEN 14.0 AND 30.0 THEN 'Attention: Reorder Window'
        ELSE 'Healthy'
    END AS stock_urgency_status,
    
    CASE 
        WHEN pm.margin_percentage >= 50.0 AND (inv.current_stock_level / NULLIF(sv.daily_velocity, 0)) < 14.0 THEN 'High Margin - Top Priority Restock'
        ELSE 'Standard Routine'
    END AS merchandising_action_item

FROM product_margins pm
LEFT JOIN sales_velocity sv ON pm.product_id = sv.product_id
LEFT JOIN inventory_status inv ON pm.product_id = inv.product_id
ORDER BY pm.margin_percentage DESC, days_of_supply ASC;
