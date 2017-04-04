#!/bin/dash
#r2 -a arm -m 0x0800C000 -b 16 -i my.r ../md380tools/patches/d13.020/unwrapped.img $*
r2 -a arm -m 0x08000000 -b 16 -i myb.r boot.img $*
