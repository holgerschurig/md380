# @compile: disasm/checksort.py disasm/myb.r

### Setting up the CPU
e asm.arch = arm
e asm.cpu = cortex
e asm.bits = 16

## Setup sections. Radara will normally get sections from ELF
## images, but our boot.bin is a "pure" binary.
S 0x0800c000 0x0800c000 0x00030000 0x00030000 text  -r-x
Sa arm 16 0x0800c000
S 0x10000000 0x10000000 0x00010000 0x00010000 TCRAM mrw
S 0x20000000 0x20000000 0x000f0000 0x000f0000 ram   mrwx
S 0xe0000000 0xe0000000 0x01000000 0x01000000 m4    mrw
S 0x40000000 0x40000000 0x01000000 0x01000000 stm32 mrw

### Setting up the ESIL VM
e esil.stack.addr = 0x20000000
e esil.stack.size = 0x000f0000
aeim

### Misc radare settings
e cfg.fortunes = false
e asm.lines.ret = true
e asm.cmtcol = 55
e scr.utf8 = 1
e asm.emustr = true
#e asm.section.sub = true
e bin.baddr = 0x80000000
e io.va = true
#e anal.hasnext = true


### Setup analysis
# Enable "aa*", which needs a symbol named "entry0"
# f entry0 @ 0x080056a4
s text
e search.in = io.sections.exec



#############################################################################
#
# Some macros that allow me to format the source code a little bit nicer,
# i.E. not have the definitions stagger around to much.

# Define a functiona AND analyze it. Analyzation is a prereq for the the "pdf" command
(func addr sz name,f sym.$2 $1 @ $0,af)

# Define things that reside in data parts of the image
(d4 addr size,Cd 4 $1 @ $0)            # define 4-byte long word
(ds addr len lbl,Cs $1 @ $0,f $2 @ $0) # define string
(dv addr name,f $1 @ $0)               # define variable


#############################################################################
#
#  Definitions from the md380tools project
#
#############################################################################

. ../../md380tools/annotations/d13.020/flash.r


#############################################################################
#
#  STM43f4 and Cortex-M4 registers
#
#############################################################################

. cpu.r


#aa*
#Vp
#pdf
s 0x8095518
