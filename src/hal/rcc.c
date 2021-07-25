#include "common.h"
#include "rcc.h"

/* Reset and Clock Control (RCC) */

#define MSION           BIT_0       
#define MSIRGSEL        BIT_3     
#define MSIRANGE        4
#define MSIRANGE_MASK   MASK_4_BIT      

// NOTE...... FIGURE OUT HOW TO GENERIC NAMES FROM THIS FILE....

/* Set the clock speed of the chipset */
void rcc_write_msi_range(RCC_TypeDef *ptr, uint32_t freq_khz) {
    clr_ptr_vol_bit_u32(&ptr->CR, MSION);
    set_ptr_vol_u32(&ptr->CR, MSIRANGE, MSIRANGE_MASK, freq_khz);
    set_ptr_vol_bit_u32(&ptr->CR, MSIRGSEL);
    set_ptr_vol_bit_u32(&ptr->CR, MSION);
}

void rcc_write_ahb1_enr(RCC_TypeDef *ptr, uint32_t value) {
    set_ptr_vol_bit_u32(&ptr->AHB1_ENR, value);
}

void rcc_write_ahb2_enr(RCC_TypeDef *ptr, uint32_t value) {
    set_ptr_vol_bit_u32(&ptr->AHB2_ENR, value);
}

void rcc_write_ahb3_enr(RCC_TypeDef *ptr, uint32_t value) {
    set_ptr_vol_bit_u32(&ptr->AHB3_ENR, value);
}

void rcc_write_apb1_enr1(RCC_TypeDef *ptr, uint32_t value) {
    set_ptr_vol_bit_u32(&ptr->APB1_ENR1, value);
}

void rcc_write_apb1_enr2(RCC_TypeDef *ptr, uint32_t value) {
    set_ptr_vol_bit_u32(&ptr->APB1_ENR2, value);
}

void rcc_write_apb2_enr(RCC_TypeDef *ptr, uint32_t value) {
    set_ptr_vol_bit_u32(&ptr->APB2_ENR, value);
}