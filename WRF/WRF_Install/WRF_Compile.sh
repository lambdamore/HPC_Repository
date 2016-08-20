#!/bin/bash
cd WRF/LIBRARIES
export DIR="$(pwd)"
export CC="gcc"
export CXX="g++"
export FC="gfortran"
export FCFLAGS="-m64"
export F77="gfortran"
export FFLAGS="-m64"
export PATH="$DIR/netcdf/bin:$PATH"
export NETCDF="$DIR/netcdf"
export PATH="$DIR/mpich/bin:$PATH"
export LDFLAGS="-L$DIR/grib2/lib"
export CPPFLAGS="-I$DIR/grib2/include"
#unset F90
#unset F90FLAGS
export JASPERLIB="$DIR/grib2/lib"
export JASPERINC="$DIR/grib2/include"
echo export DIR=$DIR >> global.sh
echo export CC="gcc" >> global.sh
echo export CXX="g++" >> global.sh
echo export FC="gfortran" >> global.sh
echo export FCFLAGS="-m64" >> global.sh
echo export F77="gfortran" >> global.sh
echo export FFLAGS="-m64" >> global.sh
echo export PATH="$DIR/netcdf/bin:$PATH" >> global.sh
echo export NETCDF="$DIR/netcdf" >> global.shd WRF
echo export PATH="$DIR/mpich/bin:$PATH" >> global.sh
echo export LDFLAGS="-L$DIR/grib2/lib"  >> global.sh
echo export CPPFLAGS="-I$DIR/grib2/include" >> global.sh
echo export JASPERLIB="$DIR/grib2/lib" >>global.sh
echo export JASPERINC="$DIR/grib2/include"  >>global.sh
#echo unset F90 >> global.sh
#echo unset F90FLAGS >> global.sh
source global.sh


cd ..
wget -q http://www2.mmm.ucar.edu/wrf/src/WRFV3.8.TAR.gz
gunzip WRFV3.8.TAR.gz
tar -xf WRFV3.8.TAR
cd WRFV3
./clean -a
export WRF_EM_CORE=1
echo set timeout 30 >>auto_configure
echo spawn ./configure >>auto_configure
echo expect "\"*1-71* :\"" >>auto_configure
echo send 34\\n >>auto_configure
echo expect "\"*default 1*\"" >>auto_configure
echo send 1\\n >>auto_configure
echo interact >>auto_configure
expect auto_configure

./compile em_real 

v_exe=$(ls -ls main/*.exe);
if [[ $v_exe == *"wrf.exe"* ]] && [[ $v_exe == *"real.exe"* ]] && [[ $v_exe == *"ndown.exe"* ]] && [[ $v_exe == *"tc.exe"* ]]
then
        echo "wrf.exe exists!" >>$main/wrf_log;
else
        echo "wrf.exe not exists!" >>$main/wrf_error;
        exit;
fi

cd ..
wget -q http://www2.mmm.ucar.edu/wrf/src/WPSV3.8.TAR.gz

gunzip WPSV3.8.TAR.gz
tar -xf WPSV3.8.TAR
cd WPS
./clean
export JASPERLIB="$DIR/grib2/lib"
export JASPERINC="$DIR/grib2/include"

echo set timeout 30 >>auto_configure
echo spawn ./configure >>auto_configure
echo expect "*1-40*" >>auto_configure
echo send 1\\n >>auto_configure
echo interact >>auto_configure
expect auto_configure


WRF_DIR = ../WRFV3
./compile
v_exe=$(ls -ls *.exe);
if [[ $v_exe == *"geogrid.exe"* ]] && [[ $v_exe == *"ungrib.exe"* ]] && [[ $v_exe == *"metgrid.exe"* ]]
then
        echo "$* exists!" >>$main/wrf_log;
else
        echo "$* not exists!" >>$main/wrf_error;
        exit;
fi

cd ..
# wget -q http://www2.mmm.ucar.edu/wrf/src/wps_files/geog_complete.tar.bz2
wget -q http://www2.mmm.ucar.edu/wrf/src/wps_files/geog_minimum.tar.bz2
gunzip geog.tar.gz
tar -xf geog.tar
mv geog WPS_GEOG

rm *.TAR


