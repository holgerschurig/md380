#!/bin/dash
r2 -a arm -m 0x08000000 -b 16 -m 0x08000000 -i myb.r boot.img $*
