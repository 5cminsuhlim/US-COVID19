## deaths_and_vaxdoses_by_date_combo
library(dplyr)
library(ggplot2)
library(reshape2)
library(lubridate)
library(scales)


## https://data.cdc.gov/api/views/unsk-b7fc/rows.csv?accessType=DOWNLOAD
## downloaded "2021-12-11 13:16:14 AEDT"
## saved as 'covid19vax.csv'

## https://data.cdc.gov/api/views/vsak-wrfu/rows.csv?accessType=DOWNLOAD
## downloaded "2021-12-11 13:28:40 AEDT"
## saved as 'covid19casesweekly.csv'


if(!file.exists('./data')){
        dir.create('./data')
}

fileURL <- 'https://data.cdc.gov/api/views/unsk-b7fc/rows.csv?accessType=DOWNLOAD'
download.file(fileURL, destfile = './data/covid19vax.csv', method = 'curl')
vaxdata <- read.csv('./data/covid19vax.csv')

fileURL <- 'https://data.cdc.gov/api/views/vsak-wrfu/rows.csv?accessType=DOWNLOAD'
download.file(fileURL, destfile = './data/covid19casesweekly.csv', method = 'curl')
casesdata <- read.csv('./data/covid19casesweekly.csv')


## format casesdata
casesdata <- casesdata %>%
        rename(Date = End.Week, MMWR_week = MMWR.Week, Deaths = COVID.19.Deaths,
               Age = Age.Group) %>%
        mutate(Date = mdy(Date)) %>%
        filter(Date <= ymd('2021-12-04'), grepl('All Ages', Age)) %>%
        arrange(Date) %>%
        select(Date, MMWR_week, Age, Deaths) %>%
        group_by(Date) %>%
        summarize(Deaths = sum(Deaths))


## set up restrictions on dates from which data will be used
oldest <- head(casesdata$Date, 1)
newest <- tail(casesdata$Date, 1)


## format vax data
vaxdata <- vaxdata %>%
        mutate(Date = mdy(Date)) %>%
        filter(between(Date, ymd(oldest), ymd(newest))) %>%
        arrange(Date) %>%
        select(Date, MMWR_week, Administered) %>%
        group_by(Date) %>%
        summarize(Administered_100k = sum(Administered) / 100000)


## plot
ggplot() +
        geom_bar(data = vaxdata, aes(x = Date, y = Administered_100k), 
                 width = .5, position = position_dodge(width = .5), 
                 stat = 'identity', fill = 'steelblue') +
        geom_line(data = casesdata, aes(x = Date, y = Deaths), stat = 'identity', 
                  group = 1, size = 1, color = 'red') +
        theme(axis.title.x = element_text(), 
              axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
              axis.title.y.left = element_text(color = 'red', vjust = 3),
              axis.title.y.right = element_text(color = 'steelblue', vjust = 3),
              plot.title = element_text(hjust = 0.5)) +
        scale_x_date(date_breaks = "1 month", date_labels =  "%b %Y") +
        scale_y_continuous(expand = expansion(mult = c(0, .05)), labels = comma, 
                           sec.axis = sec_axis(~., name = 'Total Doses Administered (in 100k)')) +
        ylab("Daily Deaths") +
        ggtitle("COVID-19 Daily Deaths and Total Vaccine Doses Administered")
