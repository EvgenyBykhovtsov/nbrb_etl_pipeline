import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os

# Загружаем .env
load_dotenv()
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

engine = create_engine(f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

# Запрос
query = open("/Users/evgenijbyhovcov/python projects/big data projects/final project_superstore_bigdata /sql/analytical_queries/top_products.sql").read()
df = pd.read_sql(query, engine)

# Экспорт
df.to_csv("/Users/evgenijbyhovcov/python projects/big data projects/final project_superstore_bigdata /sql/analytical_queries/top_products.sql", index=False)
print("✅ Результаты выгружены в reports/tables/top_products.csv")
