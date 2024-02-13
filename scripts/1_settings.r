#remove all objects
rm(list = ls())

#install required packages (if not already installed) and load them
pkgs <- c("terra", "rstudioapi", "class", "sf", "FNN", "scales")
sel <- !pkgs %in% rownames(installed.packages())
if(any(sel)){install.packages(pkgs[sel])}
invisible(lapply(X=pkgs, FUN=require, character.only = TRUE))

#set working directory
wd<-dirname(dirname(getSourceEditorContext()$path)) #now it automatically finds the parent folder to folder where this script is saved
setwd(wd)

#define objects
raster1.tif<-'dsms\\dsms_ler_171214.tif' #name of a tif raster file. All other rasters will be re sampled to this.
raster2.tif<-'dsms\\dsms_sand_171214.tif' #name of a tif raster file or NA
raster3.tif<-NA #name of a tif raster file or NA
raster4.tif<-NA #name of a tif raster file or NA
aoi.shape <- 'in\\field10.shp' # polygon shapefile, only polygon field allowed. If more complex shape, the extent will be used.
out.folder <-'out' #folder to be created under working directory. All exported files are written to this folder.
prj<-"epsg:3006" #projection of all spatial data (Sweref99TM is epsg: 3006)

#set seed
set.seed(123)

#run all
source('scripts\\2_define functions.r')
source('scripts\\3_import_data.r')
source('scripts\\4_prepare_data.r')
source('scripts\\5_generate_zones.r')
source('scripts\\6_convert_to_polygons.r')
source('scripts\\7_export_data.r')