#---parser for extracting more info from play by play
library(tidyverse)

plays <- read.csv('playByPlay20162017.csv', stringsAsFactors = FALSE)

#get assists
goals <- filter(plays, type == 'Goal')

#easy enough, for goals the first player is the scorer and the next 2 are assisting players
assists <- data.frame(stringsAsFactors = FALSE)
for(i in 1:nrow(goals)){
  
}