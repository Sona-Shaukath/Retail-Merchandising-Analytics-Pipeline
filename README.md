# 📦 Retail Inventory & Merchandising Analytics Pipeline

## 🚀 Project Overview
This project builds an end-to-end SQL analytics layer tailored for retail operations. By dynamically combining inventory levels with rolling 30-day transactional velocity, the pipeline profiles product margin health, calculates current run-rates, and triggers an automated alerting system for critical inventory stockouts.

The ultimate objective of this business logic is to maximize revenue health by ensuring high-margin products never suffer from empty shelves.

---

## 🛠️ Key Analytical Features Implemented
* **Margin Health Profiling:** Isolates items generating the highest profitability percentages using robust division structures (`NULLIF`).
* **30-Day Rolling Velocity:** Determines the average units sold daily over a trailing 30-day window to evaluate real-time demand.
* **Predictive Stockout Flags:** Employs complex `CASE` logic to calculate exactly how many days of supply remain based on current sales trajectory.
* **Priority Action Items:** Implements conditional ranking to surface products that are both high-margin and low-stock, giving merchandisers an instant, automated reorder checklist (e.g., triggering a `CRITICAL STOCKOUT RISK` alert if stock falls under a 14-day supply).

---

## 💾 Tech Stack & Database Architecture
* **Language:** SQL (MySQL optimized)
* **Techniques Used:** Common Table Expressions (CTEs), Conditional Aggregations, Safe Division Handling, Date Subtractions, Joins.

### Database Schema Structure:
1. `inventory_products`: Holds core product metadata, categories, and unit cost/pricing structures.
2. `retail_sales`: Captures transactional history, quantities sold, and rolling purchase timestamps.
3. `current_inventory`: Tracks live physical warehouse volumes and standard reorder thresholds.
