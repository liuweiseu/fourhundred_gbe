#ifndef _FHG_REGS_H_
#define _FHG_REGS_H_

#include <stdint.h>
#define AXI_REG_BASE            0xA4B00000

// 400G regs
#define PHY_CONTROL_H           AXI_REG_BASE + (15 * 4)
#define PHY_CONTROL_L           AXI_REG_BASE + (16 * 4)
#define MAC_ADDRESS_H           AXI_REG_BASE + (3 * 4)
#define MAC_ADDRESS_L           AXI_REG_BASE + (4 * 4)
#define LOCAL_IP_ADDRESS        AXI_REG_BASE + (5 * 4)
#define LOCAL_IP_NETMASK        AXI_REG_BASE + (7 * 4)
#define GW_IP_ADDRESS           AXI_REG_BASE + (6 * 4)
#define MC_IP_ADDRESS           AXI_REG_BASE + (8 * 4)
#define MC_IP_MASK              AXI_REG_BASE + (9 * 4) 
#define UDP_PORT                AXI_REG_BASE + (12 * 4)
#define CORE_CTRL               AXI_REG_BASE + (11 * 4)
#define CORE_TYPE               AXI_REG_BASE + (0 * 4)
#define PHY_STATUS_H            AXI_REG_BASE + (13 * 4)
#define PHY_STATUS_L            AXI_REG_BASE + (14 * 4)
#define TX_PKT_RATE             AXI_REG_BASE + (18 * 4)
#define TX_PKT_CNT              AXI_REG_BASE + (19 * 4)
#define TX_VLD_RATE             AXI_REG_BASE + (20 * 4)
#define TX_VLD_CNT              AXI_REG_BASE + (21 * 4)
#define TX_OFL_CNT              AXI_REG_BASE + (22 * 4)
#define TX_AF_CNT               AXI_REG_BASE + (23 * 4)
#define RX_PKT_RATE             AXI_REG_BASE + (24 * 4)
#define RX_PKT_CNT              AXI_REG_BASE + (25 * 4)
#define RX_VLD_RATE             AXI_REG_BASE + (26 * 4)
#define RX_VLD_CNT              AXI_REG_BASE + (27 * 4)
#define RX_OFL_CNT              AXI_REG_BASE + (28 * 4)
#define RX_AF_CNT               AXI_REG_BASE + (31 * 4)
#define RX_BAD_PKT_CNT          AXI_REG_BASE + (29 * 4)
#define ARP_SIZE                AXI_REG_BASE + (17 * 4)
#define WORD_SIZE               AXI_REG_BASE + (2 * 4)
#define BUFFER_MAX_SIZE         AXI_REG_BASE + (1 * 4)
#define CNT_RESET               AXI_REG_BASE + (30 * 4)
#define ARP_WR_EN               AXI_REG_BASE + (32 * 4)
#define ARP_RD_EN               AXI_REG_BASE + (33 * 4)
#define ARP_WR_DATA             AXI_REG_BASE + (34 * 4)
#define ARP_WR_ADDR             AXI_REG_BASE + (35 * 4)
#define ARP_RD_ADDR             AXI_REG_BASE + (36 * 4)
#define ARP_RD_DATA             AXI_REG_BASE + (37 * 4)
#define TX_DST_IP               AXI_REG_BASE + (38 * 4)
#define TX_DST_UDP_PORT         AXI_REG_BASE + (39 * 4)
#define TX_SRC_UDP_PORT         AXI_REG_BASE + (40 * 4)
#define TX_PKT_LEN              AXI_REG_BASE + (41 * 4)

// axis pkt gen regs
#define AXIS_PKT_GEN            AXI_REG_BASE + (42 * 4)
#define AXIS_PKT_LEN            AXI_REG_BASE + (43 * 4)
#define AXIS_PKT_CYC            AXI_REG_BASE + (44 * 4)

uint32_t dcmac_read_reg(uint32_t addr);
void dcmac_write_reg(uint32_t addr, uint32_t data);

#endif
