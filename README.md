PTAMonUbuntu14.04
=================

This repository is for enabling PTAM compilable on Ubuntu 14.04 with CMake.

What to do is to download PTAM-Ubuntu14.04Cmake.bash and run it. The bash
- installs all required libraries using Ubuntu package manager,
- downloads, compiles, and installs required C++ libraries,
- downloads PTAM source code and patches provided by Kameda Lab on github,
- downloads CMake related files from github
- applies my patch PTAM-r114-linuxYuji.patch to the source, and
- compiles the PTAM source using CMake.

This repository uses PTAM-linux-cv2.3(https://github.com/nttputus/PTAM-linux-cv2.3).
- PTAM-Ubuntu14.04Cmake.bash: a bash script installs required packages, compiles necessary libraries, and compiles PTAM using CMake,
- PTAM-r114-linuxYuji.patch: a patch applied to PTAM sources after the patch of PTAM-linux-cv2.3 to fix some bugs of the patch,
- fileForCmake: a set of files needed for PTAM compilation using CMake.

If you already know PTAM-linux-cv2.3, put all files in fileForCmake directory in the directory "PTAM-linux-cv2.3-master/PTAM".