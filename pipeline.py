from .extractor import NBRBExtractor
from .transformer import NBRBTransformer
from .loader import SQLiteLoader
import logging

class ETLPipeline:
    def __init__(self, extractor, transformer, loader):
        self.extractor = extractor
        self.transformer = transformer
        self.loader = loader
    
    def run(self):
        logging.info("Starting ETL...")
        df_raw = self.extractor.get_data()
        df_processed = self.transformer.transform(df_raw)
        self.loader.load(df_processed)
        logging.info("ETL completed!")

if __name__ == "__main__":
    pipeline = ETLPipeline(
        extractor=NBRBExtractor(),
        transformer=NBRBTransformer(),
        loader=SQLiteLoader()
    )
    pipeline.run()