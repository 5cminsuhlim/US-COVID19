## deaths_and_vaxrate_by_county_scatter.R
library(dplyr)
library(ggplot2)
library(reshape2)
library(lubridate)
library(scales)
library(readxl)
library(stringr)
library(tidyr)
library(ggpmisc)


## https://data.cdc.gov/api/views/kn79-hsxy/rows.csv?accessType=DOWNLOAD
## downloaded "2021-12-12 16:21:50 AEDT"
## saved as 'covid19deathscounty.csv'

## https://data.cdc.gov/api/views/8xkx-amqh/rows.csv?accessType=DOWNLOAD
## downloaded "2021-12-12 16:22:56 AEDT"
## saved as 'covid19vaxcounty.csv'

## https://www2.census.gov/programs-surveys/popest/tables/2010-2019/counties/totals/co-est2019-annres.xlsx
## downloaded "2021-12-12 16:50:05 AEDT"
## saved as 'covid19countypop.csv'
## NOTE: too large to push via git

if(!file.exists('./data')){
        dir.create('./data')
}

fileURL <- 'https://data.cdc.gov/api/views/kn79-hsxy/rows.csv?accessType=DOWNLOAD'
download.file(fileURL, destfile = './data/covid19deathscounty.csv', method = 'curl')
deathsdata <- read.csv('./data/covid19deathscounty.csv')

fileURL <- 'https://data.cdc.gov/api/views/8xkx-amqh/rows.csv?accessType=DOWNLOAD'
download.file(fileURL, destfile = './data/covid19vaxcounty.csv', method = 'curl')
vaxdata <- read.csv('./data/covid19vaxcounty.csv')

fileURL <- 'https://www2.census.gov/programs-surveys/popest/tables/2010-2019/counties/totals/co-est2019-annres.xlsx'
download.file(fileURL, destfile = './data/covid19countypop.csv', method = 'curl')
pop <- read_excel('./data/covid19countypop.csv', skip = 3)


## format deathsdata
deathsdata <- deathsdata %>%
        rename(Date = End.Date, FIPS = FIPS.County.Code, 
               County = County.name,
               Deaths = Deaths.involving.COVID.19) %>%
        mutate(Date = mdy(Date), FIPS = as.numeric(FIPS)) %>%
        filter(!is.na(Date), !is.na(State), !is.na(County), !is.na(FIPS), 
               !is.na(Deaths)) %>%
        arrange(State, County) %>%
        select(Date:FIPS, Deaths)


## set up restrictions on dates from which data will be used
oldest <- head(deathsdata$Date, 1)
newest <- tail(deathsdata$Date, 1)


## format vaxdata
vaxdata <- vaxdata %>%
        rename(State = Recip_State, County = Recip_County, 
               Pct.Full.Vax = Series_Complete_Pop_Pct) %>%
        mutate(Date = mdy(Date), FIPS = as.numeric(FIPS)) %>%
        filter(!is.na(Date), !is.na(State), !is.na(County), !is.na(FIPS),
               !is.na(Pct.Full.Vax), 
               between(Date, ymd(oldest), ymd(newest))) %>%
        arrange(State, County) %>%
        select(Date, State, County, FIPS, Pct.Full.Vax)


## format pop
pop$...1 <- str_remove(pop$...1, '.')
pop <- pop %>%
        slice(-c(1, 3144:3149))
pop <- separate(pop, col = ...1, into = c('County', 'State'), sep = ', ')
pop$State <- state.abb[match(tolower(pop$State), tolower(state.name))]
pop <- pop %>%
        rename(Est.Pop.2019 = `2019`) %>%
        arrange(State, County) %>%
        select(State, County, Est.Pop.2019)


## join everything together
merged <- inner_join(deathsdata, vaxdata)
merged <- inner_join(merged, pop)
merged <- merged %>%
        mutate(COVID.Mort.Rate = Deaths / Est.Pop.2019)


## plot
## stat_poly_eq SOURCE: 
## https://stackoverflow.com/questions/7549694/add-regression-line-equation-and-r2-on-graph
p <- ggplot(data = merged, aes(x = Pct.Full.Vax, y = COVID.Mort.Rate)) +
        geom_point(color = 'darkgreen', size = 0.7) +
        geom_smooth(method = lm, se = TRUE, fullrange = TRUE, level = 0.95,
                    color = 'darkred', fill = 'blue') +
        stat_poly_eq(formula = y ~ x, eq.with.lhs = "italic(hat(y))~`=`~",
                     aes(label = paste(..eq.label.., ..rr.label.., 
                                       sep = "*plain(\",\")~~~")),
                     parse = TRUE) +
        labs(title = 'COVID-19 Mortality Rate according to 
             Percent of Population Fully Vaccinated by County', 
             x = 'Percent of Population Fully Vaccinated',
             y = 'COVID-19 Mortality Rate') + 
        theme(axis.title.x = element_text(), 
              axis.title.y.left = element_text(vjust = 3),
              axis.title.y.right = element_text(vjust = 3),
              plot.title = element_text(hjust = 0.5))

p
