@ECHO off

SET OMS_VS_TARGET=%~1
IF ["%OMS_VS_TARGET%"]==["VS14-Win32"] SET OMS_VS_PLATFORM=32 && SET OMS_VS_VERSION="Visual Studio 14 2015"
IF ["%OMS_VS_TARGET%"]==["VS14-Win64"] SET OMS_VS_PLATFORM=64 && SET OMS_VS_VERSION="Visual Studio 14 2015 Win64"
IF ["%OMS_VS_TARGET%"]==["VS15-Win64"] SET OMS_VS_PLATFORM=64 && SET OMS_VS_VERSION="Visual Studio 15 2017 Win64"

echo %OMS_VS_TARGET% %OMS_VS_VERSION%

cd 3rdParty\misc
echo Building 3rdParty\misc
nmake -f Makefile.msvc
cd ..\rtime
echo Building 3rdParty\rtime
nmake -f Makefile.msvc
cd ..\..\common
echo Building common
nmake -f Makefile.msvc
cd ..\FMIWrapper\FMILibrary-2.0.1
mkdir build-fmilib
cd build-fmilib
cmake -DHAVE_SNPRINTF=1 -DHAVE_VSNPRINTF=1 -G %OMS_VS_VERSION% ../
cmake --build . --config MinSizeRel --target install
xcopy install/bin/fmilib_shared.dll ..\..\..\bin
xcopy install/bin/fmilib_shared.dll ..\..\..\..\lib
cd ../../
nmake -f Makefile.msvc
xcopy ..\..\bin\FMIWrapper ..\..\..\bin
cd ..

EXIT /B
