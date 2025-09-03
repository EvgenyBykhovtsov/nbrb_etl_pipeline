# Superstore Big Data Analytics Project

## 📋 Project Overview

This comprehensive data analytics project demonstrates end-to-end big data processing capabilities using a real-world retail dataset. The project showcases advanced SQL analytics, Python data manipulation, statistical analysis, and business intelligence visualization techniques.

### 🎯 Project Objectives
- **Data Engineering**: Implement ETL pipeline for retail data processing
- **Business Intelligence**: Generate actionable insights for retail operations
- **Performance Analytics**: Analyze sales trends, customer behavior, and profitability
- **Data Visualization**: Create compelling visualizations for stakeholder presentations

### 📊 Dataset Description
The project uses the **Sample Superstore** dataset containing:
- **9,994 records** of retail transactions
- **21 columns** including sales, customer, product, and geographic data
- **4-year time span** (2014-2017) for trend analysis
- **Multiple business dimensions**: Products, Customers, Geography, Time

### 🛠 Technical Stack
- **Database**: PostgreSQL 15+ (Local Installation)
- **Python**: Pandas, SQLAlchemy, Matplotlib, Seaborn
- **SQL**: Advanced analytical queries with window functions
- **Visualization**: Interactive charts and business dashboards
- **Development**: Jupyter Notebooks for reproducible analysis

## 🚀 Installation & Setup

### Prerequisites
- Python 3.8+
- PostgreSQL 15+ (Local Installation)
- pgAdmin (Optional, for database management)

### 1. Database Setup
```bash
# Install PostgreSQL locally
# For macOS: brew install postgresql
# For Ubuntu: sudo apt-get install postgresql postgresql-contrib

# Start PostgreSQL service
brew services start postgresql  # macOS
sudo systemctl start postgresql  # Ubuntu

# Create database and user
psql postgres
```

```sql
-- Create database
CREATE DATABASE superstore;

-- Create user with appropriate permissions
CREATE USER superuser WITH PASSWORD 'superpass';
GRANT ALL PRIVILEGES ON DATABASE superstore TO superuser;
GRANT CONNECT ON DATABASE superstore TO superuser;
\q
```

### 2. Environment Configuration
```bash
# Create environment file
cp .env.example .env
```

Edit `.env` file with your local database credentials:
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=superstore
DB_USER=superuser
DB_PASS=superpass
```

### 3. Python Dependencies
```bash
# Install required packages
pip install -r requirements.txt

# Or create virtual environment (recommended)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## 📈 Project Workflow

### Phase 1: Data Exploration & Preparation
```bash
# Run exploratory data analysis
jupyter notebook notebooks/01_eda.ipynb
```
**Deliverables:**
- Data quality assessment
- Statistical summaries
- Data cleaning and preprocessing
- Processed dataset saved to `data/processed/`

### Phase 2: Database Schema & Data Loading
```bash
# Create database tables
psql -U superuser -d superstore -f sql/00_create_table.sql

# Load data to PostgreSQL
python scripts/load_to_postgres.py
```

### Phase 3: Advanced SQL Analytics
```bash
# Execute analytical queries
jupyter notebook notebooks/02_sql_analysis.ipynb
```
**Analytical Queries:**
- Monthly revenue trends
- Top-performing products and customers
- Category performance analysis
- Discount sensitivity analysis
- Regional sales patterns

### Phase 4: Data Visualization & Reporting
```bash
# Generate visualizations and reports
jupyter notebook notebooks/03_viz.ipynb
```
**Outputs:**
- Interactive charts saved to `reports/figures/`
- Analytical tables exported to `reports/tables/`
- Business insights summary

## 📊 Key Analytics & Insights

### Sales Performance Analysis
- **Revenue Trends**: Monthly and quarterly sales patterns
- **Product Performance**: Top-selling products and categories
- **Customer Segmentation**: High-value customer identification
- **Geographic Analysis**: Regional sales performance

### Business Intelligence
- **Profitability Analysis**: Profit margins by product category
- **Discount Impact**: Correlation between discounts and sales
- **Seasonal Patterns**: Time-based sales trends
- **Customer Behavior**: Purchase patterns and preferences

### Advanced Analytics
- **RFM Analysis**: Customer value segmentation
- **Product Mix Optimization**: Category performance insights
- **Sales Forecasting**: Trend-based predictions
- **Operational Efficiency**: Shipping and delivery analysis

## 🏗 Project Structure

```
superstore_bigdata/
├── data/
│   ├── raw/                 # Original dataset
│   └── processed/           # Cleaned and processed data
├── notebooks/
│   ├── 01_eda.ipynb        # Exploratory Data Analysis
│   ├── 02_sql_analysis.ipynb # SQL Analytics
│   └── 03_visualization.py        # Data Visualization
├── scripts/
│   ├── load_to_postgres.py # Data loading script
│   └── export_sql_to_csv.py # Results export script
├── sql/
│   ├── 00_create_table.sql # Database schema
│   └── analytical_queries/  # Advanced SQL queries
├── reports/
│   ├── figures/            # Generated visualizations
│   └── tables/             # Exported analytical results
├── requirements.txt        # Python dependencies
├── README.md              # Project documentation
└── PROJECT_DOCUMENTATION.md # Results and goals achieved by the project
```

## 🔧 Technical Features

### Data Engineering
- **ETL Pipeline**: Automated data extraction, transformation, and loading
- **Data Quality**: Comprehensive data validation and cleaning
- **Schema Design**: Optimized database structure for analytical queries
- **Performance**: Efficient SQL queries with proper indexing

### Analytics Capabilities
- **Statistical Analysis**: Descriptive and inferential statistics
- **Time Series Analysis**: Trend identification and seasonality
- **Customer Analytics**: RFM segmentation and behavior analysis
- **Product Analytics**: Performance metrics and optimization insights

### Visualization & Reporting
- **Interactive Charts**: Dynamic visualizations for stakeholder presentations
- **Business Dashboards**: Key performance indicators and metrics
- **Automated Reporting**: Scheduled report generation
- **Export Capabilities**: Multiple format support (CSV, PNG, PDF)

## 🎓 Learning Outcomes

This project demonstrates proficiency in:
- **Big Data Processing**: Handling large-scale retail datasets
- **SQL Mastery**: Advanced analytical queries and optimization
- **Python Programming**: Data manipulation and analysis
- **Business Intelligence**: Converting data into actionable insights
- **Data Visualization**: Creating compelling business presentations
- **Database Management**: PostgreSQL administration and optimization

## 📝 Usage Examples

### Running Complete Analysis

# 1. Setup database
psql -U superuser -d superstore -f sql/00_create_table.sql

# 2. Load data
python scripts/load_to_postgres.py

# 3. Run analysis notebooks and scripts
jupyter notebook notebooks/01_eda.ipynb
jupyter notebook notebooks/02_sql_analysis.ipynb
python script notebooks/03_visualization.py


### Custom Analytics

# Example: Custom SQL query execution
from scripts.export_sql_to_csv import run_query
results = run_query("sql/analytical_queries/custom_analysis.sql")


## 🤝 Contributing

This project serves as a portfolio piece demonstrating data analytics capabilities. For modifications or extensions:

1. Fork the repository
2. Create a feature branch
3. Implement changes with proper documentation

---

**Note**: This project requires a local PostgreSQL installation. Ensure your database server is running before executing the scripts. All database connections are configured for localhost with the credentials specified in the `.env` file.
