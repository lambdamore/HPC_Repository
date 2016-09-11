#! /bin/bash
#Written By:  Baoxiang Pan
#Github:
export main="$(pwd)"
export softwarename=HRLDAS
function exist_test()
{
        v=$(which $*);
        if [[ $v == *"/bin/$*"* ]]
        then
                echo "$* exists!" >>$main/${softwarename}_log;
        else
                echo "$* not exists!" >>$main/${softwarename}_error;
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
        echo "$*" >>$main/${softwarename}_log;
        if [[ $* != *"SUCCESS"* ]]
        then
                echo "$*" >>$main/${softwarename}_error;
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

cd ..
rm -rf TEST

mkdir ${softwarename}
cd ${softwarename}
mkdir LIBRARIES
cd LIBRARIES
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
rm global.sh
rm -rf *-*
rm *.tar.gz


cd ..
wget https://www.ral.ucar.edu/sites/default/files/public/product-tool/high-resolution-land-data-assimilation-system-hrldas/hrldas-release-3.7.tar.gz --no-check-certificate
tar -xvf *.gz
cd *7

