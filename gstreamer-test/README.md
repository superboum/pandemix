Compile:

```
dnf install gstreamer1-devel
gcc -Wall main.c -o test $(pkg-config --cflags --libs gstreamer-1.0)
```

Enjoy:

```
./test file:///tmp/sound.ogg
./test http://chai5she.cdn.dvmr.fr/fip-midfi.mp3
```
