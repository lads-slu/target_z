#define function for creating folder, if it does not exist
wdif<-function(x){if(!dir.exists(x))dir.create(x)}

#define function for saving text-files
txt<-function(x, path, fname){
  a<-paste0(path,'\\' ,fname)
  write.table(x, file = a, sep = '\t', row.names = F)
}

#sort data.frame by angle to center
sortxy<-function(a){
  x<-a$x-mean(a$x)
  y<-a$y-mean(a$y)
  alfa<-atan2(y,x)
  sel<-order(alfa) 
  a<-a[sel,]
  return(a)
}

#give feedback
print('Functions have been defined')
