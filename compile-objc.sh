mkdir -p build/ios/objc
echo '...transpilin'
j2objc -d build/ios/objc -sourcepath core/src/main/java/ `find core/src/main/java/ -name '*.java'`
echo

echo '...compilin'
pushd build/ios/objc > /dev/null
j2objcc -c -I. `find . -name '*.m'`
popd > /dev/null
echo

echo '...static filin'
libtool -static -o build/ios/objc/libWhatsOnCore.a `find build/ios/objc -name '*.o'`
echo

echo '...Copying headers'
rm -rf build/ios/include
mkdir build/ios/include
for FILE in `find build/ios/objc -name '*.h'`; do cp $FILE build/ios/include; done
echo

echo 'Done!'
