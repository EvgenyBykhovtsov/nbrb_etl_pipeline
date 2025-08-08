import sqlite3
import pandas as pd
from abc import ABC, abstractmethod

class Loader(ABC):
    @abstractmethod
    def load(self, df: pd.DataFrame) -> None:
        pass

class SQLiteLoader(Loader):
    def __init__(self, db_path: str = "nbrb_rates.db"):
        self.db_path = db_path
        
    def load(self, df: pd.DataFrame) -> None:
        with sqlite3.connect(self.db_path) as conn:
            df.to_sql("nbrb_currency_rates", conn, if_exists="replace", index=False)
            