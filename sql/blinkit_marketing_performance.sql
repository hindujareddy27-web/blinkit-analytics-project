-- _______________________________________
-- Query 1 — Campaign Performance Overview
-- _______________________________________
SELECT 
    campaign_name,
    target_audience,
    channel,
    ROUND(SUM(spend) ,2)as total_spend,
    ROUND(SUM(revenue_generated) ,2)as total_revenue,
    SUM(conversions) as total_conversions,
    SUM(clicks) as total_clicks,
    ROUND(SUM(revenue_generated) / SUM(spend), 2) as ROAS,
    ROUND(SUM(conversions) * 100.0 / SUM(clicks), 2) as conversion_rate
FROM blinkit_marketing_performance
GROUP BY campaign_name, target_audience, channel
ORDER BY ROAS DESC;
-- _______________________________________
--  QUERY 2-Channel Efficiency (clicks vs conversions)
-- _______________________________________
SELECT
    channel,
    target_audience,
    SUM(clicks) as total_clicks,
    SUM(conversions) as total_conversions,
    ROUND(SUM(spend),2) as total_spend,
    ROUND(SUM(conversions) * 100.0 / SUM(clicks), 2) as conversion_rate,
    ROUND(SUM(revenue_generated) / SUM(spend), 2) as ROAS
FROM blinkit_marketing_performance
GROUP BY channel, target_audience
ORDER BY conversion_rate DESC;

-- _______________________________________
-- Query 3 — Monthly Trend
-- _______________________________________

SELECT
    MONTHNAME(date) as month, 
    YEAR(date) AS year,
    ROUND(SUM(spend),2) as total_spend,
    ROUND(SUM(revenue_generated),2) as total_revenue,
    ROUND(SUM(revenue_generated) / SUM(spend), 2) as monthly_ROAS
FROM blinkit_marketing_performance
GROUP BY MONTHNAME(date),year
ORDER BY year,month;

-- _______________________________________
-- Query 4 — Running ROAS trend with window function
-- _______________________________________
SELECT 
    MONTHNAME(date) as month,
    YEAR(date) as year,date,
    ROUND(SUM(revenue_generated) / SUM(spend), 2) as monthly_ROAS,
    ROUND(AVG(SUM(revenue_generated) / SUM(spend)) 
        OVER (ORDER BY YEAR(date), MONTH(date) 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) as rolling_3month_ROAS
FROM blinkit_marketing_performance
GROUP BY MONTHNAME(date), YEAR(date),MONTH(date),date
ORDER BY year, month,date;


-- _______________________________________
-- Query 5 — Campaign efficiency ranking using CTE
-- _______________________________________
WITH campaign_stats AS (
    SELECT 
        campaign_name,
        channel,
        target_audience,
        ROUND(SUM(revenue_generated) / SUM(spend), 2) as ROAS,
        ROUND(SUM(conversions) * 100.0 / SUM(clicks), 2) as conversion_rate,
        ROUND(SUM(spend), 2) as total_spend
    FROM blinkit_marketing_performance
    GROUP BY campaign_name, channel, target_audience
)
SELECT *,
    RANK() OVER (PARTITION BY channel ORDER BY ROAS DESC) as ROAS_rank,
    RANK() OVER (PARTITION BY channel ORDER BY conversion_rate DESC) as conversion_rank
FROM campaign_stats;



