# US COVID19 Data Analysis

This repo contains R code that analyzes publicly available COVID-19 data from the U.S. by cleaning, sorting, and plotting.

## Libraries Used
- dplyr
- ggplot2
- scales
- readxl
- reshape2
- lubridate
- stringr
- tidyr
- ggpmisc

## Scripts
### `by_age.R`
- Groups current COVID19 cases and deaths in the U.S. by age brackets and plots a grouped bar chart.
- Uses data from the [CDC](https://data.cdc.gov/api/views/9bhg-hcku/rows.csv?accessType=DOWNLOAD), downloaded "2021-12-10 07:00:31 AEDT" 
- Uses data from [Statista](https://www.statista.com/statistics/1254271/us-total-number-of-covid-cases-by-age-group/), generated "2021-12-10 10:06:09 AEDT"

### `by_state_bar.R`
- Groups current COVID19 cases and deaths in the U.S. by state and plots a grouped bar chart.
- Uses data from the [CDC](https://data.cdc.gov/api/views/9mfq-cb36/rows.csv?accessType=DOWNLOAD), downloaded "2021-12-10 16:13:05 AEDT"

### `by_state_map.R`
- Groups current COVID19 cases and deaths in the U.S. by state and creates a heatmap of the U.S. based on case fatality rate.
- Uses data from the [CDC](https://data.cdc.gov/api/views/9mfq-cb36/rows.csv?accessType=DOWNLOAD), downloaded "2021-12-10 16:13:05 AEDT"

### `deaths_and_vaxdoses_by_date_combo.R`
- Groups current COVID19 cases and vaccines administered in the U.S. by date and creates a combo chart, where the bar chart represents total vaccines doses administered and the line graph represents weekly deaths.
- Uses data from the [CDC](https://data.cdc.gov/api/views/unsk-b7fc/rows.csv?accessType=DOWNLOAD), downloaded "2021-12-11 13:16:14 AEDT"
- Uses data from the [CDC](https://data.cdc.gov/api/views/vsak-wrfu/rows.csv?accessType=DOWNLOAD), downloaded "2021-12-11 13:28:40 AEDT"

### `deaths_and_vaxrate_by_county_scatter.R`
- Groups current COVID19 deaths and percent of population vaccinated in the U.S. by county and creates a scatter plot with a 
- Uses data from the [CDC](https://data.cdc.gov/api/views/kn79-hsxy/rows.csv?accessType=DOWNLOAD), downloaded "2021-12-12 16:21:50 AEDT"
- Uses data from the [CDC](https://data.cdc.gov/api/views/8xkx-amqh/rows.csv?accessType=DOWNLOAD), downloaded "2021-12-12 16:22:56 AEDT"
- Uses data from the [US Census Bureau](https://www2.census.gov/programs-surveys/popest/tables/2010-2019/counties/totals/co-est2019-annres.xlsx), downloaded "2021-12-12 16:50:05 AEDT"

## Important Note
While much of the data used within this repo are from validated sources, the analysis and visualizations may not actually represent reality accurately.
According to the [CDC's Estimated COVID-19 Burden report](https://www.cdc.gov/coronavirus/2019-ncov/cases-updates/burden.html):

- 1 in 4.0 (95% UI 3.4-4.7) COVID-19 infections were reported
- 1 in 3.4 (95% UI 3.0-3.8) COVID-19 symptomatic illnesses were reported
- 1 in 1.9 (95% UI 1.7-2.1) COVID-19 hospitalizations were reported
- 1 in 1.32 (95% UI 1.29-1.34) COVID-19 deaths were reported

This suggests that the actual number of COVID-19 cases and deaths in the U.S. may be underrepresented in currently available data. 

Additionally, according to the [CDC's daily COVID-19 updates](https://www.cdc.gov/nchs/nvss/vsrr/covid19/index.htm), COVID-19 deaths may not fully be representative of reality because:

1. States report death counts at differing rates,
2. COVID-19 deaths can include cases with or without laboratory confirmation of COVID-19 (i.e. "presumed COVID-19"), and
3. Deaths *from* and *with* COVID-19 are reported cumulatively.