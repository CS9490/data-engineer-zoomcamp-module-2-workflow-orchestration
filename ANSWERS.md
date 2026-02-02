# Module 2 Homework

## NOTE

Below is the exact markdown (MD) file from the original repository (data-engineering-zoomcamp). Please click [here](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2026/02-workflow-orchestration/homework.md) to go to the actual original file.

ATTENTION: At the end of the submission form, you will be required to include a link to your GitHub repository or other public code-hosting site. This repository should contain your code for solving the homework. If your solution includes code that is not in file format, please include these directly in the README file of your repository.

> In case you don't get one option exactly, select the closest one 

For the homework, we'll be working with the _green_ taxi dataset located here:

`https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/green/download`

To get a `wget`-able link, use this prefix (note that the link itself gives 404):

`https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/`

### Assignment

So far in the course, we processed data for the year 2019 and 2020. Your task is to extend the existing flows to include data for the year 2021.

As a hint, Kestra makes that process really easy:
1. You can leverage the backfill functionality in the [scheduled flow](../../../02-workflow-orchestration/flows/09_gcp_taxi_scheduled.yaml) to backfill the data for the year 2021. Just make sure to select the time period for which data exists i.e. from `2021-01-01` to `2021-07-31`. Also, make sure to do the same for both `yellow` and `green` taxi data (select the right service in the `taxi` input).
2. Alternatively, run the flow manually for each of the seven months of 2021 for both `yellow` and `green` taxi data. Challenge for you: find out how to loop over the combination of Year-Month and `taxi`-type using `ForEach` task which triggers the flow for each combination using a `Subflow` task.

### Quiz Questions

Complete the quiz shown below. It's a set of 6 multiple-choice questions to test your understanding of workflow orchestration, Kestra, and ETL pipelines.

1) Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?
- 128.3 MiB
- 134.5 MiB
- 364.7 MiB
- 692.6 MiB

2) What is the rendered value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?
- `{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv` 
- `green_tripdata_2020-04.csv`
- `green_tripdata_04_2020.csv`
- `green_tripdata_2020.csv`

3) How many rows are there for the `Yellow` Taxi data for all CSV files in the year 2020?
- 13,537,299
- 24,648,499
- 18,324,219
- 29,430,127

4) How many rows are there for the `Green` Taxi data for all CSV files in the year 2020?
- 5,327,301
- 936,199
- 1,734,051
- 1,342,034

5) How many rows are there for the `Yellow` Taxi data for the March 2021 CSV file?
- 1,428,092
- 706,911
- 1,925,152
- 2,561,031

6) How would you configure the timezone to New York in a Schedule trigger?
- Add a `timezone` property set to `EST` in the `Schedule` trigger configuration  
- Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
- Add a `timezone` property set to `UTC-5` in the `Schedule` trigger configuration
- Add a `location` property set to `New_York` in the `Schedule` trigger configuration  

### Answers

I backfilled all of the data for both green and yellow taxi into Google BigQuery before answering these questions.

#### Question 1 Answer

- 128.3 MiB

Backfilling for yellow cabs during year `2020` and month `12`, using the following flows (first to get the size of the file in bytes, then dividing by 1024 * 1024 in order to translate bits into MiB), the return logged string is the following.

```yml
- id: get_extracted_file_size
    type: io.kestra.plugin.core.storage.Size
    uri: "{{render(vars.data)}}"

- id: log_extracted_file_size
    type: io.kestra.plugin.core.log.Log
    message: "The uncompressed file size of the extracted CSV is {{ outputs.get_extracted_file_size.size / 1024 / 1024 }} MiB."
```

```
The uncompressed file size of the extracted CSV is 128 MiB.
```

#### Question 2 Answer

- `green_tripdata_2020-04.csv`

Backfilling for `green` cabs during the year `2020` and month `04`, because in the flow there is a tag set with the variable `file` used:

```yml
  - id: set_label
    type: io.kestra.plugin.core.execution.Labels
    labels:
      file: "{{render(vars.file)}}"
      taxi: "{{inputs.taxi}}"
```

We can see in Executions tab that the labels for the run come out as the following:

```
file:green_tripdata_2020-04.csv

taxi:green
```

#### Question 3 Answer

- 24,648,499

I ran the following query in BigQuery to get the answer:

```sql
SELECT COUNT(*) AS `Number of Rows Yellow Taxi 2020` FROM `module-2-nytaxi-kestra.ny_taxi_cloud_kestra.yellow_tripdata` WHERE filename LIKE 'yellow_tripdata_2020%' 
```

#### Question 4 Answer

- 1,734,051

I ran the following query in BigQuery to get the answer:

```sql
SELECT COUNT(*) AS `Number of Rows Green Taxi 2020` FROM `module-2-nytaxi-kestra.ny_taxi_cloud_kestra.green_tripdata` WHERE filename LIKE 'green_tripdata_2020%'
```

#### Question 5 Answer

- 1,925,152

I ran the following query in BigQuery to get the answer:

```sql
SELECT COUNT(*) AS `Number of Rows Yellow Taxi March 2021` FROM `module-2-nytaxi-kestra.ny_taxi_cloud_kestra.yellow_tripdata` WHERE filename = 'yellow_tripdata_2021-03.csv' 
```

#### Question 6 Answer

- Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration

Going into the Edit tab of the flow in this repo (while in Kestra), then going to the `triggers` and clicking on them, the Documentation tile appears. Over there, under properties, you can see one of the properties is `timezone`. On default, the value is `Etc/UTC`. The description of the property is the following:


The [time zone identifier](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) (i.e. the second column in [the Wikipedia table](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)) to use for evaluating the cron expression. Default value is the server default zone ID.

In the Wikipedia table mentioned in the description, one of the `TZ identifier`s (second column in the table), the value `America/New_York` is one of the choices, which is the correct timezone value to configure the timezone to New York in our Schedule trigger.