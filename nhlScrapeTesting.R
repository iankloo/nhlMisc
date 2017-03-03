library(RCurl)
library(RJSONIO)
library(dplyr)
#--------scrape a ton of nhl game play by play

setwd('C:/Users/iankl/Desktop/nhlMisc')

scrapeSeason <- function(season){

  season <- season
  
  
  #---find the game id's
  url <- paste('http://live.nhl.com/GameData/SeasonSchedule-', season, '.json', sep = '')
  gameInfo <- getURL(url)%>%
    fromJSON() %>%
    do.call(rbind, .) %>%
    apply(., FUN = unlist, 2) %>%
    as.data.frame(stringsAsFactors=FALSE)
  
  gameInfo[,'est'] <- as.POSIXct(gameInfo[,'est'], format = '%Y%m%d %T')
  
  #---scrape games before today
  startDate <- min(gameInfo$est)
  if(max(gameInfo$est) > Sys.time()){
    endDate <- Sys.time()
  } else{
    endDate <- max(gameInfo$est)
  }
  
  #gameIDs <- gameInfo[gameInfo$est >= startDate & gameInfo$est < endDate & (gameInfo$a == 'PIT' | gameInfo$h == 'PIT'), c('id','est')]
  
  gameIDs <- gameInfo[gameInfo$est >= startDate & gameInfo$est < endDate, c('id','est')]
  
  x <- vector(mode="list", nrow(gameIDs))
  pb <- txtProgressBar(1,nrow(gameIDs), style = 3)
  count <- 1
  errorCount <- 0
  for(i in 1:nrow(gameIDs)){
    tryCatch({
      gameParse <- paste('http://live.nhl.com/GameData/', season, '/', gameIDs[i, 'id'], '/PlayByPlay.json', sep = '') %>%
        getURL() %>%
        fromJSON()
    },error=function(e){
      cat("ERROR :",conditionMessage(e), "\n")
      errorCount <<- errorCount + 1
    })
    
    if(length(gameParse[['data']][['game']][['plays']][['play']]) == 0){
      next
    }
    
    suppressWarnings(
      plays <- gameParse[['data']][['game']][['plays']][['play']] %>%
        Reduce(rbind,.) %>%
        data.frame() %>%
        select(sweater, desc, type, playername, p1name, p2name, p3name, time, period, xcoord, ycoord) %>%
        cbind(awayTeam = gameParse[['data']][['game']][['awayteamname']]) %>%
        cbind(homeTeam = gameParse[['data']][['game']][['hometeamname']]) %>%
        cbind(est = gameIDs[i, 'est'])
    )
    
    validTypes <- c('Shot', 'Hit', 'Goal', 'Fight', 'Penalty')
    plays <- plays[plays$type %in% validTypes,]
    
    
    if(length(unique(plays$type)) > 5){
      print(i)
      break
    }
    
    x[[i]] <- plays
    
    setTxtProgressBar(pb, count)
    count <- count + 1
  }
  
  dfNew <- do.call('rbind', x)
  dfNew <- data.frame(lapply(dfNew, as.character), stringsAsFactors=FALSE)
  print(paste(errorCount, 'errors'))
  dfNew
}

df <- scrapeSeason('20132014')

write.csv(df, 'playByPlay20132014.csv', row.names = FALSE)

