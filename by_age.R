## by_age
library(dplyr)
library(ggplot2)
library(scales)
library(readxl)
library(reshape2)


## https://data.cdc.gov/api/views/9bhg-hcku/rows.csv?accessType=DOWNLOAD
## downloaded "2021-12-10 07:00:31 AEDT"
## saved as 'covid19deaths.csv'

## https://www.statista.com/statistics/1254271/us-total-number-of-covid-cases-by-age-group/
## generated "2021-12-10 10:06:09 AEDT"
## saved as 'covid19casesbyage.xlsx'


if(!file.exists('./data')){
        dir.create('./data')
}

fileURL <- 'https://data.cdc.gov/api/views/9bhg-hcku/rows.csv?accessType=DOWNLOAD'
download.file(fileURL, destfile = './data/covid19deaths.csv', method = 'curl')
deathsdata <- read.csv('./data/covid19deaths.csv')
byagedata <- read_excel('./data/covid19casesbyage.xlsx', sheet = 2)


## clean covid19 death data
deathsdata <- deathsdata %>% 
        select(Age.Group, COVID.19.Deaths)

deathsdata <- deathsdata[1:17, ] %>%
        slice(-c(1, 2, 4, 5, 6, 8, 10, 12, 14))

deathsdata$Age.Group <- factor(deathsdata$Age.Group, levels = c('0-17 years', '18-29 years',
                                                    '30-39 years', '40-49 years',
                                                    '50-64 years', '65-74 years',
                                                    '75-84 years', '85 years and over'))


## clean covid19 by age data to match groupings above
byagedata <- byagedata[3:13, ]
colnames(byagedata) <- c('Age', 'Count')
byagedata$Count <- as.numeric(byagedata$Count)

y0_17 <- sum(byagedata$Count[1:4])
y18_29 <- byagedata$Count[5]
y30_39 <- byagedata$Count[6]
y40_49 <- byagedata$Count[7]
y50_64 <- byagedata$Count[8]
y65_74 <- byagedata$Count[9]
y75_84 <- byagedata$Count[10]
y85_ <- byagedata$Count[11]

col1 <- c('0-17 years', '18-29 years', '30-39 years', 
          '40-49 years', '50-64 years', '65-74 years', 
          '75-84 years', '85 years and over')
col2 <- c(y0_17, y18_29, y30_39, y40_49, y50_64, y65_74, y75_84, y85_)

casesbyage <- data.frame(col1 = col1, col2 = col2)
colnames(casesbyage) <- c('Age', 'Count')


## merge deaths and cases dfs
df <- data.frame(deathsdata, casesbyage$Count)
colnames(df) <- c('Age', 'Deaths', 'Cases')
df.m <- melt(df, id.vars = 'Age')
colnames(df.m) <- c('Age', 'Type', 'Count')


## plot
p <- ggplot(df.m, aes(Age, Count)) + 
        geom_bar(aes(fill = Type), width = .9, 
                 position = position_dodge(width = .9), stat = 'identity') +
        theme(legend.position = 'top', legend.title = element_blank(), 
              axis.title.x = element_text(), axis.title.y = element_text(),
              plot.title = element_text(hjust = 0.5)) +
        scale_y_continuous(expand = expansion(mult = c(0, .05)), labels = comma, 
                           sec.axis = sec_axis(~./sum(df$Cases), 
                                               labels = percent, 
                                               name = 'Case Fatality Rate')) +
        ggtitle("COVID-19 Case Count, Deaths, and Case Fatality Rate 
                based on Age Group")

p
