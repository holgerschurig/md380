# @compile: disasm/checksort.py disasm/cpu.r

f io_TIM3               @ 0x40000400
f io_TIM4               @ 0x40000800
f io_TIM5               @ 0x40000c00
f io_TIM6               @ 0x40001000
f io_TIM7               @ 0x40001400

f io_RTC                @ 0x40002800

f io_0x40002804         @ 0x40002804
f io_0x40002808         @ 0x40002808
f io_0x4000280c         @ 0x4000280c
f io_0x40002810         @ 0x40002810
f io_0x40002814         @ 0x40002814
f io_0x40002824         @ 0x40002824
f io_0x40002840         @ 0x40002840
f io_0x40002850         @ 0x40002850
f io_0x40003000         @ 0x40003000
f io_0x40003004         @ 0x40003004
f io_0x40003008         @ 0x40003008

f io_SPI2               @ 0x40003800
f io_SPI3               @ 0x40003c00
f io_SPI3_DR            @ 0x40003c0c
f io_4000400c           @ 0x4000400c

f io_USART3             @ 0x40004800

f io_I2C1               @ 0x40005400

f io_PWR                @ 0x40007000
f io_PWR_CSR            @ 0x40007004
f io_DAC                @ 0x40007400
f io_4000f88d           @ 0x4000f88d

f io_TIM1               @ 0x40010000

f io_TIM8               @ 0x40010400

f io_USART1             @ 0x40011000

f io_USART6             @ 0x40011400

f io_ADC1               @ 0x40012000
f io_ADC1_DR            @ 0x4001204c
f io_ADC2               @ 0x40012100
f io_ADC2_DR            @ 0x4001214c
f io_ADC3               @ 0x40012200
f io_ADC_CCR            @ 0x40012304

f io_SPI1               @ 0x40013000

f io_SYSCFG_EXTICR1     @ 0x40013808

f io_EXTI_IMR           @ 0x40013c00
f io_EXTI_EMR           @ 0x40013c04
f io_EXTI_RTSR          @ 0x40013c08
f io_EXTI_FTSR          @ 0x40013c0c
f io_EXTIPR             @ 0x40013c14

f io_GPIOA              @ 0x40020000
f io_GPIOB              @ 0x40020400
f io_GPIOC              @ 0x40020800
f io_GPIOD              @ 0x40020c00
f io_GPIOE              @ 0x40021000

f io_CRC                @ 0x40023000
f io_CRC_C              @ 0x40023008

f io_RCC_CR             @ 0x40023800
f io_RCC_PLLCFGR        @ 0x40023804
f io_RCC_CFGR           @ 0x40023808
f io_RCC_CIR            @ 0x4002380c
f io_RCC_AHB1ENR        @ 0x40023830
f io_RCC_AHB2ENR        @ 0x40023834
f io_RCC_AHB3ENR        @ 0x40023838
f io_RCC_APB1ENR        @ 0x40023840
f io_RCC_APB2ENR        @ 0x40023844
f io_RCC_BDCR           @ 0x40023870
f io_RCC_CSR            @ 0x40023874
f io_RCC_PLLI2SCFGR     @ 0x40023884

f io_FLASH_ACR          @ 0x40023c00
f io_FLASH_KEYR         @ 0x40023c04
f io_FLASH_OPTKEYR      @ 0x40023c08
f io_FLASH_SR           @ 0x40023c0c
f io_FLASH_CR           @ 0x40023c10
f io_FLASH_OPTCR        @ 0x40023c14
f io_FLASH_OPTCR_RDP    @ 0x40023c15

f io_DMA1_LISR          @ 0x40026000
f io_DMA1_S2CR          @ 0x40026040
f io_DMA1_S5CR          @ 0x40026088
f io_DMA2_LISR          @ 0x40026400
f io_DMA2_S0CR          @ 0x40026410
f io_DMA2_S3CR          @ 0x40026458
f io_OTG_HS_GOTGCTL     @ 0x40040000
f io_400a6666           @ 0x400a6666


f io_VTOR               @ 0xe000ed08 # Vector Table Offset Register
# http://infocenter.arm.com/help/topic/com.arm.doc.dui0553a/Ciheijba.html

f io_AIRCR              @ 0xe000ed0c # Application Interrupt and Reset Control Register
# http://infocenter.arm.com/help/topic/com.arm.doc.dui0553a/Cihehdge.html

f io_CPACE              @ 0xe000ed88 # Coprocessor Access Control Register
# http://infocenter.arm.com/help/topic/com.arm.doc.dui0553a/BABDBFBJ.html
