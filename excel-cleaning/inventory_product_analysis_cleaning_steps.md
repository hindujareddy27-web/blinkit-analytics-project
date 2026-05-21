# Inventory & Product Analysis — Cleaning Documentation

## Datasets Used
- blinkit_inventory.csv — 75,172 rows
- blinkit_products.csv — 268 rows

## Cleaning Steps

### blinkit_products.csv
- Verified all 268 product_ids are unique
- Confirmed margin_percentage, mrp and price columns have no zero or negative values
- Shelf life values confirmed consistent (3, 7, 15, 20, 25, 30, 35, 40, 90, 180, 365 days)

### blinkit_inventory.csv
- Standardized date format from DD-MM-YYYY to YYYY-MM-DD
- Checked for null values using Go To Special — no nulls found
-Identified instances where damaged_stock exceeds stock_received (including cases with 0 stock received) , retained as is since this may reflect damaged stock from previous inventory cycles carried forward

## Conclusion
No nulls or inconsistencies found across all two datasets.
All product references verified. Datasets ready for SQL analysis.