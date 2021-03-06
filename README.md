# nhlMisc

## Mini Project 1:
Scrape play-by-play from NHL games.

### Update
Finished basic functionality after fixing major bugs in first version.  All seasons back to 20112012, including the current season, have been scraped and verified using this script.

### Update 2
Successfully loaded to CartoDB.  Not sure if there is going to be an easy way to update the code without a Carto license (which is how you can get API access that would allow me to run the ETL from R into CartoDB).  For now, might have to deal with static data that is updated manually.

## Mini Project 2:
Spider chart visualizations based on player stats.

### Update
Complete, will probably package this in an app - possibly along with the results of mini project 3.

## Mini Project 3:
Visualization of events on the ice.  Possibly implemented in CartoDB map layer (like the LA Times Kobe shot visualization)

### Update
Cartodb integration is finished.  The LA Times group shared their code for their leaflet/carto integration, so I've been working off of that.  Initial results are good - see the to do section to see what needs to be done still.

### Update 2
Needed to build out the ice on CartoDB - not trivial given the shape of an ice rink and number of important lines to include.  Instead of drawing with polylines, I created a map layer by georeferencing a .PNG of hockey ice.  I then converted it to a leaflet map layer using Maptiler.  The result is pretty cool.

## To Do:
- Pass season to Carto
- Add filter for season on page
- Rebuild map layer to force for better size behavior -- rink built to 1.2 scale, could increase a little more.
- Recode lat/lon to meet the new size (1.2 scale)
- Send more info to tooltip - make field for this in R during parsing (conceptually, do everything possible upfront)
- Format the input buttons better
- ~~Make NHL ice using polylines in leaflet~~
- ~~Fix data that was loaded into Carto as a test~~
- ~~Add layers for each "type"~~
- ~~Add controls to filter and choose layers~~
- Develop quicker function for updating this year's data
- Tie the update function to the app (i.e., parse and load into Carto)
- ~~Fix parser to keep coordinates of events~~
- Create an app displaying the results of mini projects 2 and 3
