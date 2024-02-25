#ifndef _DCMAC_CONFIG_H_
#define _DCMAC_CONFIG_H_

#include <xparameters.h>

// DCMAC AXI Base Addresses
#define DCMAC_0_BASEADDR         0xA4A00000
#define DCMAC_0_GT_CTL_BASEADDR  XPAR_AXI_GPIO_GT_CTL_BASEADDR
#define DCMAC_0_TX_DATAPATH_BASEADDR  XPAR_AXI_GPIO_TX_DATAPATH_BASEADDR
#define DCMAC_0_RX_DATAPATH_BASEADDR  XPAR_AXI_GPIO_RX_DATAPATH_BASEADDR
#define DCMAC_0_DCMAC_RESETS   XPAR_AXI_RESETS_DYN_BASEADDR
#define DCMAC_0_GT_RESET_DONE  XPAR_AXI_RESET_DONE_DYN_BASEADDR
#define ADDR_AXI4_BASE           0xA4A00000

// APB3 Base Addresses
#define ADDR_APB3_2_BASE         0xA4100000
#define ADDR_APB3_3_BASE         0xA4110000
#define ADDR_APB3_4_BASE         0xA4120000

// Refer PG369 for additional user specific port/channel register sequencing information
/* DCMAC Register Addresses */
#define REV_ID_REG_OFFSET 0x00000
#define GLOBAL_MODE_OFFSET 0x00004
#define MAC_CONFIG_REG_TX_WR_OFFSET 0x00038
#define GLOBAL_CONTROL_REG_RX_OFFSET  0x000f0
#define GLOBAL_CONTROL_REG_TX_OFFSET  0x000f8
#define ALL_CHANNEL_MAC_TICK_REG_RX_OFFSET 0x000f4
#define ALL_CHANNEL_MAC_TICK_REG_TX_OFFSET 0x000fc
#define C0_PORT_TICK_REG_RX 0x010f4
#define C1_PORT_TICK_REG_RX 0x020f4
#define C2_PORT_TICK_REG_RX 0x030f4
#define C3_PORT_TICK_REG_RX 0x040f4
#define C4_PORT_TICK_REG_RX 0x050f4
#define C5_PORT_TICK_REG_RX 0x060f4
#define C0_PORT_TICK_REG_TX 0x010fc
#define C1_PORT_TICK_REG_TX 0x020fc
#define C2_PORT_TICK_REG_TX 0x030fc
#define C3_PORT_TICK_REG_TX 0x040fc
#define C4_PORT_TICK_REG_TX 0x050fc
#define C5_PORT_TICK_REG_TX 0x060fc
#define C0_STAT_PORT_RX_PHY_STATUS_REG_OFFSET 0x01C00
#define C1_STAT_PORT_RX_PHY_STATUS_REG_OFFSET 0x02C00
#define C2_STAT_PORT_RX_PHY_STATUS_REG_OFFSET 0x03C00
#define C3_STAT_PORT_RX_PHY_STATUS_REG_OFFSET 0x04C00
#define C4_STAT_PORT_RX_PHY_STATUS_REG_OFFSET 0x05C00
#define C5_STAT_PORT_RX_PHY_STATUS_REG_OFFSET 0x06C00
#define C0_TX_MODE_REG_OFFSET 0x01040
#define C1_TX_MODE_REG_OFFSET 0x02040
#define C2_TX_MODE_REG_OFFSET 0x03040
#define C3_TX_MODE_REG_OFFSET 0x04040
#define C4_TX_MODE_REG_OFFSET 0x05040
#define C5_TX_MODE_REG_OFFSET 0x06040
#define C0_RX_MODE_REG_OFFSET 0x01044
#define C1_RX_MODE_REG_OFFSET 0x02044
#define C2_RX_MODE_REG_OFFSET 0x03044
#define C3_RX_MODE_REG_OFFSET 0x04044
#define C4_RX_MODE_REG_OFFSET 0x05044
#define C5_RX_MODE_REG_OFFSET 0x06044
#define C0_CHANNEL_CONTROL_REG_RX_OFFSET 0x01030
#define C1_CHANNEL_CONTROL_REG_RX_OFFSET 0x02030
#define C2_CHANNEL_CONTROL_REG_RX_OFFSET 0x03030
#define C3_CHANNEL_CONTROL_REG_RX_OFFSET 0x04030
#define C4_CHANNEL_CONTROL_REG_RX_OFFSET 0x05030
#define C5_CHANNEL_CONTROL_REG_RX_OFFSET 0x06030
#define C0_CHANNEL_CONTROL_REG_TX_OFFSET 0x01038
#define C1_CHANNEL_CONTROL_REG_TX_OFFSET 0x02038
#define C2_CHANNEL_CONTROL_REG_TX_OFFSET 0x03038
#define C3_CHANNEL_CONTROL_REG_TX_OFFSET 0x04038
#define C4_CHANNEL_CONTROL_REG_TX_OFFSET 0x05038
#define C5_CHANNEL_CONTROL_REG_TX_OFFSET 0x06038
#define C0_PORT_CONTROL_REG_RX_OFFSET 0x010f0
#define C1_PORT_CONTROL_REG_RX_OFFSET 0x020f0
#define C2_PORT_CONTROL_REG_RX_OFFSET 0x030f0
#define C3_PORT_CONTROL_REG_RX_OFFSET 0x040f0
#define C4_PORT_CONTROL_REG_RX_OFFSET 0x050f0
#define C5_PORT_CONTROL_REG_RX_OFFSET 0x060f0
#define C0_PORT_CONTROL_REG_TX_OFFSET 0x010f8
#define C1_PORT_CONTROL_REG_TX_OFFSET 0x020f8
#define C2_PORT_CONTROL_REG_TX_OFFSET 0x030f8
#define C3_PORT_CONTROL_REG_TX_OFFSET 0x040f8
#define C4_PORT_CONTROL_REG_TX_OFFSET 0x050f8
#define C5_PORT_CONTROL_REG_TX_OFFSET 0x060f8
#define C0_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET 0x01100
#define C1_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET 0x02100
#define C2_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET 0x03100
#define C3_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET 0x04100
#define C4_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET 0x05100
#define C5_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET 0x06100
#define C0_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET 0x01140
#define C1_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET 0x02140
#define C2_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET 0x03140
#define C3_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET 0x04140
#define C4_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET 0x05140
#define C5_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET 0x06140
#define C0_STAT_TX_TOTAL_BYTES_LSB_OFFSET 0x01200
#define C1_STAT_TX_TOTAL_BYTES_LSB_OFFSET 0x02200
#define C2_STAT_TX_TOTAL_BYTES_LSB_OFFSET 0x03200
#define C3_STAT_TX_TOTAL_BYTES_LSB_OFFSET 0x04200
#define C4_STAT_TX_TOTAL_BYTES_LSB_OFFSET 0x05200
#define C5_STAT_TX_TOTAL_BYTES_LSB_OFFSET 0x06200
#define C0_STAT_TX_TOTAL_BYTES_MSB_OFFSET 0x01204
#define C1_STAT_TX_TOTAL_BYTES_MSB_OFFSET 0x02204
#define C2_STAT_TX_TOTAL_BYTES_MSB_OFFSET 0x03204
#define C3_STAT_TX_TOTAL_BYTES_MSB_OFFSET 0x04204
#define C4_STAT_TX_TOTAL_BYTES_MSB_OFFSET 0x05204
#define C5_STAT_TX_TOTAL_BYTES_MSB_OFFSET 0x06204
#define C0_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x01208
#define C1_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x02208
#define C2_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x03208
#define C3_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x04208
#define C4_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x05208
#define C5_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x06208
#define C0_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0120c
#define C1_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0220c
#define C2_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0320c
#define C3_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0420c
#define C4_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0520c
#define C5_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0620c
#define C0_STAT_TX_TOTAL_PACKETS_LSB_OFFSET 0x01210
#define C1_STAT_TX_TOTAL_PACKETS_LSB_OFFSET 0x02210
#define C2_STAT_TX_TOTAL_PACKETS_LSB_OFFSET 0x03210
#define C3_STAT_TX_TOTAL_PACKETS_LSB_OFFSET 0x04210
#define C4_STAT_TX_TOTAL_PACKETS_LSB_OFFSET 0x05210
#define C5_STAT_TX_TOTAL_PACKETS_LSB_OFFSET 0x06210
#define C0_STAT_TX_TOTAL_PACKETS_MSB_OFFSET 0x01214
#define C1_STAT_TX_TOTAL_PACKETS_MSB_OFFSET 0x02214
#define C2_STAT_TX_TOTAL_PACKETS_MSB_OFFSET 0x03214
#define C3_STAT_TX_TOTAL_PACKETS_MSB_OFFSET 0x04214
#define C4_STAT_TX_TOTAL_PACKETS_MSB_OFFSET 0x05214
#define C5_STAT_TX_TOTAL_PACKETS_MSB_OFFSET 0x06214
#define C0_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x01218
#define C1_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x02218
#define C2_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x03218
#define C3_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x04218
#define C4_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x05218
#define C5_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x06218
#define C0_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0121c
#define C1_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0221c
#define C2_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0321c
#define C3_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0421c
#define C4_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0521c
#define C5_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0621c
#define C0_STAT_RX_TOTAL_BYTES_LSB_OFFSET 0x01400
#define C1_STAT_RX_TOTAL_BYTES_LSB_OFFSET 0x02400
#define C2_STAT_RX_TOTAL_BYTES_LSB_OFFSET 0x03400
#define C3_STAT_RX_TOTAL_BYTES_LSB_OFFSET 0x04400
#define C4_STAT_RX_TOTAL_BYTES_LSB_OFFSET 0x05400
#define C5_STAT_RX_TOTAL_BYTES_LSB_OFFSET 0x06400
#define C0_STAT_RX_TOTAL_BYTES_MSB_OFFSET 0x01404
#define C1_STAT_RX_TOTAL_BYTES_MSB_OFFSET 0x02404
#define C2_STAT_RX_TOTAL_BYTES_MSB_OFFSET 0x03404
#define C3_STAT_RX_TOTAL_BYTES_MSB_OFFSET 0x04404
#define C4_STAT_RX_TOTAL_BYTES_MSB_OFFSET 0x05404
#define C5_STAT_RX_TOTAL_BYTES_MSB_OFFSET 0x06404
#define C0_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x01408
#define C1_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x02408
#define C2_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x03408
#define C3_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x04408
#define C4_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x05408
#define C5_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET 0x06408
#define C0_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0140c
#define C1_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0240c
#define C2_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0340c
#define C3_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0440c
#define C4_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0540c
#define C5_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET 0x0640c
#define C0_STAT_RX_TOTAL_PACKETS_LSB_OFFSET 0x01410
#define C1_STAT_RX_TOTAL_PACKETS_LSB_OFFSET 0x02410
#define C2_STAT_RX_TOTAL_PACKETS_LSB_OFFSET 0x03410
#define C3_STAT_RX_TOTAL_PACKETS_LSB_OFFSET 0x04410
#define C4_STAT_RX_TOTAL_PACKETS_LSB_OFFSET 0x05410
#define C5_STAT_RX_TOTAL_PACKETS_LSB_OFFSET 0x06410
#define C0_STAT_RX_TOTAL_PACKETS_MSB_OFFSET 0x01414
#define C1_STAT_RX_TOTAL_PACKETS_MSB_OFFSET 0x02414
#define C2_STAT_RX_TOTAL_PACKETS_MSB_OFFSET 0x03414
#define C3_STAT_RX_TOTAL_PACKETS_MSB_OFFSET 0x04414
#define C4_STAT_RX_TOTAL_PACKETS_MSB_OFFSET 0x05414
#define C5_STAT_RX_TOTAL_PACKETS_MSB_OFFSET 0x06414
#define C0_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x01418
#define C1_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x02418
#define C2_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x03418
#define C3_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x04418
#define C4_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x05418
#define C5_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET 0x06418
#define C0_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0141c
#define C1_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0241c
#define C2_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0341c
#define C3_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0441c
#define C4_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0541c
#define C5_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET 0x0641c
#define C0_STAT_PORT_TX_FEC_STATUS_OFFSET    0x0180c
#define C1_STAT_PORT_TX_FEC_STATUS_OFFSET    0x0280c
#define C2_STAT_PORT_TX_FEC_STATUS_OFFSET    0x0380c
#define C3_STAT_PORT_TX_FEC_STATUS_OFFSET    0x0480c
#define C4_STAT_PORT_TX_FEC_STATUS_OFFSET    0x0580c
#define C5_STAT_PORT_TX_FEC_STATUS_OFFSET    0x0680c
#define C0_STAT_PORT_RX_FEC_STATUS_OFFSET    0x01c34
#define C1_STAT_PORT_RX_FEC_STATUS_OFFSET    0x02c34
#define C2_STAT_PORT_RX_FEC_STATUS_OFFSET    0x03c34
#define C3_STAT_PORT_RX_FEC_STATUS_OFFSET    0x04c34
#define C4_STAT_PORT_RX_FEC_STATUS_OFFSET    0x05c34
#define C5_STAT_PORT_RX_FEC_STATUS_OFFSET    0x06c34
/* REG MAP */
#define REV_ID_REG                                  ADDR_AXI4_BASE + REV_ID_REG_OFFSET
#define GLOBAL_MODE_REG                             ADDR_AXI4_BASE + GLOBAL_MODE_OFFSET
#define MAC_CONFIG_REG_TX_WR_REG                    ADDR_AXI4_BASE + MAC_CONFIG_REG_TX_WR_OFFSET
#define GLOBAL_CONTROL_REG_RX_REG                   ADDR_AXI4_BASE + GLOBAL_CONTROL_REG_RX_OFFSET
#define GLOBAL_CONTROL_REG_TX_REG                   ADDR_AXI4_BASE + GLOBAL_CONTROL_REG_TX_OFFSET
#define ALL_CHANNEL_MAC_TICK_REG_RX_REG             ADDR_AXI4_BASE + ALL_CHANNEL_MAC_TICK_REG_RX_OFFSET
#define ALL_CHANNEL_MAC_TICK_REG_TX_REG             ADDR_AXI4_BASE + ALL_CHANNEL_MAC_TICK_REG_TX_OFFSET
#define C0_PORT_TICK_REG_RX_REG                     ADDR_AXI4_BASE + C0_PORT_TICK_REG_RX
#define C1_PORT_TICK_REG_RX_REG                     ADDR_AXI4_BASE + C1_PORT_TICK_REG_RX
#define C2_PORT_TICK_REG_RX_REG                     ADDR_AXI4_BASE + C2_PORT_TICK_REG_RX
#define C3_PORT_TICK_REG_RX_REG                     ADDR_AXI4_BASE + C3_PORT_TICK_REG_RX
#define C4_PORT_TICK_REG_RX_REG                     ADDR_AXI4_BASE + C4_PORT_TICK_REG_RX
#define C5_PORT_TICK_REG_RX_REG                     ADDR_AXI4_BASE + C5_PORT_TICK_REG_RX
#define C0_PORT_TICK_REG_TX_REG                     ADDR_AXI4_BASE + C0_PORT_TICK_REG_TX
#define C1_PORT_TICK_REG_TX_REG                     ADDR_AXI4_BASE + C1_PORT_TICK_REG_TX
#define C2_PORT_TICK_REG_TX_REG                     ADDR_AXI4_BASE + C2_PORT_TICK_REG_TX
#define C3_PORT_TICK_REG_TX_REG                     ADDR_AXI4_BASE + C3_PORT_TICK_REG_TX
#define C4_PORT_TICK_REG_TX_REG                     ADDR_AXI4_BASE + C4_PORT_TICK_REG_TX
#define C5_PORT_TICK_REG_TX_REG                     ADDR_AXI4_BASE + C5_PORT_TICK_REG_TX
#define C0_STAT_PORT_RX_PHY_STATUS_REG_REG          ADDR_AXI4_BASE + C0_STAT_PORT_RX_PHY_STATUS_REG_OFFSET
#define C1_STAT_PORT_RX_PHY_STATUS_REG_REG          ADDR_AXI4_BASE + C1_STAT_PORT_RX_PHY_STATUS_REG_OFFSET
#define C2_STAT_PORT_RX_PHY_STATUS_REG_REG          ADDR_AXI4_BASE + C2_STAT_PORT_RX_PHY_STATUS_REG_OFFSET
#define C3_STAT_PORT_RX_PHY_STATUS_REG_REG          ADDR_AXI4_BASE + C3_STAT_PORT_RX_PHY_STATUS_REG_OFFSET
#define C4_STAT_PORT_RX_PHY_STATUS_REG_REG          ADDR_AXI4_BASE + C4_STAT_PORT_RX_PHY_STATUS_REG_OFFSET
#define C5_STAT_PORT_RX_PHY_STATUS_REG_REG          ADDR_AXI4_BASE + C5_STAT_PORT_RX_PHY_STATUS_REG_OFFSET
#define C0_TX_MODE_REG_REG                          ADDR_AXI4_BASE + C0_TX_MODE_REG_OFFSET
#define C1_TX_MODE_REG_REG                          ADDR_AXI4_BASE + C1_TX_MODE_REG_OFFSET
#define C2_TX_MODE_REG_REG                          ADDR_AXI4_BASE + C2_TX_MODE_REG_OFFSET
#define C3_TX_MODE_REG_REG                          ADDR_AXI4_BASE + C3_TX_MODE_REG_OFFSET
#define C4_TX_MODE_REG_REG                          ADDR_AXI4_BASE + C4_TX_MODE_REG_OFFSET
#define C5_TX_MODE_REG_REG                          ADDR_AXI4_BASE + C5_TX_MODE_REG_OFFSET
#define C0_RX_MODE_REG_REG                          ADDR_AXI4_BASE + C0_RX_MODE_REG_OFFSET
#define C1_RX_MODE_REG_REG                          ADDR_AXI4_BASE + C1_RX_MODE_REG_OFFSET
#define C2_RX_MODE_REG_REG                          ADDR_AXI4_BASE + C2_RX_MODE_REG_OFFSET
#define C3_RX_MODE_REG_REG                          ADDR_AXI4_BASE + C3_RX_MODE_REG_OFFSET
#define C4_RX_MODE_REG_REG                          ADDR_AXI4_BASE + C4_RX_MODE_REG_OFFSET
#define C5_RX_MODE_REG_REG                          ADDR_AXI4_BASE + C5_RX_MODE_REG_OFFSET
#define C0_CHANNEL_CONTROL_REG_RX_REG               ADDR_AXI4_BASE + C0_CHANNEL_CONTROL_REG_RX_OFFSET
#define C1_CHANNEL_CONTROL_REG_RX_REG               ADDR_AXI4_BASE + C1_CHANNEL_CONTROL_REG_RX_OFFSET
#define C2_CHANNEL_CONTROL_REG_RX_REG               ADDR_AXI4_BASE + C2_CHANNEL_CONTROL_REG_RX_OFFSET
#define C3_CHANNEL_CONTROL_REG_RX_REG               ADDR_AXI4_BASE + C3_CHANNEL_CONTROL_REG_RX_OFFSET
#define C4_CHANNEL_CONTROL_REG_RX_REG               ADDR_AXI4_BASE + C4_CHANNEL_CONTROL_REG_RX_OFFSET
#define C5_CHANNEL_CONTROL_REG_RX_REG               ADDR_AXI4_BASE + C5_CHANNEL_CONTROL_REG_RX_OFFSET
#define C0_CHANNEL_CONTROL_REG_TX_REG               ADDR_AXI4_BASE + C0_CHANNEL_CONTROL_REG_TX_OFFSET
#define C1_CHANNEL_CONTROL_REG_TX_REG               ADDR_AXI4_BASE + C1_CHANNEL_CONTROL_REG_TX_OFFSET
#define C2_CHANNEL_CONTROL_REG_TX_REG               ADDR_AXI4_BASE + C2_CHANNEL_CONTROL_REG_TX_OFFSET
#define C3_CHANNEL_CONTROL_REG_TX_REG               ADDR_AXI4_BASE + C3_CHANNEL_CONTROL_REG_TX_OFFSET
#define C4_CHANNEL_CONTROL_REG_TX_REG               ADDR_AXI4_BASE + C4_CHANNEL_CONTROL_REG_TX_OFFSET
#define C5_CHANNEL_CONTROL_REG_TX_REG               ADDR_AXI4_BASE + C5_CHANNEL_CONTROL_REG_TX_OFFSET
#define C0_PORT_CONTROL_REG_RX_REG                  ADDR_AXI4_BASE + C0_PORT_CONTROL_REG_RX_OFFSET
#define C1_PORT_CONTROL_REG_RX_REG                  ADDR_AXI4_BASE + C1_PORT_CONTROL_REG_RX_OFFSET
#define C2_PORT_CONTROL_REG_RX_REG                  ADDR_AXI4_BASE + C2_PORT_CONTROL_REG_RX_OFFSET
#define C3_PORT_CONTROL_REG_RX_REG                  ADDR_AXI4_BASE + C3_PORT_CONTROL_REG_RX_OFFSET
#define C4_PORT_CONTROL_REG_RX_REG                  ADDR_AXI4_BASE + C4_PORT_CONTROL_REG_RX_OFFSET
#define C5_PORT_CONTROL_REG_RX_REG                  ADDR_AXI4_BASE + C5_PORT_CONTROL_REG_RX_OFFSET
#define C0_PORT_CONTROL_REG_TX_REG                  ADDR_AXI4_BASE + C0_PORT_CONTROL_REG_TX_OFFSET
#define C1_PORT_CONTROL_REG_TX_REG                  ADDR_AXI4_BASE + C1_PORT_CONTROL_REG_TX_OFFSET
#define C2_PORT_CONTROL_REG_TX_REG                  ADDR_AXI4_BASE + C2_PORT_CONTROL_REG_TX_OFFSET
#define C3_PORT_CONTROL_REG_TX_REG                  ADDR_AXI4_BASE + C3_PORT_CONTROL_REG_TX_OFFSET
#define C4_PORT_CONTROL_REG_TX_REG                  ADDR_AXI4_BASE + C4_PORT_CONTROL_REG_TX_OFFSET
#define C5_PORT_CONTROL_REG_TX_REG                  ADDR_AXI4_BASE + C5_PORT_CONTROL_REG_TX_OFFSET
#define C0_STAT_CHAN_TX_MAC_STATUS_REG              ADDR_AXI4_BASE + C0_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET
#define C1_STAT_CHAN_TX_MAC_STATUS_REG              ADDR_AXI4_BASE + C1_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET
#define C2_STAT_CHAN_TX_MAC_STATUS_REG              ADDR_AXI4_BASE + C2_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET
#define C3_STAT_CHAN_TX_MAC_STATUS_REG              ADDR_AXI4_BASE + C3_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET
#define C4_STAT_CHAN_TX_MAC_STATUS_REG              ADDR_AXI4_BASE + C4_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET
#define C5_STAT_CHAN_TX_MAC_STATUS_REG              ADDR_AXI4_BASE + C5_STAT_CHAN_TX_MAC_STATUS_REG_OFFSET
#define C0_STAT_CHAN_RX_MAC_STATUS_REG              ADDR_AXI4_BASE + C0_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET
#define C1_STAT_CHAN_RX_MAC_STATUS_REG              ADDR_AXI4_BASE + C1_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET
#define C2_STAT_CHAN_RX_MAC_STATUS_REG              ADDR_AXI4_BASE + C2_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET
#define C3_STAT_CHAN_RX_MAC_STATUS_REG              ADDR_AXI4_BASE + C3_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET
#define C4_STAT_CHAN_RX_MAC_STATUS_REG              ADDR_AXI4_BASE + C4_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET
#define C5_STAT_CHAN_RX_MAC_STATUS_REG              ADDR_AXI4_BASE + C5_STAT_CHAN_RX_MAC_STATUS_REG_OFFSET
#define C0_STAT_TX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C0_STAT_TX_TOTAL_BYTES_LSB_OFFSET
#define C1_STAT_TX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C1_STAT_TX_TOTAL_BYTES_LSB_OFFSET
#define C2_STAT_TX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C2_STAT_TX_TOTAL_BYTES_LSB_OFFSET
#define C3_STAT_TX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C3_STAT_TX_TOTAL_BYTES_LSB_OFFSET
#define C4_STAT_TX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C4_STAT_TX_TOTAL_BYTES_LSB_OFFSET
#define C5_STAT_TX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C5_STAT_TX_TOTAL_BYTES_LSB_OFFSET
#define C0_STAT_TX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C0_STAT_TX_TOTAL_BYTES_MSB_OFFSET
#define C1_STAT_TX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C1_STAT_TX_TOTAL_BYTES_MSB_OFFSET
#define C2_STAT_TX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C2_STAT_TX_TOTAL_BYTES_MSB_OFFSET
#define C3_STAT_TX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C3_STAT_TX_TOTAL_BYTES_MSB_OFFSET
#define C4_STAT_TX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C4_STAT_TX_TOTAL_BYTES_MSB_OFFSET
#define C5_STAT_TX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C5_STAT_TX_TOTAL_BYTES_MSB_OFFSET
#define C0_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C0_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C1_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C1_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C2_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C2_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C3_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C3_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C4_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C4_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C5_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C5_STAT_TX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C0_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C0_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C1_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C1_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C2_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C2_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C3_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C3_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C4_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C4_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C5_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C5_STAT_TX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C0_STAT_TX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C0_STAT_TX_TOTAL_PACKETS_LSB_OFFSET
#define C1_STAT_TX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C1_STAT_TX_TOTAL_PACKETS_LSB_OFFSET
#define C2_STAT_TX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C2_STAT_TX_TOTAL_PACKETS_LSB_OFFSET
#define C3_STAT_TX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C3_STAT_TX_TOTAL_PACKETS_LSB_OFFSET
#define C4_STAT_TX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C4_STAT_TX_TOTAL_PACKETS_LSB_OFFSET
#define C5_STAT_TX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C5_STAT_TX_TOTAL_PACKETS_LSB_OFFSET
#define C0_STAT_TX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C0_STAT_TX_TOTAL_PACKETS_MSB_OFFSET
#define C1_STAT_TX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C1_STAT_TX_TOTAL_PACKETS_MSB_OFFSET
#define C2_STAT_TX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C2_STAT_TX_TOTAL_PACKETS_MSB_OFFSET
#define C3_STAT_TX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C3_STAT_TX_TOTAL_PACKETS_MSB_OFFSET
#define C4_STAT_TX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C4_STAT_TX_TOTAL_PACKETS_MSB_OFFSET
#define C5_STAT_TX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C5_STAT_TX_TOTAL_PACKETS_MSB_OFFSET
#define C0_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C0_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C1_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C1_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C2_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C2_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C3_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C3_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C4_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C4_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C5_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C5_STAT_TX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C0_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C0_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C1_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C1_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C2_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C2_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C3_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C3_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C4_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C4_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C5_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C5_STAT_TX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C0_STAT_RX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C0_STAT_RX_TOTAL_BYTES_LSB_OFFSET
#define C1_STAT_RX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C1_STAT_RX_TOTAL_BYTES_LSB_OFFSET
#define C2_STAT_RX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C2_STAT_RX_TOTAL_BYTES_LSB_OFFSET
#define C3_STAT_RX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C3_STAT_RX_TOTAL_BYTES_LSB_OFFSET
#define C4_STAT_RX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C4_STAT_RX_TOTAL_BYTES_LSB_OFFSET
#define C5_STAT_RX_TOTAL_BYTES_LSB_REG              ADDR_AXI4_BASE + C5_STAT_RX_TOTAL_BYTES_LSB_OFFSET
#define C0_STAT_RX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C0_STAT_RX_TOTAL_BYTES_MSB_OFFSET
#define C1_STAT_RX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C1_STAT_RX_TOTAL_BYTES_MSB_OFFSET
#define C2_STAT_RX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C2_STAT_RX_TOTAL_BYTES_MSB_OFFSET
#define C3_STAT_RX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C3_STAT_RX_TOTAL_BYTES_MSB_OFFSET
#define C4_STAT_RX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C4_STAT_RX_TOTAL_BYTES_MSB_OFFSET
#define C5_STAT_RX_TOTAL_BYTES_MSB_REG              ADDR_AXI4_BASE + C5_STAT_RX_TOTAL_BYTES_MSB_OFFSET
#define C0_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C0_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C1_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C1_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C2_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C2_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C3_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C3_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C4_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C4_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C5_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG         ADDR_AXI4_BASE + C5_STAT_RX_TOTAL_GOOD_BYTES_LSB_OFFSET
#define C0_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C0_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C1_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C1_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C2_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C2_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C3_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C3_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C4_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C4_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C5_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG         ADDR_AXI4_BASE + C5_STAT_RX_TOTAL_GOOD_BYTES_MSB_OFFSET
#define C0_STAT_RX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C0_STAT_RX_TOTAL_PACKETS_LSB_OFFSET
#define C1_STAT_RX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C1_STAT_RX_TOTAL_PACKETS_LSB_OFFSET
#define C2_STAT_RX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C2_STAT_RX_TOTAL_PACKETS_LSB_OFFSET
#define C3_STAT_RX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C3_STAT_RX_TOTAL_PACKETS_LSB_OFFSET
#define C4_STAT_RX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C4_STAT_RX_TOTAL_PACKETS_LSB_OFFSET
#define C5_STAT_RX_TOTAL_PACKETS_LSB_REG            ADDR_AXI4_BASE + C5_STAT_RX_TOTAL_PACKETS_LSB_OFFSET
#define C0_STAT_RX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C0_STAT_RX_TOTAL_PACKETS_MSB_OFFSET
#define C1_STAT_RX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C1_STAT_RX_TOTAL_PACKETS_MSB_OFFSET
#define C2_STAT_RX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C2_STAT_RX_TOTAL_PACKETS_MSB_OFFSET
#define C3_STAT_RX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C3_STAT_RX_TOTAL_PACKETS_MSB_OFFSET
#define C4_STAT_RX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C4_STAT_RX_TOTAL_PACKETS_MSB_OFFSET
#define C5_STAT_RX_TOTAL_PACKETS_MSB_REG            ADDR_AXI4_BASE + C5_STAT_RX_TOTAL_PACKETS_MSB_OFFSET
#define C0_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C0_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C1_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C1_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C2_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C2_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C3_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C3_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C4_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C4_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C5_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG       ADDR_AXI4_BASE + C5_STAT_RX_TOTAL_GOOD_PACKETS_LSB_OFFSET
#define C0_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C0_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C1_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C1_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C2_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C2_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C3_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C3_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C4_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C4_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C5_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG       ADDR_AXI4_BASE + C5_STAT_RX_TOTAL_GOOD_PACKETS_MSB_OFFSET
#define C0_STAT_PORT_TX_FEC_STATUS_REG              ADDR_AXI4_BASE + C0_STAT_PORT_TX_FEC_STATUS_OFFSET
#define C1_STAT_PORT_TX_FEC_STATUS_REG              ADDR_AXI4_BASE + C1_STAT_PORT_TX_FEC_STATUS_OFFSET
#define C2_STAT_PORT_TX_FEC_STATUS_REG              ADDR_AXI4_BASE + C2_STAT_PORT_TX_FEC_STATUS_OFFSET
#define C3_STAT_PORT_TX_FEC_STATUS_REG              ADDR_AXI4_BASE + C3_STAT_PORT_TX_FEC_STATUS_OFFSET
#define C4_STAT_PORT_TX_FEC_STATUS_REG              ADDR_AXI4_BASE + C4_STAT_PORT_TX_FEC_STATUS_OFFSET
#define C5_STAT_PORT_TX_FEC_STATUS_REG              ADDR_AXI4_BASE + C5_STAT_PORT_TX_FEC_STATUS_OFFSET
#define C0_STAT_PORT_RX_FEC_STATUS_REG              ADDR_AXI4_BASE + C0_STAT_PORT_RX_FEC_STATUS_OFFSET
#define C1_STAT_PORT_RX_FEC_STATUS_REG              ADDR_AXI4_BASE + C1_STAT_PORT_RX_FEC_STATUS_OFFSET
#define C2_STAT_PORT_RX_FEC_STATUS_REG              ADDR_AXI4_BASE + C2_STAT_PORT_RX_FEC_STATUS_OFFSET
#define C3_STAT_PORT_RX_FEC_STATUS_REG              ADDR_AXI4_BASE + C3_STAT_PORT_RX_FEC_STATUS_OFFSET
#define C4_STAT_PORT_RX_FEC_STATUS_REG              ADDR_AXI4_BASE + C4_STAT_PORT_RX_FEC_STATUS_OFFSET
#define C5_STAT_PORT_RX_FEC_STATUS_REG              ADDR_AXI4_BASE + C5_STAT_PORT_RX_FEC_STATUS_OFFSET

#define DCMAC_0_GT_LINERATE_RESET                   DCMAC_0_GT_CTL_BASEADDR + 0x00000000
#define DCMAC_0_GT_TX_DATAPATH_RESET                DCMAC_0_TX_DATAPATH_BASEADDR + 0x00000000
#define DCMAC_0_GT_RX_DATAPATH_RESET                DCMAC_0_RX_DATAPATH_BASEADDR + 0x00000000
#define DCMAC_0_CORE_SERDES_RESET                   DCMAC_0_DCMAC_RESETS + 0x00000000
#define DCMAC_0_PHASE_FIFO_RESET                    DCMAC_0_DCMAC_RESETS + 0x00000008
#define DCMAC_0_GT_TX_RESET_DONE                    DCMAC_0_GT_RESET_DONE + 0x00000000
#define DCMAC_0_GT_RX_RESET_DONE                    DCMAC_0_GT_RESET_DONE + 0x00000008
//****
#define R_400G 2
#define R_200G 1
#define R_100G 0

typedef uint32_t U32;
typedef uint64_t U64;

int wait (uint32_t delay);
uint8_t get_chstr();
int print_port0_statistics();
int print_port1_statistics();
int print_port2_statistics();
int print_port3_statistics();
int print_port4_statistics();
int print_port5_statistics();
int latch_all();
int assert_all_reset();
int assert_txreset();
int deassert_txreset();
int assert_rxreset();
int deassert_rxreset();
int release_all_reset();
int assert_channel_resets(uint8_t client, uint8_t client_rate);
int release_channel_resets(uint8_t client, uint8_t client_rate);
int config_mac();
int check_sanity();
int cal_rst_val(int k);
int cal_stat_match();
int set_data_rate(uint8_t* rate);
int wait_for_alignment();
int test_chan_40();
int assert_dcmac_global_port_channel_resets_static();
int release_dcmac_global_port_channel_resets_static();
int init_ch_en_client_rate_static();
int dcmac_reset_dcmac_phase_fifo();
int gt_rx_datapathonly_reset();
int wait_gt_txresetdone(int lane_cnt);
int wait_gt_rxresetdone(int lane_cnt);
int assert_rx_port_reset();
int deassert_rx_port_reset();
int dcmac_rx_port_reset();
int stats_test_check();
int set_gt_pcs_loopback_and_reset_static(int mode);
int program_dcmac();
int test_fixe_sanity(uint8_t ch_en_str);
int read_rev_id();
int change_loopback_mode(int mode);

#endif