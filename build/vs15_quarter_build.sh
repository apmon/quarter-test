
# Adjust the following lines for each build type (/x64, /debug, etc) & Qt version

export BITS=64
export BUILD_TYPE=$1
export MSVS_EXT=msvs2015-$BITS
export BLD_EXT=qt56
export QTDIR=C:/Qt/5.6.1/5.6/msvc2015_64
export COINDIR=C:/Coin/4.0.0a

# Set up the build environment.
# The next few lines will move the cygwin compile tools to end of path so MSVS tools are found first.
unset CC
unset CXXmake
[ -n "${TMP}" ] || export TMP=/tmp
export PATH=`echo $PATH|sed 's,\(/usr/local/bin:/usr/bin\):\(.*\),\2:\1,'`
export COINDIR=`cygpath "$COINDIR"`
export QTDIR=`cygpath "$QTDIR"`

export CPPFLAGS="-I$QTDIR/include/QtCore -I$QTDIR/include/QtWidgets -I$QTDIR/include/QtOpenGL -I$QTDIR/include/QtGui"

export CONFIG_QTLIBS="-lQt5Core -lQt5Widgets -lQt5OpenGL -lQt5Gui -lQt5Designer -lQt5UiTools -lQt5Xml -lqtmain -lgdi32"

export QTR_BLD_DIR=/cygdrive/c/Quarter/build/cyg-$BLD_EXT-$MSVS_EXT-$BUILD_TYPE
mkdir $QTR_BLD_DIR
cd $QTR_BLD_DIR

# Disabling pkg-config seems to be fairly important:
if [ "$BUILD_TYPE" == "release" ] || [ "$BUILD_TYPE" == "" ]; then
echo "this is a release build!"
/cygdrive/c/src/quarter/configure --disable-pkgconfig --with-qt=$QTDIR --prefix=$COINDIR --with-coin=$COINDIR --with-msvcrt=md --disable-debug
fi

if [ "$BUILD_TYPE" == "debug" ]; then
echo "this is a debug build!"
/cygdrive/c/src/quarter/configure --disable-pkgconfig --with-qt=$QTDIR --prefix=$COINDIR --with-coin=$COINDIR --program-suffix=d --with-suffix=d --with-msvcrt=mdd
fi

make

echo "now you need to move the libraries into COINDIR"
