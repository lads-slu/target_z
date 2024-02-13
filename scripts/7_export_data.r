#create output folder, if it does not exist
wdif(out.folder)

#write raster
fname<-file.path(out.folder, paste0(names(r), ".tif"))
writeRaster(x=r, fname, filetype='GTiff', overwrite=TRUE)

#write shapefiles
for (k in 2:5){
  vectname<-paste0("zones_", k)
  fname<-file.path(out.folder, paste0(vectname, ".shp"))
  writeVector(get(vectname),fname, overwrite=T)
  plot(get(vectname), "zone")
  
  vectname<-paste0("zones_", k, "_jagged")
  fname<-file.path(out.folder, paste0(vectname, "_jagged.shp"))
  writeVector(get(vectname),fname, overwrite=T)
  plot(get(vectname), "zone")
}

#write text-files
txt(x=eval, path=out.folder, fname='eval.txt')
txt(x=k_opt, path=out.folder, fname='k_opt.txt')

#give feedback
print('Data have been exported')