# US COVID19 Data Analysis

This repo contains R code that analyzes publicly available COVID-19 data from the U.S. by cleaning, sorting, and plotting. This repo is currently in-progress.

## Libraries Used
- dplyr
- ggplot2
- scales
- readxl
- reshape2

## Scripts
### `by_age.R`
- Groups current COVID19 cases and deaths in the U.S. by age brackets and plots a grouped bar chart.
- Uses data from the [CDC](https://data.cdc.gov/api/views/9bhg-hcku/rows.csv?accessType=DOWNLOAD), downloaded "2021-12-10 07:00:31 AEDT" 
- Uses data from [Statista](https://www.statista.com/statistics/1254271/us-total-number-of-covid-cases-by-age-group/), generated "2021-12-10 10:06:09 AEDT"

### `by_state.R`
- Groups current COVID19 cases and deaths in the U.S. by state and plots a grouped bar chart.
- Uses data from the [CDC](https://data.cdc.gov/api/views/9mfq-cb36/rows.csv?accessType=DOWNLOAD), downloaded "2021-12-10 16:13:05 AEDT"
