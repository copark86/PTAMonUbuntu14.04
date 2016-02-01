#!/bin/bash
# a script to compile PTAM r114 on Ubuntu 14.04
# written by Yuji Oyamada (ug.oyamada@gmail.com)
# based on the script for Ubuntu 10.04 by Yoshinari Kameda (kameda[at]iit.tsukuba.ac.jp)
#

# required libraries
sudo apt-get update
sudo apt-get -yV install build-essential cmake pkg-config
sudo apt-get -yV install gfortran
sudo apt-get -yV install liblapack-dev libblas-dev
sudo apt-get -yV install libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev libv4l-dev 
sudo apt-get -yV install libavcodec-dev libavformat-dev libavutil-dev libpostproc-dev libswscale-dev libavdevice-dev libsdl-dev
sudo apt-get -yV install libgtk2.0-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev 
sudo apt-get -yV install mesa-common-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev libdc1394-22-dev

nameSource=PTAMpackage
wget -O $nameSource.zip https://github.com/nttputus/PTAM-linux-cv2.3/archive/master.zip
unzip $nameSource.zip
cd PTAM-linux-cv2.3-master

# directory setting
dirTop=`pwd` 
dirPtam=$dirTop/PTAM

mkdir -p $dirPtam

# TooN
pushd $dirPtam
# git clone https://github.com/edrosten/TooN.git
wget https://github.com/edrosten/TooN/archive/TOON_2.0.tar.gz
tar zxvf TOON_2.0.tar.gz
cd TooN-TOON_2.0
./configure
make
sudo make install
popd

# LibCVD
pushd $dirPtam
git clone https://github.com/edrosten/libcvd.git
cd libcvd
mv cvd_src/convolution.cc cvd_src/convolution.cc-original
cp $dirTop/hack/libcvd/convolution.cc cvd_src/convolution.cc
export CXXFLAGS=-D_REENTRANT
./configure --without-ffmpeg --without-v4l1buffer --without-dc1394v1 --without-dc1394v2
make
sudo make install
popd

# Gvars3
pushd $dirPtam
git clone https://github.com/edrosten/gvars.git
cd gvars
#mv gvars/serialize.h gvars/serialize.h-original
#cp $dirTop/hack/gvars3/serialize.h gvars3/serialize.h
./configure --disable-widgets
make
sudo make install
popd

# before you go further, re-arrange the dynamic libraries
sudo ldconfig

# PTAM main
pushd $dirPtam
unzip $dirTop/PTAM-r114-2010129.zip
patch -p0 -d . < $dirTop/hack/PTAM/PTAM-r114-linux.patch

wget https://github.com/charmie11/PTAMonUbuntu14.04/archive/master.zip
unzip master.zip
dirCmake=$dirPtam/PTAMonUbuntu14.04-master
patch -p0 -d . < $dirCmake/PTAM-r114-linuxYuji.patch
cp $dirCmake/fileForCmake/CMakeLists.txt $dirPtam/CMakeLists.txt
mkdir $dirPtam/cmake
cp $dirCmake/fileForCmake/cmake/* $dirPtam/cmake
pushd PTAM
cp Build/Linux/* .
popd
# cmake related file
dirBuild=build-dir
mkdir $dirBuild
cd $dirBuild
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j4
./CameraCalibrator
./PTAM
