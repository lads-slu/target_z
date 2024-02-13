#convert raster data to data.frame
r.df<-as.data.frame(r,  xy=TRUE)

#center and scale data
for (i in 1:ncol(r.df)){r.df[,i]<-scale(r.df[,i], center=T, scale=T)}

#create df for summary performance statistics
eval<-data.frame(k=1:6, twss=NA) #must do for 1:6 classes to be able to compute statistics for 2:5 classes

#do k means clustering for multiple ks
for (k in 1:6){
  sel<-complete.cases(r.df)
  a<-kmeans(x=r.df[sel,], centers=k)
  rowids<-(1:nrow(r.df))[sel]
  clusterids<-as.numeric(a$cluster)
  r.df[rowids, 'zones']<-clusterids
  
  #compile statistics
  eval[eval$k==k, 'twss']<-a$tot.withinss

  #convert to raster
  zones<-r$r1
  sel<-!is.na(values(zones))
  values(zones)[sel]<-r.df$zones

  #add to raster stack
  if (k %in% 2:5){
    names(zones)<-paste0('zones_',k)
    r<-c(r, zones)
  }
}

#identify optimal number of zones
#elbow method according to https://www.datanovia.com/en/lessons/determining-the-optimal-number-of-clusters-3-must-know-methods/
 reg<-lm(twss~k, eval[c(1,6),])
 for (k in 2:5){
  pred<-predict(reg, eval[k,])
  eval[k, 'twss_gap']<-pred-eval[k, 'twss']
 }
 eval$optimal<-"no"
 k_opt<-which.max(eval$twss_gap)
 sel<-eval$k==k_opt
 eval$optimal[sel]<-'yes'

eval<-eval[2:5,]
eval[,2:3]<-round(eval[,2:3], 1)

#drop input data layers
r_all<-r
sel<-grepl(pattern='zones', x=names(r))
r<-r[[names(r)[sel]]]

#give feedback
print('zones have have been generated')



