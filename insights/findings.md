# Project Findings — Blinkit End-to-End Business Performance Analysis

## Project Overview
Analyzed Blinkit's retail operations across two domains — marketing campaign performance and inventory product profitability — to identify where the business is losing money and where optimization opportunities exist.

---

## Page 1 — Marketing Performance Analysis

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

## Page 2 — Product Profitability & Inventory Risk

### Data Preparation
Three tables were analyzed:
- blinkit_inventory: 75,172 rows of daily stock and damage records
- blinkit_products: 268 products with pricing, margin, and shelf life data
- Tables joined on product_id

Products classified by perishability:
- Perishable: shelf_life_days ≤ 30
- Semi-Perishable: shelf_life_days ≤ 90
- Non-Perishable: shelf_life_days > 90

### Key Findings

**Revenue Leakage:**
Revenue realization across all categories is only 33.67% — meaning damage losses consume approximately 66% of potential revenue. Out of ₹17.71M in potential revenue, only ₹5.96M is actually realized. ₹11.75M is lost to inventory damage.

**Highest Risk Category:**
Pet Care emerged as the highest operational risk category — combining high margins with disproportionately high inventory damage losses. High margin potential is being significantly offset by poor inventory management.

**Category-Level Damage:**
Across most categories, inventory damage losses exceed realized revenue — indicating a systemic operational inefficiency throughout the supply chain rather than an isolated product problem.

**Top Damage Driver:**
Baby Wipes is the single highest revenue leakage product contributing ₹1.02M in damage costs within the Baby Care category. Baby Care overall shows damage rates above 70% for its top products.

**Total Damage Loss:**
₹34.81M in total damage losses identified across all categories — a figure that dwarfs the ₹5.96M in actual realized revenue, highlighting the scale of the operational problem.

**Margin vs Risk:**
Several categories maintain strong margins (25-40%) but still show severe revenue leakage — meaning the pricing strategy is sound but operational execution is not. Pet Care and Personal Care are the clearest examples of this pattern.

---

## Overall Business Recommendations

**Marketing:**
- Reallocate budget from equal distribution to App-heavy for growth phases and Email-heavy for revenue optimization phases
- Investigate the ₹8.18M wasted spend — identify which specific campaigns have sub-10% conversion and either optimize or cut them
- Referral Program and New User Discount are the two campaigns worth scaling

**Inventory & Products:**
- Pet Care and Baby Care require immediate inventory management intervention given damage rates above 70%
- Revenue realization of 33.67% is unsustainably low — a 10% improvement in damage reduction would add approximately ₹1.77M to actual revenue
- High-margin categories with high damage (Pet Care, Personal Care) should be prioritized for cold chain or storage improvements
