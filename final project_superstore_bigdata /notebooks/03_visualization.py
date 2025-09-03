#!/usr/bin/env python3

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os
from pathlib import Path

# Load environment variables from the correct path
env_path = Path(__file__).parent.parent / ".env"
load_dotenv(env_path)

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "superstore")
DB_USER = os.getenv("DB_USER", "evgenijbyhovcov")
DB_PASS = os.getenv("DB_PASS", "postgres")

# Create database connection
engine = create_engine(f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

def run_query(path):
    """Execute SQL query and return results as DataFrame"""
    with open(path, "r") as f:
        query = f.read()
    return pd.read_sql(query, engine)

def save_figure(fig, filename):
    """Save figure to reports/figures directory"""
    output_path = Path(__file__).parent.parent / "reports" / "figures" / filename
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=300, bbox_inches='tight')
    print(f"✅ Figure saved: {output_path}")

# 1. Monthly Revenue Trend Analysis
print("📊 Creating Monthly Revenue Trend Analysis...")
monthly_revenue = run_query(Path(__file__).parent.parent / "sql" / "analytical_queries" / "monthly_revenue.sql")

plt.figure(figsize=(12, 5))
sns.lineplot(data=monthly_revenue, x="month", y="revenue", marker="o")
plt.title("Monthly Revenue Trend (2014-2017)")
plt.xlabel("Month")
plt.ylabel("Revenue ($)")
plt.xticks(rotation=45)
plt.tight_layout()
save_figure(plt.gcf(), "monthly_revenue.png")
plt.show()

# 2. Top Products Analysis
print("📊 Creating Top Products Analysis...")
top_products = run_query(Path(__file__).parent.parent / "sql" / "analytical_queries" / "top_products.sql")

plt.figure(figsize=(10, 5))
top_10_products = top_products.head(10)
sns.barplot(data=top_10_products, x="total_revenue", y="Product Name", palette="viridis")
plt.title("Top 10 Products by Revenue")
plt.xlabel("Total Revenue ($)")
plt.ylabel("Product Name")
plt.tight_layout()
save_figure(plt.gcf(), "top_products.png")
plt.show()

# 3. Top Customers Analysis
print("📊 Creating Top Customers Analysis...")
top_customers = run_query(Path(__file__).parent.parent / "sql" / "analytical_queries" / "top_customers.sql")

plt.figure(figsize=(10, 5))
top_10_customers = top_customers.head(10)
sns.barplot(data=top_10_customers, x="total_revenue", y="Customer Name", palette="magma")
plt.title("Top 10 Customers by Revenue")
plt.xlabel("Total Revenue ($)")
plt.ylabel("Customer Name")
plt.tight_layout()
save_figure(plt.gcf(), "top_customers.png")
plt.show()

# 4. Category Performance Analysis
print("📊 Creating Category Performance Analysis...")
category_mix = run_query(Path(__file__).parent.parent / "sql" / "analytical_queries" / "category_mix.sql")

plt.figure(figsize=(8, 5))
sns.barplot(data=category_mix, x="revenue", y="Category", palette="Set2")
plt.title("Revenue by Category")
plt.xlabel("Revenue ($)")
plt.ylabel("Category")
plt.tight_layout()
save_figure(plt.gcf(), "category_mix.png")
plt.show()

# 5. Discount Sensitivity Analysis
print("📊 Creating Discount Sensitivity Analysis...")
discount_sensitivity = run_query(Path(__file__).parent.parent / "sql" / "analytical_queries" / "discount_sensitivity.sql")

plt.figure(figsize=(8, 5))
sns.lineplot(data=discount_sensitivity, x="discount_range", y="total_profit", marker="o")
plt.title("Total Profit by Discount Range")
plt.xlabel("Discount Range")
plt.ylabel("Total Profit ($)")
plt.xticks(rotation=45)
plt.tight_layout()
save_figure(plt.gcf(), "discount_sensitivity.png")
plt.show()

print("🎉 All visualizations completed successfully!")
print("📁 Check the 'reports/figures/' directory for saved charts.")
