.cpu cortex-m3      @ Generates Cortex-M3 instructions
.extern __main
.section .text
.align	1
.syntax unified
.thumb
.global SysTick_Handler

.include "gpio_map.inc"

SysTick_Handler:
# NVIC automaticamente apila 8 registros: r0-r3, r12, lr, psr y pc
    ldr     r0, =numero        @ Replace <sum_variable> with the address of the variable you want to sum
    ldr     r0, [r0]
    ldr     r1, [r0]            @ Load the current value of the variable
    add     r1, r1, #1          @ Increment the value by 1 (or adjust as needed)
    str     r1, [r0]
    lsls    r1, r1, #6
    ldr     r0, =GPIOB_BASE
    str     r1, [r0, GPIOx_ODR_OFFSET]
    sub     r10, r10, #1
    bx lr   

.size   SysTick_Handler, .-SysTick_Handler

