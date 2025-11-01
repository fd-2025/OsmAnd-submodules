#!/bin/bash

native_lib_arch=$1

# Exit as soon as something fails

set -e

# Always start from the directory this script is in

script_dir="$(dirname -- "$( readlink -f -- "$0"; )")";
pushd "$script_dir"

osmand_dir="$script_dir/android/OsmAnd"
osmand_java_dir="$script_dir/android/OsmAnd-java"

# Build MP Android Chart

pushd MPAndroidChart
echo "MPAndroidChart assembleRelease dry run BEGIN"
gradle assembleRelease --dry-run
echo "MPAndroidChart assembleRelease dry run END"
gradle assembleRelease
echo "list MPAndroidChart aar:"
ls -la MPChartLib/build/outputs/aar/*.aar
cp MPChartLib/build/outputs/aar/MPChartLib-release.aar "$osmand_dir/libs/"
popd

# Build OsmAnd core and copy into libs folder

pushd core/wrappers/android/
echo "Core build dry run BEGIN"
gradle build --dry-run
echo "Core build dry run END"
##echo "Core build dry run -x BEGIN"
##gradle build -x :OsmAndCore_androidNativeDebug:build --dry-run
##echo "Core build dry run -x END"

# build, assemble so that native libs are included
##gradle build -x :OsmAndCore_androidNativeDebug:build
gradle build
echo "list core aar without assembleRelease:"
ls -la build/outputs/aar/*.aar
ls -la NativeCore*/build/outputs/aar/*.aar

echo "Core assembleRelease dry run BEGIN"
gradle assembleRelease --dry-run
echo "Core assembleRelease dry run END"
echo "Core assembleRelease dry run -x BEGIN"
#gradle assembleRelease -x :OsmAndCore_androidNativeDebug:assembleRelease -x :swigGenerateJava -x :OsmAndCore_androidNative:buildOsmAndCore --dry-run
gradle assembleRelease -x :swigGenerateJava -x :OsmAndCore_androidNative:buildOsmAndCore --dry-run
echo "Core assembleRelease dry run -x END"

#gradle assembleRelease -x :OsmAndCore_androidNativeDebug:assembleRelease -x :swigGenerateJava -x :OsmAndCore_androidNative:buildOsmAndCore
gradle assembleRelease -x :swigGenerateJava -x :OsmAndCore_androidNative:buildOsmAndCore
echo "list core aar assembleRelease:"
ls -la build/outputs/aar/*.aar
ls -la NativeCore*/build/outputs/aar/*.aar
cp build/outputs/aar/OsmAndCore_android-release.aar "$osmand_dir/libs/"
cp NativeCoreRelease/build/outputs/aar/OsmAndCore_androidNativeRelease-release.aar "$osmand_dir/libs/"
popd

# Build OsmAnd patched version of ICU. Remove a bunch of unused data
# files to keep file size down. Copy into OsmAnd lib dirs.

pushd "icu-release-50-2-1-patched-mirror/icu4j"
ant jar
zip -d icu4j.jar "com/ibm/icu/impl/data/icudt50b/brkitr/*"
zip -d icu4j.jar "com/ibm/icu/impl/data/icudt50b/coll/*"
zip -d icu4j.jar "com/ibm/icu/impl/data/icudt50b/curr/*"
zip -d icu4j.jar "com/ibm/icu/impl/data/icudt50b/lang/*"
zip -d icu4j.jar "com/ibm/icu/impl/data/icudt50b/rbnf/*"
zip -d icu4j.jar "com/ibm/icu/impl/data/icudt50b/region/*"
zip -d icu4j.jar "com/ibm/icu/impl/data/icudt50b/translit/*"
zip -d icu4j.jar "com/ibm/icu/impl/data/icudt50b/zone/*"

cp icu4j.jar "$osmand_dir/libs/"
cp icu4j.jar "$osmand_java_dir/libs/"
popd

# return from whence we came (just in case)
popd
