(in Swedish)

#1.	I filen scripts\\1_settings.r görs alla ändringar (sökvägar etc). 
#övriga skript ska aldrig behöva öppnas utan körs från detta huvudskript. 
#R-paket som  behövs men inte finns installerade kommer att installeras och en 
#mapp kommer skapas under "working directory" dit utdata exporteras.

#2.	Man kan importera ett till fyra raster, som zonindelningen baserases på. 
    Dessa kan till exempel läggas i mappen serverdata. Det kan satellitbaserade 
    indexkartor (förslagsvis  NDRE75 från DC37), höjddata eller lerhaltsraster. 
    Sätt det mest högupplösta rastret som raster 1, då de andra rastren 
    resamplas till detta rasters upplösning.

#3.	Shapefil med blockgräns kan till exempel läggas i mappen userdata. 

#4. Följande exporteras till den specificerade utdatafoldern: 
    -rasterfiler med två till fem zoner (t e x zones4.tif).
    -polygon-shapefiler med två till fem zoner (t e x zones4.shp).
    -textfil med en siffra som talar om vilket antal zoner som är 
    statistiskt optimalt (k_opt.txt).
    -textfiler med utvärderingsstatistik för alla antal klasser (eval.txt). 
    Denna är antagligen inte så intressant att visa i ett system.

#5. Gör så här:
1) ändra till egna settings (sökvägar et c) i filen scripts\\1_settings.r 
2) Kör hela skriptet scripts\\1_settings.r.
3) Hämta data i den specificerade utdatafoldern.
