-- Ran in GCP BigQuery

SELECT COUNT(*) AS `Number of Rows Yellow Taxi March 2021` FROM `module-2-nytaxi-kestra.ny_taxi_cloud_kestra.yellow_tripdata` WHERE filename = 'yellow_tripdata_2021-03.csv' 