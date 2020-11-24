library(readr)
#reading dataset
students <-  read_csv("dataset.csv")


#shapefile
states.shp <- rgdal::readOGR(dsn=path.expand('STE_2016_AUST.shp'), layer = 'STE_2016_AUST')


# configure the global sessions when the app initially starts up.
polished::global_sessions_config(
  app_name = "aus_students",
  api_key = "FRM44MKpDwuOHTfgyRrUJXuaQi9inwcVvz"
)