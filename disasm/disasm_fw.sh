#!/bin/dash
r2 -a arm -b 16 -m 0x0800c000 -i fw.r ../../md380tools/patches/d13.020/patched.img $*
