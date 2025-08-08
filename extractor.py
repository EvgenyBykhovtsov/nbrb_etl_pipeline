import requests
import pandas as pd
from datetime import datetime
from abc import ABC, abstractmethod

class Extractor(ABC):
    @abstractmethod
    def get_data(self) -> pd.DataFrame:
        pass

class NBRBExtractor(Extractor):
    def get_data(self) -> pd.DataFrame:
        url = "https://api.nbrb.by/exrates/rates?periodicity=0"
        response = requests.get(url)
        data = response.json()
        
        records = []
        for currency in data:
            records.append({
                "code": currency["Cur_Abbreviation"],
                "name": currency["Cur_Name"],
                "scale": currency["Cur_Scale"],
                "rate": currency["Cur_OfficialRate"],
                "date": datetime.strptime(currency["Date"], "%Y-%m-%dT%H:%M:%S")
            })
        
        return pd.DataFrame(records)