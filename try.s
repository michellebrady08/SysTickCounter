
.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

.include "ivt.s"
.include "delay.s"
.include "systick_handler.s"
.include "gpio_map.inc"
.include "rcc_map.inc"
.include "scb_map.inc"
.include "systick_map.inc"

.section .data
numero: .word 0x0
.section .text
.align 1
.syntax unified
.thumb
.global __main

__main:

        push	{r7, lr}                                @ create frame
	sub	sp, sp, #8
	add	r7, sp, #0  

        # enabling clock in port B
        ldr     r0, =RCC_BASE                      @ move 0x40021018 to r0
        mov     r3, #0x8                                @ loads 8 in r1 to enable clock in port B (IOPB bit)
        str     r3, [r0, RCC_APB2ENR_OFFSET]                                @ M[RCC_APB2ENR] gets 8

        # SYSTICK CONFIG
        # Set SysTick_CRL to disable SysTick IRQ and SysTick timer
        ldr     r0, =SYSTICK_BASE
        # Disable SysTick IRQ and SysTick counter, select external clock
        mov     r1, #0
        str     r1, [r0, STK_LOAD_OFFSET]
        # Specify the number of clock cycles between two interrupts
        ldr     r2, =1000000                @ Change it based on interrupt interval
        str     r2, [r0, STK_LOAD_OFFSET]   @ Save to SysTick reload register
        # Clear SysTick current value register (SysTick_VAL)
        mov     r1, #0
        str     r1, [r0, STK_VAL_OFFSET]    @ Write 0 to SysTick value register

        # Set SysTick_CRL to enable Systick timer and SysTick interrupt
        ldr     r1, [r0, STK_CTRL_OFFSET]
        orr     r1, r1, #3
        str     r1, [r0, STK_CTRL_OFFSET]

        # set pin 8-15 as digital output
        ldr     r0, =GPIOB_BASE                      @ moves address of GPIOB_CRH register to r0
        ldr     r3, =0x33333333                         @ PB15 output push-pull, max speed 50 MHz
        str     r3, [r0, GPIOx_CRH_OFFSET]                                @ M[GPIOB_CRH] gets 

        # set pin 6-7 as digital input and pin 0 and 3 as digital input
        ldr     r3, =0x33448448                         @ PB0: input
        str     r3, [r0, GPIOx_CRL_OFFSET]
        # conf
        mov     r3, #0
        str     r3, [r0, GPIOx_ODR_OFFSET]

        mov     r3, 0x0 
        str     r3, [r7, #4]                               @ counter initial value 
        add     r1, r7, #4
        ldr     r0, =numero
        str     r1, [r0]
loop:
        
        b       loop

