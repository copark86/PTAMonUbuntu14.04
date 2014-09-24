cmake_minimum_required(VERSION 2.8.3)
set(PROJ_CALIB_NAME CameraCalibrator)
set(PROJ_PTAM_NAME PTAM)

project(ptam)


##############################################
## External libraries


######################################
set(EXT_DIR ${CMAKE_SOURCE_DIR}/cmake CACHE STRING "directory storing all external libraries")
list( APPEND CMAKE_MODULE_PATH
  ${EXT_DIR}
)

## find openCV
find_package( OpenCV REQUIRED )
set( OpenCV_INCLUDE_DIRS
	${OpenCV_INCLUDE_DIRS}
	CACHE PATH "OpenCV include directory"
)
set( OpenCV_LIBS
	${OpenCV_LIBS}
	CACHE PATH "OpenCV libraries"
)
list( APPEND
	EXT_INCLUDE_DIRS
	${OpenCV_INCLUDE_DIRS}
)
list( APPEND
	EXT_LIBS
	${OpenCV_LIBS}
)

find_package(LAPACK REQUIRED)
if(LAPACK_FOUND)
set(LAPACKLIBS_FOUND TRUE)
endif()
list( APPEND
	EXT_LINKER_FLAGS
	${LAPACK_LINKER_FLAGS}
)
list( APPEND
	EXT_LIBS
	${LAPACK_LIBRARIES}
	gfortran
)

## find CVO
find_package(CVD REQUIRED)
list( APPEND
	EXT_INCLUDE_DIRS
	${CVD_INCLUDE_DIR}
)
list( APPEND
	EXT_LIBS
	${CVD_LIBRARY}
)

## find TooN
find_package(TooN REQUIRED)
list( APPEND
	EXT_INCLUDE_DIRS
	${TooN_INCLUDE_DIRS}
)
list( APPEND
	EXT_LIBS
	${TooN_LIBRARIES}
)

## find GVars3
find_package(GVars3 REQUIRED)
list( APPEND
	EXT_INCLUDE_DIRS
	${GVars3_INCLUDE_DIR}
)
list( APPEND
	EXT_LIBS
	${GVars3_LIBRARY}
)

## find OpenGL
find_package(OPENGL REQUIRED)
list( APPEND
	EXT_INCLUDE_DIRS
	${OPENGL_INCLUDE_DIR}
)
list( APPEND
	EXT_LIBS
	${OPENGL_LIBRARIES}
)


add_definitions(-DCVD_HAVE_TooN)


##############################################
## PTAM files

set(PROJ_PTAM_SOURCE
	${CMAKE_SOURCE_DIR}/PTAM/main.cc
	${CMAKE_SOURCE_DIR}/PTAM/GLWindow2.cc
	${CMAKE_SOURCE_DIR}/PTAM/GLWindowMenu.cc
	${CMAKE_SOURCE_DIR}/PTAM/VideoSource_Linux_OpenCV.cc
	${CMAKE_SOURCE_DIR}/PTAM/System.cc
	${CMAKE_SOURCE_DIR}/PTAM/ATANCamera.cc
	${CMAKE_SOURCE_DIR}/PTAM/KeyFrame.cc
	${CMAKE_SOURCE_DIR}/PTAM/MapPoint.cc
	${CMAKE_SOURCE_DIR}/PTAM/Map.cc
	${CMAKE_SOURCE_DIR}/PTAM/SmallBlurryImage.cc
	${CMAKE_SOURCE_DIR}/PTAM/ShiTomasi.cc
	${CMAKE_SOURCE_DIR}/PTAM/HomographyInit.cc
	${CMAKE_SOURCE_DIR}/PTAM/MapMaker.cc
	${CMAKE_SOURCE_DIR}/PTAM/Bundle.cc
	${CMAKE_SOURCE_DIR}/PTAM/PatchFinder.cc
	${CMAKE_SOURCE_DIR}/PTAM/Relocaliser.cc
	${CMAKE_SOURCE_DIR}/PTAM/MiniPatch.cc
	${CMAKE_SOURCE_DIR}/PTAM/MapViewer.cc
	${CMAKE_SOURCE_DIR}/PTAM/ARDriver.cc
	${CMAKE_SOURCE_DIR}/PTAM/EyeGame.cc
	${CMAKE_SOURCE_DIR}/PTAM/Tracker.cc
)
set(PROJ_PTAM_INCLUDE
	${CMAKE_SOURCE_DIR}/PTAM/GLWindow2.h
	${CMAKE_SOURCE_DIR}/PTAM/GLWindowMenu.h
	${CMAKE_SOURCE_DIR}/PTAM/VideoSource.h
	${CMAKE_SOURCE_DIR}/PTAM/System.h
	${CMAKE_SOURCE_DIR}/PTAM/ATANCamera.h
	${CMAKE_SOURCE_DIR}/PTAM/KeyFrame.h
	${CMAKE_SOURCE_DIR}/PTAM/MapPoint.h
	${CMAKE_SOURCE_DIR}/PTAM/Map.h
	${CMAKE_SOURCE_DIR}/PTAM/SmallBlurryImage.h
	${CMAKE_SOURCE_DIR}/PTAM/ShiTomasi.h
	${CMAKE_SOURCE_DIR}/PTAM/HomographyInit.h
	${CMAKE_SOURCE_DIR}/PTAM/MapMaker.h
	${CMAKE_SOURCE_DIR}/PTAM/Bundle.h
	${CMAKE_SOURCE_DIR}/PTAM/PatchFinder.h
	${CMAKE_SOURCE_DIR}/PTAM/Relocaliser.h
	${CMAKE_SOURCE_DIR}/PTAM/MiniPatch.h
	${CMAKE_SOURCE_DIR}/PTAM/MapViewer.h
	${CMAKE_SOURCE_DIR}/PTAM/CameraCalibrator.h
	${CMAKE_SOURCE_DIR}/PTAM/ARDriver.h
	${CMAKE_SOURCE_DIR}/PTAM/EyeGame.h
	${CMAKE_SOURCE_DIR}/PTAM/Tracker.h
)

set(PROJ_CALIB_SOURCE
	${CMAKE_SOURCE_DIR}/PTAM/GLWindow2.cc	
	${CMAKE_SOURCE_DIR}/PTAM/GLWindowMenu.cc
	${CMAKE_SOURCE_DIR}/PTAM/VideoSource_Linux_OpenCV.cc
	${CMAKE_SOURCE_DIR}/PTAM/CalibImage.cc
	${CMAKE_SOURCE_DIR}/PTAM/CalibCornerPatch.cc
	${CMAKE_SOURCE_DIR}/PTAM/ATANCamera.cc
	${CMAKE_SOURCE_DIR}/PTAM/CameraCalibrator.cc
)
set(PROJ_CALIB_INCLUDE
	${CMAKE_SOURCE_DIR}/PTAM/GLWindow2.h
	${CMAKE_SOURCE_DIR}/PTAM/GLWindowMenu.h
	${CMAKE_SOURCE_DIR}/PTAM/VideoSource.h
	${CMAKE_SOURCE_DIR}/PTAM/CalibImage.h
	${CMAKE_SOURCE_DIR}/PTAM/CalibCornerPatch.h
	${CMAKE_SOURCE_DIR}/PTAM/ATANCamera.h
	${CMAKE_SOURCE_DIR}/PTAM/CameraCalibrator.h
)

file(GLOB filesConfig ${CMAKE_SOURCE_DIR}/PTAM/*.cfg)
foreach(file ${filesconfig})
	file(COPY ${file} DESTINATION ${CMAKE_BINARY_DIR})
endforeach(file)

include_directories(${EXT_INCLUDE_DIRS})
#link_directories(${})

add_executable(${PROJ_CALIB_NAME}
	${PROJ_CALIB_INCLUDE}
	${PROJ_CALIB_SOURCE}
)
set_property(TARGET ${PROJ_CALIB_NAME} APPEND_STRING PROPERTY COMPILE_FLAGS "-D_LINUX -D_REENTRANT -Wall -march=native ")
if(CMAKE_BUILD_TYPE MATCHES Release)
	set_property(TARGET ${PROJ_CALIB_NAME} APPEND_STRING PROPERTY COMPILE_FLAGS "-O3 ")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${EXT_LINKER_FLAGS} -fsee -funsafe-loop-optimizations -fno-signed-zeros -fno-math-errno -funroll-loops" )
endif(CMAKE_BUILD_TYPE MATCHES Release)
target_link_libraries(${PROJ_CALIB_NAME} ${EXT_LIBS})

add_executable(${PROJ_PTAM_NAME}
	${PROJ_PTAM_SOURCE}
	${PROJ_PTAM_INCLUDE}
)
set_property(TARGET ${PROJ_PTAM_NAME} APPEND_STRING PROPERTY COMPILE_FLAGS "-D_LINUX -D_REENTRANT -Wall -march=native ")
if(CMAKE_BUILD_TYPE MATCHES Release)
	set_property(TARGET ${PROJ_PTAM_NAME} APPEND_STRING PROPERTY COMPILE_FLAGS "-O3 ")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${EXT_LINKER_FLAGS} -fsee -funsafe-loop-optimizations -fno-signed-zeros -fno-math-errno -funroll-loops" )
endif(CMAKE_BUILD_TYPE MATCHES Release)
target_link_libraries(${PROJ_PTAM_NAME} ${EXT_LIBS})