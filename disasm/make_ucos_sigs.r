e asm.arch = arm
e asm.cpu = cortex
e asm.section.sub = true


e cfg.fortunes = false
e asm.lines.ret = true
e asm.cmtcol = 55

. cpu.r

# Also generate signatures for small functions
e zign.min = 6

# Analyze function calls
aaa >/dev/null
aac

# generate zignatures for all functions
zaF

# Extract signatures
z* >sig_ucos.r

pdf @ sym.__fp_lock
pdf @ sym.__fp_unlock
pdf @ sym.RTC_Alarm_IRQHandler
pdf @ sym.CPU_SW_Exception
pdf @ loc.08006f1c
pdf @ sym.__seofread
pdf @ sym.__locale_charset
pdf @ sym.OSCfg_Init
pdf @ sym._localeconv_r
pdf @ sym.OS_Dbg_Init
pdf @ sym.CPU_IntEn
pdf @ sym.CPU_TS_Update
pdf @ sym.CPU_WaitForExcept
pdf @ sym.__sfp_lock_acquire
pdf @ sym.__aeabi_dsub
pdf @ sym.__sinit_lock_release
pdf @ sym.CPU_TS_Get32
pdf @ sym.__malloc_lock
pdf @ sym.__locale_cjk_lang
pdf @ sym.CPU_IntDis
pdf @ sym.localeconv
pdf @ sym.CPU_WaitForInt
pdf @ sym.__locale_msgcharset
pdf @ sym.__sfp_lock_release
pdf @ sym.__sinit_lock_acquire
pdf @ sym.__malloc_unlock
