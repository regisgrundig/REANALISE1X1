;
; transforma reanalise normal em resolucao de 1x1 grau
;
; 19/10/2016
;
;
;---------------------------------------------------------------

load "./mpas_ncl_regis.ncl"

begin 

;
; reanalise monthly means grid 2.5 
;
;
; pressao ao nivel do mar 
;
data=prepara_reanalise("./monthly/slp.mon.mean.nc","slp",1)
slp=reanalise1grau( data )
;
; como slp é a primeira variavel e a estrutura se mantem para as demais
; variaveis
; pego as dimensoes 
;
dims=dimsizes(slp)
nLat=dims(1)
nLon=dims(2) 
lat=slp&lat 
lon=slp&lon
delete(data)
;
; pressao normal superficie
;
data=prepara_reanalise("./monthly/pres.mon.mean.nc","pres",1)
pressao=reanalise1grau( data )
delete(data)
;
; umidade relativa 
;
data=prepara_reanalise("./monthly/rhum.mon.mean.nc","rhum",1)
rhum=reanalise1grau( data )
delete(data)
;
; temperatura 
;
data=prepara_reanalise("./monthly/air.mon.mean.nc","air",1)
temp=reanalise1grau( data )
delete(data)
;
; omega 
;
data=prepara_reanalise("./monthly/omega.sig995.mon.mean.nc","omega",1)
omega=reanalise1grau( data )
delete(data)
;
;
;-----------------------------------------------------------------
;
; reaalise gauss 
;
;
; temperatura a dois metros
;
data=prepara_reanalise("./monthly_gauss/air.2m.mon.mean.nc","air",1)
t2m=reanalise1grau( data )
t2m=t2m-273.15 
delete(data)
;
; concentracao de gelo 
;
data=prepara_reanalise("./monthly_gauss/icec.sfc.mon.mean.nc","icec",1)
icec=reanalise1grau( data )
delete(data)
;
; umidade especifica
;
data=prepara_reanalise("./monthly_gauss/shum.2m.mon.mean.nc","shum",1)
shum=reanalise1grau( data )
delete(data)
;
; skin temperature
;

data=prepara_reanalise("./monthly_gauss/skt.sfc.mon.mean.nc","skt",1)
skin=reanalise1grau( data )
skin=skin-273.15 
delete(data)
;
; vento u 10 metros 
;

data=prepara_reanalise("./monthly_gauss/uwnd.10m.mon.mean.nc","uwnd",1)
u10m=reanalise1grau( data )
delete(data)
;
; vento v 10 metros
;
data=prepara_reanalise("./monthly_gauss/vwnd.10m.mon.mean.nc","vwnd",1)
v10m=reanalise1grau( data )
delete(data)
;
;    
; cria arquivo unico de saida
;
;
fout=addfile("reanalise1x1.nc","c")
;
; estrutura 
;
dimNames = (/"Time", "lat" , "lon"/)
dimSizes = (/-1    , nLat  , nLon/)
dimUnlim = (/True  , False , False/)
filedimdef(fout,dimNames,dimSizes,dimUnlim)
;
;copy global atttibutes from the input to the output file:
;
; fileattdef(fout,slp)
;
;... predefine the dimensionality of the variables to be written out:
;
;
      filevardef(fout,"latitude" ,typeof(lat)  ,(/"lat"/))
      filevardef(fout,"longitude",typeof(lon)  ,(/"lon"/))
      filevardef(fout,"slp",typeof(slp),(/"Time","lat","lon"/))
      filevardef(fout,"pressao",typeof(pressao),(/"Time","lat","lon"/))
      filevardef(fout,"rh",typeof(rhum),(/"Time","lat","lon"/))
      filevardef(fout,"temp",typeof(temp),(/"Time","lat","lon"/))
      filevardef(fout,"omega",typeof(omega),(/"Time","lat","lon"/))
      filevardef(fout,"t2m",typeof(t2m),(/"Time","lat","lon"/))
      filevardef(fout,"icec",typeof(icec),(/"Time","lat","lon"/))
      filevardef(fout,"shum",typeof(shum),(/"Time","lat","lon"/))
      filevardef(fout,"skin",typeof(skin),(/"Time","lat","lon"/))
      filevardef(fout,"u10m",typeof(u10m),(/"Time","lat","lon"/))
      filevardef(fout,"v10m",typeof(v10m),(/"Time","lat","lon"/))

      ;
      ;... output data:
      ;
      fout->latitude  = (/lat/)
      fout->longitude = (/lon/)
      fout->slp = (/slp/)
      fout->pressao = (/pressao/)
      fout->rh = (/rhum/)
      fout->temp = (/temp/)
      fout->omega = (/omega/)
      fout->t2m = (/t2m/)
      fout->icec = (/icec/)
      fout->shum = (/shum/)
      fout->skin = (/skin/)
      fout->u10m = (/u10m/)
      fout->v10m = (/v10m/)
end
