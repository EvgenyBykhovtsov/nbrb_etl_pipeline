#!/usr/bin/env python3
"""
Superstore Data Loading Script
==============================

This script loads the Superstore CSV dataset into a local PostgreSQL database.
It handles data preprocessing, validation, and provides basic output.

Requirements:
- Local PostgreSQL installation running
- .env file with database credentials
- SampleSuperstore.csv in data/raw/ directory
"""

import pandas as pd
import numpy as np
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
import os
import sys
from datetime import datetime
from pathlib import Path

# Абсолютный корень проекта (укажем ровно как тебе нужно)
PROJECT_ROOT = Path("/Users/evgenijbyhovcov/python projects/big data projects/final project_superstore_bigdata ").resolve()

def get_csv_file_path(filename="SampleSuperstore.csv"):
    return PROJECT_ROOT / "data" / "raw" / filename


csv_file_path = get_csv_file_path()
print("👉 Проверка пути:", csv_file_path)
print("📂 Файл существует?", os.path.exists(csv_file_path))



ENV_FILE = os.path.join(str(PROJECT_ROOT), ".env")

def load_environment_variables():
    """Load database configuration from environment variables."""
    try:
        load_dotenv(ENV_FILE)
        db_config = {
            'host': os.getenv("DB_HOST", "localhost"),
            'port': os.getenv("DB_PORT", "5432"),
            'database': os.getenv("DB_NAME", "superstore"),
            'user': os.getenv("DB_USER", "evgenijbyhovcov"),
            'password': os.getenv("DB_PASS", "postgres")
        }
        missing_params = [k for k, v in db_config.items() if not v]
        if missing_params:
            raise ValueError(f"Missing required environment variables: {missing_params}")
        print("✅ Environment variables loaded successfully")
        return db_config
    except Exception as e:
        print(f"❌ Failed to load environment variables: {e}")
        raise

def create_database_connection(db_config):
    """Create database connection using SQLAlchemy."""
    try:
        db_url = f"postgresql+psycopg2://{db_config['user']}:{db_config['password']}@{db_config['host']}:{db_config['port']}/{db_config['database']}"
        engine = create_engine(db_url, pool_size=5, max_overflow=10, pool_timeout=30, pool_recycle=3600)
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        print("✅ Database connection established successfully")
        return engine
    except Exception as e:
        print(f"❌ Failed to create database connection: {e}")
        raise

def load_and_preprocess_data(file_path):
    """Load CSV data and perform preprocessing."""
    try:
        print(f"📂 Loading data from {file_path}")
        df = pd.read_csv(
            file_path,
            encoding='latin1',
            parse_dates=['Order Date', 'Ship Date'],
            thousands=',',
            decimal='.'
        )
        print(f"✅ Data loaded: {df.shape[0]} rows, {df.shape[1]} columns")

        # Data validation
        if df.isnull().sum().sum() > 0:
            print("⚠️ Missing values detected")
        print(f"📊 Date range: {df['Order Date'].min()} to {df['Order Date'].max()}")

        numeric_fields = ['Sales', 'Quantity', 'Discount', 'Profit']
        for field in numeric_fields:
            if field in df.columns:
                print(f"{field}: Min={df[field].min()}, Max={df[field].max()}, Mean={df[field].mean():.2f}")

        print(f"🔹 Unique orders: {df['Order ID'].nunique()}")
        print(f"🔹 Unique customers: {df['Customer ID'].nunique()}")
        print(f"🔹 Unique products: {df['Product ID'].nunique()}")

        return df.head(5)
    except FileNotFoundError:
        print(f"❌ CSV file not found at {file_path}")
        raise
    except Exception as e:
        print(f"❌ Failed to load and preprocess data: {e}")
        raise

def load_data_to_database(df, engine, table_name='superstore'):
    """Load preprocessed data into PostgreSQL database."""
    try:
        print(f"⬆️ Loading {len(df)} records into table '{table_name}'...")
        df.to_sql(
            name=table_name,
            con=engine,
            if_exists='append',
            index=False,
            method='multi',
            chunksize=1000
        )
        print("✅ Data loaded successfully")

        with engine.connect() as conn:
            result = conn.execute(text(f"SELECT COUNT(*) FROM {table_name}"))
            count = result.scalar()
            print(f"📊 Total records in database: {count}")
    except Exception as e:
        print(f"❌ Failed to load data to database: {e}")
        raise

def main():
    """Main execution function for data loading process."""
    start_time = datetime.now()
    print("🚀 Starting Superstore data loading process")

    try:
        db_config = load_environment_variables()
        engine = create_database_connection(db_config)
        csv_file_path = get_csv_file_path()
        df = load_and_preprocess_data(str(csv_file_path))
        print("✅ Пример данных:")
        print(df.head(5))
        load_data_to_database(df, engine)

        with engine.connect() as conn:
            result = conn.execute(text("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'superstore' ORDER BY ordinal_position"))
            print(f"📋 Table structure: {len(result.fetchall())} columns")

            result = conn.execute(text("SELECT COUNT(*) as total_records, COUNT(DISTINCT \"Order ID\") as unique_orders, COUNT(DISTINCT \"Customer ID\") as unique_customers FROM superstore"))
            stats = result.fetchone()
            print(f"📊 Stats: {stats[0]} total records, {stats[1]} unique orders, {stats[2]} unique customers")

        duration = datetime.now() - start_time
        print(f"✅ Data loading completed in {duration}")
    except Exception as e:
        print(f"❌ Data loading failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
