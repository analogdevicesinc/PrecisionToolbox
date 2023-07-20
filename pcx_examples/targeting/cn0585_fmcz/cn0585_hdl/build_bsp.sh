#!/bin/bash
set -x
cd "$(dirname "$0")"
if [ -z "${HDLBRANCH}" ]; then
HDLBRANCH='cn0585_pr'
fi

# Script is designed to run from specific location
scriptdir=`dirname "$BASH_SOURCE"`
cd $scriptdir
#cd ..
# Get HDL
if [ -d "hdl" ]; then
    rm -rf "hdl"
fi
for i in {1..5}
do
	if git clone --single-branch -b $HDLBRANCH https://github.com/analogdevicesinc/hdl.git
	then
	   break
	fi
	if [ -d "hdl" ]; then
	   break
	fi
done
if [ ! -d "hdl" ]; then
   echo "HDL clone failed"
   exit 1
fi

# Get required vivado version needed for HDL
if [ -f "hdl/library/scripts/adi_ip.tcl" ]; then
	TARGET="hdl/library/scripts/adi_ip.tcl"
else
	TARGET="hdl/library/scripts/adi_ip_xilinx.tcl"
fi
VER=$(awk '/set required_vivado_version/ {print $3}' $TARGET | sed 's/"//g')
echo "Required Vivado version ${VER}"
VIVADOFULL=${VER}
if [ ${#VER} = 8 ]
then
VER=${VER:0:6}
fi
VIVADO=${VER}

# Setup
#source /opt/Xilinx/Vivado/$VIVADO/settings64.sh
source /emea/mediadata/opt/Xilinx/Vivado/$VIVADO/settings64.sh

# Rename .prj files since MATLAB ignores then during packaging
FILES=$(grep -lrn hdl/projects/common -e '.prj' | grep -v Makefile | grep -v .git)
for f in $FILES
do
  echo "Updating prj reference in: $f"
  sed -i "s/\.prj/\.mk/g" "$f"
done
FILES=$(find hdl/projects/common -name "*.prj")
for f in $FILES
do
  DEST="${f::-3}mk"
  echo "Renaming: $f to $DEST"
  mv "$f" "$DEST"
done

# Remove git directory move to bsp folder
rm -fr hdl/.git*
TARGET="../../../../hdl/vendor/AnalogDevices/vivado"
if [ -d "$TARGET" ]; then
    rm -rf "$TARGET"
fi

mv hdl $TARGET

# Post-process ports.json
cp ./ports.json ../../../../CI/
python3 ../../../../CI/scripts/read_ports_json.py
cp ../../../../CI/ports.json ../../../../hdl/vendor/AnalogDevices/+AnalogDevices/

# Updates
cp ./matlab_processors.tcl ../../../../hdl/vendor/AnalogDevices/vivado/projects/scripts/matlab_processors.tcl
cp ./system_project_rxtx.tcl ../../../../hdl/vendor/AnalogDevices/vivado/projects/scripts/system_project_rxtx.tcl
cp ./adi_build.tcl ../../../../hdl/vendor/AnalogDevices/vivado/projects/scripts/adi_build.tcl

# Copy boot files
mkdir ../../../../hdl/vendor/AnalogDevices/vivado/projects/common/boot/
cp -r ../../../../CI/scripts/boot/* ../../../../hdl/vendor/AnalogDevices/vivado/projects/common/boot/

echo 'puts "Skipping"' > ../../../../hdl/vendor/AnalogDevices/vivado/library/axi_ad9361/axi_ad9361_delay.tcl
