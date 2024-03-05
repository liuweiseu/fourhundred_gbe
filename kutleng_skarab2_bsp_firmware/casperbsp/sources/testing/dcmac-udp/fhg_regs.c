#include <xparameters.h>
#include "fhg_regs.h"

// read register
uint32_t dcmac_read_reg(uint32_t addr)
{
    return *(uint32_t *)(addr);
}

// write register
void dcmac_write_reg(uint32_t addr, uint32_t data)
{
    *(uint32_t *)(addr) = data;
}

// write arp table
void write_arp(uint32_t addr, uint32_t data)
{
    dcmac_write_reg(ARP_WR_ADDR, addr);
    dcmac_write_reg(ARP_WR_DATA, data);
    dcmac_write_reg(ARP_WR_EN, 1);
    usleep(2000);
    dcmac_write_reg(ARP_WR_EN, 0);
}

// read arp table
uint32_t read_arp(uint32_t addr)
{
    dcmac_write_reg(ARP_RD_ADDR, addr);
    dcmac_write_reg(ARP_RD_EN, 1);
    usleep(2000);
    dcmac_write_reg(ARP_RD_EN, 0);
    return dcmac_read_reg(ARP_RD_DATA);
}

// write mac address
void write_mac_addr(uint32_t *mac_addr)
{
    dcmac_write_reg(MAC_ADDRESS_H, mac_addr[0]);
    dcmac_write_reg(MAC_ADDRESS_L, mac_addr[1]);
}

// read mac address
void read_mac_addr(uint32_t *mac_addr)
{
    mac_addr[0] = dcmac_read_reg(MAC_ADDRESS_H);
    mac_addr[1] = dcmac_read_reg(MAC_ADDRESS_L);
}

// write local ip address
void write_local_ip(uint32_t ip_addr)
{
    dcmac_write_reg(LOCAL_IP_ADDRESS, ip_addr);
}

// read local ip address
uint32_t read_local_ip()
{
    return dcmac_read_reg(LOCAL_IP_ADDRESS);
}

// write local ip netmask
void write_local_netmask(uint32_t netmask)
{
    dcmac_write_reg(LOCAL_IP_NETMASK, netmask);
}

// read local ip netmask
uint32_t read_local_netmask()
{
    return dcmac_read_reg(LOCAL_IP_NETMASK);
}

// write gateway ip address
void write_gw_ip(uint32_t ip_addr)
{
    dcmac_write_reg(GW_IP_ADDRESS, ip_addr);
}

// read gateway ip address
uint32_t read_gw_ip()
{
    return dcmac_read_reg(GW_IP_ADDRESS);
}

// write multicast ip address
void write_mc_ip(uint32_t ip_addr)
{
    dcmac_write_reg(MC_IP_ADDRESS, ip_addr);
}

// read multicast ip address
uint32_t read_mc_ip()
{
    return dcmac_read_reg(MC_IP_ADDRESS);
}

// write multicast ip mask
void write_mc_mask(uint32_t mask)
{
    dcmac_write_reg(MC_IP_MASK, mask);
}

// read multicast ip mask
uint32_t read_mc_mask()
{
    return dcmac_read_reg(MC_IP_MASK);
}

// write udp port
void write_udp_port(uint32_t port)
{
    dcmac_write_reg(UDP_PORT, port);
}

// read udp port
uint32_t read_udp_port()
{
    return dcmac_read_reg(UDP_PORT);
}

// write dst ip
void write_dst_ip(uint32_t ip_addr)
{
    dcmac_write_reg(TX_DST_IP, ip_addr);
}

// read dst ip
uint32_t read_dst_ip()
{
    return dcmac_read_reg(TX_DST_IP);
}

// write dst udp port
void write_dst_udp_port(uint32_t port)
{
    dcmac_write_reg(TX_DST_UDP_PORT, port);
}

// read dst udp port
uint32_t read_dst_udp_port()
{
    return dcmac_read_reg(TX_DST_UDP_PORT);
}

// write src udp port
void write_src_udp_port(uint32_t port)
{
    dcmac_write_reg(TX_SRC_UDP_PORT, port);
}

// read src udp port
uint32_t read_src_udp_port()
{
    return dcmac_read_reg(TX_SRC_UDP_PORT);
}

// write pkt len
void write_pkt_len(uint32_t len)
{
    dcmac_write_reg(TX_PKT_LEN, len);
}

// read pkt len
uint32_t read_pkt_len()
{
    return dcmac_read_reg(TX_PKT_LEN);
}

// enable core control
void enable_core_ctrl()
{
    dcmac_write_reg(CORE_CTRL, 1);
}

// disable core control
void disable_core_ctrl()
{
    dcmac_write_reg(CORE_CTRL, 0);
}

// enable AXIS pkt gen
void enable_axis_pkt_gen()
{
    dcmac_write_reg(AXIS_PKT_GEN, 1);
}

// disable AXIS pkt gen
void disable_axis_pkt_gen()
{
    dcmac_write_reg(AXIS_PKT_GEN, 0);
}

// write AXIS pkt len
void write_axis_pkt_len(uint32_t len)
{
    dcmac_write_reg(AXIS_PKT_LEN, len);
}

// read AXIS pkt len
uint32_t read_axis_pkt_len()
{
    return dcmac_read_reg(AXIS_PKT_LEN);
}

// write AXIS pkt cyc
void write_axis_pkt_cyc(uint32_t cyc)
{
    dcmac_write_reg(AXIS_PKT_CYC, cyc);
}

// read AXIS pkt cyc
uint32_t read_axis_pkt_cyc()
{
    return dcmac_read_reg(AXIS_PKT_CYC);
}

// set rx tx vl length
void set_tx_rx_vl_length(uint32_t len)
{
    dcmac_write_reg(RX_VL_LEN, len);
    dcmac_write_reg(TX_VL_LEN, len);
}

// set vl marker
void set_vl_marker(uint32_t *marker)
{
    dcmac_write_reg(VL_MARKER_ID0_LSB, marker[0]);
    dcmac_write_reg(VL_MARKER_ID0_MSB, marker[1]);
    dcmac_write_reg(VL_MARKER_ID1_LSB, marker[2]);
    dcmac_write_reg(VL_MARKER_ID1_MSB, marker[3]);
    dcmac_write_reg(VL_MARKER_ID2_LSB, marker[4]);
    dcmac_write_reg(VL_MARKER_ID2_MSB, marker[5]);
    dcmac_write_reg(VL_MARKER_ID3_LSB, marker[6]);
    dcmac_write_reg(VL_MARKER_ID3_MSB, marker[7]);
    dcmac_write_reg(VL_MARKER_ID4_LSB, marker[8]);
    dcmac_write_reg(VL_MARKER_ID4_MSB, marker[9]);
    dcmac_write_reg(VL_MARKER_ID5_LSB, marker[10]);
    dcmac_write_reg(VL_MARKER_ID5_MSB, marker[11]);
    dcmac_write_reg(VL_MARKER_ID6_LSB, marker[12]);
    dcmac_write_reg(VL_MARKER_ID6_MSB, marker[13]);
    dcmac_write_reg(VL_MARKER_ID7_LSB, marker[14]);
    dcmac_write_reg(VL_MARKER_ID7_MSB, marker[15]);
    dcmac_write_reg(VL_MARKER_ID8_LSB, marker[16]);
    dcmac_write_reg(VL_MARKER_ID8_MSB, marker[17]);
    dcmac_write_reg(VL_MARKER_ID9_LSB, marker[18]);
    dcmac_write_reg(VL_MARKER_ID9_MSB, marker[19]);
    dcmac_write_reg(VL_MARKER_ID10_LSB, marker[20]);
    dcmac_write_reg(VL_MARKER_ID10_MSB, marker[21]);
    dcmac_write_reg(VL_MARKER_ID11_LSB, marker[22]);
    dcmac_write_reg(VL_MARKER_ID11_MSB, marker[23]);
    dcmac_write_reg(VL_MARKER_ID12_LSB, marker[24]);
    dcmac_write_reg(VL_MARKER_ID12_MSB, marker[25]);
    dcmac_write_reg(VL_MARKER_ID13_LSB, marker[26]);
    dcmac_write_reg(VL_MARKER_ID13_MSB, marker[27]);
    dcmac_write_reg(VL_MARKER_ID14_LSB, marker[28]);
    dcmac_write_reg(VL_MARKER_ID14_MSB, marker[29]);
    dcmac_write_reg(VL_MARKER_ID15_LSB, marker[30]);
    dcmac_write_reg(VL_MARKER_ID15_MSB, marker[31]);
    dcmac_write_reg(VL_MARKER_ID16_LSB, marker[32]);
    dcmac_write_reg(VL_MARKER_ID16_MSB, marker[33]);
    dcmac_write_reg(VL_MARKER_ID17_LSB, marker[34]);
    dcmac_write_reg(VL_MARKER_ID17_MSB, marker[35]);
    dcmac_write_reg(VL_MARKER_ID18_LSB, marker[36]);
    dcmac_write_reg(VL_MARKER_ID18_MSB, marker[37]);
    dcmac_write_reg(VL_MARKER_ID19_LSB, marker[38]);
    dcmac_write_reg(VL_MARKER_ID19_MSB, marker[39]);
}
