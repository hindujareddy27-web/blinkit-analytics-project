# Marketing Performance Data — Cleaning Documentation

## Dataset: blinkit_marketing_performance.csv
## Rows: 5,400

## Checks Performed
- Verified no blank or null values across all columns
- Checked for date format consistency(YYYY-MM-DD):found inconsistency(DD-MM-YYYY) format
- Checked for duplicate campaign_ids — none found
- Verified ROAS column — no zero or negative values
- Confirmed all channel values consistent (App, Email, SMS, Social Media)
- Confirmed all target_audience values consistent
## Changes
- changed date format to: YYYY-MM-DD

## Conclusion
Rest of the Dataset required no cleaning. All fields verified accurate and consistent.