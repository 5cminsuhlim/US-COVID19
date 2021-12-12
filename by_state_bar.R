## by_state
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

df.m <- melt(states, id.vars = 'State')
colnames(df.m) <- c('State', 'Type', 'Count')


p <- ggplot(df.m, aes(State, Count)) + 
        geom_bar(aes(fill = Type), width = .9, 
                 position = position_dodge(width = .9), stat = 'identity') +
        theme(legend.position = 'top', legend.title = element_blank(), 
              axis.title.x = element_text(), 
              axis.title.y.left = element_text(vjust = 3),
              axis.title.y.right = element_text(vjust = 3),
              plot.title = element_text(hjust = 0.5)) +
        scale_y_continuous(expand = expansion(mult = c(0, .05)), labels = comma, 
                           sec.axis = sec_axis(~./sum(states$Total.Cases), 
                                               labels = percent, 
                                               name = 'Case Fatality Rate')) +
        scale_fill_discrete(labels = c('Total Cases', 'Total Deaths')) +
        ggtitle("COVID-19 Case Count, Deaths, and Case Fatality Rate 
                based on Age Group")

p