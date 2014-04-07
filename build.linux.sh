BUILD="make -f makefile.unix USE_UPNP=-"
cd src
$BUILD clean
$BUILD
cd - 
