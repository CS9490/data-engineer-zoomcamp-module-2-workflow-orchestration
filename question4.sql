-- Ran in GCP BigQuery

SELECT COUNT(*) AS `Number of Rows Green Taxi 2020` FROM `module-2-nytaxi-kestra.ny_taxi_cloud_kestra.green_tripdata` WHERE filename LIKE 'green_tripdata_2020%'