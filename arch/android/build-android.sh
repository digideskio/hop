#! /bin/bash

if [ "$(basename $0)" == "build-android.sh" ]; then
  set -e
fi

arch_dir=$(dirname $0)
conf_file=$arch_dir/config.sh

# import settings
if [ -f $conf_file ]; then
   source $conf_file
else
   echo "config file '$conf_file' not found, bailing out."
   exit 1
fi

prefix=/data/data/fr.inria.hop
install_prefix=$(pwd)/arch/android/assets
libdir=$install_prefix/hoplib

function install {
    # installs $src in $dst,
    # creating all the parent dirs as needed
    src="$1"
    dst="$2"

    dir="$(dirname $dst)"
    mkdir -p "$dir"
    cp -vur "$src" "$dst"
}

if [ "$1" == "configure" -o "$1" == "all" ]; then
  ./configure \
    --prefix=$prefix \
    --libdir=$prefix/hoplib \
    --cc=$CC \
    --bigloolibdir=$XBGL_LIBDIR \
    --devel \
    --srfi=static \
    --disable-threads

  if [ "$1" == "configure" ]; then
    shift
  fi
fi

if [ "$1" == "build" -o "$1" == "all" ]; then
  # yes, we need a bootstraping hop too :|
  # unluckily our build system is not ready for this kind of things
  # so we must hack it
  pwd=$(pwd)

  ( cd widget
    mkdir -pv o
    for i in *.hop; do
      echo $BS_HOPDIR/bin/hopc $i -o o/${i%.hop}.o -c
      # TODO: this command is too specific. try to use bigloo's and hop's config
      $BS_HOPDIR/bin/hopc $i -o o/${i%.hop}.o -c \
        --bigloo=$BGL_PREFIX/bin/bigloo -L $BS_HOPDIR/lib \
        --share-dir $pwd/share -- \
        -O2 -fsharing -Wall -wslots -L $BS_HOPDIR/lib \
        -lib-dir $XBGL_LIBDIR \
        -cc $CC \
        -copt "-O3 -DPLATFORM_ANDROID -I$XBGL_LIBDIR" \
        -copt -fPIC -unsafe -safee
    done
  )
  ( cd share
    mkdir -pv o
    for i in hop-exception.scm; do
      echo $BS_HOPDIR/bin/hopc $i -o o/${i%.hop}.o -c
      $BS_HOPDIR/bin/hopc $i -o ${i%.scm}.js -c -j \
        --bigloo=$BGL_PREFIX/bin/bigloo -L $XBS_HOPDIR/lib \
        --share-dir $pwd/share --
    done
  )
  # this first attempt to build will fail when linkking hop
  # because we don't have a way to detect and compile a static hop in the build system
  make || true

  # compile a static hop by hand
  ( cd src
    # TODO: this command is too specific. try to use bigloo's and hop's config
    $BGL_PREFIX/bin/bigloo -fsharing -Wall -wslots -static-all-bigloo \
      -L $pwd/lib -lib-dir $XBGL_LIBDIR -cc $CC \
      -copt "-g -DPLATFORM_ANDROID -I$XBGL_LIBDIR" \
      -o $pwd/bin/hop \
         o/hop-param.o o/parseargs.o o/main.o o/init.o o/scheduler.o o/accept.o \
         o/pipeline.o o/nothread-scheduler.o o/queue-scheduler.o o/oto-scheduler.o \
         o/pool-scheduler.o o/amany-scheduler.o \
      -ldopt -L $pwd/lib/libhop_s-2.1.0.a \
      -ldopt -L $pwd/lib/libhop_e-2.1.0.a \
      -ldopt -L $pwd/lib/libhopscheme_s-2.1.0.a \
      -ldopt -L $pwd/lib/libhopscheme_e-2.1.0.a \
      -ldopt -L $pwd/lib/libscheme2js_s-2.1.0.a \
      -ldopt -L $pwd/lib/libscheme2js_e-2.1.0.a \
      -ldopt -L $pwd/lib/libhopwidget_s-2.1.0.a \
      -ldopt -L $pwd/lib/libhopwidget_e-2.1.0.a \
      -ldopt -L $XBGL_LIBDIR/libbiglooweb_e-3.3b.a \
      -ldopt -L $XBGL_LIBDIR/libbigloomultimedia_e-3.3b.a
  )

  if [ "$1" == "build" ]; then
    shift
  fi
fi

if [ "$1" == "prepare" -o "$1" == "all" ]; then
  # we have to install by hand because prefix is needed for the host layout
  source .hoprelease
  rm -rf $install_prefix

  # binary and config to the same path
  for file in bin/hop etc/hoprc.hop; do
    install "$file" "$install_prefix/$file"
  done
  # files related to libs to hoplib
  for file in lib/*.init; do
    install "$file" "$libdir/$(basename $file)"
  done
  # misc
  for file in share/{buttons,icons,*.js,*.hss,*.scm,.afile,hop-runtime.sch}; do
    install "$file" "$install_prefix/share/hop/$(basename $file)"
  done
  # don't install all the weblets
  for file in weblets/{wizard,hop,hz,shutdown,info,color,dashboard,doc,home,hopsh,wiki,weblets}; do
    install "$file" "$install_prefix/hoplib/hop/$major/weblets/$(basename $file)"
  done

  # throw in bigloo's libs too
  install $XBGL_LIBDIR/*.init $libdir

  # the apkbuilder ignores the .afiles, so we change their names
  # and the installer changes them back
  for afile in $(find arch/android/assets -name .afile); do
    # dot.afile
    dot_afile=$(dirname $afile)/dot$(basename $afile)
    mv -v $afile $dot_afile
  done
  if [ "$1" == "prepare" ]; then
    shift
  fi
fi

if [ "$1" == "apk" -o "$1" == "all" ]; then
  $ANDNDK/ndk-build -C arch/android/ V=1
  (
    cd arch/android
    # build the .apk
    ant debug
  )

  if [ "$1" == "apk" ]; then
    shift
  fi
fi

if [ "$1" == "install" -o "$1" == "all" ]; then
  $ANDSDK/tools/adb install -r arch/android/bin/hop-debug.apk

  if [ "$1" == "install" ]; then
    shift
  fi
fi

if [ "$1" == "run" -o "$1" == "all" ]; then
  $ANDSDK/tools/adb shell monkey -p fr.inria.hop 1
  if [ "$1" == "run" ]; then
    shift
  fi
fi