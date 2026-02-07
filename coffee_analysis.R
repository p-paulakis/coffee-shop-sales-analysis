# ═══════════════════════════════════════════════════════════
# PROJECT 1: COFFEE SHOP SALES ANALYSIS
# Mini-Project completed: [Your Date]
# 
# Purpose: Analyze one week of coffee shop sales to find insights
# Tools: R, SQL (sqldf), ggplot2
# ═══════════════════════════════════════════════════════════

# Load libraries
library(tidyverse)
library(sqldf)

# ═══════════════════════════════════════════════════════════
# CREATE THE DATA
# ═══════════════════════════════════════════════════════════

sales <- data.frame(
  sale_id = 1:30,
  date = rep(c("2026-01-20", "2026-01-21", "2026-01-22", "2026-01-23", "2026-01-24"), each = 6),
  day_of_week = rep(c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"), each = 6),
  product = rep(c("Latte", "Cappuccino", "Espresso", "Tea", "Pastry", "Sandwich"), 5),
  price = rep(c(4.50, 4.00, 3.00, 2.50, 3.50, 6.00), 5),
  quantity_sold = c(12, 8, 5, 3, 10, 7,
                    15, 10, 6, 4, 12, 8,
                    18, 12, 8, 5, 15, 10,
                    20, 15, 10, 6, 18, 12,
                    22, 18, 12, 8, 20, 15),
  customer_rating = c(4.5, 4.2, 4.8, 4.0, 4.3, 4.6,
                      4.6, 4.3, 4.7, 4.1, 4.4, 4.5,
                      4.7, 4.5, 4.9, 4.2, 4.5, 4.7,
                      4.8, 4.6, 5.0, 4.3, 4.6, 4.8,
                      4.9, 4.7, 4.8, 4.4, 4.7, 4.9)
)

# View first few rows
head(sales)

# ═══════════════════════════════════════════════════════════
# PART 1: SQL QUERIES (Answering Business Questions)
# ═══════════════════════════════════════════════════════════

# QUERY 1: Total weekly revenue
total_revenue <- sqldf("
  SELECT SUM(price * quantity_sold) AS total_revenue
  FROM sales
")
print("Query 1: Total Weekly Revenue")
print(total_revenue)

# QUERY 2: Best-selling product (by quantity)
best_seller <- sqldf("
  SELECT product, SUM(quantity_sold) AS total_quantity
  FROM sales
  GROUP BY product
  ORDER BY total_quantity DESC
")
print("Query 2: Best-Selling Product")
print(best_seller)

# QUERY 3: Daily revenue by day of week
daily_revenue <- sqldf("
  SELECT day_of_week, SUM(price * quantity_sold) AS day_revenue
  FROM sales
  GROUP BY day_of_week
")
print("Query 3: Daily Revenue")
print(daily_revenue)

# QUERY 4: Products with average rating above 4.5
high_rated <- sqldf("
  SELECT product, AVG(customer_rating) AS avg_rating
  FROM sales
  GROUP BY product
  HAVING AVG(customer_rating) > 4.5
")
print("Query 4: High-Rated Products (avg > 4.5)")
print(high_rated)

# QUERY 5: Friday sales only
friday_sales <- sqldf("
  SELECT day_of_week, SUM(price * quantity_sold) AS friday_revenue
  FROM sales
  WHERE day_of_week = 'Friday'
")
print("Query 5: Friday Sales")
print(friday_sales)

# ═══════════════════════════════════════════════════════════
# PART 2: VISUALIZATIONS
# ═══════════════════════════════════════════════════════════

# VISUALIZATION 1: Revenue by Day of Week
viz1_data <- sqldf("
  SELECT day_of_week, SUM(price * quantity_sold) AS revenue
  FROM sales
  GROUP BY day_of_week
")

viz1 <- ggplot(viz1_data, aes(x = day_of_week, y = revenue)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Coffee Shop Revenue by Day of Week",
    x = "Day",
    y = "Revenue ($)"
  ) +
  theme_minimal()

print(viz1)

# VISUALIZATION 2: Total Quantity Sold by Product
viz2_data <- sqldf("
  SELECT product, SUM(quantity_sold) AS total_quantity
  FROM sales
  GROUP BY product
  ORDER BY total_quantity DESC
")

viz2 <- ggplot(viz2_data, aes(x = product, y = total_quantity)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Total Quantity Sold by Product",
    x = "Product",
    y = "Total Q")
print(viz2)
