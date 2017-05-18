# print commands for debugging
set -x
BUILD_FOLDER=`cygpath $APPVEYOR_BUILD_FOLDER`
TARGET="ffmpeg-$FFMPEG_VERSION"
OPTIONS="--disable-programs --disable-doc --enable-runtime-cpudetect"

TARGET+="-$LICENSE"
case "$LICENSE" in
	lgpl2)
		;;
	lgpl3)
		OPTIONS+=" --enable-version3"
		;;
	gpl2)
		OPTIONS+=" --enable-gpl"
		;;
	gpl3)
		OPTIONS+=" --enable-gpl --enable-version3"
		;;
	*)
		echo "LICENSE must be lgpl2, lgpl3, gpl2, or gpl3"
		exit 1
esac

TARGET+="-$LINKAGE"
case "$LINKAGE" in
	shared)
		OPTIONS+=" --disable-static --enable-shared"
		;;
	static)
		OPTIONS+=" --enable-static --disable-shared"
		;;
	*)
		echo "LINKAGE must be shared or static"
		exit 1
esac

# note: bash is case sensitive; need to use $Configuration and $Platform
TARGET+="-$RUNTIME_LIBRARY"
TARGET+="-$Configuration"
TARGET+="-$Platform"
RUNTIME_CFLAGS=`echo "-$RUNTIME_LIBRARY" | tr '[:lower:]' '[:upper:]'`
case "$Configuration" in
	Release)
		;;
	Debug)
		RUNTIME_CFLAGS="${RUNTIME_CFLAGS}d"
		;;
	*)
		echo "CONFIGURATION must be Release or Debug"
		exit 1
esac
OPTIONS+=" --extra-cflags=${RUNTIME_CFLAGS} --extra-cxxflags=${RUNTIME_CFLAGS}"

# lower case
TARGET=`echo "$TARGET" | tr '[:upper:]' '[:lower:]'`

OPTIONS+=" --prefix=$BUILD_FOLDER/$TARGET"

# print some environment variables for debugging
set +x
echo "------------------------------------------------------------------------"
echo "FFMPEG_VERSION=$FFMPEG_VERSION"
echo "CONFIGURATION=$Configuration"
echo "LINKAGE=$LINKAGE"
echo "LICENSE=$LICENSE"
echo "RUNTIME_LIBRARY=$RUNTIME_LIBRARY"
echo "OPTIONS=$OPTIONS"
echo "------------------------------------------------------------------------"
echo "PATH=$PATH"
echo "INCLUDE=$INCLUDE"
echo "LIB=$LIB"
echo "LIBPATH=$LIBPATH"
echo "CL=$CL"
echo "_CL_=$_CL_"
echo "------------------------------------------------------------------------"
set -x

# ensure link.exe is the one from msvc
rm /usr/bin/link
which link

# ensure cl.exe can be called
which cl
cl

# run configure
cd "$BUILD_FOLDER/ffmpeg-$FFMPEG_VERSION"
./configure --toolchain=msvc $OPTIONS > "$BUILD_FOLDER/configure.txt"
cat "$BUILD_FOLDER/configure.txt"

# print last 30 lines from config log file for debugging
tail -30 config.log

# run make
make
make install

# zip the result
cd "$BUILD_FOLDER"
7z a -tzip -r "$TARGET.zip" $TARGET configure.txt
