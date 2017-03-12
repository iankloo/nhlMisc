# nhlMisc

## Mini Project 1:
Scrape play-by-play from NHL games.

### Update
Finished basic functionality after fixing major bugs in first version.  All seasons back to 20112012, including the current season, have been scraped and verified using this script.

## Mini Project 2:
Spider chart visualizations based on player stats.

### Update
Complete, will probably package this in an app - possibly along with the results of mini project 3.

## Mini Project 3:
Visualization of events on the ice.  Possibly implemented in CartoDB map layer (like the LA Times Kobe shot visualization)

###Update
Cartodb integration is finished.  The LA Times group shared their code for their leaflet/carto integration, so I've been working off of that.  Initial results are good - see the to do section to see what needs to be done still.


## To Do:
- Fix parser to find assists (not recorded as "events" by the tracker)
- Fix parser to find saves (not recorded as "events" by the tracker)
- Make NHL ice using polylines in leaflet
- Fix data that was loaded into Carto as a test
- Add layers for each "type"
- Add controls to filter and choose layers
- Develop quicker function for updating this year's data
- Tie the update function to the app (i.e., parse and load into Carto)
- ~~Fix parser to keep coordinates of events~~
- Create an app displaying the results of mini projects 2 and 3

