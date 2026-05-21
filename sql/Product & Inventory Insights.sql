-- _______________________________________
-- Query 1 — Campaign Performance Overview
-- _______________________________________

WITH damage_summary AS (
  SELECT
    i.product_id,
    SUM(i.stock_received)                              AS total_received,
    SUM(i.damaged_stock)                               AS total_damaged,
    SUM(i.damaged_stock * p.mrp)                       AS damage_cost_inr,
    ROUND(SUM(i.damaged_stock) * 100.0
          / NULLIF(SUM(i.stock_received), 0), 2)       AS damage_rate_pct
  FROM blinkit_inventory i
  INNER JOIN blinkit_products p ON i.product_id = p.product_id
  GROUP BY i.product_id
),
ranked AS (
  SELECT
    p.product_name,
    p.category,
    p.mrp,
    p.margin_percentage,
    d.total_received,
    d.total_damaged,
    d.damage_cost_inr,
    d.damage_rate_pct,
    RANK() OVER (
      PARTITION BY p.category
      ORDER BY d.damage_cost_inr DESC
    ) AS damage_rank_in_category
  FROM damage_summary d
  INNER JOIN blinkit_products p ON d.product_id = p.product_id
)
SELECT *
FROM   ranked
WHERE  damage_rank_in_category <= 3
ORDER BY category, damage_rank_in_category;

-- _______________________________________
-- Query2-Category margin efficiency
-- _______________________________________

WITH product_economics AS (
  SELECT
    p.category,
    p.product_name,
    p.mrp,
    p.price,
    p.margin_percentage,
    SUM(i.stock_received - i.damaged_stock)       AS units_sold,
    SUM((i.stock_received - i.damaged_stock)
        * p.price)                                AS actual_revenue,
    SUM(i.stock_received * p.mrp)                 AS potential_revenue,
    SUM(i.damaged_stock * p.mrp)                  AS revenue_lost
  FROM blinkit_inventory i
  INNER JOIN blinkit_products p ON i.product_id = p.product_id
  GROUP BY p.category, p.product_name, p.mrp,
           p.price, p.margin_percentage
)
SELECT
  category,
  ROUND(SUM(actual_revenue), 2)                   AS total_revenue,
  ROUND(SUM(potential_revenue), 2)                AS potential_revenue,
  ROUND(SUM(revenue_lost), 2)                     AS total_damage_loss,
  ROUND(SUM(revenue_lost) * 100.0
        / NULLIF(SUM(potential_revenue), 0), 2)   AS loss_pct_of_potential
FROM   product_economics
GROUP BY category
ORDER BY total_damage_loss DESC;





