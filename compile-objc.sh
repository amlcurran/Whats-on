mkdir -p build/ios/objc
echo '...transpilin'
cd build/ios/objc
j2objc -d . -sourcepath ../../../core/src/main/java/ `find ../../../core/src/main/java/ -name '*.java'`
echo
echo '...compilin'
j2objcc -c -I. `find . -name '*.m'`
echo
echo '...static filin'
libtool -static -o libWhatsOnCore.a `find . -name '*.o'`
echo
echo '...Copying headers'
rm -rf ../include
mkdir ../include
for FILE in `find . -name '*.h'`; do cp $FILE ../include; done
echo
echo 'Done!'
