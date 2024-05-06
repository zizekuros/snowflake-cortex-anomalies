# Anomaly Detection with Snowflake Cortex ML functions

Snowflake Cortex comprises a set of ML (machine learning) and LLM (large language models) functions designed to simplify the implementation of various models based on data within the Snowflake Data Warehouse (DWH). This guide provides a simple walkthrough for preparing data, training a model, and invoking function for detecting anomalies in data set.

This guide covers two different concepts:

- Basic (unsupervised) anomaly detection
- Supervised anomaly detection

## Pre-requisites

To run this guide effectively, you will need to meet the following requirements:

1. **Snowflake Platform Account**: Ensure you have an active account on the Snowflake platform. If you don't have one yet, sign up for a Snowflake account on their website.

2. **User/Role Configuration with Permissions**:
   - Configure a user or role with the necessary permissions to select tables and generate views within your Snowflake account.
   - This user or role should have privileges to access the required database objects (tables, views) for data preparation, model training, and anomaly detection.

3. **Configured Warehouse**:
   - Set up a Snowflake warehouse configured to run queries. 
   - Ensure that the warehouse is properly scaled based on the size of your dataset and computational requirements.

4. **Test Data According to Data Schema**:
   - Prepare test data that adheres to the data schema required for the anomaly detection outlined in the guide.
   - The data schema should include all necessary fields and formats expected by the anomaly detection model.


## Data scheme

Guide is based on following data scheme:
```sql
create or replace TABLE MYDATABASE.PUBLIC.EVENTS (
	TIME TIMESTAMP_NTZ(9) NOT NULL,
	EVENT_TYPE VARCHAR(50) NOT NULL
);
```
## Guidelines

Here are guidelines (set of SQL queries) for two different concepts:

1. [Basic Anomaly Detection](basic-anomaly-detection.sql): A simple anomaly detection model trained with historical data.

2. [Supervised Anomaly Detection](supervised-anomaly-detection.sql): An advanced anomaly detection model that enhances data with additional label that signals whether some data point in the historic data set is an exception.
