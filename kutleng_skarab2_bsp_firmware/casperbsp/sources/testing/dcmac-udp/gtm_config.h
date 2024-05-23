#ifndef _GTM_REGS_H_
#define _GTM_REGS_H_

#include <stdint.h>
#define GTM0_REG_BASE            0xA4C00000
#define GTM1_REG_BASE            0xA4C40000
#define GT0_CURSOR_BASE			 0xA4180000
#define GT1_CURSOR_BASE		     0xA4190000

#define CH0_TX_PCS_CFG0_OFFSET   (0x0C16 * 4)
#define CH1_TX_PCS_CFG0_OFFSET   (0x0D16 * 4)
#define CH2_TX_PCS_CFG0_OFFSET   (0x0E16 * 4)
#define CH3_TX_PCS_CFG0_OFFSET   (0x0F16 * 4)

#define CH0_RX_PCS_CFG0_OFFSET   (0x0C14 * 4)
#define CH1_RX_PCS_CFG0_OFFSET   (0x0D14 * 4)
#define CH2_RX_PCS_CFG0_OFFSET   (0x0E14 * 4)
#define CH3_RX_PCS_CFG0_OFFSET   (0x0F14 * 4)

#define CH0_FABRIC_INTF_CFG1     (0x0C4D * 4)
#define CH1_FABRIC_INTF_CFG1     (0x0D4D * 4)
#define CH2_FABRIC_INTF_CFG1     (0x0E4D * 4)
#define CH3_FABRIC_INTF_CFG1     (0x0F4D * 4)

#define CH0_CHCLK_CFG3           (0x0C2F * 4)
#define CH1_CHCLK_CFG3           (0x0D2F * 4)
#define CH2_CHCLK_CFG3           (0x0E2F * 4)
#define CH3_CHCLK_CFG3           (0x0F2F * 4)

#define CH0_PMA_MISC_CFG0        (0x0C27 * 4)
#define CH1_PMA_MISC_CFG0        (0x0D27 * 4)
#define CH2_PMA_MISC_CFG0        (0x0E27 * 4)
#define CH3_PMA_MISC_CFG0        (0x0F27 * 4)

#define GPIO_DATA_OFFSET         (0x0000 * 4)
#define GPIO_TRI_OFFSET          (0x0001 * 4)
#define GPIO2_DATA_OFFSET        (0x0002 * 4)
#define GPIO2_TRI_OFFSET         (0x0003 * 4)

uint32_t gtm_read_reg(uint32_t addr);
void gtm_write_reg(uint32_t addr, uint32_t data);

uint32_t check_tx_pcs_cfg(char i, char ch);
uint32_t check_loopback_mode(char i, char ch);
uint32_t check_chclk_cfg(char i, char ch);
uint32_t check_pma_misc_cfg(char i, char ch);
void set_tx_maincursor(uint8_t gt, uint8_t ch, uint8_t val);
void set_tx_postcursor(uint8_t gt, uint8_t ch, uint8_t val);
void set_tx_precursor(uint8_t gt, uint8_t ch, uint8_t val);
void set_tx_precursor2(uint8_t gt, uint8_t ch, uint8_t val);
void set_tx_precursor3(uint8_t gt, uint8_t ch, uint8_t val);
#endif
