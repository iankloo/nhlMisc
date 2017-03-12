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
  
  gameIDs <- gameInfo[gameInfo$est >= startDate & gameInfo$est < endDate, ]
  
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
    
    plays <- gameParse[['data']][['game']][['plays']][['play']]
    playsList <- list()
    fields <- c('sweater', 'desc', 'type', 'playername', 'p1name', 'p2name', 'p3name', 'time', 'period', 'xcoord', 'ycoord')
    for(j in 1:length(plays)){
      play <- plays[[j]]
      
      for(k in 1:length(fields)){
        if(is.null(play[[fields[k]]])){
          play[[fields[k]]] <- NA
        }
      }
      
      temp <- play[fields]
      playsList[[j]] <- as_data_frame(temp)
    }
    
    playsDF <- do.call('rbind', playsList)
    playsDF$home <- gameIDs[i, 'h']
    playsDF$away <- gameIDs[i, 'a']
    playsDF$date <- gameIDs[i, 'est']

    x[[i]] <- playsDF
    
    setTxtProgressBar(pb, count)
    count <- count + 1
  }
  
  dfNew <- do.call('rbind', x)
  dfNew <- data.frame(lapply(dfNew, as.character), stringsAsFactors=FALSE)
  print(paste(errorCount, 'errors'))
  dfNew
}

seasonTargets <- c('20112012', '20122013', '20132014', '20142015', '20152016', '20162017')

for(z in 1:length(seasonTargets)){
  df <- scrapeSeason(seasonTargets[z])
  file <- paste('playByPlay', seasonTargets[z], '.csv', sep = '')
  write.csv(df, file, row.names = FALSE)
  print(paste(seasonTargets[z], 'done'))
}
