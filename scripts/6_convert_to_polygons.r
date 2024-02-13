#coordinate names
xy<-c("x","y") 
res<-res(r)[1]

#modal filter for 3m*3m (to remove small zones islands)
r<-extend(r, 3)
r<-focal(r, w=c(3,3), fun="modal", na.rm=T, pad=T)
r<-focal(r, w=c(3,3), fun="modal", na.rm=T, pad=T)

for (k in 2:5){
  #copy raster layer
  layername<-paste0("zones_", k)
  rr<-r[[layername]]
  names(rr)<-"zone"
  
  #create polygons
  p<-as.polygons(rr)
  p<-disagg(p)
  p$id<-1:nrow(p)
  
  #create points
  pts<-as.points(p)
  
  #convert to data.frame and add id columns  d<-data.frame(geom(pts),zone=pts$zone)
  d<-data.frame(geom(pts), id=pts$id, zone=pts$zone)
  
  #move points
  dd<-d
  n<-20
  for (i in 1:n){d
    dd$x<-knn.reg(train=dd[,xy], test = d[,xy], y=dd$x, k = 3)$pred
    dd$y<-knn.reg(train=dd[,xy], test = dd[,xy], y=dd$y, k = 3)$pred
  }
  ucols<-c(xy,"id")
  dd<-unique(round(dd[,ucols]))

  # recreate polygons
  ptids<-unique(d$id)
  rm(p)
  for (i in 1:length(ptids)){
    sel<-dd$id==ptids[i]
    a<-dd[sel,xy]
    if(nrow(a)<3)  next
    #a<-sortxy(a)
    a<-rbind(a, a[1,])
    apts<-vect(a, geom=xy, prj)
    alns<-as.lines(apts)
    apls<-as.polygons(alns)
    if(nrow(apls)==0) next
    if(!exists("p")){p<-apls} else {p<-p+apls}
    }

#crop with aoi
if(nrow(aoi)>1) {aoi<-as.polygons(ext(aoi), prj)}
p<-intersect(p, aoi)
p$id<-as.factor(1:nrow(p))

#extract zone for polygon center points
cp<-centroids(x=p, inside=TRUE)
r3<-focal(rr, w=c(3,3), fun="modal", na.rm=T, pad=T)
p$zone<-extract(r3, cp, fun=median,na.rm=T, ID=F) 
p<-aggregate(p, by="zone", dissolve=T)

#do two rounds of fixing
for (i in 1:2){
  #add missing areas
  slivers<-(aoi-p)
  values(p)<-NULL
  values(slivers)<-NULL
  if(nrow(slivers) >0) p<-p+slivers
  p$id<-1:nrow(p)
  
  #extract zone for polygon center points
  cp<-centroids(x=p, inside=TRUE)
  r3<-focal(rr, w=c(3,3), fun="modal", na.rm=T, pad=T)
  p$zone<-extract(r3, cp, fun=median,na.rm=T, ID=F) 
  p<-aggregate(p, by="zone", dissolve=T)

  #merge small polygons with large neighbor
  p<-disagg(p)
  p$area<-round(expanse(p))
  small <- p$area<=3*(res^2)
  if(sum(small)>0) p <- combineGeoms(p[!small], p[small])
  p$area<-round(expanse(p))

  #extract zone for polygon center points
  cp<-centroids(x=p, inside=TRUE)
  r3<-focal(rr, w=c(3,3), fun="modal", na.rm=T, pad=T)
  p$zone<-extract(r3, cp, fun=median,na.rm=T, ID=F) 
  p<-aggregate(p, by="zone", dissolve=T)
}

#fix attributes
zones<-p$zone
values(p)<-NULL
p$zone<-zones
p$id<-1:nrow(p)
p$area<-round(expanse(p))

#asign vectyor of polygons
assign(x=layername, value=p)
}

#mask raster
r<-crop(r, aoi, mask=TRUE)

