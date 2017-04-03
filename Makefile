PROJECT=md380

.PHONY:: all clean
all::

#CROSS=arm-linux-gnueabihf
CROSS=arm-none-eabi
#RTOS_ARCH=ARM_CM4_MPU
RTOS_ARCH=ARM_CM4F
CC=$(CROSS)-gcc
AR=$(CROSS)-ar
OBJCOPY=$(CROSS)-objcopy
OBJDUMP=$(CROSS)-objdump
ARCH=$(CROSS)-ar
WARNINGS=-Wall -Wextra
LDSCRIPT=md380.ld
CFLAGS= $(WARNINGS) \
	-std=c99 \
	-D $(RTOS_ARCH) \
	$(INCLUDES) $(BASEINCLUDE) \
	-mcpu=cortex-m4 -mthumb \
	-mfpu=fpv4-sp-d16 -mfloat-abi=hard \
	-T$(LDSCRIPT) \
	-g -O3 -fomit-frame-pointer
INCLUDES += -I.
INCLUDES += -Istm
INCLUDES += -Ifreertos/FreeRTOS/Source/include
INCLUDES += -Ifreertos/FreeRTOS/Source/portable/GCC/$(RTOS_ARCH)
LINKER_FLAGS=-Xlinker -o$(PROJECT).elf
#LINKER_FLAGS+-Xlinker -M
#LINKER_FLAGS+=-Xlinker -Map=$(PROJECT).map
BASEINCLUDE=-I. -I/FreeRTOS/include -I/FreeRTOS/portable/GCC/$(RTOS_ARCH)

vpath %.c stm
vpath %.c freertos/FreeRTOS/Source
vpath %.c freertos/FreeRTOS/Source/portable/MemMang
vpath %.c freertos/FreeRTOS/Source/portable/GCC/$(RTOS_ARCH)

# Our code:
SRC_FILES += main.c rcc.c gpio.c fault.c led.c
# STM code:
SRC_FILES += system_stm32f4xx.c
# RTOS code:
SRC_FILES += list.c queue.c tasks.c heap_2.c port.c

ARM_OBJ = $(SRC_FILES:.c=.o)

$(ARM_OBJ) : %.o : %.c Makefile
	$(CC) -c $(CFLAGS) $< -o $@
clean::
	rm -f $(ARM_OBJ)


all:: $(PROJECT).elf
$(PROJECT).elf: Makefile $(ARM_OBJ) $(LDSCRIPT)
	$(CC) $(CFLAGS) $(ARM_OBJ) -nostartfiles $(LINKER_FLAGS)

$(PROJECT).lst: $(PROJECT).elf
	$(OBJDUMP) -d -S $(PROJECT).elf >$(PROJECT).lst
clean::
	rm -f $(PROJECT).elf $(PROJECT).map





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


