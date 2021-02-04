
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _colloc=R5
	.DEF _rowloc=R4
	.DEF _out=R7
	.DEF _SelectedCategory=R6
	.DEF _i=R8
	.DEF _i_msb=R9
	.DEF _h=R10
	.DEF _h_msb=R11
	.DEF _WordIndex=R12
	.DEF _WordIndex_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x6:
	.DB  0x31,0x32,0x33,0x41,0x36,0x35,0x34,0x42
	.DB  0x37,0x38,0x39,0x43,0x2A,0x30,0x23,0x44
_0x17:
	.DB  LOW(_0x16),HIGH(_0x16),LOW(_0x16+6),HIGH(_0x16+6),LOW(_0x16+12),HIGH(_0x16+12),LOW(_0x16+22),HIGH(_0x16+22)
_0x19:
	.DB  LOW(_0x18),HIGH(_0x18),LOW(_0x18+9),HIGH(_0x18+9),LOW(_0x18+20),HIGH(_0x18+20),LOW(_0x18+31),HIGH(_0x18+31)
	.DB  LOW(_0x18+38),HIGH(_0x18+38),LOW(_0x18+45),HIGH(_0x18+45),LOW(_0x18+52),HIGH(_0x18+52),LOW(_0x18+59),HIGH(_0x18+59)
	.DB  LOW(_0x18+67),HIGH(_0x18+67),LOW(_0x18+77),HIGH(_0x18+77),LOW(_0x18+84),HIGH(_0x18+84),LOW(_0x18+89),HIGH(_0x18+89)
	.DB  LOW(_0x18+94),HIGH(_0x18+94),LOW(_0x18+103),HIGH(_0x18+103),LOW(_0x18+112),HIGH(_0x18+112),LOW(_0x18+120),HIGH(_0x18+120)
	.DB  LOW(_0x18+130),HIGH(_0x18+130),LOW(_0x18+140),HIGH(_0x18+140),LOW(_0x18+148),HIGH(_0x18+148),LOW(_0x18+157),HIGH(_0x18+157)
_0x1B:
	.DB  LOW(_0x1A),HIGH(_0x1A),LOW(_0x1A+6),HIGH(_0x1A+6),LOW(_0x1A+13),HIGH(_0x1A+13),LOW(_0x1A+23),HIGH(_0x1A+23)
	.DB  LOW(_0x1A+30),HIGH(_0x1A+30),LOW(_0x1A+35),HIGH(_0x1A+35),LOW(_0x1A+47),HIGH(_0x1A+47),LOW(_0x1A+55),HIGH(_0x1A+55)
	.DB  LOW(_0x1A+63),HIGH(_0x1A+63),LOW(_0x1A+70),HIGH(_0x1A+70),LOW(_0x1A+75),HIGH(_0x1A+75),LOW(_0x1A+87),HIGH(_0x1A+87)
	.DB  LOW(_0x1A+93),HIGH(_0x1A+93),LOW(_0x1A+101),HIGH(_0x1A+101),LOW(_0x1A+108),HIGH(_0x1A+108),LOW(_0x1A+116),HIGH(_0x1A+116)
	.DB  LOW(_0x1A+124),HIGH(_0x1A+124),LOW(_0x1A+129),HIGH(_0x1A+129),LOW(_0x1A+146),HIGH(_0x1A+146),LOW(_0x1A+159),HIGH(_0x1A+159)
_0x1D:
	.DB  LOW(_0x1C),HIGH(_0x1C),LOW(_0x1C+5),HIGH(_0x1C+5),LOW(_0x1C+13),HIGH(_0x1C+13),LOW(_0x1C+20),HIGH(_0x1C+20)
	.DB  LOW(_0x1C+28),HIGH(_0x1C+28),LOW(_0x1C+38),HIGH(_0x1C+38),LOW(_0x1C+45),HIGH(_0x1C+45),LOW(_0x1C+51),HIGH(_0x1C+51)
	.DB  LOW(_0x1C+57),HIGH(_0x1C+57),LOW(_0x1C+61),HIGH(_0x1C+61),LOW(_0x1C+72),HIGH(_0x1C+72),LOW(_0x1C+80),HIGH(_0x1C+80)
	.DB  LOW(_0x1C+86),HIGH(_0x1C+86),LOW(_0x1C+97),HIGH(_0x1C+97),LOW(_0x1C+107),HIGH(_0x1C+107),LOW(_0x1C+115),HIGH(_0x1C+115)
	.DB  LOW(_0x1C+123),HIGH(_0x1C+123),LOW(_0x1C+134),HIGH(_0x1C+134),LOW(_0x1C+141),HIGH(_0x1C+141),LOW(_0x1C+148),HIGH(_0x1C+148)
_0x1F:
	.DB  LOW(_0x1E),HIGH(_0x1E),LOW(_0x1E+5),HIGH(_0x1E+5),LOW(_0x1E+11),HIGH(_0x1E+11),LOW(_0x1E+20),HIGH(_0x1E+20)
	.DB  LOW(_0x1E+25),HIGH(_0x1E+25),LOW(_0x1E+33),HIGH(_0x1E+33),LOW(_0x1E+49),HIGH(_0x1E+49),LOW(_0x1E+56),HIGH(_0x1E+56)
	.DB  LOW(_0x1E+65),HIGH(_0x1E+65),LOW(_0x1E+72),HIGH(_0x1E+72),LOW(_0x1E+79),HIGH(_0x1E+79),LOW(_0x1E+88),HIGH(_0x1E+88)
	.DB  LOW(_0x1E+95),HIGH(_0x1E+95),LOW(_0x1E+111),HIGH(_0x1E+111),LOW(_0x1E+123),HIGH(_0x1E+123),LOW(_0x1E+130),HIGH(_0x1E+130)
	.DB  LOW(_0x1E+136),HIGH(_0x1E+136),LOW(_0x1E+146),HIGH(_0x1E+146),LOW(_0x1E+153),HIGH(_0x1E+153),LOW(_0x1E+163),HIGH(_0x1E+163)
_0x21:
	.DB  LOW(_0x20),HIGH(_0x20),LOW(_0x20+2),HIGH(_0x20+2),LOW(_0x20+4),HIGH(_0x20+4),LOW(_0x20+6),HIGH(_0x20+6)
	.DB  LOW(_0x20+8),HIGH(_0x20+8),LOW(_0x20+10),HIGH(_0x20+10)
_0x23:
	.DB  LOW(_0x22),HIGH(_0x22),LOW(_0x22+2),HIGH(_0x22+2),LOW(_0x22+4),HIGH(_0x22+4),LOW(_0x22+6),HIGH(_0x22+6)
	.DB  LOW(_0x22+8),HIGH(_0x22+8),LOW(_0x22+10),HIGH(_0x22+10)
_0x25:
	.DB  LOW(_0x24),HIGH(_0x24),LOW(_0x24+2),HIGH(_0x24+2),LOW(_0x24+4),HIGH(_0x24+4),LOW(_0x24+6),HIGH(_0x24+6)
	.DB  LOW(_0x24+8),HIGH(_0x24+8),LOW(_0x24+10),HIGH(_0x24+10),LOW(_0x24+12),HIGH(_0x24+12)
_0x27:
	.DB  LOW(_0x26),HIGH(_0x26),LOW(_0x26+2),HIGH(_0x26+2),LOW(_0x26+4),HIGH(_0x26+4),LOW(_0x26+6),HIGH(_0x26+6)
	.DB  LOW(_0x26+8),HIGH(_0x26+8),LOW(_0x26+10),HIGH(_0x26+10),LOW(_0x26+12),HIGH(_0x26+12)
_0x29:
	.DB  LOW(_0x28),HIGH(_0x28),LOW(_0x28+2),HIGH(_0x28+2),LOW(_0x28+4),HIGH(_0x28+4),LOW(_0x28+6),HIGH(_0x28+6)
	.DB  LOW(_0x28+8),HIGH(_0x28+8),LOW(_0x28+10),HIGH(_0x28+10),LOW(_0x28+12),HIGH(_0x28+12)
_0x2B:
	.DB  LOW(_0x2A),HIGH(_0x2A),LOW(_0x2A+2),HIGH(_0x2A+2),LOW(_0x2A+4),HIGH(_0x2A+4),LOW(_0x2A+6),HIGH(_0x2A+6)
	.DB  LOW(_0x2A+8),HIGH(_0x2A+8),LOW(_0x2A+10),HIGH(_0x2A+10),LOW(_0x2A+12),HIGH(_0x2A+12),LOW(_0x2A+14),HIGH(_0x2A+14)
	.DB  LOW(_0x2A+16),HIGH(_0x2A+16),LOW(_0x2A+18),HIGH(_0x2A+18),LOW(_0x2A+20),HIGH(_0x2A+20),LOW(_0x2A+22),HIGH(_0x2A+22)
	.DB  LOW(_0x2A+24),HIGH(_0x2A+24),LOW(_0x2A+26),HIGH(_0x2A+26),LOW(_0x2A+28),HIGH(_0x2A+28),LOW(_0x2A+30),HIGH(_0x2A+30)
	.DB  LOW(_0x2A+32),HIGH(_0x2A+32),LOW(_0x2A+34),HIGH(_0x2A+34),LOW(_0x2A+36),HIGH(_0x2A+36),LOW(_0x2A+38),HIGH(_0x2A+38)
	.DB  LOW(_0x2A+40),HIGH(_0x2A+40),LOW(_0x2A+42),HIGH(_0x2A+42),LOW(_0x2A+44),HIGH(_0x2A+44),LOW(_0x2A+46),HIGH(_0x2A+46)
	.DB  LOW(_0x2A+48),HIGH(_0x2A+48),LOW(_0x2A+50),HIGH(_0x2A+50)
_0x2C:
	.DB  0x3
_0x0:
	.DB  0x53,0x70,0x6F,0x72,0x74,0x0,0x4D,0x6F
	.DB  0x76,0x69,0x65,0x0,0x43,0x6F,0x75,0x6E
	.DB  0x74,0x72,0x69,0x65,0x73,0x0,0x43,0x53
	.DB  0x0,0x66,0x6F,0x6F,0x74,0x62,0x61,0x6C
	.DB  0x6C,0x0,0x62,0x61,0x73,0x6B,0x65,0x74
	.DB  0x62,0x61,0x6C,0x6C,0x0,0x76,0x6F,0x6C
	.DB  0x6C,0x65,0x79,0x62,0x61,0x6C,0x6C,0x0
	.DB  0x6B,0x61,0x72,0x61,0x74,0x65,0x0,0x6B
	.DB  0x75,0x6E,0x67,0x66,0x75,0x0,0x62,0x6F
	.DB  0x78,0x69,0x6E,0x67,0x0,0x74,0x65,0x6E
	.DB  0x6E,0x69,0x73,0x0,0x72,0x75,0x6E,0x6E
	.DB  0x69,0x6E,0x67,0x0,0x77,0x72,0x65,0x73
	.DB  0x74,0x6C,0x69,0x6E,0x67,0x0,0x68,0x6F
	.DB  0x63,0x6B,0x65,0x79,0x0,0x6A,0x75,0x64
	.DB  0x6F,0x0,0x67,0x6F,0x6C,0x66,0x0,0x62
	.DB  0x61,0x73,0x65,0x62,0x61,0x6C,0x6C,0x0
	.DB  0x62,0x69,0x6C,0x6C,0x69,0x61,0x72,0x64
	.DB  0x0,0x63,0x75,0x72,0x6C,0x69,0x6E,0x67
	.DB  0x0,0x77,0x61,0x74,0x65,0x72,0x70,0x6F
	.DB  0x6C,0x6F,0x0,0x74,0x61,0x65,0x6B,0x77
	.DB  0x61,0x6E,0x64,0x6F,0x0,0x66,0x65,0x6E
	.DB  0x63,0x69,0x6E,0x67,0x0,0x73,0x77,0x69
	.DB  0x6D,0x6D,0x69,0x6E,0x67,0x0,0x6A,0x75
	.DB  0x6A,0x69,0x74,0x73,0x75,0x0,0x6A,0x6F
	.DB  0x6B,0x65,0x72,0x0,0x62,0x61,0x74,0x6D
	.DB  0x61,0x6E,0x0,0x67,0x6F,0x64,0x66,0x61
	.DB  0x74,0x68,0x65,0x72,0x0,0x6C,0x69,0x7A
	.DB  0x61,0x72,0x64,0x0,0x73,0x6F,0x75,0x6C
	.DB  0x0,0x69,0x6E,0x63,0x72,0x65,0x64,0x69
	.DB  0x62,0x6C,0x65,0x73,0x0,0x6D,0x65,0x6D
	.DB  0x65,0x6E,0x74,0x6F,0x0,0x61,0x72,0x72
	.DB  0x69,0x76,0x61,0x6C,0x0,0x62,0x75,0x72
	.DB  0x69,0x65,0x64,0x0,0x63,0x75,0x62,0x65
	.DB  0x0,0x62,0x6C,0x61,0x64,0x65,0x72,0x75
	.DB  0x6E,0x6E,0x65,0x72,0x0,0x61,0x6C,0x69
	.DB  0x65,0x6E,0x0,0x73,0x68,0x69,0x6E,0x69
	.DB  0x6E,0x67,0x0,0x70,0x79,0x73,0x63,0x68
	.DB  0x6F,0x0,0x74,0x69,0x74,0x61,0x6E,0x69
	.DB  0x63,0x0,0x76,0x65,0x72,0x74,0x69,0x67
	.DB  0x6F,0x0,0x65,0x78,0x61,0x6D,0x0,0x6E
	.DB  0x6F,0x63,0x74,0x75,0x72,0x6E,0x61,0x6C
	.DB  0x61,0x6E,0x69,0x6D,0x61,0x6C,0x73,0x0
	.DB  0x73,0x77,0x69,0x73,0x73,0x61,0x72,0x6D
	.DB  0x79,0x6D,0x61,0x6E,0x0,0x73,0x65,0x70
	.DB  0x65,0x72,0x61,0x74,0x69,0x6F,0x6E,0x0
	.DB  0x69,0x72,0x61,0x6E,0x0,0x67,0x65,0x72
	.DB  0x6D,0x61,0x6E,0x79,0x0,0x62,0x72,0x61
	.DB  0x7A,0x69,0x6C,0x0,0x65,0x6E,0x67,0x6C
	.DB  0x61,0x6E,0x64,0x0,0x61,0x72,0x67,0x65
	.DB  0x6E,0x74,0x69,0x6E,0x61,0x0,0x73,0x77
	.DB  0x65,0x64,0x65,0x6E,0x0,0x73,0x61,0x6D
	.DB  0x6F,0x61,0x0,0x63,0x68,0x69,0x6E,0x61
	.DB  0x0,0x75,0x61,0x65,0x0,0x75,0x7A,0x62
	.DB  0x61,0x6B,0x69,0x73,0x74,0x61,0x6E,0x0
	.DB  0x64,0x65,0x6E,0x6D,0x61,0x72,0x6B,0x0
	.DB  0x67,0x68,0x61,0x6E,0x61,0x0,0x62,0x61
	.DB  0x6E,0x67,0x6C,0x61,0x64,0x65,0x73,0x68
	.DB  0x0,0x76,0x65,0x6E,0x65,0x7A,0x75,0x65
	.DB  0x6C,0x61,0x0,0x7A,0x69,0x6D,0x62,0x61
	.DB  0x77,0x65,0x0,0x6E,0x69,0x67,0x65,0x72
	.DB  0x69,0x61,0x0,0x6C,0x75,0x78,0x65,0x6D
	.DB  0x62,0x6F,0x75,0x72,0x67,0x0,0x67,0x72
	.DB  0x65,0x65,0x63,0x65,0x0,0x66,0x72,0x61
	.DB  0x6E,0x63,0x65,0x0,0x63,0x79,0x70,0x72
	.DB  0x75,0x73,0x0,0x63,0x6F,0x64,0x65,0x0
	.DB  0x64,0x65,0x62,0x75,0x67,0x0,0x63,0x6F
	.DB  0x6D,0x70,0x69,0x6C,0x65,0x72,0x0,0x6A
	.DB  0x61,0x76,0x61,0x0,0x62,0x6F,0x6F,0x6C
	.DB  0x65,0x61,0x6E,0x0,0x6F,0x70,0x65,0x72
	.DB  0x61,0x74,0x69,0x6E,0x67,0x73,0x79,0x73
	.DB  0x74,0x65,0x6D,0x0,0x67,0x69,0x74,0x68
	.DB  0x75,0x62,0x0,0x66,0x75,0x6E,0x63,0x74
	.DB  0x69,0x6F,0x6E,0x0,0x73,0x79,0x6E,0x74
	.DB  0x61,0x78,0x0,0x63,0x69,0x70,0x68,0x65
	.DB  0x72,0x0,0x61,0x72,0x67,0x75,0x6D,0x65
	.DB  0x6E,0x74,0x0,0x70,0x79,0x74,0x68,0x6F
	.DB  0x6E,0x0,0x6D,0x61,0x63,0x68,0x69,0x6E
	.DB  0x65,0x6C,0x65,0x61,0x72,0x6E,0x69,0x6E
	.DB  0x67,0x0,0x69,0x6E,0x74,0x65,0x72,0x70
	.DB  0x72,0x65,0x74,0x65,0x72,0x0,0x67,0x6F
	.DB  0x6F,0x67,0x6C,0x65,0x0,0x71,0x75,0x65
	.DB  0x72,0x79,0x0,0x61,0x6C,0x67,0x6F,0x72
	.DB  0x69,0x74,0x68,0x6D,0x0,0x6B,0x65,0x72
	.DB  0x6E,0x65,0x6C,0x0,0x70,0x72,0x6F,0x63
	.DB  0x65,0x73,0x73,0x6F,0x72,0x0,0x63,0x6F
	.DB  0x6E,0x63,0x75,0x72,0x72,0x65,0x6E,0x63
	.DB  0x79,0x0,0x69,0x0,0x6A,0x0,0x70,0x0
	.DB  0x71,0x0,0x76,0x0,0x77,0x0,0x7A,0x0
	.DB  0x20,0x0,0x2A,0x0,0x53,0x63,0x6F,0x72
	.DB  0x65,0x3A,0x20,0x25,0x64,0x0,0x53,0x65
	.DB  0x63,0x6F,0x6E,0x64,0x20,0x4C,0x63,0x64
	.DB  0x0,0x20,0x25,0x64,0x2E,0x0,0x5F,0x20
	.DB  0x0,0x43,0x6F,0x72,0x72,0x65,0x63,0x74
	.DB  0x21,0x0,0x47,0x41,0x4D,0x45,0x20,0x4F
	.DB  0x56,0x45,0x52,0x21,0x21,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x74,0x72,0x79,0x20,0x61,0x67,0x61,0x69
	.DB  0x6E,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0C
	.DW  __REG_VARS*2

	.DW  0x10
	.DW  _keypad
	.DW  _0x6*2

	.DW  0x06
	.DW  _0x16
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x16+6
	.DW  _0x0*2+6

	.DW  0x0A
	.DW  _0x16+12
	.DW  _0x0*2+12

	.DW  0x03
	.DW  _0x16+22
	.DW  _0x0*2+22

	.DW  0x08
	.DW  _Category
	.DW  _0x17*2

	.DW  0x09
	.DW  _0x18
	.DW  _0x0*2+25

	.DW  0x0B
	.DW  _0x18+9
	.DW  _0x0*2+34

	.DW  0x0B
	.DW  _0x18+20
	.DW  _0x0*2+45

	.DW  0x07
	.DW  _0x18+31
	.DW  _0x0*2+56

	.DW  0x07
	.DW  _0x18+38
	.DW  _0x0*2+63

	.DW  0x07
	.DW  _0x18+45
	.DW  _0x0*2+70

	.DW  0x07
	.DW  _0x18+52
	.DW  _0x0*2+77

	.DW  0x08
	.DW  _0x18+59
	.DW  _0x0*2+84

	.DW  0x0A
	.DW  _0x18+67
	.DW  _0x0*2+92

	.DW  0x07
	.DW  _0x18+77
	.DW  _0x0*2+102

	.DW  0x05
	.DW  _0x18+84
	.DW  _0x0*2+109

	.DW  0x05
	.DW  _0x18+89
	.DW  _0x0*2+114

	.DW  0x09
	.DW  _0x18+94
	.DW  _0x0*2+119

	.DW  0x09
	.DW  _0x18+103
	.DW  _0x0*2+128

	.DW  0x08
	.DW  _0x18+112
	.DW  _0x0*2+137

	.DW  0x0A
	.DW  _0x18+120
	.DW  _0x0*2+145

	.DW  0x0A
	.DW  _0x18+130
	.DW  _0x0*2+155

	.DW  0x08
	.DW  _0x18+140
	.DW  _0x0*2+165

	.DW  0x09
	.DW  _0x18+148
	.DW  _0x0*2+173

	.DW  0x08
	.DW  _0x18+157
	.DW  _0x0*2+182

	.DW  0x28
	.DW  _Sport
	.DW  _0x19*2

	.DW  0x06
	.DW  _0x1A
	.DW  _0x0*2+190

	.DW  0x07
	.DW  _0x1A+6
	.DW  _0x0*2+196

	.DW  0x0A
	.DW  _0x1A+13
	.DW  _0x0*2+203

	.DW  0x07
	.DW  _0x1A+23
	.DW  _0x0*2+213

	.DW  0x05
	.DW  _0x1A+30
	.DW  _0x0*2+220

	.DW  0x0C
	.DW  _0x1A+35
	.DW  _0x0*2+225

	.DW  0x08
	.DW  _0x1A+47
	.DW  _0x0*2+237

	.DW  0x08
	.DW  _0x1A+55
	.DW  _0x0*2+245

	.DW  0x07
	.DW  _0x1A+63
	.DW  _0x0*2+253

	.DW  0x05
	.DW  _0x1A+70
	.DW  _0x0*2+260

	.DW  0x0C
	.DW  _0x1A+75
	.DW  _0x0*2+265

	.DW  0x06
	.DW  _0x1A+87
	.DW  _0x0*2+277

	.DW  0x08
	.DW  _0x1A+93
	.DW  _0x0*2+283

	.DW  0x07
	.DW  _0x1A+101
	.DW  _0x0*2+291

	.DW  0x08
	.DW  _0x1A+108
	.DW  _0x0*2+298

	.DW  0x08
	.DW  _0x1A+116
	.DW  _0x0*2+306

	.DW  0x05
	.DW  _0x1A+124
	.DW  _0x0*2+314

	.DW  0x11
	.DW  _0x1A+129
	.DW  _0x0*2+319

	.DW  0x0D
	.DW  _0x1A+146
	.DW  _0x0*2+336

	.DW  0x0B
	.DW  _0x1A+159
	.DW  _0x0*2+349

	.DW  0x28
	.DW  _Movie
	.DW  _0x1B*2

	.DW  0x05
	.DW  _0x1C
	.DW  _0x0*2+360

	.DW  0x08
	.DW  _0x1C+5
	.DW  _0x0*2+365

	.DW  0x07
	.DW  _0x1C+13
	.DW  _0x0*2+373

	.DW  0x08
	.DW  _0x1C+20
	.DW  _0x0*2+380

	.DW  0x0A
	.DW  _0x1C+28
	.DW  _0x0*2+388

	.DW  0x07
	.DW  _0x1C+38
	.DW  _0x0*2+398

	.DW  0x06
	.DW  _0x1C+45
	.DW  _0x0*2+405

	.DW  0x06
	.DW  _0x1C+51
	.DW  _0x0*2+411

	.DW  0x04
	.DW  _0x1C+57
	.DW  _0x0*2+417

	.DW  0x0B
	.DW  _0x1C+61
	.DW  _0x0*2+421

	.DW  0x08
	.DW  _0x1C+72
	.DW  _0x0*2+432

	.DW  0x06
	.DW  _0x1C+80
	.DW  _0x0*2+440

	.DW  0x0B
	.DW  _0x1C+86
	.DW  _0x0*2+446

	.DW  0x0A
	.DW  _0x1C+97
	.DW  _0x0*2+457

	.DW  0x08
	.DW  _0x1C+107
	.DW  _0x0*2+467

	.DW  0x08
	.DW  _0x1C+115
	.DW  _0x0*2+475

	.DW  0x0B
	.DW  _0x1C+123
	.DW  _0x0*2+483

	.DW  0x07
	.DW  _0x1C+134
	.DW  _0x0*2+494

	.DW  0x07
	.DW  _0x1C+141
	.DW  _0x0*2+501

	.DW  0x07
	.DW  _0x1C+148
	.DW  _0x0*2+508

	.DW  0x28
	.DW  _Countries
	.DW  _0x1D*2

	.DW  0x05
	.DW  _0x1E
	.DW  _0x0*2+515

	.DW  0x06
	.DW  _0x1E+5
	.DW  _0x0*2+520

	.DW  0x09
	.DW  _0x1E+11
	.DW  _0x0*2+526

	.DW  0x05
	.DW  _0x1E+20
	.DW  _0x0*2+535

	.DW  0x08
	.DW  _0x1E+25
	.DW  _0x0*2+540

	.DW  0x10
	.DW  _0x1E+33
	.DW  _0x0*2+548

	.DW  0x07
	.DW  _0x1E+49
	.DW  _0x0*2+564

	.DW  0x09
	.DW  _0x1E+56
	.DW  _0x0*2+571

	.DW  0x07
	.DW  _0x1E+65
	.DW  _0x0*2+580

	.DW  0x07
	.DW  _0x1E+72
	.DW  _0x0*2+587

	.DW  0x09
	.DW  _0x1E+79
	.DW  _0x0*2+594

	.DW  0x07
	.DW  _0x1E+88
	.DW  _0x0*2+603

	.DW  0x10
	.DW  _0x1E+95
	.DW  _0x0*2+610

	.DW  0x0C
	.DW  _0x1E+111
	.DW  _0x0*2+626

	.DW  0x07
	.DW  _0x1E+123
	.DW  _0x0*2+638

	.DW  0x06
	.DW  _0x1E+130
	.DW  _0x0*2+645

	.DW  0x0A
	.DW  _0x1E+136
	.DW  _0x0*2+651

	.DW  0x07
	.DW  _0x1E+146
	.DW  _0x0*2+661

	.DW  0x0A
	.DW  _0x1E+153
	.DW  _0x0*2+668

	.DW  0x0C
	.DW  _0x1E+163
	.DW  _0x0*2+678

	.DW  0x28
	.DW  _ComputerScience
	.DW  _0x1F*2

	.DW  0x02
	.DW  _0x20
	.DW  _0x0*2+396

	.DW  0x02
	.DW  _0x20+2
	.DW  _0x0*2+569

	.DW  0x02
	.DW  _0x20+4
	.DW  _0x0*2+304

	.DW  0x02
	.DW  _0x20+6
	.DW  _0x0*2+135

	.DW  0x02
	.DW  _0x20+8
	.DW  _0x0*2+10

	.DW  0x02
	.DW  _0x20+10
	.DW  _0x0*2+117

	.DW  0x0C
	.DW  _AWords
	.DW  _0x21*2

	.DW  0x02
	.DW  _0x22
	.DW  _0x0*2+75

	.DW  0x02
	.DW  _0x22+2
	.DW  _0x0*2+455

	.DW  0x02
	.DW  _0x22+4
	.DW  _0x0*2+690

	.DW  0x02
	.DW  _0x22+6
	.DW  _0x0*2+692

	.DW  0x02
	.DW  _0x22+8
	.DW  _0x0*2+438

	.DW  0x02
	.DW  _0x22+10
	.DW  _0x0*2+32

	.DW  0x0C
	.DW  _BWords
	.DW  _0x23*2

	.DW  0x02
	.DW  _0x24
	.DW  _0x0*2+317

	.DW  0x02
	.DW  _0x24+2
	.DW  _0x0*2+201

	.DW  0x02
	.DW  _0x24+4
	.DW  _0x0*2+112

	.DW  0x02
	.DW  _0x24+6
	.DW  _0x0*2+694

	.DW  0x02
	.DW  _0x24+8
	.DW  _0x0*2+696

	.DW  0x02
	.DW  _0x24+10
	.DW  _0x0*2+194

	.DW  0x02
	.DW  _0x24+12
	.DW  _0x0*2+20

	.DW  0x0E
	.DW  _CWords
	.DW  _0x25*2

	.DW  0x02
	.DW  _0x26
	.DW  _0x0*2+4

	.DW  0x02
	.DW  _0x26+2
	.DW  _0x0*2+68

	.DW  0x02
	.DW  _0x26+4
	.DW  _0x0*2+698

	.DW  0x02
	.DW  _0x26+6
	.DW  _0x0*2+700

	.DW  0x02
	.DW  _0x26+8
	.DW  _0x0*2+585

	.DW  0x02
	.DW  _0x26+10
	.DW  _0x0*2+107

	.DW  0x02
	.DW  _0x26+12
	.DW  _0x0*2+702

	.DW  0x0E
	.DW  _FWords
	.DW  _0x27*2

	.DW  0x02
	.DW  _0x28
	.DW  _0x0*2+4

	.DW  0x02
	.DW  _0x28+2
	.DW  _0x0*2+68

	.DW  0x02
	.DW  _0x28+4
	.DW  _0x0*2+698

	.DW  0x02
	.DW  _0x28+6
	.DW  _0x0*2+700

	.DW  0x02
	.DW  _0x28+8
	.DW  _0x0*2+585

	.DW  0x02
	.DW  _0x28+10
	.DW  _0x0*2+107

	.DW  0x02
	.DW  _0x28+12
	.DW  _0x0*2+702

	.DW  0x0E
	.DW  _DWords
	.DW  _0x29*2

	.DW  0x02
	.DW  _0x2A
	.DW  _0x0*2+396

	.DW  0x02
	.DW  _0x2A+2
	.DW  _0x0*2+569

	.DW  0x02
	.DW  _0x2A+4
	.DW  _0x0*2+304

	.DW  0x02
	.DW  _0x2A+6
	.DW  _0x0*2+135

	.DW  0x02
	.DW  _0x2A+8
	.DW  _0x0*2+10

	.DW  0x02
	.DW  _0x2A+10
	.DW  _0x0*2+117

	.DW  0x02
	.DW  _0x2A+12
	.DW  _0x0*2+75

	.DW  0x02
	.DW  _0x2A+14
	.DW  _0x0*2+455

	.DW  0x02
	.DW  _0x2A+16
	.DW  _0x0*2+690

	.DW  0x02
	.DW  _0x2A+18
	.DW  _0x0*2+692

	.DW  0x02
	.DW  _0x2A+20
	.DW  _0x0*2+438

	.DW  0x02
	.DW  _0x2A+22
	.DW  _0x0*2+32

	.DW  0x02
	.DW  _0x2A+24
	.DW  _0x0*2+317

	.DW  0x02
	.DW  _0x2A+26
	.DW  _0x0*2+201

	.DW  0x02
	.DW  _0x2A+28
	.DW  _0x0*2+112

	.DW  0x02
	.DW  _0x2A+30
	.DW  _0x0*2+694

	.DW  0x02
	.DW  _0x2A+32
	.DW  _0x0*2+696

	.DW  0x02
	.DW  _0x2A+34
	.DW  _0x0*2+194

	.DW  0x02
	.DW  _0x2A+36
	.DW  _0x0*2+20

	.DW  0x02
	.DW  _0x2A+38
	.DW  _0x0*2+4

	.DW  0x02
	.DW  _0x2A+40
	.DW  _0x0*2+68

	.DW  0x02
	.DW  _0x2A+42
	.DW  _0x0*2+698

	.DW  0x02
	.DW  _0x2A+44
	.DW  _0x0*2+700

	.DW  0x02
	.DW  _0x2A+46
	.DW  _0x0*2+585

	.DW  0x02
	.DW  _0x2A+48
	.DW  _0x0*2+107

	.DW  0x02
	.DW  _0x2A+50
	.DW  _0x0*2+702

	.DW  0x34
	.DW  _Words
	.DW  _0x2B*2

	.DW  0x01
	.DW  _health
	.DW  _0x2C*2

	.DW  0x02
	.DW  _0x30
	.DW  _0x0*2+704

	.DW  0x02
	.DW  _0x30+2
	.DW  _0x0*2+706

	.DW  0x02
	.DW  _0x30+4
	.DW  _0x0*2+704

	.DW  0x02
	.DW  _0x30+6
	.DW  _0x0*2+704

	.DW  0x02
	.DW  _0x30+8
	.DW  _0x0*2+704

	.DW  0x0B
	.DW  _0x34
	.DW  _0x0*2+718

	.DW  0x03
	.DW  _0x61
	.DW  _0x0*2+734

	.DW  0x02
	.DW  _0x6A
	.DW  _0x0*2+704

	.DW  0x03
	.DW  _0x6A+2
	.DW  _0x0*2+734

	.DW  0x09
	.DW  _0x6A+5
	.DW  _0x0*2+737

	.DW  0x28
	.DW  _0x7D
	.DW  _0x0*2+746

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <io.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include <string.h>
;#include <delay.h>
;#include "LCD.h"

	.CSEG
_lcdCommand:
; .FSTART _lcdCommand
	ST   -Y,R26
;	cmnd -> Y+0
	LD   R30,Y
	OUT  0x18,R30
	CBI  0x12,5
	CALL SUBOPT_0x0
	RJMP _0x20A0007
; .FEND
_lcdData:
; .FSTART _lcdData
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0x18,R30
	SBI  0x12,5
	CALL SUBOPT_0x0
	RJMP _0x20A0007
; .FEND
_lcd_init:
; .FSTART _lcd_init
	LDI  R30,LOW(255)
	OUT  0x17,R30
	IN   R30,0x11
	ORI  R30,LOW(0xF0)
	OUT  0x11,R30
	CBI  0x12,7
	CALL SUBOPT_0x1
	LDI  R26,LOW(56)
	RCALL _lcdCommand
	LDI  R26,LOW(14)
	RCALL _lcdCommand
	LDI  R26,LOW(1)
	RCALL _lcdCommand
	CALL SUBOPT_0x1
	LDI  R26,LOW(6)
	RCALL _lcdCommand
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	CALL SUBOPT_0x2
;	x -> Y+5
;	y -> Y+4
;	firstCharAdr -> Y+0
	RCALL _lcdCommand
	RJMP _0x20A0009
; .FEND
_lcd_print:
; .FSTART _lcd_print
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0x3:
	CALL SUBOPT_0x3
	LD   R30,X
	CPI  R30,0
	BREQ _0x5
	CALL SUBOPT_0x3
	LD   R26,X
	RCALL _lcdData
	SUBI R17,-1
	RJMP _0x3
_0x5:
	RJMP _0x20A0008
; .FEND

	.DSEG

	.CSEG
_get_key:
; .FSTART _get_key
	LDI  R30,LOW(239)
	OUT  0x15,R30
	NOP
	CALL SUBOPT_0x4
	BREQ _0x7
	CLR  R4
	RJMP _0x8
_0x7:
	LDI  R30,LOW(223)
	OUT  0x15,R30
	NOP
	CALL SUBOPT_0x4
	BREQ _0x9
	LDI  R30,LOW(1)
	RJMP _0x7E
_0x9:
	LDI  R30,LOW(191)
	OUT  0x15,R30
	NOP
	CALL SUBOPT_0x4
	BREQ _0xB
	LDI  R30,LOW(2)
	RJMP _0x7E
_0xB:
	LDI  R30,LOW(127)
	OUT  0x15,R30
	NOP
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R5,R30
	LDI  R30,LOW(3)
_0x7E:
	MOV  R4,R30
_0x8:
	LDI  R30,LOW(14)
	CP   R30,R5
	BRNE _0xD
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_keypad)
	SBCI R31,HIGH(-_keypad)
	LD   R30,Z
	RET
_0xD:
	LDI  R30,LOW(13)
	CP   R30,R5
	BRNE _0xF
	__POINTW2MN _keypad,4
	RJMP _0x20A000A
_0xF:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x11
	__POINTW2MN _keypad,8
	RJMP _0x20A000A
_0x11:
	__POINTW2MN _keypad,12
_0x20A000A:
	CLR  R30
	ADD  R26,R4
	ADC  R27,R30
	LD   R30,X
	RET
	RET
; .FEND
;#include <string.h>
;#include <stdbool.h>
;#include "LCD2.h"
_lcdCommand2:
; .FSTART _lcdCommand2
	ST   -Y,R26
;	cmnd -> Y+0
	LD   R30,Y
	OUT  0x1B,R30
	CBI  0x12,1
	CALL SUBOPT_0x5
	RJMP _0x20A0007
; .FEND
_lcdData2:
; .FSTART _lcdData2
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0x1B,R30
	SBI  0x12,1
	CALL SUBOPT_0x5
	RJMP _0x20A0007
; .FEND
_lcd_init2:
; .FSTART _lcd_init2
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	IN   R30,0x11
	ORI  R30,LOW(0xB)
	OUT  0x11,R30
	CBI  0x12,4
	CALL SUBOPT_0x1
	LDI  R26,LOW(56)
	RCALL _lcdCommand2
	LDI  R26,LOW(14)
	RCALL _lcdCommand2
	LDI  R26,LOW(1)
	RCALL _lcdCommand2
	CALL SUBOPT_0x1
	LDI  R26,LOW(6)
	RCALL _lcdCommand2
	RET
; .FEND
_lcd_gotoxy2:
; .FSTART _lcd_gotoxy2
	CALL SUBOPT_0x2
;	x -> Y+5
;	y -> Y+4
;	firstCharAdr -> Y+0
	RCALL _lcdCommand2
_0x20A0009:
	__DELAY_USW 200
	ADIW R28,6
	RET
; .FEND
_lcd_print2:
; .FSTART _lcd_print2
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0x13:
	CALL SUBOPT_0x3
	LD   R30,X
	CPI  R30,0
	BREQ _0x15
	CALL SUBOPT_0x3
	LD   R26,X
	RCALL _lcdData2
	SUBI R17,-1
	RJMP _0x13
_0x15:
_0x20A0008:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
;
;unsigned char out;
;unsigned char SelectedCategory;
;int i;
;char* h;
;
;int WordIndex = 0;
;int WordLen;
;char tmp[50];
;char Scoretmp[50];
;#define  CATEGORY_LENGTH    4
;#define MAX_HEALTH 3
;char* Category[CATEGORY_LENGTH] = {"Sport","Movie","Countries","CS"};

	.DSEG
_0x16:
	.BYTE 0x19
;char* Sport[20] = {"football","basketball","volleyball","karate","kungfu","boxing","tennis","running","wrestling","hocke ...
;                    "judo","golf","baseball","billiard","curling","waterpolo","taekwando","fencing","swimming","jujitsu" ...
_0x18:
	.BYTE 0xA5
;char * Movie[20] ={"joker","batman","godfather","lizard","soul","incredibles","memento","arrival","buried","cube","blade ...
;               "shining","pyscho","titanic","vertigo","exam","nocturnalanimals","swissarmyman","seperation"
;               };
_0x1A:
	.BYTE 0xAA
;
;char * Countries[20]={"iran","germany","brazil","england","argentina","sweden","samoa","china","uae","uzbakistan"
;                        ,"denmark","ghana","bangladesh","venezuela","zimbawe","nigeria","luxembourg","greece","france"," ...
_0x1C:
	.BYTE 0x9B
;
;char * ComputerScience[20]={"code","debug","compiler","java","boolean","operatingsystem","github","function","syntax" ," ...
;                            "argument","python","machinelearning","interpreter","google","query","algorithm","kernel","p ...
;
;};
_0x1E:
	.BYTE 0xAF
;char* AWords[6] = { "a","b","c","d","e","f" };
_0x20:
	.BYTE 0xC
;char* BWords[6] = { "g","h","i","j","k","l" };
_0x22:
	.BYTE 0xC
;char* CWords[7] = { "m","n","o","p","q","r","s" };
_0x24:
	.BYTE 0xE
;char* FWords[7] = { "t","u","v","w","x","y","z" };
_0x26:
	.BYTE 0xE
;char* DWords[7] = { "t","u","v","w","x","y","z" };
_0x28:
	.BYTE 0xE
;
;char* Words[26] = { "a","b","c","d","e","f", "g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y" ...
_0x2A:
	.BYTE 0x34
;
;int alphabet[26];
;
;int point;
;
;int WordSetState = 0;
;
;int CharIndex; // index of words set
; char* ChoosenChar;
;char* CurrentWord;
;
;bool bCanSelectCategory;
;bool bCanGuess;
;bool bIsSelectedNumber;
;bool bIsFirstTime;
;bool bWrongGuess;
;bool bFoundCorrectGuess;
;
;int health = MAX_HEALTH;
;
;void CheckGuess( char* in,char* CurrWord);
;
;void ShowCategory();
;
;
;void SelectAndShowWord(unsigned char in);
;
;void ShowRandomWord(char* InputStr);
;
;void Print6( char* in[6]);
;
;void Print7(char*  in[7]);
;void InitAlphabet();
;void InitHealth();
;void EndGame();
;void CalculatePoint();
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 005C {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	CALL SUBOPT_0x6
; 0000 005D // Reinitialize Timer1 value
; 0000 005E TCNT1H=0xFF;
	OUT  0x2D,R30
; 0000 005F TCNT1L=0x0F;
	LDI  R30,LOW(15)
	OUT  0x2C,R30
; 0000 0060 // Place your code here
; 0000 0061 
; 0000 0062 lcd_gotoxy2(11,4);
	CALL SUBOPT_0x7
; 0000 0063 for ( i = 0 ; i < 3; i++){
_0x2E:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x2F
; 0000 0064 
; 0000 0065     lcd_print2(" ");
	__POINTW2MN _0x30,0
	RCALL _lcd_print2
; 0000 0066 }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x2E
_0x2F:
; 0000 0067 lcd_gotoxy2(11,4);
	CALL SUBOPT_0x7
; 0000 0068 
; 0000 0069 for ( i = 0 ; i < health; i++){
_0x32:
	LDS  R30,_health
	LDS  R31,_health+1
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x33
; 0000 006A 
; 0000 006B     lcd_print2("*");
	__POINTW2MN _0x30,2
	RCALL _lcd_print2
; 0000 006C }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x32
_0x33:
; 0000 006D 
; 0000 006E 
; 0000 006F      sprintf(Scoretmp,"Score: %d",point);
	LDI  R30,LOW(_Scoretmp)
	LDI  R31,HIGH(_Scoretmp)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,708
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_point
	LDS  R31,_point+1
	CALL SUBOPT_0x8
; 0000 0070 
; 0000 0071       lcd_gotoxy2(10,3);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _lcd_gotoxy2
; 0000 0072       lcd_print2(Scoretmp);
	LDI  R26,LOW(_Scoretmp)
	LDI  R27,HIGH(_Scoretmp)
	RCALL _lcd_print2
; 0000 0073       lcd_print2(" ");
	__POINTW2MN _0x30,4
	RCALL _lcd_print2
; 0000 0074       lcd_print2(" ");
	__POINTW2MN _0x30,6
	RCALL _lcd_print2
; 0000 0075       lcd_print2(" ");
	__POINTW2MN _0x30,8
	RCALL _lcd_print2
; 0000 0076 }
	RJMP _0x85
; .FEND

	.DSEG
_0x30:
	.BYTE 0xA
;
;void main(void)
; 0000 0079 {

	.CSEG
_main:
; .FSTART _main
; 0000 007A 
; 0000 007B TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 007C TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 007D TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
; 0000 007E TCNT1L=0x0F;
	LDI  R30,LOW(15)
	OUT  0x2C,R30
; 0000 007F ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0080 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0081 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0082 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0083 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0084 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0085 
; 0000 0086 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0087 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0088 
; 0000 0089     bIsFirstTime = true;
	LDI  R30,LOW(1)
	STS  _bIsFirstTime,R30
; 0000 008A      MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 008B      GICR=(1<<INT0);
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 008C 
; 0000 008D 
; 0000 008E     KEY_DDR = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 008F     KEY_PRT = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 0090     i=0;
	CLR  R8
	CLR  R9
; 0000 0091 
; 0000 0092 // Global enable interrupts
; 0000 0093 
; 0000 0094 
; 0000 0095 
; 0000 0096 
; 0000 0097     ShowCategory();
	RCALL _ShowCategory
; 0000 0098 
; 0000 0099     lcd_init2();
	RCALL _lcd_init2
; 0000 009A     lcd_gotoxy2(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy2
; 0000 009B     lcd_print2("Second Lcd");
	__POINTW2MN _0x34,0
	RCALL _lcd_print2
; 0000 009C #asm("sei")
	sei
; 0000 009D 
; 0000 009E while (1)
_0x35:
; 0000 009F       {
; 0000 00A0       // Place your code here
; 0000 00A1 
; 0000 00A2       }
	RJMP _0x35
; 0000 00A3 }
_0x38:
	RJMP _0x38
; .FEND

	.DSEG
_0x34:
	.BYTE 0xB
;
;
;
;
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 00A9 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	CALL SUBOPT_0x6
; 0000 00AA 
; 0000 00AB   DDRA=0xFF;
	OUT  0x1A,R30
; 0000 00AC   PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00AD 
; 0000 00AE  lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 00AF 
; 0000 00B0  out=get_key();
	RCALL _get_key
	MOV  R7,R30
; 0000 00B1 
; 0000 00B2 
; 0000 00B3 
; 0000 00B4  if(bCanSelectCategory == true)
	LDS  R26,_bCanSelectCategory
	CPI  R26,LOW(0x1)
	BRNE _0x39
; 0000 00B5  {
; 0000 00B6 
; 0000 00B7     if(atoi(&out) >= 1 && atoi(&out) <= CATEGORY_LENGTH)  //Check If input is valid
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL _atoi
	SBIW R30,1
	BRLT _0x3B
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL _atoi
	SBIW R30,5
	BRLT _0x3C
_0x3B:
	RJMP _0x3A
_0x3C:
; 0000 00B8     {
; 0000 00B9        bCanSelectCategory = false;
	LDI  R30,LOW(0)
	STS  _bCanSelectCategory,R30
; 0000 00BA        SelectedCategory = out;
	MOV  R6,R7
; 0000 00BB        SelectAndShowWord(out);
	MOV  R26,R7
	RCALL _SelectAndShowWord
; 0000 00BC 
; 0000 00BD     }
; 0000 00BE  }
_0x3A:
; 0000 00BF  else if ( bCanGuess == true )
	RJMP _0x3D
_0x39:
	LDS  R26,_bCanGuess
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x3E
; 0000 00C0  {
; 0000 00C1 
; 0000 00C2 
; 0000 00C3 
; 0000 00C4     if(out == 'A')
	LDI  R30,LOW(65)
	CP   R30,R7
	BRNE _0x3F
; 0000 00C5        {
; 0000 00C6             WordSetState = 0;
	LDI  R30,LOW(0)
	STS  _WordSetState,R30
	STS  _WordSetState+1,R30
; 0000 00C7             Print6( AWords);
	LDI  R26,LOW(_AWords)
	LDI  R27,HIGH(_AWords)
	RCALL _Print6
; 0000 00C8 
; 0000 00C9             bIsFirstTime = false;
	LDI  R30,LOW(0)
	STS  _bIsFirstTime,R30
; 0000 00CA        }
; 0000 00CB        else if(out == 'B')
	RJMP _0x40
_0x3F:
	LDI  R30,LOW(66)
	CP   R30,R7
	BRNE _0x41
; 0000 00CC        {
; 0000 00CD             WordSetState = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x9
; 0000 00CE             Print6( BWords);
	LDI  R26,LOW(_BWords)
	LDI  R27,HIGH(_BWords)
	RCALL _Print6
; 0000 00CF             bIsFirstTime = false;
	LDI  R30,LOW(0)
	STS  _bIsFirstTime,R30
; 0000 00D0        }
; 0000 00D1        else if(out == 'C')
	RJMP _0x42
_0x41:
	LDI  R30,LOW(67)
	CP   R30,R7
	BRNE _0x43
; 0000 00D2        {
; 0000 00D3             WordSetState = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x9
; 0000 00D4             Print7( CWords);
	LDI  R26,LOW(_CWords)
	LDI  R27,HIGH(_CWords)
	RCALL _Print7
; 0000 00D5             bIsFirstTime = false;
	LDI  R30,LOW(0)
	STS  _bIsFirstTime,R30
; 0000 00D6        }
; 0000 00D7        else if(out == 'D')
	RJMP _0x44
_0x43:
	LDI  R30,LOW(68)
	CP   R30,R7
	BRNE _0x45
; 0000 00D8        {
; 0000 00D9             WordSetState = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x9
; 0000 00DA             Print7( FWords);
	LDI  R26,LOW(_FWords)
	LDI  R27,HIGH(_FWords)
	RCALL _Print7
; 0000 00DB             bIsFirstTime = false;
	LDI  R30,LOW(0)
	STS  _bIsFirstTime,R30
; 0000 00DC        }else
	RJMP _0x46
_0x45:
; 0000 00DD        {
; 0000 00DE            if(!bIsFirstTime)
	LDS  R30,_bIsFirstTime
	CPI  R30,0
	BRNE _0x47
; 0000 00DF            {
; 0000 00E0                 if(out == '#')
	LDI  R30,LOW(35)
	CP   R30,R7
	BREQ _0x49
; 0000 00E1                 {
; 0000 00E2                     //todo UpperCase
; 0000 00E3                 }
; 0000 00E4                 else
; 0000 00E5                 {
; 0000 00E6                      bIsSelectedNumber = true;
	LDI  R30,LOW(1)
	STS  _bIsSelectedNumber,R30
; 0000 00E7                 }
_0x49:
; 0000 00E8 
; 0000 00E9            }
; 0000 00EA        }
_0x47:
_0x46:
_0x44:
_0x42:
_0x40:
; 0000 00EB 
; 0000 00EC 
; 0000 00ED     if(bIsSelectedNumber)
	LDS  R30,_bIsSelectedNumber
	CPI  R30,0
	BRNE PC+2
	RJMP _0x4A
; 0000 00EE     {
; 0000 00EF         bIsSelectedNumber = false;
	LDI  R30,LOW(0)
	STS  _bIsSelectedNumber,R30
; 0000 00F0 
; 0000 00F1         h = &out;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R10,R30
; 0000 00F2         sscanf(&out,"%d",&CharIndex);
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,715
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_CharIndex)
	LDI  R31,HIGH(_CharIndex)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sscanf
	ADIW R28,8
; 0000 00F3 
; 0000 00F4 
; 0000 00F5 
; 0000 00F6         if(WordSetState == 0)
	LDS  R30,_WordSetState
	LDS  R31,_WordSetState+1
	SBIW R30,0
	BRNE _0x4B
; 0000 00F7         {
; 0000 00F8                 ChoosenChar = AWords[CharIndex - 1];
	CALL SUBOPT_0xA
	LDI  R26,LOW(_AWords)
	LDI  R27,HIGH(_AWords)
	RJMP _0x7F
; 0000 00F9 
; 0000 00FA         }
; 0000 00FB         else if ( WordSetState == 1)
_0x4B:
	CALL SUBOPT_0xB
	SBIW R26,1
	BRNE _0x4D
; 0000 00FC         {
; 0000 00FD                ChoosenChar = BWords[CharIndex - 1];
	CALL SUBOPT_0xA
	LDI  R26,LOW(_BWords)
	LDI  R27,HIGH(_BWords)
	RJMP _0x7F
; 0000 00FE 
; 0000 00FF         }
; 0000 0100         else if ( WordSetState == 2)
_0x4D:
	CALL SUBOPT_0xB
	SBIW R26,2
	BRNE _0x4F
; 0000 0101         {
; 0000 0102                ChoosenChar = CWords[CharIndex - 1];
	CALL SUBOPT_0xA
	LDI  R26,LOW(_CWords)
	LDI  R27,HIGH(_CWords)
	RJMP _0x7F
; 0000 0103         }
; 0000 0104         else if ( WordSetState == 3)
_0x4F:
	CALL SUBOPT_0xB
	SBIW R26,3
	BRNE _0x51
; 0000 0105         {
; 0000 0106               ChoosenChar = DWords[CharIndex - 1];
	CALL SUBOPT_0xA
	LDI  R26,LOW(_DWords)
	LDI  R27,HIGH(_DWords)
_0x7F:
	LSL  R30
	ROL  R31
	CALL SUBOPT_0xC
	STS  _ChoosenChar,R30
	STS  _ChoosenChar+1,R31
; 0000 0107         }
; 0000 0108 
; 0000 0109         //lcd_print2(&ChoosenChar);
; 0000 010A         CheckGuess(ChoosenChar, CurrentWord);
_0x51:
	LDS  R30,_ChoosenChar
	LDS  R31,_ChoosenChar+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_CurrentWord
	LDS  R27,_CurrentWord+1
	RCALL _CheckGuess
; 0000 010B 
; 0000 010C     }
; 0000 010D 
; 0000 010E 
; 0000 010F  }
_0x4A:
; 0000 0110 
; 0000 0111 
; 0000 0112   KEY_DDR = 0xF0;
_0x3E:
_0x3D:
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 0113   KEY_PRT = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 0114 
; 0000 0115 }
_0x85:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;  void ShowCategory()
; 0000 0119   {
_ShowCategory:
; .FSTART _ShowCategory
; 0000 011A 
; 0000 011B 
; 0000 011C 
; 0000 011D         InitAlphabet();
	RCALL _InitAlphabet
; 0000 011E         InitHealth();
	RCALL _InitHealth
; 0000 011F         lcd_init();
	RCALL _lcd_init
; 0000 0120         WordIndex = 0;
	CLR  R12
	CLR  R13
; 0000 0121         point = 0;
	LDI  R30,LOW(0)
	STS  _point,R30
	STS  _point+1,R30
; 0000 0122         WordIndex = 0;
	CLR  R12
	CLR  R13
; 0000 0123        lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0124 
; 0000 0125        for(i = 0 ; i < CATEGORY_LENGTH ; i++)
	CLR  R8
	CLR  R9
_0x53:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x54
; 0000 0126        {
; 0000 0127             if(i != 0)
	MOV  R0,R8
	OR   R0,R9
	BREQ _0x55
; 0000 0128                 sprintf(tmp," %d.",i+1);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,729
	RJMP _0x80
; 0000 0129             else
_0x55:
; 0000 012A                 sprintf(tmp,"%d.",i+1);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,730
_0x80:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xE
; 0000 012B 
; 0000 012C             lcd_print(tmp);
	LDI  R26,LOW(_tmp)
	LDI  R27,HIGH(_tmp)
	RCALL _lcd_print
; 0000 012D             lcd_print(Category[i]);
	MOVW R30,R8
	LDI  R26,LOW(_Category)
	LDI  R27,HIGH(_Category)
	CALL SUBOPT_0xF
	MOVW R26,R30
	RCALL _lcd_print
; 0000 012E        }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x53
_0x54:
; 0000 012F 
; 0000 0130        bCanSelectCategory = true;
	LDI  R30,LOW(1)
	STS  _bCanSelectCategory,R30
; 0000 0131   }
	RET
; .FEND
;
;  void SelectAndShowWord(unsigned char in)
; 0000 0134   {
_SelectAndShowWord:
; .FSTART _SelectAndShowWord
; 0000 0135 
; 0000 0136 
; 0000 0137       //Init and seed
; 0000 0138       switch(in)
	ST   -Y,R26
;	in -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 0139       {
; 0000 013A         case '1':
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x5A
; 0000 013B                 CurrentWord = Sport[WordIndex];
	MOVW R30,R12
	LDI  R26,LOW(_Sport)
	LDI  R27,HIGH(_Sport)
	RJMP _0x81
; 0000 013C                 ShowRandomWord(CurrentWord);
; 0000 013D                 break;
; 0000 013E         case '2':
_0x5A:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x5B
; 0000 013F                 CurrentWord = Movie[WordIndex];
	MOVW R30,R12
	LDI  R26,LOW(_Movie)
	LDI  R27,HIGH(_Movie)
	RJMP _0x81
; 0000 0140                 ShowRandomWord(CurrentWord);
; 0000 0141                 break;
; 0000 0142         case '3':
_0x5B:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x5C
; 0000 0143                 CurrentWord = Countries[WordIndex];
	MOVW R30,R12
	LDI  R26,LOW(_Countries)
	LDI  R27,HIGH(_Countries)
	RJMP _0x81
; 0000 0144                 ShowRandomWord(CurrentWord);
; 0000 0145                 break;
; 0000 0146         case '4':
_0x5C:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0x59
; 0000 0147 
; 0000 0148             CurrentWord = ComputerScience[WordIndex];
	MOVW R30,R12
	LDI  R26,LOW(_ComputerScience)
	LDI  R27,HIGH(_ComputerScience)
_0x81:
	LSL  R30
	ROL  R31
	CALL SUBOPT_0xC
	STS  _CurrentWord,R30
	STS  _CurrentWord+1,R31
; 0000 0149             ShowRandomWord(CurrentWord);
	LDS  R26,_CurrentWord
	LDS  R27,_CurrentWord+1
	RCALL _ShowRandomWord
; 0000 014A             break;
; 0000 014B       }
_0x59:
; 0000 014C 
; 0000 014D             WordIndex = (WordIndex+ 1) ;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 014E 
; 0000 014F   }
_0x20A0007:
	ADIW R28,1
	RET
; .FEND
;
;  void ShowRandomWord(char* InputStr)
; 0000 0152   {
_ShowRandomWord:
; .FSTART _ShowRandomWord
; 0000 0153 
; 0000 0154      lcd_init();
	CALL SUBOPT_0x10
;	*InputStr -> Y+0
; 0000 0155      lcdCommand(0x0c);
; 0000 0156      WordLen = strlen(InputStr);
	LD   R26,Y
	LDD  R27,Y+1
	CALL _strlen
	STS  _WordLen,R30
	STS  _WordLen+1,R31
; 0000 0157      InitAlphabet();
	RCALL _InitAlphabet
; 0000 0158 
; 0000 0159 
; 0000 015A 
; 0000 015B      for(  i = 0 ; i < WordLen ; i++)
	CLR  R8
	CLR  R9
_0x5F:
	CALL SUBOPT_0x11
	BRGE _0x60
; 0000 015C      {
; 0000 015D        alphabet[InputStr[i] - 'a'] = 1;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 015E 
; 0000 015F 
; 0000 0160          lcd_print("_ ");
	__POINTW2MN _0x61,0
	RCALL _lcd_print
; 0000 0161 
; 0000 0162      }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x5F
_0x60:
; 0000 0163       bCanGuess = true;
	LDI  R30,LOW(1)
	STS  _bCanGuess,R30
; 0000 0164   }
	RJMP _0x20A0006
; .FEND

	.DSEG
_0x61:
	.BYTE 0x3
;
;
;  void CheckGuess( char* in,char* CurrWord)
; 0000 0168   {

	.CSEG
_CheckGuess:
; .FSTART _CheckGuess
; 0000 0169 
; 0000 016A 
; 0000 016B 
; 0000 016C 
; 0000 016D       lcd_init();
	CALL SUBOPT_0x10
;	*in -> Y+2
;	*CurrWord -> Y+0
; 0000 016E 
; 0000 016F      lcdCommand(0x0c);
; 0000 0170      bWrongGuess = true;
	LDI  R30,LOW(1)
	STS  _bWrongGuess,R30
; 0000 0171 
; 0000 0172      for(  i = 0 ; i < WordLen ; i++)
	CLR  R8
	CLR  R9
_0x63:
	CALL SUBOPT_0x11
	BRGE _0x64
; 0000 0173      {
; 0000 0174 
; 0000 0175          if( in[0] == CurrWord[i] )
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R0,X
	CALL SUBOPT_0x12
	CP   R30,R0
	BRNE _0x65
; 0000 0176          {
; 0000 0177             alphabet[in[0] - 'a'] = 2;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CALL SUBOPT_0x13
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 0178             bWrongGuess = false;
	LDI  R30,LOW(0)
	STS  _bWrongGuess,R30
; 0000 0179          }
; 0000 017A 
; 0000 017B      }
_0x65:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x63
_0x64:
; 0000 017C 
; 0000 017D 
; 0000 017E 
; 0000 017F      bFoundCorrectGuess = true;
	LDI  R30,LOW(1)
	STS  _bFoundCorrectGuess,R30
; 0000 0180      for(  i = 0 ; i < WordLen ; i++)
	CLR  R8
	CLR  R9
_0x67:
	CALL SUBOPT_0x11
	BRGE _0x68
; 0000 0181      {
; 0000 0182 
; 0000 0183          if( alphabet[CurrWord[i] - 'a'] == 2 )
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x69
; 0000 0184          {
; 0000 0185 
; 0000 0186             lcd_print(Words[CurrWord[i] - 'a'] );
	CALL SUBOPT_0x12
	LDI  R31,0
	SUBI R30,LOW(97)
	SBCI R31,HIGH(97)
	LDI  R26,LOW(_Words)
	LDI  R27,HIGH(_Words)
	CALL SUBOPT_0xF
	MOVW R26,R30
	RCALL _lcd_print
; 0000 0187 
; 0000 0188             lcd_print(" ");
	__POINTW2MN _0x6A,0
	RJMP _0x82
; 0000 0189          }
; 0000 018A          else if( alphabet[CurrWord[i] - 'a'] == 1 )
_0x69:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6C
; 0000 018B          {
; 0000 018C               bFoundCorrectGuess = false;
	LDI  R30,LOW(0)
	STS  _bFoundCorrectGuess,R30
; 0000 018D               lcd_print("_ ");
	__POINTW2MN _0x6A,2
_0x82:
	RCALL _lcd_print
; 0000 018E          }
; 0000 018F 
; 0000 0190 
; 0000 0191      }
_0x6C:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x67
_0x68:
; 0000 0192 
; 0000 0193           if(bWrongGuess)
	LDS  R30,_bWrongGuess
	CPI  R30,0
	BREQ _0x6D
; 0000 0194      {
; 0000 0195          health -= 1;
	LDS  R30,_health
	LDS  R31,_health+1
	SBIW R30,1
	STS  _health,R30
	STS  _health+1,R31
; 0000 0196             if( health <= 0)
	LDS  R26,_health
	LDS  R27,_health+1
	CALL __CPW02
	BRLT _0x6E
; 0000 0197             {
; 0000 0198 
; 0000 0199                 EndGame();
	RCALL _EndGame
; 0000 019A             }
; 0000 019B      }
_0x6E:
; 0000 019C 
; 0000 019D      if(bFoundCorrectGuess)
_0x6D:
	LDS  R30,_bFoundCorrectGuess
	CPI  R30,0
	BREQ _0x6F
; 0000 019E      {
; 0000 019F 
; 0000 01A0          CalculatePoint();
	RCALL _CalculatePoint
; 0000 01A1          delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 01A2          lcd_init();
	RCALL _lcd_init
; 0000 01A3          lcd_print("Correct!");
	__POINTW2MN _0x6A,5
	RCALL _lcd_print
; 0000 01A4          delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 01A5          InitHealth();
	RCALL _InitHealth
; 0000 01A6          SelectAndShowWord(SelectedCategory);
	MOV  R26,R6
	RCALL _SelectAndShowWord
; 0000 01A7      }
; 0000 01A8 
; 0000 01A9 
; 0000 01AA 
; 0000 01AB 
; 0000 01AC 
; 0000 01AD       //bIsFirstTime = true;
; 0000 01AE   }
_0x6F:
	ADIW R28,4
	RET
; .FEND

	.DSEG
_0x6A:
	.BYTE 0xE
;
;
;  void InitAlphabet()
; 0000 01B2   {

	.CSEG
_InitAlphabet:
; .FSTART _InitAlphabet
; 0000 01B3     for( i = 0 ; i < 25 ; i++)
	CLR  R8
	CLR  R9
_0x71:
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x72
; 0000 01B4         alphabet[i] = 0;
	MOVW R30,R8
	LDI  R26,LOW(_alphabet)
	LDI  R27,HIGH(_alphabet)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x71
_0x72:
; 0000 01B6 }
	RET
; .FEND
;
;  void Print6( char* in[6])
; 0000 01B9   {
_Print6:
; .FSTART _Print6
; 0000 01BA 
; 0000 01BB 
; 0000 01BC     lcd_init2();
	CALL SUBOPT_0x15
;	in -> Y+0
; 0000 01BD     lcdCommand2(0x0c);
; 0000 01BE 
; 0000 01BF     for(i = 0 ; i < 6 ; i++)
_0x74:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x75
; 0000 01C0     {
; 0000 01C1          if(i != 0)
	MOV  R0,R8
	OR   R0,R9
	BREQ _0x76
; 0000 01C2                 sprintf(tmp," %d.",i+1);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,729
	RJMP _0x83
; 0000 01C3             else
_0x76:
; 0000 01C4                 sprintf(tmp,"%d.",i+1);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,730
_0x83:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xE
; 0000 01C5 
; 0000 01C6 
; 0000 01C7             lcd_print2(tmp);
	CALL SUBOPT_0x16
; 0000 01C8             lcd_print2(in[i]);
	MOVW R26,R30
	RCALL _lcd_print2
; 0000 01C9     }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x74
_0x75:
; 0000 01CA   }
	RJMP _0x20A0006
; .FEND
;
;    void Print7(char*  in[7])
; 0000 01CD   {
_Print7:
; .FSTART _Print7
; 0000 01CE 
; 0000 01CF 
; 0000 01D0 
; 0000 01D1     lcd_init2();
	CALL SUBOPT_0x15
;	in -> Y+0
; 0000 01D2     lcdCommand2(0x0c);
; 0000 01D3 
; 0000 01D4     for(i = 0 ; i < 7 ; i++)
_0x79:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x7A
; 0000 01D5     {
; 0000 01D6          if(i != 0)
	MOV  R0,R8
	OR   R0,R9
	BREQ _0x7B
; 0000 01D7                 sprintf(tmp," %d.",i+1);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,729
	RJMP _0x84
; 0000 01D8             else
_0x7B:
; 0000 01D9                 sprintf(tmp,"%d.",i+1);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,730
_0x84:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xE
; 0000 01DA 
; 0000 01DB 
; 0000 01DC             lcd_print2(tmp);
	CALL SUBOPT_0x16
; 0000 01DD             lcd_print2(in[i]);
	MOVW R26,R30
	RCALL _lcd_print2
; 0000 01DE     }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x79
_0x7A:
; 0000 01DF   }
_0x20A0006:
	ADIW R28,2
	RET
; .FEND
;
;  void InitHealth()
; 0000 01E2   {
_InitHealth:
; .FSTART _InitHealth
; 0000 01E3     health = MAX_HEALTH;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _health,R30
	STS  _health+1,R31
; 0000 01E4 
; 0000 01E5   }
	RET
; .FEND
;
;  void EndGame()
; 0000 01E8   {
_EndGame:
; .FSTART _EndGame
; 0000 01E9 
; 0000 01EA       bCanGuess = false;
	LDI  R30,LOW(0)
	STS  _bCanGuess,R30
; 0000 01EB       //todo lcd print
; 0000 01EC       lcd_init();
	RCALL _lcd_init
; 0000 01ED       lcd_print("GAME OVER!!                   try again");
	__POINTW2MN _0x7D,0
	RCALL _lcd_print
; 0000 01EE       delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 01EF       InitHealth();
	RCALL _InitHealth
; 0000 01F0       ShowCategory();
	RCALL _ShowCategory
; 0000 01F1 
; 0000 01F2   }
	RET
; .FEND

	.DSEG
_0x7D:
	.BYTE 0x28
;
;  void CalculatePoint()
; 0000 01F5   {

	.CSEG
_CalculatePoint:
; .FSTART _CalculatePoint
; 0000 01F6 
; 0000 01F7      point += ( WordLen * 10 + WordIndex);
	LDS  R30,_WordLen
	LDS  R31,_WordLen+1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R12
	ADC  R31,R13
	LDS  R26,_point
	LDS  R27,_point+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _point,R30
	STS  _point+1,R31
; 0000 01F8 
; 0000 01F9   }
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x17
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x17
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0004
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x18
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x18
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x19
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1A
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x18
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x18
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x18
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x1A
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x1D
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0005
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x1D
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x1E
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0005:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
_get_buff_G100:
; .FSTART _get_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200007A
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x200007B
_0x200007A:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x200007C
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+1
	LDD  R27,Z+2
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200007D
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	CALL SUBOPT_0x17
_0x200007D:
	RJMP _0x200007E
_0x200007C:
	LDI  R17,LOW(0)
_0x200007E:
_0x200007B:
	MOV  R30,R17
	LDD  R17,Y+0
_0x20A0004:
	ADIW R28,5
	RET
; .FEND
__scanf_G100:
; .FSTART __scanf_G100
	PUSH R15
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOV  R20,R30
_0x200007F:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000081
	CALL SUBOPT_0x1F
	BREQ _0x2000082
_0x2000083:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x20
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2000086
	CALL SUBOPT_0x1F
	BRNE _0x2000087
_0x2000086:
	RJMP _0x2000085
_0x2000087:
	CALL SUBOPT_0x21
	BRGE _0x2000088
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0002
_0x2000088:
	RJMP _0x2000083
_0x2000085:
	MOV  R20,R19
	RJMP _0x2000089
_0x2000082:
	CPI  R19,37
	BREQ PC+2
	RJMP _0x200008A
	LDI  R21,LOW(0)
_0x200008B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LPM  R19,Z+
	STD  Y+16,R30
	STD  Y+16+1,R31
	CPI  R19,48
	BRLO _0x200008F
	CPI  R19,58
	BRLO _0x200008E
_0x200008F:
	RJMP _0x200008D
_0x200008E:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200008B
_0x200008D:
	CPI  R19,0
	BRNE _0x2000091
	RJMP _0x2000081
_0x2000091:
_0x2000092:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x20
	POP  R20
	MOV  R18,R30
	MOV  R26,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x2000094
	CALL SUBOPT_0x21
	BRGE _0x2000095
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0002
_0x2000095:
	RJMP _0x2000092
_0x2000094:
	CPI  R18,0
	BRNE _0x2000096
	RJMP _0x2000097
_0x2000096:
	MOV  R20,R18
	CPI  R21,0
	BRNE _0x2000098
	LDI  R21,LOW(255)
_0x2000098:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x200009C
	CALL SUBOPT_0x22
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x20
	POP  R20
	MOVW R26,R16
	ST   X,R30
	CALL SUBOPT_0x21
	BRGE _0x200009D
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0002
_0x200009D:
	RJMP _0x200009B
_0x200009C:
	CPI  R30,LOW(0x73)
	BRNE _0x20000A6
	CALL SUBOPT_0x22
_0x200009F:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x20000A1
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x20
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x20000A3
	CALL SUBOPT_0x1F
	BREQ _0x20000A2
_0x20000A3:
	CALL SUBOPT_0x21
	BRGE _0x20000A5
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0002
_0x20000A5:
	RJMP _0x20000A1
_0x20000A2:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R19
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x200009F
_0x20000A1:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x200009B
_0x20000A6:
	SET
	BLD  R15,1
	CLT
	BLD  R15,2
	MOV  R30,R19
	CPI  R30,LOW(0x64)
	BREQ _0x20000AB
	CPI  R30,LOW(0x69)
	BRNE _0x20000AC
_0x20000AB:
	CLT
	BLD  R15,1
	RJMP _0x20000AD
_0x20000AC:
	CPI  R30,LOW(0x75)
	BRNE _0x20000AE
_0x20000AD:
	LDI  R18,LOW(10)
	RJMP _0x20000A9
_0x20000AE:
	CPI  R30,LOW(0x78)
	BRNE _0x20000AF
	LDI  R18,LOW(16)
	RJMP _0x20000A9
_0x20000AF:
	CPI  R30,LOW(0x25)
	BRNE _0x20000B2
	RJMP _0x20000B1
_0x20000B2:
	RJMP _0x20A0003
_0x20000A9:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
	SET
	BLD  R15,0
_0x20000B3:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20000B5
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x20
	POP  R20
	MOV  R19,R30
	CPI  R30,LOW(0x21)
	BRSH _0x20000B6
	CALL SUBOPT_0x21
	BRGE _0x20000B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0002
_0x20000B7:
	RJMP _0x20000B8
_0x20000B6:
	SBRC R15,1
	RJMP _0x20000B9
	SET
	BLD  R15,1
	CPI  R19,45
	BRNE _0x20000BA
	BLD  R15,2
	RJMP _0x20000B3
_0x20000BA:
	CPI  R19,43
	BREQ _0x20000B3
_0x20000B9:
	CPI  R18,16
	BRNE _0x20000BC
	MOV  R26,R19
	CALL _isxdigit
	CPI  R30,0
	BREQ _0x20000B8
	RJMP _0x20000BE
_0x20000BC:
	MOV  R26,R19
	CALL _isdigit
	CPI  R30,0
	BRNE _0x20000BF
_0x20000B8:
	SBRC R15,0
	RJMP _0x20000C1
	MOV  R20,R19
	RJMP _0x20000B5
_0x20000BF:
_0x20000BE:
	CPI  R19,97
	BRLO _0x20000C2
	SUBI R19,LOW(87)
	RJMP _0x20000C3
_0x20000C2:
	CPI  R19,65
	BRLO _0x20000C4
	SUBI R19,LOW(55)
	RJMP _0x20000C5
_0x20000C4:
	SUBI R19,LOW(48)
_0x20000C5:
_0x20000C3:
	MOV  R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	CLT
	BLD  R15,0
	RJMP _0x20000B3
_0x20000B5:
	CALL SUBOPT_0x22
	SBRS R15,2
	RJMP _0x20000C6
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __ANEGW1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x20000C6:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x200009B:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x20000C7
_0x200008A:
_0x20000B1:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x20
	POP  R20
	CP   R30,R19
	BREQ _0x20000C8
	CALL SUBOPT_0x21
	BRGE _0x20000C9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0002
_0x20000C9:
_0x2000097:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x20000CA
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0002
_0x20000CA:
	RJMP _0x2000081
_0x20000C8:
_0x20000C7:
_0x2000089:
	RJMP _0x200007F
_0x2000081:
_0x20000C1:
_0x20A0003:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x20A0002:
	CALL __LOADLOCR6
	ADIW R28,18
	POP  R15
	RET
; .FEND
_sscanf:
; .FSTART _sscanf
	PUSH R15
	MOV  R15,R24
	SBIW R28,3
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,7
	CALL SUBOPT_0x1E
	SBIW R30,0
	BRNE _0x20000CB
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x20000CB:
	MOVW R26,R28
	ADIW R26,1
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,7
	CALL SUBOPT_0x1E
	STD  Y+3,R30
	STD  Y+3+1,R31
	MOVW R26,R28
	ADIW R26,5
	CALL SUBOPT_0x1E
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_get_buff_G100)
	LDI  R31,HIGH(_get_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __scanf_G100
_0x20A0001:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	POP  R15
	RET
; .FEND

	.CSEG
_atoi:
; .FSTART _atoi
	ST   -Y,R27
	ST   -Y,R26
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isspace
        mov  r26,r24
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isdigit
        mov  r26,r24
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret
; .FEND

	.DSEG

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND
_isxdigit:
; .FSTART _isxdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    subi r31,0x30
    brcs isxdigit0
    cpi  r31,10
    brcs isxdigit1
    andi r31,0x5f
    subi r31,7
    cpi  r31,10
    brcs isxdigit0
    cpi  r31,16
    brcs isxdigit1
isxdigit0:
    clr  r30
isxdigit1:
    ret
; .FEND

	.DSEG
_keypad:
	.BYTE 0x10
_WordLen:
	.BYTE 0x2
_tmp:
	.BYTE 0x32
_Scoretmp:
	.BYTE 0x32
_Category:
	.BYTE 0x8
_Sport:
	.BYTE 0x28
_Movie:
	.BYTE 0x28
_Countries:
	.BYTE 0x28
_ComputerScience:
	.BYTE 0x28
_AWords:
	.BYTE 0xC
_BWords:
	.BYTE 0xC
_CWords:
	.BYTE 0xE
_FWords:
	.BYTE 0xE
_DWords:
	.BYTE 0xE
_Words:
	.BYTE 0x34
_alphabet:
	.BYTE 0x34
_point:
	.BYTE 0x2
_WordSetState:
	.BYTE 0x2
_CharIndex:
	.BYTE 0x2
_ChoosenChar:
	.BYTE 0x2
_CurrentWord:
	.BYTE 0x2
_bCanSelectCategory:
	.BYTE 0x1
_bCanGuess:
	.BYTE 0x1
_bIsSelectedNumber:
	.BYTE 0x1
_bIsFirstTime:
	.BYTE 0x1
_bWrongGuess:
	.BYTE 0x1
_bFoundCorrectGuess:
	.BYTE 0x1
_health:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	CBI  0x12,6
	SBI  0x12,7
	__DELAY_USB 3
	CBI  0x12,7
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	__DELAY_USW 4000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x2:
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(128)
	ST   Y,R30
	LDI  R30,LOW(192)
	STD  Y+1,R30
	LDI  R30,LOW(148)
	STD  Y+2,R30
	LDI  R30,LOW(212)
	STD  Y+3,R30
	LDD  R30,Y+4
	LDI  R31,0
	SBIW R30,1
	MOVW R26,R28
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDD  R26,Y+5
	ADD  R26,R30
	SUBI R26,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R5,R30
	LDI  R30,LOW(15)
	CP   R30,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	CBI  0x12,3
	SBI  0x12,4
	__DELAY_USB 3
	CBI  0x12,4
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(4)
	CALL _lcd_gotoxy2
	CLR  R8
	CLR  R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x8:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	STS  _WordSetState,R30
	STS  _WordSetState+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	LDS  R30,_CharIndex
	LDS  R31,_CharIndex+1
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDS  R26,_WordSetState
	LDS  R27,_WordSetState+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xC:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(_tmp)
	LDI  R31,HIGH(_tmp)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	MOVW R30,R8
	ADIW R30,1
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	ST   -Y,R27
	ST   -Y,R26
	CALL _lcd_init
	LDI  R26,LOW(12)
	JMP  _lcdCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDS  R30,_WordLen
	LDS  R31,_WordLen+1
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x12:
	MOVW R30,R8
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDI  R31,0
	SUBI R30,LOW(97)
	SBCI R31,HIGH(97)
	LDI  R26,LOW(_alphabet)
	LDI  R27,HIGH(_alphabet)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDI  R31,0
	SUBI R30,LOW(97)
	SBCI R31,HIGH(97)
	LDI  R26,LOW(_alphabet)
	LDI  R27,HIGH(_alphabet)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	ST   -Y,R27
	ST   -Y,R26
	CALL _lcd_init2
	LDI  R26,LOW(12)
	CALL _lcdCommand2
	CLR  R8
	CLR  R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(_tmp)
	LDI  R27,HIGH(_tmp)
	CALL _lcd_print2
	MOVW R30,R8
	LD   R26,Y
	LDD  R27,Y+1
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x18:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	MOV  R26,R19
	CALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x20:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R26,X
	CPI  R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x22:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,4
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
