# Project Findings — Blinkit End-to-End Business Performance Analysis

## Project Overview
Analyzed Blinkit's retail operations across two domains — marketing campaign performance and inventory product profitability — to identify where the business is losing money and where optimization opportunities exist.

---

## Page 1 & 2 — Marketing Performance Analysis

### Data Preparation
The marketing dataset contained 5,400 campaign records across 9 campaign types, 4 channels (App, Email, SMS, Social Media) and 4 audience segments (All, Inactive, New Users, Premium).

Custom metrics created:

**Wasted Spend (DAX):**
```
Campaigns with conversion rate < 10% — spend on these is classified as wasted
```

**Revenue per Click (DAX):**
```
Total Revenue / Total Clicks
```

**Campaign Rankings (SQL Window Function):**
```sql
RANK() OVER (PARTITION BY channel ORDER BY ROAS DESC) as ROAS_rank,
RANK() OVER (PARTITION BY channel ORDER BY conversion_rate DESC) as conversion_rank
```

**Rolling 3-Month ROAS (SQL Window Function):**
```sql
AVG(SUM(revenue_generated) / SUM(spend)) 
OVER (ORDER BY YEAR(date), MONTH(date) 
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
```

### Key Findings

**Wasted Spend:**
₹8.18M was spent on campaigns with sub-10% conversion rates across all audience segments. For Premium segment alone this figure is ₹2.14M — indicating even the highest value audience segment is being targeted inefficiently.

**Channel Efficiency:**
App channel consistently delivers the highest conversion rate (10.78 for All audiences) while Email delivers the highest ROAS. This means App is better for acquiring customers, Email is better for generating revenue per rupee spent. Budget allocation should reflect both goals rather than treating channels equally.

**Campaign Performance:**
Referral Program ranked #1 for ROAS across all audience segments. Flash Sale ranked highest in the window function efficiency rankings. New User Discount drives the most total conversions overall.

**Budget Allocation:**
All four channels receive almost equal budget (approximately 25% each). Given that App and Email show clearly different strengths, a reallocation strategy could improve both conversion volume and revenue efficiency simultaneously.

**Revenue Trend:**
Revenue consistently ran at 2x spend across all months in both 2023 and 2024 — confirming that marketing investment is generating positive returns overall despite the wasted spend identified above.

---

## Page 3 & 4 — Product Profitability & Inventory Risk

### Data Preparation
Three tables were analyzed:
- blinkit_inventory: 75,172 rows of daily stock and damage records
- blinkit_products: 268 products with pricing, margin, and shelf life data
- Tables joined on product_id

### This page used:
- SQL aggregations
-Common Table Expressions (CTEs)
-Window functions
-DAX calculations
-Interactive filter-aware measures
  

Custom metrics created:

**Revenue Leakage Calculation (DAX):**
```
Revenue Leakage = SUM(table[potential_revenue]) - SUM(table[total_revenue])
```

**Revenue Realization %(DAX):**
```
Revenue Realization % = DIVIDE( SUM(table[total_revenue]), SUM(table[potential_revenue]), 0 ) * 100
```

**Product Damage Ranking (SQL Window Function):**
```sql
RANK() OVER ( PARTITION BY p.category ORDER BY d.damage_cost_inr DESC ) AS damage_rank_in_category
```

**Damage Rate Calculation (SQL):**
```sql
ROUND( SUM(i.damaged_stock) * 100.0 / NULLIF(SUM(i.stock_received), 0), 2 ) AS damage_rate_pct
```

### Key Findings

**Revenue Leakage:**
₹11.75M in potential revenue was lost due to damaged inventory, leaving overall revenue realization at only 33.7% of total potential revenue.

This indicates that inventory inefficiencies are significantly impacting operational profitability.

**Highest Risk Category:**
Pet Care emerged as the highest-risk category due to disproportionately large inventory damage losses.

Despite maintaining relatively strong margins, inventory inefficiencies within this category substantially reduced realized revenue.

**Product-Level Damage:**
Baby Wipes, Pet Treats, and Toilet Cleaner ranked among the highest contributors to inventory damage costs and revenue leakage.

The ranking analysis revealed that a relatively small subset of products contributes disproportionately to overall operational losses.

**Top Damage Driver:**
Baby Wipes is the single highest revenue leakage product contributing ₹1.02M in damage costs within the Baby Care category. Baby Care overall shows damage rates above 70% for its top products.

**Revenue Realization Patterns:**
Categories such as Instant & Frozen Food and Personal Care lose a substantial portion of potential revenue through damaged inventory despite maintaining strong sales activity.

This indicates that improving operational handling could significantly increase realized profitability.

**Margin vs Operational Efficiency:**
Several categories operate at healthy average margins (~28%) while simultaneously experiencing severe inventory losses.

This suggests that profitability potential exists, but operational inefficiencies are preventing revenue realization.

---

## Overall Business Recommendations

**Marketing:**
- Reallocate budget from equal distribution to App-heavy for growth phases and Email-heavy for revenue optimization phases
- Investigate the ₹8.18M wasted spend — identify which specific campaigns have sub-10% conversion and either optimize or cut them
- Referral Program and New User Discount are the two campaigns worth scaling

**Inventory & Products:**
- Prioritize operational improvements within Pet Care and Personal Care categories where inventory losses are disproportionately high
- Implement stricter monitoring for high-risk SKUs such as Baby Wipes, Pet Treats, and Toilet Cleaner
- Improve storage, replenishment, and handling strategies for categories with high damage rates but healthy profit margins
- Use product-level damage rankings to prioritize inventory control and markdown optimization efforts

