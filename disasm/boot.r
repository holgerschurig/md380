# @compile: disasm/checksort.py disasm/boot.r

### Setting up the CPU
e asm.arch = arm
e asm.cpu = cortex
e asm.bits = 16

## Setup sections. Radara will normally get sections from ELF
## images, but our boot.bin is a "pure" binary.
S 0x08000000 0x08000000 0x0000c000 0x0000c000 boot  -r-x
#Sa arm 16 0x08000000
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
e scr.nkey = func
e asm.emustr = true
#e asm.section.sub = true
e bin.baddr = 0x80000000
e io.va = true
#e anal.hasnext = true


### Setup analysis
# Enable "aa*", which needs a symbol named "entry0"
f entry0 @ 0x080056a4
s boot
e search.in = io.sections.exec
# later you can try: "aa*" or (slower) "aac"



#############################################################################
#
# Some macros that allow me to format the source code a little bit nicer,
# i.E. not have the definitions stagger around to much.

# Define a functiona AND analyze it. Analyzation is a prereq for the the "pdf" command
#(func addr sz name,f sym.$2 $1 @ $0,s $0,af)  # analyze each function, slow
(func addr sz name,af+ $0 sym.$2)              # don't analyze, use "aa*" later

# Define things that reside in data parts of the image
(d4 addr size,Cd 4 $1 @ $0)            # define 4-byte long word
(ds addr len lbl,Cs $1 @ $0,f $2 @ $0) # define string
(dv addr name,f $1 @ $0)               # define variable



#############################################################################
# Load findings from the md380tools project:
. bootloader.r



#############################################################################
# see core_cm4.h

.(d4 0x08000000 98)

.(func 0x08000188 30 NVIC_SystemReset)

#############################################################################
# see usbd_dfu_core.c

.(func 0x080001a8 38 usbd_dfu_Init)
CCa 0x080001b2 STATE_dfuIDLE
CCa 0x080001ba STATUS_OK

.(func 0x080001ce 54 usbd_dfu_DeInit)
CCa 0x080001d4 STATE_dfuIDLE
CCa 0x080001dc STATUS_OK

.(func 0x08000204 190 usbd_dfu_Setup)
CCa 0x0800020a req.bmRequest
CCa 0x0800020c USB_REQ_TYPE_MASK
CCa 0x08000212 USB_REQ_TYPE_STANDARD
CCa 0x08000216 USB_REQ_TYPE_CLASS
CCa 0x0800021a req.bRequest
f case.dnload @ 0x8000234
f case.upload @ 0x800023a
f case.getstatus @ 0x8000240
f case.clearstatus @ 0x8000246
f case.getstate @ 0x800024c
f case.abort @ 0x8000252
f case.detach @ 0x8000258
f case.default @ 0x800025e
CCa 0x08000262 USBD_FAIL
CCa 0x08000266 req.bRequest
f case.req_get_descriptor @ 0x8000276
f case.req_get_interface @ 0x800029c
f case.req_set_interface @ 0x80002a8
CCa 0x0800027e DFU_DESCRIPTOR_TYPE

# XXX quite interesting function, because this function
# XXX decodes the DFU protocol and acts accordingly
.(func 0x080002c2 1330 EP0_TxSent)
CCa 0x080002cc STATE_dfuDNBUSY
CCa 0x080002e4 CMD_GETCOMMANDS
CCa 0x0800030a CMD_SETADDRESSPOINTER
CCa 0x0800036e CMD_ERASE
CCa 0x080003e8 CMD_MD380_ACCESS_CLOCK_MEMORY?
CCa 0x08000412 CMD_MD380_INTERNAL?
f loc.cmd_md380_programming @ 0x8000444
f loc.cmd_md380_set_time @ 0x8000494
f loc.cmd_md380_internal_3 @ 0x80004a8
f loc.cmd_md380_internal_4 @ 0x80004da
f loc.cmd_md380_reboot @ 0x800050c
f loc.cmd_md380_begin_fwupd @ 0x8000520
CCa 0x0800054a Command 0xC4 with wLength 10
CCa 0x0800059e Command 0xB2 with wLength 33
CCa 0x080005e2 Command 0xB3 with wLength 25
CCa 0x0800062e Command 0xD5 with wLength 513
f loc.ep0txsent.dnbusy @ 0x80007e2
CCa 0x080007e8 STATE_dfuMANIFEST
# Later there is code with command b4

.(func 0x080007f4 4 EP0_RxReady)
CCa 0x080007f4 USBD_OK

.(func 0x080007f8 162 DFU_Req_DETACH)
CCa 0x08000802 STATE_dfuIDLE
CCa 0x0800080c STATE_dfuDNLOAD_SYNC
CCa 0x08000816 STATE_dfuDNLOAD_IDLE
CCa 0x08000820 STATE_dfuMANIFEST_SYNC
CCa 0x0800082a STATE_dfuUPLOAD_IDLE
CCa 0x08000832 STATE_dfuIDLE

.(func 0x0800089a 168 DFU_Req_DNLOAD)
CCA 0x0800089c req.wLength
CCa 0x080008a8 STATE_dfuIDLE
CCa 0x080008b2 STATE_dfuDNLOAD_IDLE
CCa 0x080008f8 STATE_dfuDNLOAD_IDLE
CCa 0x08000902 STATE_dfuIDLE
CCa 0x08000912 STATE_dfuMANIFEST_SYNC

.(func 0x08000942 1170 DFU_Req_UPLOAD)
CCa 0x08000958 STATE_dfuIDLE
CCa 0x08000962 STATE_dfuUPLOAD_IDLE
CCa 0x08000984 XXX here it get's interesting
f loc.upload_1 @ 0x80009b8
f loc.upload_3 @ 0x8000a90
f loc.upload_4 @ 0x8000af6
f loc.upload_5 @ 0x8000b56
f loc.upload_7 @ 0x8000bb8
f loc.upload_x32 @ 0x8000c14

# TODO .(dv 0x0004b510 Pointer)
.(d4 0x08000dd4 11)

.(func 0x08000e04 482 DFU_Req_GETSTATUS)
CCa 0x08000e0a STATE_dfuDNLOAD_SYNC
CCa 0x08000e0e STATE_dfuMANIFEST_SYNC
CCa 0x08000e46 CMD_ERASE

.(d4 0x08000fe8 1)

.(func 0x08000fec 100 DFU_Req_CLEARSTATUS)

.(func 0x08001050 12 DFU_Req_GETSTATE)

.(d4 0x0800105c 7)

.(func 0x08001078 98 DFU_Req_ABORT)

.(d4 0x080010dc 1)

.(func 0x080010e0 96 DFU_LeaveDFUMode)
CCa 0x080010e4 Manifest_complete

.(func 0x08001140 8 USBD_DFU_GetCfgDesc)

.(func 0x08001148 36 USBD_DFU_GetUsrStringDesc)

#############################################################################
# see usbd_dfu_mal.c

.(d4 0x0800116c 15)

.(func 0x080011a8 42 MAL_Init)
CCa 0x080011c6 tMALTab.pMAL_Init

.(func 0x080011d2 42 MAL_DeInit)
CCa 0x080011f0 tMALTab.pMAL_DeInit

.(func 0x080011fc 76 MAL_Erase)
CCa 0x0800123c tMALTab.pMAL_Erase

.(func 0x08001298 54 MAL_Read)
CCa 0x080012c2 tMALTab.pMAL_Read

.(func 0x080012ce 96 MAL_GetStatus)
CCa 0x0800134a tMALTab.pMAL_CheckAdd

#############################################################################
# see usbd_req.c

.(func 0x0800132e 20 MAL_CheckAdd)

.(d4 0x0800135c 2)

.(func 0x08001364 88 USBD_StdDevReq)

.(func 0x080013bc 80 USBD_StdItfReq)

.(func 0x0800140c 360 USBD_StdEPReq)

.(func 0x08001574 296 USBD_GetDescriptor)
CCa 0x08001582 USB_DESC_TYPE_DEVICE
CCa 0x08001586 USB_DESC_TYPE_CONFIGURATION
CCa 0x0800158a USB_DESC_TYPE_STRING
CCa 0x0800158e USB_DESC_TYPE_DEVICE_QUALIFIER
CCa 0x08001592 USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION
f loc.getdesc_type @ 0x8001598
f loc.getdesc_conf @ 0x80015d6
f loc.getdesc_string @ 0x80015ec
f loc.getdesc_devqual @ 0x800166a
f loc.getdesc_other_speedconf @ 0x8001674
f loc.getdesc_default @ 0x800167e

.(func 0x0800169c 88 USBD_SetAddress)
CCa 0x080016b6 USB_OTG_CONFIGURED

.(func 0x080016f4 192 USBD_SetConfig)
CCa 0x08001712 USB_OTG_ADDRESSED
CCa 0x08001716 USB_OTG_CONFIGURED

.(func 0x080017b4 56 USBD_GetConfig)
CCa 0x080017c6 USB_OTG_ADDRESSED
CCa 0x080017ca USB_OTG_CONFIGURED

.(func 0x080017ec 54 USBD_GetStatus)

.(func 0x08001822 136 USBD_SetFeature)
CCa 0x0800182e USB_FEATURE_REMOTE_WAKEUP
CCa 0x08001848 USB_FEATURE_TEST_MODE

.(d4 0x080018ac 5)

.(func 0x080018c0 52 USBD_ClrFeature)
CCa 0x080018e2 pdev.dev.class_cb.Setup

.(func 0x080018f4 68 USBD_ParseSetupRequest)
.(func 0x08001938 28 USBD_CtlError)
.(func 0x08001954 70 USBD_GetString)
.(func 0x0800199a 20 USBD_GetLen)

#############################################################################
# see usbd_ioreq.c

.(func 0x080019ae 40 USBD_CtlSendData)
.(func 0x080019d6 22 USBD_CtlContinueSendData)
.(func 0x080019ec 40 USBD_CtlPrepareRx)
.(func 0x08001a14 22 USBD_CtlContinueRx)

.(func 0x08001a2a 36 USBD_CtlSendStatus)
CCa 0x08001a30 USB_OTG_EP0_STATUS_IN

.(func 0x08001a4e 36 USBD_CtlReceiveStatus)
CCa 0x08001a54 USB_OTG_EP0_STATUS_OUT

#############################################################################
# no source yet :-(

.(func 0x08001a72 46 XXX_08001a72)
.(func 0x08001aa0 85 XXX_08001aa0)
.(func 0x08001af6 34 XXX_08001af6)
.(func 0x08001b18 36 XXX_08001b18)
.(func 0x08001b3c 52 XXX_08001b3c)
.(func 0x08001b70 18 XXX_08001b70)
.(func 0x08001b82 26 XXX_08001b82)
.(func 0x08001b9c 120 XXX_08001b9c)
.(func 0x08001c14 18 XXX_08001c14)
.(func 0x08001c26 18 XXX_08001c26)
.(func 0x08001c38 26 XXX_08001c38)
.(func 0x08001c52 22 XXX_08001c52)
.(func 0x08001c68 36 XXX_08001c68)
.(func 0x08001c8c 86 XXX_08001c8c)
.(func 0x08001ce2 26 XXX_08001ce2)
.(func 0x08001cfc 34 XXX_08001cfc)
.(func 0x08001d1e 86 XXX_08001d1e)
.(func 0x08001d74 22 XXX_08001d74)
.(func 0x08001d8a 22 XXX_08001d8a)
.(func 0x08001da0 22 XXX_08001da0)
.(func 0x08001db6 24 XXX_08001db6)
.(func 0x08001dce 16 XXX_08001dce)
.(func 0x08001dde 16 XXX_08001dde)

#############################################################################
# no source yet :-(

.(d4 0x08001df0 26)

.(func 0x08001e58 32 FLASH_Unlock)

.(func 0x08001e78 18 XXX_08001e78)
.(func 0x08001e8a 176 XXX_08001e8a)
.(func 0x08001f3a 82 XXX_08001f3a)
CCa 0x08001f52 clear PSIZE
CCa 0x08001f5e set PSIZE to program x32
CCa 0x08001f6a activate flash programming
CCa 0x08001f7e weird method to clear bit 0 and stop programming

.(func 0x08001f8c 22 FLASH_UnlockOpt)
CCa 0x08001f90 isolate the OPTLOCK bit

.(func 0x08001fa2 14 FLASH_LockOpt)

# sym.rdp_lock
CCa 0x08001fd0 set OPTSTRT

.(func 0x08001ffa 58 FLASH_GetFlagStatus)
CCa 0x08002000 isolate BSY bit
CCa 0x08002004 FLASH_FLAG_BSY

#############################################################################
# see usb_dcd.c

.(d4 0x08002038 10)

.(func 0x08002088 150 DCD_Init)

.(func 0x0800211e 90 DCD_EP_Close)
.(func 0x08002178 70 DCD_EP_PrepareRx)
.(func 0x080021be 62 DCD_EP_Tx)
.(func 0x080021fc 70 DCD_EP_Stall)
.(func 0x08002242 70 DCD_EP_ClrStall)
.(func 0x08002288 20 DCD_EP_SetAddress)
.(func 0x0800229c 22 DevConnect)
.(func 0x080022b2 22 DCD_DevDisconnect)
.(func 0x080022c8 104 XXX_080022c8)
.(d4 0x08002330 1)
.(func 0x08002334 42 XXX_08002334)
.(func 0x0800235e 22 XXX_0800235e)
.(func 0x08002374 14 USB_OTG_BSP_mDelay)
.(func 0x08002384 68 XXX_08002384)
.(func 0x080023c8 4 XXX_080023c8)
.(func 0x080023cc 82 XXX_080023cc)
.(func 0x0800241e 148 XXX_0800241e)
.(func 0x080024b2 204 XXX_080024b2)
.(func 0x0800257e 12 XXX_0800257e)
.(d4 0x0800258c 1)
.(func 0x08002590 48 XXX_08002590)
.(func 0x080025c0 30 XXX_080025c0)
.(func 0x080025de 28 XXX_080025de)
.(func 0x080025fa 24 XXX_080025fa)
.(func 0x08002612 28 USBD_SetCfg)
.(func 0x0800262e 16 USBD_ClrCfg)
.(func 0x0800263e 14 XXX_0800263e)
.(func 0x0800264c 14 XXX_0800264c)
.(func 0x0800265c 32 XXX_0800265c)
.(func 0x0800267c 98 XXX_0800267c)
.(func 0x080026de 64 XXX_080026de)
.(func 0x0800271e 42 XXX_0800271e)
.(func 0x08002748 218 USB_OTG_SelectCore)
.(func 0x08002822 182 USB_OTG_CoreInit)
.(func 0x080028d8 24 USB_OTG_EnableGlobalInt)
.(func 0x080028f0 26 USB_OTG_DisableGlobalInt)
.(func 0x0800290a 70 XXX_0800290a)
.(func 0x08002950 62 XXX_08002950)
.(d4 0x08002990 2)
.(func 0x08002998 54 USB_OTG_SetCurrentMode)
.(func 0x080029ce 10 XXX_080029ce)
.(func 0x080029d8 20 XXX_080029d8)
.(func 0x080029ec 18 XXX_080029ec)
.(func 0x080029fe 16 XXX_080029fe)
.(func 0x08002a0e 368 USB_OTG_CoreInitDev)
.(func 0x08002b7e 88 XXX_08002b7e)
.(func 0x08002bd6 44 XXX_08002bd6)
.(func 0x08002c02 74 XXX_08002c02)
.(func 0x08002c4c 114 USB_OTG_EPDeactivate)
.(func 0x08002cbe 358 USB_OTG_EPStartXfer)
.(func 0x08002e24 294 USB_OTG_EP0StartXfer)
.(func 0x08002f4a 62 USB_OTG_EPSetStall)
.(func 0x08002f88 52 USB_OTG_EPClearStall)
.(func 0x08002fc6 14 XXX_08002fc6)
.(func 0x08002fd4 20 XXX_08002fd4)
.(func 0x08002fe8 14 XXX_08002fe8)
.(func 0x08002ff6 80 USB_OTG_EP0_OutStart)

#############################################################################

.(func 0x08003048 8 CPU_SR_Save_0)
CCa 0x08003048 store current PRIMASK in r0
CCa 0x0800304c disable IRQ via PRIMASK
.(func 0x08003050 6 CPU_SR_Restore_)
.(func 0x08003056 10 XXX_08003056)
.(func 0x08003072 8 XXX_08003072)
.(func 0x0800307a 8 XXX_0800307a)
.(func 0x08003082 86 vec.PEND_SV)
f vec.PEND_SV @ 0x08003082
.(d4 0x080030d8 9)
.(func 0x080030fc 122 XXX_080030fc)
.(func 0x08003176 140 XXX_08003176)
.(func 0x08003202 50 XXX_08003202)
.(func 0x08003234 92 XXX_08003234)
.(func 0x08003290 30 XXX_08003290)
.(d4 0x080032b0 11)
.(func 0x080032dc 130 XXX_080032dc)
.(func 0x0800335e 52 XXX_0800335e)
.(func 0x08003392 52 XXX_08003392)
.(func 0x080033c6 76 XXX_080033c6)
.(func 0x08003412 332 XXX_08003412)
.(func 0x0800355e 70 XXX_0800355e)
.(func 0x080035a4 58 XXX_080035a4)
.(func 0x080035de 18 XXX_080035de)
.(func 0x080035f0 34 XXX_080035f0)
.(func 0x08003612 28 XXX_08003612)
.(func 0x0800362e 24 XXX_0800362e)
.(func 0x08003646 704 XXX_08003646)
.(d4 0x08003908 4)
.(func 0x08003918 52 XXX_08003918)
.(func 0x0800394c 76 XXX_0800394c)
.(func 0x08003998 78 XXX_08003998)
.(func 0x080039e8 10 XXX_080039e8)
.(func 0x080039f2 32 XXX_080039f2)
.(func 0x08003a12 32 XXX_08003a12)
.(func 0x08003a32 32 XXX_08003a32)
.(d4 0x08003a54 4)
.(func 0x08003a64 8 XXX_08003a64) # something with io_CRC
.(func 0x08003a6c 10 XXX_08003a6c)
.(d4 0x08003a78 2)
.(func 0x08003a80 166 XXX_08003a80)
.(func 0x08003b26 22 XXX_08003b26)
.(func 0x08003b3c 4 XXX_08003b3c)
.(func 0x08003b40 4 XXX_08003b40)
.(func 0x08003b44 14 XXX_08003b44)
.(func 0x08003b52 82 XXX_08003b52)
.(func 0x08003ba4 10 XXX_08003ba4)
.(func 0x08003bae 104 XXX_08003bae)
.(d4 0x08003c18 5)
.(func 0x08003c2c 64 XXX_08003c2c)
.(func 0x08003c6c 28 XXX_08003c6c)
.(func 0x08003c88 4 XXX_08003c88)
.(func 0x08003c8c 4 XXX_08003c8c)
.(func 0x08003c90 20 XXX_08003c90)
.(func 0x08003ca4 218 XXX_08003ca4)
.(d4 0x08003d80 3)
.(func 0x08003d8c 92 XXX_08003d8c)
.(func 0x08003de8 210 otg_fs_int)
.(func 0x08003eba 72 XXX_08003eba)
.(func 0x08003f02 136 XXX_08003f02)
.(func 0x08003f8a 244 XXX_08003f8a)
.(func 0x0800407e 202 XXX_0800407e)
.(func 0x08004148 28 XXX_08004148)
.(func 0x08004164 158 XXX_08004164)
.(func 0x08004202 136 XXX_08004202)
.(func 0x0800428a 186 XXX_0800428a)
.(func 0x08004344 74 XXX_08004344)
.(func 0x0800438e 28 XXX_0800438e)
.(func 0x080043aa 28 XXX_080043aa)
.(d4 0x080043c8 2)
.(func 0x080043d0 32 XXX_080043d0)
.(func 0x080043f0 388 unk_080043f0)
.(func 0x08004574 100 XXX_08004574)
.(func 0x080045e0 426 XXX_080045e0)
.(func 0x0800478a 100 XXX_0800478a)
.(func 0x080047ee 384 XXX_080047ee)
.(d4 0x08004970 17)

.(func 0x080049b4 54 unk_080049b0)
.(func 0x080049ee 54 XXX_080049ee)
.(func 0x08004a08 98 XXX_08004a08)
.(d4 0x08004a6c 10)

.(func 0x08004a94 80 unk_08004a94)

.(d4 0x08004ae4 1)

# The cipher table has been found with "/x 2edf40b5bdda"
f cipher_table @ 0x08004ae8
Cd 1024 @ 0x08004ae8

.(func 0x08004ee8 10 unk_08004ee8)
.(func 0x08004ef2 10 unk_08004ef2)
.(func 0x08004efc 20 unk_08004efc)
.(func 0x08004f10 184 unk_08004f10)
.(func 0x08005020 4 unk_08005020)
.(func 0x08005024 18 unk_08005024)

.(d4 0x08005038 13)

#############################################################################
# see stm32f4xx.c

.(func 0x0800506c 96 SystemInit)
# Enable FPU
CCa 0x0800506e access Coprozessor Access Control Register
CCa 0x08005072 enable CP10 and CP11 coprocessors (FPU)
# Set up PLL
CCa 0x0800507e set HSION
CCa 0x08005088 weird, reset value already 0x00000000
CCa 0x08005092 unset PLLON, CSSON, HSEON
CCa 0x0800509c weird, reset value already 0x24003010
CCa 0x080050a2 unset HSEBYP
CCa 0x080050ac weird, reset value already 0x00000000
CCa 0x080050b0 delay loop
# Set up vector table
CCa 0x080050c2 Vector Table Offset Register
CCa 0x080050da set HSEON
CCa 0x080050e6 check HSERDY
CCa 0x080050fa HSE_STARTUP_TIMEOUT
CCa 0x08005104 RCC_CR & RCC_CR_HSERDY) != RESET
CCa 0x08005114 if (HSEStatus == 0x01)
CCa 0x0800511c set PWREN
CCa 0x08005128 set PWR_CR_VOS

.(func 0x080050cc 202 SetSysClock)
CCa 0x080055e4 set DN (Default NaN)
CCa 0x080055e8 store in FPSCR

.(d4 0x08005198 76)

f vec.NMI @ 0x080054b8
f vec.HARD_FAULT @ 0x080054ba
f vec.MEM_MANAGE @ 0x080054bc
f vec.BUS_FAULT @ 0x080054be
f vec.USAGE_FAULT @ 0x080054c0
f vec.SVCALL @ 0x080054c2
f vec.DEBUG_MONITOR @ 0x080054c4
f vec.SYSTICK @ 0x080054c6

f vec.OTG_FS_WKUP @ 0x080054c8

f vec.OTG_FS @ 0x080054ca
.(d4 0x080054d4 1)

f vec.EXTI3 @ 0x080054d8
f vec.EXTI2 @ 0x080054da
f vec.EXTI1 @ 0x080054dc
f vec.EXTI0 @ 0x080054de
f vec.TIM4_INT @ 0x080054e0
f vec.TIM3_INT @ 0x080054e2
f vec.TIM6_DAC @ 0x080054e4
f vec.TIM7 @ 0x080054e6
f vec.TIM8_UP_TIM13 @ 0x080054e8
f vec.RTC_WKUP @ 0x080054ea

f vec.DMA2_Stream3 @ 0x080054ec
.(ds 0x080054f0 40 str.SPI_Flash_Memory1)
.(ds 0x08005518 40 str.SPI_Flash_Memory2)

.(func 0x08005540 32 XXX_weird_jumptable)
#af 0x08005540
#e asm.emustr=0
#afvr r1 r1_ptr int
#afvr r4 r4_end int

.(d4 0x08005560 2)

.(d4 0x08005580 2)

.(d4 0x0800558c 11)
f loc.weird_jumptable @ 0x800558c

.(ds 0x080055b8 0x1c str.Radio_USB_Mode)

.(func 0x080055d4 26 init_fpu)
CCa 0x080055dc access CPACE
CCa 0x080055de enable CP10 and CP11 coprocessors (FPU)

.(ds 0x080055f0 0x14 str.Radio_Config)

.(ds 0x08005608 0x18 str.Radio_Interface)
.(func 0x08005620 26 main2)

.(func 0x08005636 4 store_1_in_r0)

.(func 0x0800563a 14 XXX_0800563a)

.(ds 0x08005660 0x14 str.Anytone)
.(ds 0x08005674 0x10 str.AnyRoad)
.(ds 0x08005684 0x10 str.00000000010B)
.(ds 0x08005694 0x10 str.00000000010C)

.(func 0x080056a4 8 Reset_Handler)
CCa 0x080056a4 this is SystemInit as thumb address
CCa 0x080056a8 this is main as thumb address

.(d4 0x080056ac 5)

.(d4 0x080056ac 5)

.(func 0x080056c0 16 main)

# 5552: r1 = 2c         
# 5544: r1 = 5574                     # r1 += pc
# 5546: r1 = 558c                     # r1 += 0x18
# 5548: r4 = 54
# 554a: r4 = 55a2                     # r4 += pc
# 555c: r4 = 55b8                     # r4 += 0x16
# 554e: b 555a
# 555a: cmp r1,r4
# 555c: bne 5550
# 5550: r0 = 5590                     # r0 = r1 + 4
# 5552: r2 = 0xffffc56b               # r2 = [r0], this is -14997
# 5554: r1 = 1af7                     # r1 = r2 + r1
# 5556: bl 0x08001af6

# 1af6: r1 = 1000, r0 = 5594          # ldr r1, [r0], 4
# 1afa: cbz (!r1) end
# 1afc: r2 = 10000000, r0 = 5598      # ldr r2, [r0], 4
# 1b00: r3 = 0                        # r2 = r3 << 31
# 1b02: itt mi
# 1b04: ignored
# 1b06: ignored
# 1b08: r2 = 10000000                 # r2 = r3 + r2
# 1b0a: r3 = 0
# 1b0c: r2 = 10000004                 # *r2++ = 0
# 1b10: r1 = 0ffc
# 1b12: bne 1b0a
#       r0 = 55a0?

# The following seems to be wrong :-(
# 5558: r1 = 55a0
# 555a: cmp r1, r4
# 555c: bne 5550
# 5550: r0 = 55a4                     # r0 = r1 + 4
# 5552: r2 = 0xffffc4cf               # r2 = [r0], this is -15153
# 5554: r1 = 1a6f                     # r1 = r2 + r1
# 5556: bl 0x8001a6e?

# 
CCa 0x08001af6 clear 0x10000000-0x10001000 and 0x20000138-0x20001230
CCa 0x0800558c points to 0x08001af6, the function that will interpret this table
CCa 0x08005590 bytes in TCRAM to clear
CCa 0x08005594 start in TCRAM to clear
CCa 0x08005598 bytes in RAM to clear
CCa 0x0800559c start in RAM to clear
CCa 0x080055a0 end of table


f vec.WWDG @ 0x080056f0
f vec.PVD @ 0x080056f4
f vec.TAMP_STAMP @ 0x080056f8
f vec.FLASH @ 0x08005700
f vec.RCC @ 0x08005704
f vec.EXTI4 @ 0x08005718
f vec.DMA1_Stream0 @ 0x0800571c
f vec.DMA1_Stream1 @ 0x08005720
f vec.DMA1_Stream2 @ 0x08005724
f vec.DMA1_Stream3 @ 0x08005728
f vec.DMA1_Stream4 @ 0x0800572c
f vec.DMA1_Stream5 @ 0x08005730
f vec.DMA1_Stream6 @ 0x08005734
f vec.ADC @ 0x08005738
f vec.CAN1_TX @ 0x0800573c
f vec.CAN1_RX0 @ 0x08005740
f vec.CAN1_RX1 @ 0x08005744
f vec.CAN1_SCE @ 0x08005748
f vec.EXTI9_5 @ 0x0800574c
f vec.TIM1_BRK_TIM9 @ 0x08005750
f vec.TIM1_UP_TIM10 @ 0x08005754
f vec.IM1_TRG_COM_TIM11 @ 0x08005758
f vec.TIM1_CC @ 0x0800575c
f vec.TIM2 @ 0x08005760
f vec.I2C1_EV @ 0x0800576c
f vec.I2C1_ER @ 0x08005770
f vec.I2C2_EV @ 0x08005774
f vec.I2C2_ER @ 0x08005778
f vec.SPI1 @ 0x0800577c
f vec.SPI2 @ 0x08005780
f vec.USART1 @ 0x08005784
f vec.USART2 @ 0x08005788
f vec.USART3 @ 0x0800578c
f vec.EXTI5_10 @ 0x08005790
f vec.RTC_ALARM @ 0x08005794
f vec.TIM8_BRK_TIM12 @ 0x0800579c
f vec.TIM8_TRG_COM_TIM14 @ 0x080057a4
f vec.TIM8_CC @ 0x080057a8
f vec.DMA1_Stream7 @ 0x080057ac
f vec.FSMC @ 0x080057b0
f vec.SDIO @ 0x080057b4
f vec.TIM5 @ 0x080057b8
f vec.SPI3 @ 0x080057bc
f vec.UART4 @ 0x080057c0
f vec.UART5 @ 0x080057c4
f vec.DMA2_Stream0 @ 0x080057d0
f vec.DMA2_Stream1 @ 0x080057d4
f vec.DMA2_Stream2 @ 0x080057d8
f vec.DMA2_Stream4 @ 0x080057e0
f vec.ETH @ 0x080057e4
f vec.ETH_WKUP @ 0x080057e8
f vec.CAN2_TX @ 0x080057ec
f vec.CAN2_RX0 @ 0x080057f0
f vec.CAN2_RX1 @ 0x080057f4
f vec.CAN2_SCE @ 0x080057f8
f vec.DMA2_Stream5 @ 0x08005800
f vec.DMA2_Stream6 @ 0x08005804
f vec.DMA2_Stream7 @ 0x08005808
f vec.USART6 @ 0x0800580c
f vec.I2C3_EV @ 0x08005810
f vec.I2C3_ER @ 0x08005814
f vec.OTG_HS_EP1_OUT @ 0x08005818
f vec.OTG_HS_EP1_IN @ 0x0800581c
f vec.OTG_HS_WKUP @ 0x08005820
f vec.OTG_HS @ 0x08005824
f vec.DCMI @ 0x08005828
f vec.CRYP @ 0x0800582c
f vec.HASH_RNG @ 0x08005830
f vec.FPU @ 0x08005834



#############################################################################
#
#  Memory locations
#
#############################################################################

.(dv 0x2000005c DeviceState2)
.(dv 0x20000077 wLength)
.(dv 0x20000114 tMALTab)
.(dv 0x20000724 usbd_dfu_AltSet)
.(dv 0x200011c0 DeviceState1)
.(dv 0x200011fc Manifest_State)
.(dv 0x20001200 DeviceStatus)
.(dv 0x20001204 wBlockNum)
.(dv 0x20001208 usbd_dfu_Desc)
.(dv 0x20001210 USBD_default_cfg)
.(dv 0x20001214 USBD_cfg_status)
.(dv 0x20001218 MAL_Buffer)
.(dv 0x2000122c DeviceState3)



#############################################################################
#
#  STM43F4 and Cortex-M4 registers
#
#############################################################################

. cpu.r


?e Analyzing functions (aac) ...
aac

