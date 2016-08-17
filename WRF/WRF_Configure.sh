#!/bin/csh
setenv main /pub/baoxianp/Build_WRF #set to WRF directory
mkdir CaseDomain
cd CaseDomain
mkdir WPS
cd WPS
cp $main/WPS/namelist.wps ./namelist.wps
ln -sf $main/WPS/*.exe  . 
mkdir geogrid
ln -sf $main/WPS/geogrid/GEOGRID.TBL geogrid/GEOGRID.TBL 
./geogrid.exe
ln -sf $main/WPS/ungrib/Variable_Tables/Vtable.GFS Vtable #set to specific driven data
ln -sf $main/WPS/link_grib.csh link_grib.csh
#chmod +x link_grib.csh
./link_grib.csh /pub/baoxianp/Build_WRF/DATA/GFS/gfsanl #/pub/baoxianp/Buid_WRF/DATA/test2/data/fnl* #driven data here#
./ungrib.exe
mkdir metgrid
ln -sf $main/WPS/metgrid/METGRID.TBL metgrid/METGRID.TBL 
./metgrid.exe

cd ..
mkdir WRF
cd WRF
ln -sf $main/WRFV3/run/*_DATA*  . 
ln -sf $main/WRFV3/run/ETAMP*  . 
ln -sf $main/WRFV3/run/*.TBL  . 
ln -sf $main/WRFV3/run/tr*  . 
ln -sf $main/WRFV3/run/*.txt . 
ln -sf $main/WRFV3/run/*.tbl  . 
ln -sf $main/WRFV3/run/*.formatted  . 
ln -sf $main/WRFV3/main/*.exe . 
ln -sf ../WPS/met_em* .

cp $main/WRFV3/run/namelist.input .
