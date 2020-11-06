#!/bin/bash
path="/home/$(whoami)/m21-GSI-TWRP"
mkdir $path
cd $path
mkdir bin
PATH=$path/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > $path/bin/repo
chmod a+x $path/bin/repo
mkdir twrp
cd twrp
echo -ne '\n' | repo init -u git://github.com/RaghuVarma331/Twrp-Manifest.git -b android-10.0 --depth=1
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
git clone https://github.com/4ifi/android_device_samsung_m21-TWRP.git -b android-10.0 device/samsung/m21
export ALLOW_MISSING_DEPENDENCIES=true
cd bootable/recovery
mv ../../device/samsung/m21/a0931de.diff .
patch -p1 < a0931de.diff
. build/envsetup.sh && lunch omni_m21-eng && make -j$(nproc --all) recoveryimage
cd ..
mkdir build
mv -rf twrp/out/target/product/m21/recovery.img build/
echo Here is your build:
echo $path/build/recovery.img
