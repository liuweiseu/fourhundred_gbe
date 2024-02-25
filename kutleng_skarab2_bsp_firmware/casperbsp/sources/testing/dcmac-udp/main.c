#include <stdio.h>
#include <xil_printf.h>
#include <xparameters.h>
#include "xil_exception.h"
#include "xstatus.h"
#include "xil_types.h"
#include "xgpio.h"
#include "sleep.h"

#include "fhg_regs.h"
#include "dcmac_config.h"

#define LOCAL_IP_ADDRESS    0xC0A80301
#define LOCAL_IP_NETMASK    0xFFFFFF00
#define GW_IP_ADDRESS       0xC0A80301
#define UDP_PORT            0x1234
#define DST_IP              0xC0A8030C
#define DST_UDP_PORT        0x5678
#define SRC_UDP_PORT        0x4321

#define PKT_LEN             8192
#define BUS_WIDTH           128

extern int flag_alignment;

void init_dcmac()
{
    uint8_t ch_en_str = 0;
    int gt_lanes = 8;
	int rst_cnt = 0;

	xil_printf("######################################### \n\r");
	xil_printf("# 1x400G  \n\r");
	xil_printf("######################################### \n\r");
    xil_printf("Reading REV ID... \n\r");
    read_rev_id();
    xil_printf("Done.\r\n");
    xil_printf("Init rate to 400G... \n\r");
    init_ch_en_client_rate_static ();
    xil_printf("Done.\r\n");

    xil_printf("Setting gt pcs loopback and reset static... \n\r");
    set_gt_pcs_loopback_and_reset_static(2);
    xil_printf("Done.\r\n");

    // Check/Wait for GT TX and RX resetdone
    xil_printf("Waiting for GT TX and RX resetdone... \n\r");
    wait_gt_txresetdone(gt_lanes);
    wait_gt_rxresetdone(gt_lanes);
    xil_printf("Done.\r\n");
    // -----------------------------------------
    // DCMAC Configuration & Reset Section
    // -----------------------------------------
    xil_printf("Resetting channels... \n\r");
    assert_dcmac_global_port_channel_resets_static (); // Global & Port, Channel flush
    xil_printf("Done.\r\n");

    xil_printf("Programming DCMAC... \n\r");
    program_dcmac ();
    xil_printf("Done.\r\n");

    xil_printf("Releasing DCMAC... \n\r");
    release_dcmac_global_port_channel_resets_static ();
    xil_printf("Done.\r\n");

    wait(2000);
    // -------------------------------------------------------
    // Perform a GT RX Datapathonly reset and DCMAC RX Reset
    // -------------------------------------------------------
    // let's ignore rx for now.
    /*
    xil_printf("Resetting GT RX datapath and DCMAC RX... \n\r");
	do
	{
        // GT RX Datapath only Reset
        gt_rx_datapathonly_reset();
	    wait_gt_rxresetdone(gt_lanes);

        wait(2000);
        // DCMAC RX Port reset
        dcmac_rx_port_reset();
        wait(2000);


	    wait_for_alignment();
	    rst_cnt = rst_cnt + 1;
	}
	while ((flag_alignment == 0) && (rst_cnt < 10));
	//change_loopback_mode(0);
    xil_printf("rst_cnt = %d\n\r", rst_cnt);
    xil_printf("Done.\r\n");

    usleep(20U);
	ch_en_str = get_chstr();
	//sleep(5);
	//test_fixe_sanity(ch_en_str);
	//wait(100);

    stats_test_check();

	xil_printf("\n\r*******Test Completed        \n\r");
    */
}


void main()
{
    int i;

    // read the core type to make sure the RW is working.
    xil_printf("core type: 0x%08x\r\n", dcmac_read_reg(CORE_TYPE));

    // init dcmac and gtm transceivers
    init_dcmac();

    // write arp table
    // write the arp table to FF:FF:FF:FF:FF:FF, 
    // so that all of the NIC should be able to receive the packet
    xil_printf("writing arp table...\r\n");
    for(i = 0; i < 512; i++)
    {
        write_arp(i, 0xFFFFFFFF);
    }
    xil_printf("arp table written.\r\n");
    // read the arp table back to make sure it's written correctly
    xil_printf("reading arp table...\r\n");
    uint32_t arp_data;
    for(i = 0; i < 512; i++)
    {
        arp_data = read_arp(i);
        if(arp_data != 0xFFFFFFFF)
        {
            xil_printf("arp table read error: index %d, data 0x%08x\r\n", i, arp_data);
        }
    }
    xil_printf("arp table read.\r\n");

    // configure the mac address
    uint32_t mac_addr[2] = {0x12345678, 0x9ABCDEF0};
    uint32_t mac_addr_read[2];
    xil_printf("writing mac address...\r\n");
    write_mac_addr(mac_addr);
    xil_printf("mac address written.\r\n");
    // read the mac address back to make sure it's written correctly
    xil_printf("reading mac address...\r\n");
    read_mac_addr(mac_addr_read);
    if(mac_addr_read[0] != mac_addr[0] || mac_addr_read[1] != mac_addr[1])
    {
        xil_printf("mac address read error: 0x%08x%08x, 0x%08x%08x\r\n", mac_addr[0], mac_addr[1], mac_addr_read[0], mac_addr_read[1]);
    }
    else
    {
        xil_printf("mac address is written correctly.\r\n");
    }

    // configure the local ip address
    uint32_t ip_addr = LOCAL_IP_ADDRESS; //
    uint32_t ip_addr_read;
    xil_printf("writing local ip address...\r\n");
    write_local_ip(ip_addr);
    xil_printf("local ip address written.\r\n");
    // read the local ip address back to make sure it's written correctly
    xil_printf("reading local ip address...\r\n");
    ip_addr_read = read_local_ip();
    if(ip_addr_read != ip_addr)
    {
        xil_printf("local ip address read error: 0x%08x, 0x%08x\r\n", ip_addr, ip_addr_read);
    }
    else
    {
        xil_printf("local ip address is written correctly.\r\n");
    }

    // configure the local ip netmask
    uint32_t netmask = LOCAL_IP_NETMASK;
    uint32_t netmask_read;
    xil_printf("writing local ip netmask...\r\n");
    write_local_netmask(netmask);
    xil_printf("local ip netmask written.\r\n");
    // read the local ip netmask back to make sure it's written correctly
    xil_printf("reading local ip netmask...\r\n");
    netmask_read = read_local_netmask();
    if(netmask_read != netmask)
    {
        xil_printf("local ip netmask read error: 0x%08x, 0x%08x\r\n", netmask, netmask_read);
    }
    else
    {
        xil_printf("local ip netmask is written correctly.\r\n");
    }

    // configure the gateway ip address
    uint32_t gw_ip_addr = GW_IP_ADDRESS;
    uint32_t gw_ip_addr_read;
    xil_printf("writing gateway ip address...\r\n");
    write_gw_ip(gw_ip_addr);
    xil_printf("gateway ip address written.\r\n");
    // read the gateway ip address back to make sure it's written correctly
    xil_printf("reading gateway ip address...\r\n");
    gw_ip_addr_read = read_gw_ip();
    if(gw_ip_addr_read != gw_ip_addr)
    {
        xil_printf("gateway ip address read error: 0x%08x, 0x%08x\r\n", gw_ip_addr, gw_ip_addr_read);
    }
    else
    {
        xil_printf("gateway ip address is written correctly.\r\n");
    }

    // configure the udp port
    uint32_t udp_port = UDP_PORT;
    uint32_t udp_port_read;
    xil_printf("writing udp port...\r\n");
    write_udp_port(udp_port);
    xil_printf("udp port written.\r\n");
    // read the udp port back to make sure it's written correctly
    xil_printf("reading udp port...\r\n");
    udp_port_read = read_udp_port();
    if(udp_port_read != udp_port)
    {
        xil_printf("udp port read error: 0x%08x, 0x%08x\r\n", udp_port, udp_port_read);
    }
    else
    {
        xil_printf("udp port is written correctly.\r\n");
    }

    // configure the tx dst ip
    uint32_t tx_dst_ip = DST_IP;
    uint32_t tx_dst_ip_read;
    xil_printf("writing tx dst ip...\r\n");
    write_dst_ip(tx_dst_ip);
    xil_printf("tx dst ip written.\r\n");
    // read the tx dst ip back to make sure it's written correctly
    xil_printf("reading tx dst ip...\r\n");
    tx_dst_ip_read = read_dst_ip();
    if(tx_dst_ip_read != tx_dst_ip)
    {
        xil_printf("tx dst ip read error: 0x%08x, 0x%08x\r\n", tx_dst_ip, tx_dst_ip_read);
    }
    else
    {
        xil_printf("tx dst ip is written correctly.\r\n");
    }

    // configure the tx dst udp port
    uint32_t tx_dst_udp_port = DST_UDP_PORT;
    uint32_t tx_dst_udp_port_read;
    xil_printf("writing tx dst udp port...\r\n");
    write_dst_udp_port(tx_dst_udp_port);
    xil_printf("tx dst udp port written.\r\n");
    // read the tx dst udp port back to make sure it's written correctly
    xil_printf("reading tx dst udp port...\r\n");
    tx_dst_udp_port_read = read_dst_udp_port();
    if(tx_dst_udp_port_read != tx_dst_udp_port)
    {
        xil_printf("tx dst udp port read error: 0x%08x, 0x%08x\r\n", tx_dst_udp_port, tx_dst_udp_port_read);
    }
    else
    {
        xil_printf("tx dst udp port is written correctly.\r\n");
    }

    // configure the tx src udp port
    uint32_t tx_src_udp_port = SRC_UDP_PORT;
    uint32_t tx_src_udp_port_read;
    xil_printf("writing tx src udp port...\r\n");
    write_src_udp_port(tx_src_udp_port);
    xil_printf("tx src udp port written.\r\n");
    // read the tx src udp port back to make sure it's written correctly
    xil_printf("reading tx src udp port...\r\n");
    tx_src_udp_port_read = read_src_udp_port();
    if(tx_src_udp_port_read != tx_src_udp_port)
    {
        xil_printf("tx src udp port read error: 0x%08x, 0x%08x\r\n", tx_src_udp_port, tx_src_udp_port_read);
    }
    else
    {
        xil_printf("tx src udp port is written correctly.\r\n");
    }

    // configure the tx pkt len
    uint32_t tx_pkt_len = PKT_LEN;
    uint32_t tx_pkt_len_read;
    xil_printf("writing tx pkt len...\r\n");
    write_pkt_len(tx_pkt_len);
    xil_printf("tx pkt len written.\r\n");
    // read the tx pkt len back to make sure it's written correctly
    xil_printf("reading tx pkt len...\r\n");
    tx_pkt_len_read = read_pkt_len();
    if(tx_pkt_len_read != tx_pkt_len)
    {
        xil_printf("tx pkt len read error: 0x%08x, 0x%08x\r\n", tx_pkt_len, tx_pkt_len_read);
    }
    else
    {
        xil_printf("tx pkt len is written correctly.\r\n");
    }

    // wirte AXIS_PKT_LEN
    xil_printf("writing AXIS_PKT_LEN...\r\n");
    uint32_t axis_pkt_len = PKT_LEN / BUS_WIDTH;
    uint32_t axis_pkt_len_read;
    write_axis_pkt_len(axis_pkt_len);
    xil_printf("AXIS_PKT_LEN written.\r\n");
    // read the AXIS_PKT_LEN back to make sure it's written correctly
    xil_printf("reading AXIS_PKT_LEN...\r\n");
    axis_pkt_len_read = read_axis_pkt_len();
    if(axis_pkt_len_read != axis_pkt_len)
    {
        xil_printf("AXIS_PKT_LEN read error: 0x%08x, 0x%08x\r\n", axis_pkt_len, axis_pkt_len_read);
    }
    else
    {
        xil_printf("AXIS_PKT_LEN is written correctly.\r\n");
    }

    // wirte AXIS_PKT_CYC
    xil_printf("writing AXIS_PKT_CYC...\r\n");
    uint32_t axis_pkt_cyc = PKT_LEN / BUS_WIDTH * 2;
    uint32_t axis_pkt_cyc_read;
    write_axis_pkt_cyc(axis_pkt_cyc);
    xil_printf("AXIS_PKT_CYC written.\r\n");
    // read the AXIS_PKT_CYC back to make sure it's written correctly
    xil_printf("reading AXIS_PKT_CYC...\r\n");
    axis_pkt_cyc_read = read_axis_pkt_cyc();
    if(axis_pkt_cyc_read != axis_pkt_cyc)
    {
        xil_printf("AXIS_PKT_CYC read error: 0x%08x, 0x%08x\r\n", axis_pkt_cyc, axis_pkt_cyc_read);
    }
    else
    {
        xil_printf("AXIS_PKT_CYC is written correctly.\r\n");
    }

    // enable core control
    xil_printf("enabling core control...\r\n");
    enable_core_ctrl();
    xil_printf("core control enabled.\r\n");

    // enable AXIS pkt gen
    xil_printf("enabling AXIS pkt gen...\r\n");
    enable_axis_pkt_gen(1);
    xil_printf("AXIS pkt gen enabled.\r\n");

}
