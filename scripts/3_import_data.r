#raster
r1<-rast(raster1.tif, prj); crs(r1)<-prj
if(!is.na(raster2.tif)) {r2<-rast(raster2.tif, prj)}
if(!is.na(raster3.tif)) {r3<-rast(raster3.tif, prj)}
if(!is.na(raster4.tif)) {r4<-rast(raster4.tif, prj)}

##polygons
aoi<-vect(aoi.shape, crs=prj)
aoi$id<-1:nrow(aoi) #add id column
aoi<-aoi[,'id'] #keep only id column

#give feedback
print('Data have been imported')