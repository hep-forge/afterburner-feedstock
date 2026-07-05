#! /usr/bin/bash
set -e

# the actual CMake project lives under cpp/, not the repo root
cd cpp
mkdir -p build
cd build

# HEPMC3_ROOTIO defaults ON but abconv's own CMakeLists.txt never links
# HepMC3::rootIO despite compiling ROOT reader/writer code paths behind
# it -- undefined symbols at link time. Disable it for this first cut;
# ascii/hepmc2/hepmc3 conversion still works, just not the treeroot/root
# output formats.
cmake .. \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DHEPMC3_ROOTIO=Off

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
make -j"$NPROC"
make install
