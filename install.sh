#!/bin/sh
if [ ! -f adm/Mkinclude ]; then
  echo please set adm/Mkinclude
  echo afterward, continue again
  exit
fi
cd lib
echo ----------------------------
echo install.sh: lib
echo ----------------------------
make clean
make all
cd ../
cd bin
echo ----------------------------
echo install.sh: bin
echo ----------------------------
make clean
make all
cd ../
if [ -d map/bin ]; then
echo ----------------------------
echo install.sh: map/bin
echo ----------------------------
  cd   map/bin
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d map/pre ]; then
echo ----------------------------
echo install.sh: map/pre
echo ----------------------------
  cd   map/pre
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d met/pre ]; then
echo ----------------------------
echo install.sh: met/pre
echo ----------------------------
  cd   met/pre
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d met/pst ]; then
echo ----------------------------
echo install.sh: met/pst
echo ----------------------------
  cd   met/pst
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d riv/bin ]; then
echo ----------------------------
echo install.sh: riv/bin
echo ----------------------------
  cd   riv/bin
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d riv/pre ]; then
echo ----------------------------
echo install.sh: riv/pre
echo ----------------------------
  cd   riv/pre
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d riv/pst ]; then
echo ----------------------------
echo install.sh: riv/pst
echo ----------------------------
  cd   riv/pst
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d lnd/bin ]; then
echo ----------------------------
echo install.sh: lnd/bin
echo ----------------------------
  cd   lnd/bin
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d lnd/pre ]; then
echo ----------------------------
echo install.sh: lnd/pre
echo ----------------------------
  cd   lnd/pre
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d lnd/pst ]; then
echo ----------------------------
echo install.sh: lnd/pst
echo ----------------------------
  cd   lnd/pst
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d crp/bin ]; then
echo ----------------------------
echo install.sh: crp/bin
echo ----------------------------
  cd   crp/bin
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d crp/pre ]; then
echo ----------------------------
echo install.sh: crp/pre
echo ----------------------------
  cd   crp/pre
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d crp/pst ]; then
echo ----------------------------
echo install.sh: crp/pst
echo ----------------------------
  cd   crp/pst
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d dam/bin ]; then
echo ----------------------------
echo install.sh: dam/bin
echo ----------------------------
  cd   dam/bin
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d dam/pre ]; then
echo ----------------------------
echo install.sh: dam/pre
echo ----------------------------
  cd   dam/pre
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d dam/pst ]; then
echo ----------------------------
echo install.sh: dam/pst
echo ----------------------------
  cd   dam/pst
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d cpl/bin ]; then
echo ----------------------------
echo install.sh: cpl/bin
echo ----------------------------
  cd   cpl/bin
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d cpl/pre ]; then
echo ----------------------------
echo install.sh: cpl/pre
echo ----------------------------
  cd   cpl/pre
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
if [ -d cpl/pst ]; then
echo ----------------------------
echo install.sh: cpl/pst
echo ----------------------------
  cd   cpl/pst
  if [ -f Makefile ]; then
    make clean
    make all
  fi
  cd   ../../
fi
