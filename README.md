# 🛒 E-Commerce Data Pipeline with dbt, Snowflake & Airflow

A modern **ELT (Extract, Load, Transform)** data pipeline for e-commerce analytics, built using industry-standard tools: **dbt** for data transformation, **Snowflake** as the cloud data warehouse, and **Apache Airflow** for workflow orchestration.

![Pipeline Architecture](diagram-export-12-11-2025-10_44_33-AM.png)

## 📋 Overview

This project demonstrates how to build a production-ready data pipeline that transforms raw e-commerce data into analytics-ready fact tables. The pipeline follows modern data engineering best practices including modular SQL transformations, automated testing, comprehensive documentation, and scheduled orchestration.

The architecture processes order data through multiple transformation layers—from raw staging tables to summarized fact tables—enabling business intelligence and reporting on e-commerce performance metrics.

## 🛠️ Technology Stack

### Snowflake (Data Warehouse)

**Snowflake** serves as the cloud-native data warehouse where all data is stored and transformed. Key advantages include:

- **Separation of storage and compute** — Scale independently based on workload needs
- **Zero-copy cloning** — Create instant development environments without duplicating data
- **Automatic scaling** — Handle concurrent queries without performance degradation
- **Time travel** — Access historical data states for debugging and recovery

In this pipeline, Snowflake hosts the raw e-commerce data sources (orders, line items, pricing) and stores all transformed staging and mart tables.

### dbt (Data Build Tool)

**dbt** handles all data transformations using SQL, bringing software engineering best practices to analytics workflows:

- **Modular SQL models** — Each transformation is a versioned, reusable SQL file
- **Dependency management** — The `ref()` function automatically builds models in the correct order
- **Built-in testing** — Validate data quality with schema tests (unique, not_null, relationships)
- **Auto-generated documentation** — Create a searchable data catalog from your models
- **Macros** — Reusable SQL snippets for common business logic (e.g., pricing calculations)

The dbt models in this project follow a layered architecture:

| Layer | Purpose | Materialization |
|-------|---------|-----------------|
| **Staging** | Clean and standardize raw source data | View |
| **Intermediate** | Join and enrich data across sources | Ephemeral/View |
| **Marts** | Business-ready fact and dimension tables | Table |

### Apache Airflow

**Apache Airflow** orchestrates the entire pipeline, ensuring reliable and scheduled execution:

- **DAG-based workflows** — Define pipeline dependencies as Directed Acyclic Graphs
- **Scheduled execution** — Run transformations on a daily (or custom) schedule
- **Conditional logic** — Execute validation tasks only when tests are configured
- **Monitoring & alerting** — Track pipeline health and catch failures early
- **Retry mechanisms** — Automatically handle transient failures

The Airflow DAG coordinates dbt runs, manages dependencies between tasks, and provides observability into pipeline execution.

## 🔄 Pipeline Workflow

The data pipeline follows this execution flow:

### 1. Project Configuration
- Read project settings and connection profiles
- Parse dbt configuration files (`dbt_project.yml`, `profiles.yml`)
- Establish secure connection to Snowflake

### 2. Source Discovery
- Connect to Snowflake and discover available data sources
- Define source tables in dbt's `sources.yml`
- Set up freshness checks for data quality monitoring

### 3. Data Transformation (dbt)
The transformation layer processes data through these stages:

```
Raw Data → Staging → Intermediate → Fact Tables
```

**Staging Models:**
- `stg_orders` — Cleaned and typed order headers
- `stg_line_items` — Standardized order line items
- `stg_pricing` — Normalized pricing data

**Intermediate Models:**
- `int_order_items_detailed` — Joined orders with line items and pricing
- `int_order_items_summarized` — Aggregated metrics per order

**Fact Models:**
- `fct_orders` — Final analytics-ready orders fact table with calculated metrics

### 4. Testing & Documentation
- **Schema tests** — Validate primary keys, foreign key relationships, and data types
- **Data tests** — Custom SQL assertions for business logic validation
- **Documentation** — Auto-generated lineage graphs and column descriptions

### 5. Orchestration (Airflow)
- Daily scheduled execution of the dbt pipeline
- Conditional test execution based on configuration
- Pipeline monitoring and failure alerting

## 📁 Project Structure

```
├── data_pipeline/
│   ├── models/
│   │   ├── staging/           # Source data cleaning
│   │   ├── intermediate/      # Data enrichment
│   │   └── marts/             # Business-ready tables
│   ├── macros/                # Reusable SQL functions
│   ├── tests/                 # Custom data tests
│   ├── dbt_project.yml        # dbt configuration
│   └── profiles.yml           # Connection settings
│
├── dbt-dag/
│   └── dags/
│       └── dbt_pipeline.py    # Airflow DAG definition
│
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- Python 3.8+
- Snowflake account with appropriate permissions
- Apache Airflow (2.x recommended)
- dbt-core and dbt-snowflake adapter

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/llevi95/dbt-snowflake-airlfow-ecommerce.git
   cd dbt-snowflake-airlfow-ecommerce
   ```

2. **Set up Python environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install dbt-snowflake apache-airflow
   ```

3. **Configure Snowflake connection**
   
   Create or update `~/.dbt/profiles.yml`:
   ```yaml
   data_pipeline:
     outputs:
       dev:
         type: snowflake
         account: <your_account>
         user: <your_username>
         password: <your_password>
         role: <your_role>
         warehouse: <your_warehouse>
         database: <your_database>
         schema: <your_schema>
         threads: 4
     target: dev
   ```

4. **Run dbt models**
   ```bash
   cd data_pipeline
   dbt debug          # Test connection
   dbt deps           # Install dependencies
   dbt run            # Execute transformations
   dbt test           # Run data tests
   dbt docs generate  # Generate documentation
   dbt docs serve     # View documentation locally
   ```

5. **Set up Airflow DAG**
   
   Copy the DAG file to your Airflow DAGs folder and configure the Snowflake connection in the Airflow UI.

## 📊 Key Features

- **Incremental processing** — Only process new or changed records for efficiency
- **Idempotent transformations** — Safe to re-run without duplicate data
- **Data quality checks** — Automated validation at every layer
- **Lineage tracking** — Understand data flow from source to consumption
- **Environment separation** — Isolated dev, staging, and production environments

## 🔧 Configuration

### dbt Variables

Configure business logic through dbt variables in `dbt_project.yml`:

```yaml
vars:
  default_currency: 'USD'
  order_status_filter: ['completed', 'shipped']
```

### Airflow Schedule

Modify the DAG schedule in `dbt_pipeline.py`:

```python
schedule_interval='0 6 * * *'  # Daily at 6 AM UTC
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

Built with ❄️ Snowflake, 🔧 dbt, and 🌬️ Airflow
