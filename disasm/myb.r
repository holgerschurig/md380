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
#e asm.section.sub = true

# Generate signures with: ./make_ucos_sigs
. sig_ucos.r

e cfg.fortunes = false
e asm.lines.ret = true
e asm.cmtcol = 55

(func addr sz name,af $2 $0)

# Define a function, optionally analyze it recursively and seek to it
(f_ addr,s $0,af)
(fr addr,s $0,afr)
(fn addr name,s $0,f $1 @ $0,af) # dito, but with a name

# Define a data section and seek to it
(d4 addr size,Cd 4 $1 @ $0,s $0)
(ds addr len lbl,Cs $1 @ $0,f $2 @ $0)

. cpu.r
f RCC_CR @ 0x40023800
f RCC_PLLCFGR @ 0x40023804
f RCC_CFGR @ 0x40023808
f RCC_CIR @ 0x4002380C
f CPACE @ 0xE000ED88
f AIRCR @ 0xE000ED0C

. bootloader.r

# The vectors are described in the PM chapter 12.2

.(d4 0x08000000 98)
f vec.RESET @ 0x080056a4
f vec.NMI @ 0x080054b8
f vec.HARD_FAULT @ 0x080054ba
f vec.MEM_MANAGE @ 0x080054bc
f vec.BUS_FAULT @ 0x080054be
f vec.USAGE_FAULT @ 0x080054c0
f vec.SVCALL @ 0x080054c2
f vec.DEBUG_MONITOR @ 0x080054c4
f vec.PEND_SV @ 0x08003082
f vec.SYSTICK @ 0x080054c6
f vec.WWDG @ 0x080056f0
f vec.PVD @ 0x080056f4
f vec.TAMP_STAMP @ 0x080056f8
f vec.RTC_WKUP @ 0x080054ea
f vec.FLASH @ 0x08005700
f vec.RCC @ 0x08005704
f vec.EXTI0 @ 0x080054de
f vec.EXTI1 @ 0x080054dc
f vec.EXTI2 @ 0x080054da
f vec.EXTI3 @ 0x080054d8
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
f vec.TIM3_INT @ 0x080054e2
f vec.TIM4_INT @ 0x080054e0
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
f vec.OTG_FS_WKUP @ 0x080054c8
f vec.TIM8_BRK_TIM12 @ 0x0800579c
f vec.TIM8_UP_TIM13 @ 0x080054e8
f vec.TIM8_TRG_COM_TIM14 @ 0x080057a4
f vec.TIM8_CC @ 0x080057a8
f vec.DMA1_Stream7 @ 0x080057ac
f vec.FSMC @ 0x080057b0
f vec.SDIO @ 0x080057b4
f vec.TIM5 @ 0x080057b8
f vec.SPI3 @ 0x080057bc
f vec.UART4 @ 0x080057c0
f vec.UART5 @ 0x080057c4
f vec.TIM6_DAC @ 0x080054e4
f vec.TIM7 @ 0x080054e6
f vec.DMA2_Stream0 @ 0x080057d0
f vec.DMA2_Stream1 @ 0x080057d4
f vec.DMA2_Stream2 @ 0x080057d8
f vec.DMA2_Stream3 @ 0x080054ec
f vec.DMA2_Stream4 @ 0x080057e0
f vec.ETH @ 0x080057e4
f vec.ETH_WKUP @ 0x080057e8
f vec.CAN2_TX @ 0x080057ec
f vec.CAN2_RX0 @ 0x080057f0
f vec.CAN2_RX1 @ 0x080057f4
f vec.CAN2_SCE @ 0x080057f8
f vec.OTG_FS @ 0x080054ca
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
#  Named functions
#
#############################################################################
# Keep names functions near the top, so that they are known when the
# unnamed functions trigger an afr.

.(fn 0x08000188 NVIC_SystemReset)
.(fn 0x080011d2 MAL_DeInit)
.(fn 0x080010e0 DFU_LeaveDFUMode)

.(fn 0x080007f4 080007f4.retzero)
.(fn 0x080022b2 DCD_DevDisconnect)
.(fn 0x080023c8 080023c8.retzero)
.(fn 0x08003048 CPU_SR_Save_0)
.(fn 0x08003050 CPU_SR_Restore_)
.(fn 0x08003082 vec.PEND_SV)
.(fn 0x08003de8 otg_fs_int)
.(fn 0x0800506c SystemInit)
.(fn 0x080056a4 vec.RESET)
.(fn 0x080056c0 main0)
.(fn 0x080055d4 init_fpu)
.(fn 0x08005620 main2)
.(fn 0x080050cc SetSysClock)

.(fr 0x080001a8)
.(f_ 0x080001ce)
.(f_ 0x08000204)      # TODO .(fr) here trashes data area @ 0x08000dd4
.(f_ 0x080002c2)
.(fr 0x080007f8)
.(fr 0x0800089a)
.(f_ 0x08000942)
.(d4 0x08000dd4 11)
.(f_ 0x08000e00)
.(d4 0x08000fe8 1)
.(fr 0x08000fec)
.(fr 0x08001050)
.(d4 0x0800105c 7)
.(d4 0x080010dc 1)
.(fr 0x08001078)
.(fr 0x08001140)
.(fr 0x08001148)
.(d4 0x0800116c 15)
.(fr 0x080011a8)
.(f_ 0x080011fc)
.(f_ 0x08001248)
.(f_ 0x08001298)
.(f_ 0x080012ce)
.(fr 0x0800132e)
.(fr 0x08001364)
.(d4 0x0800135c 2)
.(fr 0x08001364)
.(fr 0x080013bc)
.(fr 0x0800140c)
.(fr 0x08001574)
.(fr 0x0800169c)
.(fr 0x080016f4)
.(fr 0x080017ec)
.(fr 0x08001822)
.(d4 0x080018ac 5)
.(fr 0x080018c0)
# unknown 0x080018f4
.(fr 0x08001938)
.(fr 0x08001954)
.(fr 0x0800199a)
.(fr 0x080019ae)
.(fr 0x080019d6)
.(fr 0x080019ec)
.(fr 0x08001a14)
.(fr 0x08001a2a)
.(fr 0x08001a4e)
.(fr 0x08001a72)
.(fr 0x08001aa0)
.(fr 0x08001af6)
.(fr 0x08001b18)
.(fr 0x08001b3c)
.(fr 0x08001b70)
.(fr 0x08001b82)
.(fr 0x08001b9c)
.(fr 0x08001c14)
.(fr 0x08001c26)
.(fr 0x08001c38)
.(fr 0x08001c52)
.(fr 0x08001c68)
.(fr 0x08001c8c)
.(fr 0x08001ce2)
.(f_ 0x08001cfc) # TODO using "afr" here trashes the data area @ 0x08001df0
.(fr 0x08001d1e)
.(fr 0x08001d74)
.(fr 0x08001d8a)
.(fr 0x08001da0)
.(fr 0x08001db6)
.(fr 0x08001dce)
.(fr 0x08001dde)
.(d4 0x08001df0 26)
.(fr 0x08001e58)  # unsure
.(fr 0x08001e78)  # unsure
.(fr 0x08001e8a)
.(fr 0x08001f3a)
.(fr 0x08001f8c)
.(fr 0x08001fa2)
.(fr 0x08001ffa)
.(d4 0x8002038 10)
.(fr 0x08002088)
.(fr 0x0800211e)
.(fr 0x08002178)
.(fr 0x080021be)
.(fr 0x080021fc)
.(fr 0x08002242)
.(fr 0x08002288)
.(fr 0x0800229c)
.(fr 0x080022c8)
.(d4 0x08002330 1)
.(fr 0x08002334)
.(fr 0x0800235e)
.(fr 0x08002374)
.(fr 0x080023cc)
.(fr 0x0800241e)
.(fr 0x080024b2)
.(fr 0x0800257e)
.(fr 0x0800258c)
.(fr 0x080025c0)
.(fr 0x080025de)
.(fr 0x080025fa)
.(fr 0x08002612)
.(fr 0x0800262e)
.(fr 0x0800263e)
.(fr 0x0800264c)
.(fr 0x0800265c)
.(fr 0x0800267c)
.(fr 0x080026de)
.(fr 0x0800271e)
.(fr 0x08002748)
.(fr 0x08002822)
.(fr 0x080028d8)
.(fr 0x080028f0)
.(fr 0x0800290a)
.(fr 0x08002950)
.(d4 0x08002990 2)
.(fr 0x08002998)
.(fr 0x080029ce)
.(fr 0x080029d8)
.(fr 0x080029ec)
.(fr 0x080029fe)
.(fr 0x08002a0e)
.(fr 0x08002b7e)
.(fr 0x08002bd6)
.(fr 0x08002c02)
.(fr 0x08002c4c)
.(fr 0x08002cbe)
.(fr 0x08002e24)
.(fr 0x08002f4a)
.(fr 0x08002f88)
.(fr 0x08002fc6)
.(fr 0x08002fd4)
.(fr 0x08002fe8)
.(fr 0x08002ff6)
CCa 0x08003048 store current PRIMASK in r0
CCa 0x0800304c disable IRQ via PRIMASK
.(fr 0x08003056)
.(fr 0x0800307a)
.(d4 0x080030d8 9)
.(fr 0x080030fc)
.(fr 0x08003176)
.(fr 0x08003202)
.(fr 0x08003234)
.(fr 0x08003290)
.(d4 0x080032b0 11)
.(fr 0x080032dc)
.(fr 0x0800335e)
.(fr 0x08003392)
.(fr 0x080033c6)
.(fr 0x08003412)
.(fr 0x0800355e)
.(fr 0x080035a4)
.(fr 0x080035de)
.(fr 0x080035f0)
.(fr 0x08003612)
.(fr 0x0800362e)
.(fr 0x08003646)
.(d4 0x08003908 4)
.(fr 0x08003918)
.(fr 0x0800394c)
.(fr 0x08003998)
.(fr 0x080039e8)
.(fr 0x080039f2)
.(fr 0x08003a12)
.(fr 0x08003a32)
.(d4 0x08003a54 4)
.(fr 0x08003a64)
.(fr 0x08003a6c)
.(d4 0x08003a78 2)
.(fr 0x08003a80)
.(fr 0x08003b26)
.(fr 0x08003b3c)
.(fr 0x08003b40)
.(fr 0x08003b44)
.(fr 0x08003b52)
.(fr 0x08003ba4)
.(fr 0x08003bae)
.(d4 0x08003c18 5)
.(fr 0x08003c2c)
.(fr 0x08003c6c)
.(fr 0x08003c88)
.(fr 0x08003c8c)
.(fr 0x08003c90)
.(fr 0x08003ca4)
.(d4 0x08003d80 3)
.(fr 0x08003d8c)
.(fr 0x08003eba)
.(fr 0x08003f02)
# 0x08003f2c
.(fr 0x08003f8a)
.(fr 0x0800407e)
.(fr 0x08004148)
.(fr 0x08004164)
.(fr 0x08004202)
.(fr 0x0800428a)
.(fr 0x08004344)
.(fr 0x0800438e)
.(d4 0x08004970 16)
.(fr 0x080049b0)
.(fr 0x080049ee)
.(fr 0x08004a08)
.(d4 0x08004a6c 10)
.(fr 0x08004a94)
.(d4 0x08004ae4 1)
.(fr 0x08004ae8)  # unsure
.(fr 0x08004ef2)
.(fr 0x08004efc)
.(fr 0x08004f10)
.(fr 0x08005020)
.(fr 0x08005024)
.(d4 0x08005038 13)
CCa 0x0800506c see stm/system_stm32f4xx.c
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
f VTOR @ 0xe000ed08
CCa 0x080050c2 Vector Table Offset Register
.(d4 0x08005198 76)
.(d4 0x080054d4 1)
.(d4 0x080056ac 5)
.(ds 0x080054f0 40 str.SPI_Flash_Memory1)
.(ds 0x08005518 40 str.SPI_Flash_Memory2)
CCa 0x080055dc access CPACE
CCa 0x080055de enable CP10 and CP11 coprocessors (FPU)
CCa 0x080055e4 set DN (Default NaN)
CCa 0x080055e8 store in FPSCR
#afvs 0 HSEStatus int
#afvs 4 StartUpCounter qint
CCa 0x080050da set HSEON
CCa 0x080050e6 check HSERDY
CCa 0x080050fa HSE_STARTUP_TIMEOUT
CCa 0x08005104 RCC_CR & RCC_CR_HSERDY) != RESET
CCa 0x08005114 if (HSEStatus == 0x01)
f RCC_RCC_APB1ENR @ 0x40023840
CCa 0x0800511c set PWREN
f RCC_RCC_APB1ENR @ 0x40023840
CCa 0x08005128 set PWR_CR_VOS

#Vp
# s SetSysClock
#e asm.describe=1
#e asm.esil=1
# pdf @ main2
e asm.bytes = 1


s DFU_LeaveDFUMode
afM >a.map
Vp
