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
    dcmac_write_reg(ARP_WR_EN, 0);
}

// read arp table
uint32_t read_arp(uint32_t addr)
{
    dcmac_write_reg(ARP_RD_ADDR, addr);
    dcmac_write_reg(ARP_RD_EN, 1);
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
void enable_axis_pkt_gen(uint32_t data)
{
    dcmac_write_reg(AXIS_PKT_GEN, 1);
}

// disable AXIS pkt gen
void disable_axis_pkt_gen(uint32_t data)
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