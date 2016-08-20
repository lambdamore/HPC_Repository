#!/bin/bash
export main="$(pwd)"
function exist_test()
{
	v=$(which $*);
	if [[ $v == *"/bin/$*"* ]]
	then 
		echo "$* exists!" >>$main/wrf_log;
	else
		echo "$* not exists!" >>$main/wrf_error;
		exit;
	fi
};
exist_test gfortran
exist_test cpp
exist_test gcc

mkdir TEST
cd TEST
wget -q http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar;
tar -xf Fortran_C_tests.tar;

function success_test()
{
	echo "$*" >>$main/wrf_log;
	if [[ $* != *"SUCCESS"* ]]
        then
		echo "$*" >>$main/wrf_error;
                exit;
        fi
}
gfortran TEST_1_fortran_only_fixed.f
fixed_format_fortran_test=$(./a.out);
success_test $fixed_format_fortran_test

gfortran TEST_2_fortran_only_free.f90
free_format_fortran_test=$(./a.out);
success_test $free_format_fortran_test

gcc -c -m64 TEST_4_fortran+c_c.c
gfortran -c -m64 TEST_4_fortran+c_f.f90
gfortran -m64 TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
c_test=$(./a.out);
success_test $c_test

csh_test=$(./TEST_csh.csh);
perl_test=$(./TEST_perl.pl);
sh_test=$(./TEST_sh.sh);

success_test $csh_test
success_test $perl_test
success_test $sh_test
cd ..

mkdir WRF
cd WRF
mkdir LIBRARIES
cd LIBRARIES
wget -q http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/mpich-3.0.4.tar.gz
wget -q http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/netcdf-4.1.3.tar.gz
wget -q http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz
wget -q http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz
wget -q http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.7.tar.gz

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
unset F90
unset F90FLAGS
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
echo export NETCDF="$DIR/netcdf" >> global.sh 
echo export PATH="$DIR/mpich/bin:$PATH" >> global.sh 
echo export LDFLAGS="-L$DIR/grib2/lib"  >> global.sh 
echo export CPPFLAGS="-I$DIR/grib2/include" >> global.sh 
echo export JASPERLIB="$DIR/grib2/lib" >>global.sh
echo export JASPERINC="$DIR/grib2/include"  >>global.sh
echo unset F90 >> global.sh 
echo unset F90FLAGS >> global.sh 
source global.sh


tar xzf  netcdf-4.1.3.tar.gz
cd netcdf-4.1.3
./configure --prefix=$DIR/netcdf --disable-dap --disable-netcdf-4 --disable-shared
make
make install
cd ..

tar xzf mpich-3.0.4.tar.gz 
cd mpich-3.0.4
./configure --prefix=$DIR/mpich
make
make install
cd ..

tar xzf zlib-1.2.7.tar.gz 
cd zlib-1.2.7
./configure --prefix=$DIR/grib2
make
make install
cd ..

tar xzf libpng-1.2.50.tar.gz
cd libpng-1.2.50
./configure --prefix=$DIR/grib2
make
make install
cd ..

tar xzf jasper-1.900.1.tar.gz
cd jasper-1.900.1
./configure --prefix=$DIR/grib2
make
make install
cd ..
rm *.tar.gz
rm -rf *.*

cd ..
cd ..
cd TEST
wget -q http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
tar -xf Fortran_C_NETCDF_MPI_tests.tar

v_netcdf=$(which ncdump);
v_mpi=$(which mpicc);
if [[ $v_netcdf == *"$DIR"* ]]
then 
	echo "netcdf directory correct" >>$main/wrf_log;
else
	echo "netcdf directory wrong" >>$main/wrf_error;
	exit;
fi


if [[ $v_mpi == *"$DIR"* ]]
then 
	echo "MPI directory correct" >>$main/wrf_log;
else
	echo "MPI directory wrong" >>$main/wrf_error;
	exit;
fi

cp ${NETCDF}/include/netcdf.inc .
gfortran -c 01_fortran+c+netcdf_f.f
gcc -c 01_fortran+c+netcdf_c.c
gfortran 01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf
v_fortran_c_netcdf=$(./a.out)
success_test $v_fortran_c_netcdf

cp ${NETCDF}/include/netcdf.inc .
mpif90 -c 02_fortran+c+netcdf+mpi_f.f
mpicc -c 02_fortran+c+netcdf+mpi_c.c
mpif90 02_fortran+c+netcdf+mpi_f.o 02_fortran+c+netcdf+mpi_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf
v_mpi=$(mpirun  ./a.out)
success_test $v_mpi

cd ..
rm -rf TEST


cd WRF
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
echo expect "\"*1-40*\"" >>auto_configure
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

