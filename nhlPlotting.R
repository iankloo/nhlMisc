library(highcharter)
library(tidyverse)
library(htmltools)

df <- read.csv('playByPlay.csv', stringsAsFactors = FALSE)

#---make plot for single player
player <- 'Brooks Orpik'

playerStats <- df %>%
  filter(playerName == player) %>%
  count(vars = 'type')

highchart() %>% 
  hc_chart(type = 'area', polar = TRUE) %>%
  hc_pane(size = '80%') %>%
  hc_xAxis(categories = playerStats$type, lineWidth = '0', tickmarkPlacement = 'on') %>% 
  hc_yAxis(gridLineInterpolation = 'polygon', lineWidth = '0', min = '0', endOnTick = FALSE, max = max(playerStats$freq)) %>%
  hc_add_series(name = player, data = playerStats$freq, pointPlacement = 'on')


#---make single plot with all players
players <- c('Brooks Orpik', 'Alex Ovechkin', 'Sidney Crosby', 'Evgeni Malkin')

chart <- highchart() %>% 
  hc_chart(type = 'area', polar = TRUE) %>%
  hc_pane(size = '80%') %>%
  hc_xAxis(categories = playerStats$type, lineWidth = '0', tickmarkPlacement = 'on') %>% 
  hc_yAxis(gridLineInterpolation = 'polygon', lineWidth = '0', min = '0', endOnTick = FALSE)

for(i in 1:length(players)){
  playerStats <- df %>%
    filter(playerName == players[i]) %>%
    count(vars = 'type')
  
  chart <- chart %>% hc_add_series(name = players[i], data = playerStats$freq, pointPlacement = 'on', fillOpacity = .20, lineWidth = 0, marker = list(enabled = FALSE))
}

chart



#---make plots for multiple players

players <- c('Brooks Orpik', 'Alex Ovechkin', 'Sidney Crosby', 'Evgeni Malkin')
types <- c('Shot', 'Hit', 'Goal', 'Fight', 'Penalty')
exclude <- 'Fight'
varNum <- 1
chartList <- list()
maxStat <- 0
for(i in 1:length(players)){
  playerStats <- df %>%
    filter(playerName == players[i]) %>%
    count(vars = 'type')
  
  if(max(playerStats$freq) > maxStat){
    maxStat <- max(playerStats$freq)
  }
}
for(i in 1:length(players)){
  playerStats <- df %>%
    filter(playerName == players[i]) %>%
    count(vars = 'type')
  
  for(j in 1:length(types)) {
    if(!types[j] %in% playerStats$type){
      playerStats <- rbind(playerStats, data.frame(type = types[j], freq = 0))
    }
  }
  
  for(k in 1:length(exclude)){
    if(exclude[k] %in% playerStats$type){
      playerStats <- playerStats[which(playerStats$type != exclude[k]),]
    }
  }
  
  playerStats <- playerStats[order(playerStats$type),]
  
  chart <- highchart() %>% 
    hc_chart(type = 'area', polar = TRUE) %>%
    hc_title(text = players[i]) %>%
    hc_legend(enabled = FALSE) %>%
    hc_pane(size = '80%') %>%
    hc_xAxis(categories = playerStats$type, lineWidth = '0', tickmarkPlacement = 'on') %>% 
    hc_yAxis(gridLineInterpolation = 'polygon', lineWidth = '0', min = '0', max = maxStat + 5, endOnTick = FALSE) %>%
    hc_add_series(name = players[i], data = playerStats$freq, pointPlacement = 'on', lineWidth = 0, marker = list(enabled = FALSE))
  
  varName <- paste('chart',varNum, sep = '')
  assign(varName, chart)
  varNum <- varNum + 1
  
  chartList[[varName]] <- chart
}

browsable(hw_grid(chartList, ncol = 2))






