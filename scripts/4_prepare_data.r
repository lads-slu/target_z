#resample all rasters to have the same origin and resolution as r1 and c them
names(r1)<-'r1'
crs(aoi)<-crs(r1)
r1<-crop(x=r1, y=aoi)
r<-r1

if(!is.na(raster2.tif)) {
  r2<-resample(x=r2, y=r, method ='bilinear')
  r2<-crop(x=r2, y=r)
  names(r2)<-'r2'
  r<-c(r, r2)
}

if(!is.na(raster3.tif)) {
  r3<-resample(x=r3, y=r, method ='bilinear')
  r3<-crop(x=r3, y=r)
  names(r3)<-'r3'
  r<-c(r, r3)
}

if(!is.na(raster4.tif)) {
  r4<-resample(x=r4, y=r, method ='bilinear')
  r3<-crop(x=r4, y=r)
  names(r4)<-'r4'
  r<-c(r, r4)
}

#mask all rasters with aoi, skrink and extend (to remove unwanted edge effects)
aoi_small<-buffer(aoi, -res(r)[1])
r<-mask(r, aoi_small)
r<-extend(x=r, y=aoi)

#give feedback
print('Data have been prepared')