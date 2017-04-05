# Setting the cortex CPU
e asm.cpu = cortex
# TODO Setup two RAM regions
# TODO Emulating memory mapped devices
# TODO ESIL emulation of Thumb2 code
# TODO Force filter search hits aligned to 4 bytes
# TODO Configure sections with iS, S, S=, o.
S 0x08000000 0x08000000 0x0000c000 0x0000c000 boot  -r-x
S 0xe0000000 0xe0000000 0x01000000 0x01000000 m4    mrw
S 0x40000000 0x40000000 0x01000000 0x01000000 stm32 mrw
S 0x20000000 0x20000000 0x00020000 0x00020000 ram   mrw
S 0x10000000 0x10000000 0x00010000 0x00010000 TCRAM mrw
e asm.section.sub = true

. sig_ucos.r

e cfg.fortunes = false
e asm.lines.ret = true
e asm.cmtcol = 55
