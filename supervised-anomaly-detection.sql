--
-- SUPERVISED ANOMALY DETECTION
--

-- 1: create a view of historical data
-- in this case, I am using only data from Jan 01 to Mar 01
-- i am also creating a label (true/false) for saturday and sunday
create or replace view requests_historical_data_with_label as
select 
    DATE(time)::TIMESTAMP_NTZ as day,
    count(*) as request_cnt,
    case when (DAYOFWEEK(time)=6 or DAYOFWEEK(time)=0)
      then TRUE 
      else FALSE 
    end as label
from events_ad 
where event_type='request' and day > '2024-01-01 00:00:00.000' and day < '2024-03-01 00:00:00.000'
group by day, label
order by day asc;

-- 2: create a view of new data
-- in this case, I am using only data from Mar 01 to Apr 01
create or replace view requests_new_data as
select 
    DATE(time)::TIMESTAMP_NTZ as day,
    count(*) as request_cnt
from events_ad 
where event_type='request' and day >= '2024-03-01 00:00:00.000' and day < '2024-04-01 00:00:00.000'
group by day
order by day asc;

-- 3: train model
create or replace SNOWFLAKE.ML.ANOMALY_DETECTION requests_anomaly_model_with_label(
  input_data => SYSTEM$REFERENCE('VIEW', 'requests_historical_data_with_label'),
  timestamp_colname => 'day',
  target_colname => 'request_cnt',
  label_colname => 'label');
  
-- 4: find anomalies on new data
call requests_anomaly_model_with_label!DETECT_ANOMALIES(
  input_data => SYSTEM$REFERENCE('VIEW', 'requests_new_data'),
  timestamp_colname =>'day',
  target_colname => 'request_cnt'
);

-- 5: save the results to a table
create or replace table requests_model_anomalies_with_label as 
select * from table(result_scan(last_query_id()));

-- 6: combine historical and forecasted values
select 
  DATE(time)::TIMESTAMP_NTZ as day, 
  count(*) as request_cnt,
  null as forecast, 
  null as is_anomaly
from events_ad
where event_type='request' and day > '2024-01-01 00:00:00.000' and day < '2024-04-01 00:00:00.000'
group by day
union all
select 
  ts as day,
  null as request_cnt,
  forecast, 
  case when is_anomaly then 10000000 end as anomaly_flg
from requests_model_anomalies_with_label;