## by_state_map
library(dplyr)
library(ggplot2)
library(reshape2)
library(maps)

## https://data.cdc.gov/api/views/9mfq-cb36/rows.csv?accessType=DOWNLOAD
## downloaded "2021-12-10 16:13:05 AEDT"
## saved as 'covid19states.csv'

if(!file.exists('./data')){
        dir.create('./data')
}

fileURL <- 'https://data.cdc.gov/api/views/9mfq-cb36/rows.csv?accessType=DOWNLOAD'
download.file(fileURL, destfile = './data/covid19states.csv', method = 'curl')
states <- read.csv('./data/covid19states.csv')


mainstates <- map_data('state') %>%
                rename(State = region)
mainstates$State <- state.abb[match(mainstates$State, tolower(state.name))]

## change submission_date column to date objects
## order df by submission_date (newest to oldest) and state alphabetically
## filter for only rows associated w/ the 50 US states
## get the most recent uploaded data for each 50 states
## only keep submission_date, state, tot_cases, tot_death
states <- states %>%
        mutate(submission_date = as.Date(submission_date, '%m/%d/%Y')) %>%
        arrange(desc(submission_date), state) %>%
        filter(state %in% state.abb) %>%
        head(50) %>%
        rename(State = state, Total.Cases = tot_cases, Total.Deaths = tot_death) %>% 
        select(State, Total.Cases, Total.Deaths)


states <- states %>%
        arrange(desc(Total.Cases))

merged <- inner_join(mainstates, states, by = 'State')

centroids <- merged %>% 
        group_by(State) %>%
        summarize_at(vars(long, lat), ~mean(range(.)))


p <- ggplot(merged, aes(long, lat)) + 
        geom_polygon(aes(x = long, y = lat, group = group, 
                         fill = Total.Deaths / Total.Cases), color = 'black', 
                     size = .1) +
        geom_text(data = centroids, aes(x = long, y = lat, label = State), 
                  size = 2, color = 'black') + 
        theme(legend.position = 'right', legend.title = element_text(), 
              axis.title.x = element_blank(), axis.title.y = element_blank(),
              axis.ticks = element_blank(), axis.text = element_blank(),
              plot.title = element_text(hjust = 0.5)) + 
        scale_fill_continuous(name = "Case Fatality Rate", low = '#FFFFCC', high = '#800026') +
        ggtitle("USA Heatmap based on COVID-19 Case Fatality Rate") +
        coord_map()

p