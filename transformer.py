import pandas as pd
from abc import ABC, abstractmethod

class Transformer(ABC):
    @abstractmethod
    def transform(self, df: pd.DataFrame) -> pd.DataFrame:
        pass

class NBRBTransformer(Transformer):
    def transform(self, df: pd.DataFrame) -> pd.DataFrame:
        df = df.dropna(subset=["rate"])
        df["rate_norm"] = df["rate"] / df["scale"]
        df = df[df["code"].isin(["USD", "EUR", "RUB", "CNY"])]
        return df