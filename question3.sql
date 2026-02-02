-- Ran in GCP BigQuery

SELECT COUNT(*) AS `Number of Rows Yellow Taxi 2020` FROM `module-2-nytaxi-kestra.ny_taxi_cloud_kestra.yellow_tripdata` WHERE filename LIKE 'yellow_tripdata_2020%' 