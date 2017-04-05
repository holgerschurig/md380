e asm.arch = arm
e asm.cpu = cortex
#e asm.section.sub = true


e cfg.fortunes = false
e asm.lines.ret = true
e asm.cmtcol = 55

. cpu.r
f RCC_CR @ 0x40023800
f RCC_PLLCFGR @ 0x40023804
f RCC_CFGR @ 0x40023808
f RCC_CIR @ 0x4002380C

s NVIC_SystemReset
aac
Vp
