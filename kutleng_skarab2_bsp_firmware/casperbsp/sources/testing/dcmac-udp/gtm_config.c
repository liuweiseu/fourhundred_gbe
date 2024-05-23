#include <stdio.h>
#include <xil_printf.h>
#include <xparameters.h>
#include "xil_exception.h"
#include "xstatus.h"
#include "xil_types.h"
#include "xgpio.h"
#include "sleep.h"

#include "gtm_config.h"

uint32_t gtm_read_reg(uint32_t addr)
{
    return *(uint32_t *)(addr);
}  

void gtm_write_reg(uint32_t addr, uint32_t data)
{
    *(uint32_t *)(addr) = data;
}

uint32_t check_tx_pcs_cfg(char i, char ch)
{
    if(i == 0)
    {
        if(ch == 0)
            return gtm_read_reg(GTM0_REG_BASE + CH0_TX_PCS_CFG0_OFFSET);
        else if(ch == 1)
            return gtm_read_reg(GTM0_REG_BASE + CH1_TX_PCS_CFG0_OFFSET);
        else if(ch == 2)
            return gtm_read_reg(GTM0_REG_BASE + CH2_TX_PCS_CFG0_OFFSET);
        else if(ch == 3)
            return gtm_read_reg(GTM0_REG_BASE + CH3_TX_PCS_CFG0_OFFSET);
    }
    else if(i == 1)
    {
        if(ch == 0)
            return gtm_read_reg(GTM1_REG_BASE + CH0_TX_PCS_CFG0_OFFSET);
        else if(ch == 1)
            return gtm_read_reg(GTM1_REG_BASE + CH1_TX_PCS_CFG0_OFFSET);
        else if(ch == 2)
            return gtm_read_reg(GTM1_REG_BASE + CH2_TX_PCS_CFG0_OFFSET);
        else if(ch == 3)
            return gtm_read_reg(GTM1_REG_BASE + CH3_TX_PCS_CFG0_OFFSET);
    }
}

uint32_t check_rx_pcs_cfg(char i, char ch)
{
    if(i == 0)
    {
        if(ch == 0)
            return gtm_read_reg(GTM0_REG_BASE + CH0_RX_PCS_CFG0_OFFSET);
        else if(ch == 1)
            return gtm_read_reg(GTM0_REG_BASE + CH1_RX_PCS_CFG0_OFFSET);
        else if(ch == 2)
            return gtm_read_reg(GTM0_REG_BASE + CH2_RX_PCS_CFG0_OFFSET);
        else if(ch == 3)
            return gtm_read_reg(GTM0_REG_BASE + CH3_RX_PCS_CFG0_OFFSET);
    }
    else if(i == 1)
    {
        if(ch == 0)
            return gtm_read_reg(GTM1_REG_BASE + CH0_RX_PCS_CFG0_OFFSET);
        else if(ch == 1)
            return gtm_read_reg(GTM1_REG_BASE + CH1_RX_PCS_CFG0_OFFSET);
        else if(ch == 2)
            return gtm_read_reg(GTM1_REG_BASE + CH2_RX_PCS_CFG0_OFFSET);
        else if(ch == 3)
            return gtm_read_reg(GTM1_REG_BASE + CH3_RX_PCS_CFG0_OFFSET);
    }
}

uint32_t check_loopback_mode(char i, char ch)
{
    if(i == 0)
    {
        if(ch == 0)
            return gtm_read_reg(GTM0_REG_BASE + CH0_FABRIC_INTF_CFG1);
        else if(ch == 1)
            return gtm_read_reg(GTM0_REG_BASE + CH1_FABRIC_INTF_CFG1);
        else if(ch == 2)
            return gtm_read_reg(GTM0_REG_BASE + CH2_FABRIC_INTF_CFG1);
        else if(ch == 3)
            return gtm_read_reg(GTM0_REG_BASE + CH3_FABRIC_INTF_CFG1);
    }
    else if(i == 1)
    {
        if(ch == 0)
            return gtm_read_reg(GTM1_REG_BASE + CH0_FABRIC_INTF_CFG1);
        else if(ch == 1)
            return gtm_read_reg(GTM1_REG_BASE + CH1_FABRIC_INTF_CFG1);
        else if(ch == 2)
            return gtm_read_reg(GTM1_REG_BASE + CH2_FABRIC_INTF_CFG1);
        else if(ch == 3)
            return gtm_read_reg(GTM1_REG_BASE + CH3_FABRIC_INTF_CFG1);
    }
}

uint32_t check_chclk_cfg(char i, char ch)
{
    if(i == 0)
    {
        if(ch == 0)
            return gtm_read_reg(GTM0_REG_BASE + CH0_CHCLK_CFG3);
        else if(ch == 1)
            return gtm_read_reg(GTM0_REG_BASE + CH1_CHCLK_CFG3);
        else if(ch == 2)
            return gtm_read_reg(GTM0_REG_BASE + CH2_CHCLK_CFG3);
        else if(ch == 3)
            return gtm_read_reg(GTM0_REG_BASE + CH3_CHCLK_CFG3);
    }
    else if(i == 1)
    {
        if(ch == 0)
            return gtm_read_reg(GTM1_REG_BASE + CH0_CHCLK_CFG3);
        else if(ch == 1)
            return gtm_read_reg(GTM1_REG_BASE + CH1_CHCLK_CFG3);
        else if(ch == 2)
            return gtm_read_reg(GTM1_REG_BASE + CH2_CHCLK_CFG3);
        else if(ch == 3)
            return gtm_read_reg(GTM1_REG_BASE + CH3_CHCLK_CFG3);
    }
}

uint32_t check_pma_misc_cfg(char i, char ch)
{
    if(i == 0)
    {
        if(ch == 0)
            return gtm_read_reg(GTM0_REG_BASE + CH0_PMA_MISC_CFG0);
        else if(ch == 1)
            return gtm_read_reg(GTM0_REG_BASE + CH1_PMA_MISC_CFG0);
        else if(ch == 2)
            return gtm_read_reg(GTM0_REG_BASE + CH2_PMA_MISC_CFG0);
        else if(ch == 3)
            return gtm_read_reg(GTM0_REG_BASE + CH3_PMA_MISC_CFG0);
    }
    else if(i == 1)
    {
        if(ch == 0)
            return gtm_read_reg(GTM1_REG_BASE + CH0_PMA_MISC_CFG0);
        else if(ch == 1)
            return gtm_read_reg(GTM1_REG_BASE + CH1_PMA_MISC_CFG0);
        else if(ch == 2)
            return gtm_read_reg(GTM1_REG_BASE + CH2_PMA_MISC_CFG0);
        else if(ch == 3)
            return gtm_read_reg(GTM1_REG_BASE + CH3_PMA_MISC_CFG0);
    }
}

void set_tx_maincursor(uint8_t gt, uint8_t ch, uint8_t val)
{
    uint32_t offset = 0;
    if(gt == 0)
    {
        offset = GT0_CURSOR_BASE + (ch * 4);
    }
    else if(gt == 1)
    {
        offset = GT1_CURSOR_BASE + (ch * 4);
    }
    // we use gtm_read_reg here, even though we're reading reg from axi gpio.
    uint32_t reg = 0;
    reg = gtm_read_reg(offset);
    // the least 7 bits are for main cursor
    reg = (reg & 0xFFFFFF80) | val; 
    gtm_write_reg(offset, reg);
}

void set_tx_postcursor(uint8_t gt, uint8_t ch, uint8_t val)
{
    uint32_t offset = 0;
    if(gt == 0)
    {
        offset = GT0_CURSOR_BASE + (ch * 4);
    }
    else if(gt == 1)
    {
        offset = GT1_CURSOR_BASE + (ch * 4);
    }
    // we use gtm_read_reg here, even though we're reading reg from axi gpio.
    uint32_t reg = 0;
    reg = gtm_read_reg(offset);
    // the least 7 bits are for main cursor
    reg = (reg & 0xFFFFE07F) | val; 
    gtm_write_reg(offset, reg);
}


void set_tx_precursor(uint8_t gt, uint8_t ch, uint8_t val)
{
    uint32_t offset = 0;
    if(gt == 0)
    {
        offset = GT0_CURSOR_BASE + (ch * 4);
    }
    else if(gt == 1)
    {
        offset = GT1_CURSOR_BASE + (ch * 4);
    }
    // we use gtm_read_reg here, even though we're reading reg from axi gpio.
    uint32_t reg = 0;
    reg = gtm_read_reg(offset);
    // the least 7 bits are for main cursor
    reg = (reg & 0xFFF81FFF) | (val << 13); 
    gtm_write_reg(offset, reg);
}

void set_tx_precursor2(uint8_t gt, uint8_t ch, uint8_t val)
{
    uint32_t offset = 0;
    if(gt == 0)
    {
        offset = GT0_CURSOR_BASE + (ch * 4);
    }
    else if(gt == 1)
    {
        offset = GT1_CURSOR_BASE + (ch * 4);
    }
    // we use gtm_read_reg here, even though we're reading reg from axi gpio.
    uint32_t reg = 0;
    reg = gtm_read_reg(offset);
    // the least 7 bits are for main cursor
    reg = (reg & 0xFE07FFFF) | (val << 19); 
    gtm_write_reg(offset, reg);
}

void set_tx_precursor3(uint8_t gt, uint8_t ch, uint8_t val)
{
    uint32_t offset = 0;
    if(gt == 0)
    {
        offset = GT0_CURSOR_BASE + (ch * 4);
    }
    else if(gt == 1)
    {
        offset = GT1_CURSOR_BASE + (ch * 4);
    }
    // we use gtm_read_reg here, even though we're reading reg from axi gpio.
    uint32_t reg = 0;
    reg = gtm_read_reg(offset);
    // the least 7 bits are for main cursor
    reg = (reg & 0x81FFFFFF) | (val << 25); 
    gtm_write_reg(offset, reg);
}