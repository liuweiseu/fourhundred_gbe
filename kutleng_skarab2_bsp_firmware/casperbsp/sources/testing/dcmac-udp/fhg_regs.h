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

// am setting
#define RX_VL_LEN               AXI_REG_BASE + (45 * 4)
#define TX_VL_LEN               AXI_REG_BASE + (46 * 4)
#define VL_MARKER_ID0_LSB       AXI_REG_BASE + (47 * 4)
#define VL_MARKER_ID0_MSB       AXI_REG_BASE + (48 * 4)
#define VL_MARKER_ID1_LSB       AXI_REG_BASE + (49 * 4)
#define VL_MARKER_ID1_MSB       AXI_REG_BASE + (50 * 4)
#define VL_MARKER_ID2_LSB       AXI_REG_BASE + (51 * 4)
#define VL_MARKER_ID2_MSB       AXI_REG_BASE + (52 * 4)
#define VL_MARKER_ID3_LSB       AXI_REG_BASE + (53 * 4)
#define VL_MARKER_ID3_MSB       AXI_REG_BASE + (54 * 4)
#define VL_MARKER_ID4_LSB       AXI_REG_BASE + (55 * 4)
#define VL_MARKER_ID4_MSB       AXI_REG_BASE + (56 * 4)
#define VL_MARKER_ID5_LSB       AXI_REG_BASE + (57 * 4)
#define VL_MARKER_ID5_MSB       AXI_REG_BASE + (58 * 4)
#define VL_MARKER_ID6_LSB       AXI_REG_BASE + (59 * 4)
#define VL_MARKER_ID6_MSB       AXI_REG_BASE + (60 * 4)
#define VL_MARKER_ID7_LSB       AXI_REG_BASE + (61 * 4)
#define VL_MARKER_ID7_MSB       AXI_REG_BASE + (62 * 4)
#define VL_MARKER_ID8_LSB       AXI_REG_BASE + (63 * 4)
#define VL_MARKER_ID8_MSB       AXI_REG_BASE + (64 * 4)
#define VL_MARKER_ID9_LSB       AXI_REG_BASE + (65 * 4)
#define VL_MARKER_ID9_MSB       AXI_REG_BASE + (66 * 4)
#define VL_MARKER_ID10_LSB      AXI_REG_BASE + (67 * 4)
#define VL_MARKER_ID10_MSB      AXI_REG_BASE + (68 * 4)
#define VL_MARKER_ID11_LSB      AXI_REG_BASE + (69 * 4)
#define VL_MARKER_ID11_MSB      AXI_REG_BASE + (70 * 4)
#define VL_MARKER_ID12_LSB      AXI_REG_BASE + (71 * 4)
#define VL_MARKER_ID12_MSB      AXI_REG_BASE + (72 * 4)
#define VL_MARKER_ID13_LSB      AXI_REG_BASE + (73 * 4)
#define VL_MARKER_ID13_MSB      AXI_REG_BASE + (74 * 4)
#define VL_MARKER_ID14_LSB      AXI_REG_BASE + (75 * 4)
#define VL_MARKER_ID14_MSB      AXI_REG_BASE + (76 * 4)
#define VL_MARKER_ID15_LSB      AXI_REG_BASE + (77 * 4)
#define VL_MARKER_ID15_MSB      AXI_REG_BASE + (78 * 4)
#define VL_MARKER_ID16_LSB      AXI_REG_BASE + (79 * 4)
#define VL_MARKER_ID16_MSB      AXI_REG_BASE + (80 * 4)
#define VL_MARKER_ID17_LSB      AXI_REG_BASE + (81 * 4)
#define VL_MARKER_ID17_MSB      AXI_REG_BASE + (82 * 4)
#define VL_MARKER_ID18_LSB      AXI_REG_BASE + (83 * 4)
#define VL_MARKER_ID18_MSB      AXI_REG_BASE + (84 * 4)
#define VL_MARKER_ID19_LSB      AXI_REG_BASE + (85 * 4)
#define VL_MARKER_ID19_MSB      AXI_REG_BASE + (86 * 4)


uint32_t dcmac_read_reg(uint32_t addr);
void dcmac_write_reg(uint32_t addr, uint32_t data);
void write_arp(uint32_t addr, uint32_t data);
uint32_t read_arp(uint32_t addr);
void write_mac_addr(uint32_t *mac_addr);
void read_mac_addr(uint32_t *mac_addr);
void write_local_ip(uint32_t ip_addr);
uint32_t read_local_ip();
void write_local_netmask(uint32_t netmask);
uint32_t read_local_netmask();
void write_gw_ip(uint32_t ip_addr);
uint32_t read_gw_ip();
void write_mc_ip(uint32_t ip_addr);
uint32_t read_mc_ip();
void write_mc_mask(uint32_t mask);
uint32_t read_mc_mask();
void write_udp_port(uint32_t port);
uint32_t read_udp_port();
void write_dst_ip(uint32_t ip_addr);
uint32_t read_dst_ip();
void write_dst_udp_port(uint32_t port);
uint32_t read_dst_udp_port();
void write_src_udp_port(uint32_t port);
uint32_t read_src_udp_port();
void write_pkt_len(uint32_t len);
uint32_t read_pkt_len();
void enable_core_ctrl();
void disable_core_ctrl();
void enable_axis_pkt_gen();
void disable_axis_pkt_gen();
void write_axis_pkt_len(uint32_t len);
uint32_t read_axis_pkt_len();
void write_axis_pkt_cyc(uint32_t cyc);
uint32_t read_axis_pkt_cyc();
void set_tx_rx_vl_length(uint32_t len);
void set_vl_marker(uint32_t *marker);
#endif
