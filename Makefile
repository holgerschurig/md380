PROJECT=md380

.PHONY:: all clean
all obj/md380.bin:: freertos/.git/HEAD
	@ninja | cat

clean::
	ninja -t clean





#############################################################################
#
#  Documentation
#
#############################################################################
.PHONY:: doc
doc:: doc/STM32F405.pdf
doc/STM32F405.pdf:
	mkdir -p doc
	wget -O $@ -c http://www.st.com/resource/en/datasheet/STM32F405rg.pdf
doc:: doc/STM32F405_Reference_Manual.pdf
doc/STM32F405_Reference_Manual.pdf:
	mkdir -p doc
	wget -O $@ -c http://www.st.com/resource/en/reference_manual/dm00031020.pdf
doc:: doc/STM32F405_Programming_Manual.pdf
doc/STM32F405_Programming_Manual.pdf:
	mkdir -p doc
	wget -O $@ -c http://www.st.com/resource/en/programming_manual/dm00046982.pdf
doc:: doc/STM32Cube_UM1725_HAL_LL_Driver_description.pdf
doc/STM32Cube_UM1725_HAL_LL_Driver_description.pdf:
	mkdir -p doc
	wget -O $@ -c http://www.st.com/resource/en/user_manual/dm00105879.pdf
doc:: doc/STM32Cube_UM1734_USB_Device_Library.pdf
doc/STM32Cube_UM1734_USB_Device_Library.pdf:
	mkdir -p doc
	wget -O $@ -c http://www.st.com/resource/en/user_manual/dm00108129.pdf
doc:: doc/MD380_Schematics.pdf
doc/MD380_Schematics.pdf:
	mkdir -p doc
	wget -O $@ -c http://www.pc5e.nl/downloads/md380/documents/MD-380UHF-RF-schematic.pdf
doc:: doc/SKY72310_Frequency_Synthesizer.pdf
doc/SKY72310_Frequency_Synthesizer.pdf:
	mkdir -p doc
	wget -O $@ -c http://www.skyworksinc.com/uploads/documents/200705E.pdf
doc:: doc/GT3136_Detector.pdf
doc/GT3136_Detector.pdf:
	mkdir -p doc
	wget -O $@ -c "http://www.devicemart.co.kr/include/down.php?file=/data/goods/goodsfile/1074873_file_0.pdf&mode=goods&name=GT3136%20Rev.pdf"
doc:: doc/XC6204_PMIC.pdf
doc/XC6204_PMIC.pdf:
	mkdir -p doc
	wget -O $@ -c https://www.torexsemi.com/file/xc6204/XC6204-XC6205.pdf
doc:: doc/ILI9481_LCD_Display.pdf
doc/ILI9481_LCD_Display.pdf:
	wget -O $@ -c http://www.ncsys.co.jp/webshop/GTV350MPZI04\(ILI9481\).pdf
doc:: doc/CS8x0_Service_Manual.pdf
doc/CS8x0_Service_Manual.pdf:
	wget -O $@ -c http://www.connectsystems.com/software/CS810_documents/CS800%20Service%20Manual.pdf
doc:: doc/UC-OS-III.pdf
doc/UC-OS-III.pdf:
	wget -O $@ -c https://presentations.inxpo.com/Shows/UBM/EETimes/STMicroelectronics/12-10/Booths/Micrium/100-uCOS-III-ST-STM32-002.pdf




#############################################################################
#
#  Freertos
#
#############################################################################

# Woah, the GIT mirror has much faster download times than
# sourceforge's file download. Let's use it:
.PHONY:: getrtos
getrtos: freertos/.git/HEAD
freertos/.git/HEAD:
	git clone --depth 1 https://github.com/cjlano/freertos

# I have a prune target that removes the unneeded things. That way I
# can much faster search with "ag" (or "grep -r") inside freertos/
.PHONY:: prunertos
prunertos:
	rm -rf freertos/FreeRTOS-Plus
	rm -rf freertos/FreeRTOS/Demo/ARM7*
	rm -rf freertos/FreeRTOS/Demo/ARM9*
	rm -rf freertos/FreeRTOS/Demo/AVR*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_A*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_C*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_E*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_K*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_L*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_LPC*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_M0*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_M4F_ATSAM4E_Atmel_Studio
	rm -rf freertos/FreeRTOS/Demo/CORTEX_M4F_CEC1302_Keil_GCC/
	rm -rf freertos/FreeRTOS/Demo/CORTEX_M4F_CEC1302_MikroC/
	rm -rf freertos/FreeRTOS/Demo/CORTEX_M4F_CEC_MEC_17xx_Keil_GCC/
	rm -rf freertos/FreeRTOS/Demo/CORTEX_M4F_Infineon_*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_M4F_M0_LPC43xx_Keil/
	rm -rf freertos/FreeRTOS/Demo/CORTEX_M4F_MSP432_LaunchPad_IAR_CCS_Keil/
	rm -rf freertos/FreeRTOS/Demo/CORTEX_M4_*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_M7*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_MB*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_MPU*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_R*
	rm -rf freertos/FreeRTOS/Demo/CORTEX_STM32F100_Atollic
	rm -rf freertos/FreeRTOS/Demo/CORTEX_STM32F103_IAR/
	rm -rf freertos/FreeRTOS/Demo/CORTEX_STM32F103_Keil/
	rm -rf freertos/FreeRTOS/Demo/CORTEX_STM32L152_Discovery_IAR/
	rm -rf freertos/FreeRTOS/Demo/CORTEX_STM32L152_IAR/
	rm -rf freertos/FreeRTOS/Demo/CORTEX_Sm*
	rm -rf freertos/FreeRTOS/Demo/CORTUS*
	rm -rf freertos/FreeRTOS/Demo/ColdFire*
	rm -rf freertos/FreeRTOS/Demo/Cygnal
	rm -rf freertos/FreeRTOS/Demo/Flshlite
	rm -rf freertos/FreeRTOS/Demo/H8S
	rm -rf freertos/FreeRTOS/Demo/HCS12*
	rm -rf freertos/FreeRTOS/Demo/IA32*
	rm -rf freertos/FreeRTOS/Demo/M*
	rm -rf freertos/FreeRTOS/Demo/MSP*
	rm -rf freertos/FreeRTOS/Demo/NEC*
	rm -rf freertos/FreeRTOS/Demo/Nios*
	rm -rf freertos/FreeRTOS/Demo/PC
	rm -rf freertos/FreeRTOS/Demo/PIC*
	rm -rf freertos/FreeRTOS/Demo/PPC*
	rm -rf freertos/FreeRTOS/Demo/RL78*
	rm -rf freertos/FreeRTOS/Demo/RX*
	rm -rf freertos/FreeRTOS/Demo/SuperH*
	rm -rf freertos/FreeRTOS/Demo/TriCore*
	rm -rf freertos/FreeRTOS/Demo/Unsupported*
	rm -rf freertos/FreeRTOS/Demo/WIN32*
	rm -rf freertos/FreeRTOS/Demo/WizNET*
	rm -rf freertos/FreeRTOS/Demo/Xilinx*
	rm -rf freertos/FreeRTOS/Demo/dsPIC*
	rm -rf freertos/FreeRTOS/Demo/lwIP*
	rm -rf freertos/FreeRTOS/Demo/msp*
	rm -rf freertos/FreeRTOS/Demo/uIP*
	rm -rf freertos/FreeRTOS/Source/portable/BCC
	rm -rf freertos/FreeRTOS/Source/portable/CCS
	rm -rf freertos/FreeRTOS/Source/portable/CodeWarrior
	rm -rf freertos/FreeRTOS/Source/portable/IAR
	rm -rf freertos/FreeRTOS/Source/portable/Keil
	rm -rf freertos/FreeRTOS/Source/portable/MikroC
	rm -rf freertos/FreeRTOS/Source/portable/MPLAB
	rm -rf freertos/FreeRTOS/Source/portable/MSVC-MingW
	rm -rf freertos/FreeRTOS/Source/portable/oWatcom
	rm -rf freertos/FreeRTOS/Source/portable/Paradigm
	rm -rf freertos/FreeRTOS/Source/portable/Renesas
	rm -rf freertos/FreeRTOS/Source/portable/Rowley
	rm -rf freertos/FreeRTOS/Source/portable/RVDS
	rm -rf freertos/FreeRTOS/Source/portable/SDCC
	rm -rf freertos/FreeRTOS/Source/portable/Softune
	rm -rf freertos/FreeRTOS/Source/portable/Tasking
	rm -rf freertos/FreeRTOS/Source/portable/WizC


#############################################################################
#
#  µC/OS-III
#
#############################################################################

# See for example https://github.com/HANDS-FREE/OpenRE how this might work out

ucosiii: ucosiii/.git/HEAD
ucosiii/.git/HEAD:
	git clone --depth 1 https://github.com/HANDS-FREE/OpenRE ucosiii
