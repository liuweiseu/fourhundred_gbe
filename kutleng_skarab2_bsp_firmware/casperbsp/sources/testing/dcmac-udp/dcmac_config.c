#include <stdio.h>
#include <xil_printf.h>
#include <xparameters.h>
#include "xil_exception.h"
#include "xstatus.h"
#include "xil_types.h"
#include "xgpio.h"
#include "sleep.h"

#include "dcmac_config.h"

//Channel enable;
uint8_t ch_en[6] = {0,0,0,0,0,0};
uint8_t client_rate[6] = {0,0,0,0,0,0};

int flag_alignment = 0;

// 01: wait for a delay
//
int wait (uint32_t delay)
{
	while (delay > 0){
		delay --;
	}
	return 1;
}

// 02: combine the ch_en bits together
//
uint8_t get_chstr(){
	uint8_t ch_en_str = 0;
	for(int i = 6; i > 0 ; i--) {
		if(ch_en[i-1] > 0)
                {
		ch_en_str = ch_en_str << 1;
		ch_en_str = ch_en_str | 1;
                }
                else
                {
                ch_en_str = ch_en_str << 1;
                }
	}
	return ch_en_str;
}

// 03: print port0 statistics
//
int print_port0_statistics() {
	int stat_match_flag_port_0;
	uint32_t tx_total_pkt_0_MSB, tx_total_pkt_0_LSB, tx_total_bytes_0_MSB, tx_total_bytes_0_LSB, tx_total_good_pkts_0_MSB, tx_total_good_pkts_0_LSB, tx_total_good_bytes_0_MSB, tx_total_good_bytes_0_LSB;
	uint32_t rx_total_pkt_0_MSB, rx_total_pkt_0_LSB, rx_total_bytes_0_MSB, rx_total_bytes_0_LSB, rx_total_good_pkts_0_MSB, rx_total_good_pkts_0_LSB, rx_total_good_bytes_0_MSB, rx_total_good_bytes_0_LSB;
	uint64_t tx_total_pkt_0, tx_total_bytes_0, tx_total_good_bytes_0, tx_total_good_pkts_0, rx_total_pkt_0, rx_total_bytes_0, rx_total_good_bytes_0, rx_total_good_pkts_0;
 	tx_total_pkt_0_MSB        = *(U32 *) (C0_STAT_TX_TOTAL_PACKETS_MSB_REG);
	tx_total_pkt_0_LSB        = *(U32 *) (C0_STAT_TX_TOTAL_PACKETS_LSB_REG);
	tx_total_good_pkts_0_MSB  = *(U32 *) (C0_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG);
	tx_total_good_pkts_0_LSB  = *(U32 *) (C0_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG);
	tx_total_bytes_0_MSB      = *(U32 *) (C0_STAT_TX_TOTAL_BYTES_MSB_REG);
	tx_total_bytes_0_LSB      = *(U32 *) (C0_STAT_TX_TOTAL_BYTES_LSB_REG);
	tx_total_good_bytes_0_LSB = *(U32 *) (C0_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG);
	tx_total_good_bytes_0_MSB = *(U32 *) (C0_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG);

	rx_total_pkt_0_MSB        = *(U32 *) (C0_STAT_RX_TOTAL_PACKETS_MSB_REG);
	rx_total_pkt_0_LSB        = *(U32 *) (C0_STAT_RX_TOTAL_PACKETS_LSB_REG);
	rx_total_good_pkts_0_MSB  = *(U32 *) (C0_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG);
	rx_total_good_pkts_0_LSB  = *(U32 *) (C0_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG);
	rx_total_bytes_0_MSB      = *(U32 *) (C0_STAT_RX_TOTAL_BYTES_MSB_REG);
	rx_total_bytes_0_LSB      = *(U32 *) (C0_STAT_RX_TOTAL_BYTES_LSB_REG);
	rx_total_good_bytes_0_LSB = *(U32 *) (C0_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG);
	rx_total_good_bytes_0_MSB = *(U32 *) (C0_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG);
	xil_printf( "\n\rPORT - 0 Statistics           \n\r\n\r" );
 	tx_total_pkt_0 = (uint64_t) tx_total_pkt_0_MSB << 32 | tx_total_pkt_0_LSB;
	tx_total_bytes_0 = (uint64_t) tx_total_bytes_0_MSB << 32 | tx_total_bytes_0_LSB;
	tx_total_good_pkts_0 = (uint64_t) tx_total_good_pkts_0_MSB << 32 | tx_total_good_pkts_0_LSB;
	rx_total_pkt_0 = (uint64_t) rx_total_pkt_0_MSB << 32 | rx_total_pkt_0_LSB;
	rx_total_bytes_0 = (uint64_t) rx_total_bytes_0_MSB << 32 | rx_total_bytes_0_LSB;
	rx_total_good_pkts_0 = (uint64_t) rx_total_good_pkts_0_MSB << 32 | rx_total_good_pkts_0_LSB;
	tx_total_good_bytes_0 =(uint64_t) tx_total_good_bytes_0_MSB << 32 | tx_total_good_bytes_0_LSB;
	rx_total_good_bytes_0 =(uint64_t) rx_total_good_bytes_0_MSB << 32 | rx_total_good_bytes_0_LSB;

	xil_printf("  STAT_TX_TOTAL_PACKETS           = %d,     \t STAT_RX_TOTAL_PACKETS           = %d\n\r\n\r", tx_total_pkt_0,rx_total_pkt_0);
	xil_printf("  STAT_TX_TOTAL_GOOD_PACKETS      = %d,     \t STAT_RX_TOTAL_GOOD_PACKETS      = %d\n\r\n\r", tx_total_good_pkts_0,rx_total_good_pkts_0);
	xil_printf("  STAT_TX_TOTAL_BYTES             = %d,     \t STAT_RX_BYTES                   = %d\n\r\n\r", tx_total_bytes_0,rx_total_bytes_0);
	xil_printf("  STAT_TX_TOTAL_GOOD_BYTES        = %d,     \t STAT_RX_TOTAL_GOOD_BYTES        = %d\n\r\n\r", tx_total_good_bytes_0,rx_total_good_bytes_0);

	if ( (tx_total_pkt_0 != 0) && (tx_total_pkt_0 == rx_total_pkt_0) && (tx_total_bytes_0 == rx_total_bytes_0) && (tx_total_good_pkts_0 == rx_total_good_pkts_0) && (tx_total_good_bytes_0 == rx_total_good_bytes_0) )
        {
            stat_match_flag_port_0 = 1;
        } else {
            stat_match_flag_port_0 = 0;
        }
        return stat_match_flag_port_0;
}

//  04: print port1 statistics
//
int print_port1_statistics() {
	int stat_match_flag_port_1;
	uint32_t tx_total_pkt_1_MSB, tx_total_pkt_1_LSB, tx_total_bytes_1_MSB, tx_total_bytes_1_LSB, tx_total_good_pkts_1_MSB, tx_total_good_pkts_1_LSB, tx_total_good_bytes_1_MSB, tx_total_good_bytes_1_LSB;
	uint32_t rx_total_pkt_1_MSB, rx_total_pkt_1_LSB, rx_total_bytes_1_MSB, rx_total_bytes_1_LSB, rx_total_good_pkts_1_MSB, rx_total_good_pkts_1_LSB, rx_total_good_bytes_1_MSB, rx_total_good_bytes_1_LSB;
	uint64_t tx_total_pkt_1, tx_total_bytes_1, tx_total_good_bytes_1, tx_total_good_pkts_1, rx_total_pkt_1, rx_total_bytes_1, rx_total_good_bytes_1, rx_total_good_pkts_1;
	tx_total_pkt_1_MSB        = *(U32 *) (C1_STAT_TX_TOTAL_PACKETS_MSB_REG);
	tx_total_pkt_1_LSB        = *(U32 *) (C1_STAT_TX_TOTAL_PACKETS_LSB_REG);
	tx_total_good_pkts_1_MSB  = *(U32 *) (C1_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG);
	tx_total_good_pkts_1_LSB  = *(U32 *) (C1_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG);
	tx_total_bytes_1_MSB      = *(U32 *) (C1_STAT_TX_TOTAL_BYTES_MSB_REG);
	tx_total_bytes_1_LSB      = *(U32 *) (C1_STAT_TX_TOTAL_BYTES_LSB_REG);
	tx_total_good_bytes_1_LSB = *(U32 *) (C1_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG);
	tx_total_good_bytes_1_MSB = *(U32 *) (C1_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG);

	rx_total_pkt_1_MSB        = *(U32 *) (C1_STAT_RX_TOTAL_PACKETS_MSB_REG);
	rx_total_pkt_1_LSB        = *(U32 *) (C1_STAT_RX_TOTAL_PACKETS_LSB_REG);
	rx_total_good_pkts_1_MSB  = *(U32 *) (C1_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG);
	rx_total_good_pkts_1_LSB  = *(U32 *) (C1_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG);
	rx_total_bytes_1_MSB      = *(U32 *) (C1_STAT_RX_TOTAL_BYTES_MSB_REG);
	rx_total_bytes_1_LSB      = *(U32 *) (C1_STAT_RX_TOTAL_BYTES_LSB_REG);
	rx_total_good_bytes_1_LSB = *(U32 *) (C1_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG);
	rx_total_good_bytes_1_MSB = *(U32 *) (C1_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG);
	xil_printf( "\n\rPORT - 1 Statistics           \n\r\n\r" );
	tx_total_pkt_1 = (uint64_t) tx_total_pkt_1_MSB << 32 | tx_total_pkt_1_LSB;
	tx_total_bytes_1 = (uint64_t) tx_total_bytes_1_MSB << 32 | tx_total_bytes_1_LSB;
	tx_total_good_pkts_1 = (uint64_t) tx_total_good_pkts_1_MSB << 32 | tx_total_good_pkts_1_LSB;
	rx_total_pkt_1 = (uint64_t) rx_total_pkt_1_MSB << 32 | rx_total_pkt_1_LSB;
	rx_total_bytes_1 = (uint64_t) rx_total_bytes_1_MSB << 32 | rx_total_bytes_1_LSB;
	rx_total_good_pkts_1 = (uint64_t) rx_total_good_pkts_1_MSB << 32 | rx_total_good_pkts_1_LSB;
	tx_total_good_bytes_1 =(uint64_t) tx_total_good_bytes_1_MSB << 32 | tx_total_good_bytes_1_LSB;
	rx_total_good_bytes_1 =(uint64_t) rx_total_good_bytes_1_MSB << 32 | rx_total_good_bytes_1_LSB;

	xil_printf("  STAT_TX_TOTAL_PACKETS           = %d,     \t STAT_RX_TOTAL_PACKETS           = %d\n\r\n\r", tx_total_pkt_1,rx_total_pkt_1);
	xil_printf("  STAT_TX_TOTAL_GOOD_PACKETS      = %d,     \t STAT_RX_TOTAL_GOOD_PACKETS      = %d\n\r\n\r", tx_total_good_pkts_1,rx_total_good_pkts_1);
	xil_printf("  STAT_TX_TOTAL_BYTES             = %d,     \t STAT_RX_BYTES                   = %d\n\r\n\r", tx_total_bytes_1,rx_total_bytes_1);
	xil_printf("  STAT_TX_TOTAL_GOOD_BYTES        = %d,     \t STAT_RX_TOTAL_GOOD_BYTES        = %d\n\r\n\r", tx_total_good_bytes_1,rx_total_good_bytes_1);
	if ( (tx_total_pkt_1 != 0) && (tx_total_pkt_1 == rx_total_pkt_1) && (tx_total_bytes_1 == rx_total_bytes_1) && (tx_total_good_pkts_1 == rx_total_good_pkts_1) && (tx_total_good_bytes_1 == rx_total_good_bytes_1) )
        {
            stat_match_flag_port_1 = 1;
        } else {
            stat_match_flag_port_1 = 0;
        }
        return stat_match_flag_port_1;
}

//  05: print port2 statistics
//
int print_port2_statistics() {
	int stat_match_flag_port_2;
	uint32_t tx_total_pkt_2_MSB, tx_total_pkt_2_LSB, tx_total_bytes_2_MSB, tx_total_bytes_2_LSB, tx_total_good_pkts_2_MSB, tx_total_good_pkts_2_LSB, tx_total_good_bytes_2_MSB, tx_total_good_bytes_2_LSB;
	uint32_t rx_total_pkt_2_MSB, rx_total_pkt_2_LSB, rx_total_bytes_2_MSB, rx_total_bytes_2_LSB, rx_total_good_pkts_2_MSB, rx_total_good_pkts_2_LSB, rx_total_good_bytes_2_MSB, rx_total_good_bytes_2_LSB;
	uint64_t tx_total_pkt_2, tx_total_bytes_2, tx_total_good_bytes_2, tx_total_good_pkts_2, rx_total_pkt_2, rx_total_bytes_2, rx_total_good_bytes_2, rx_total_good_pkts_2;
	tx_total_pkt_2_MSB        = *(U32 *) (C2_STAT_TX_TOTAL_PACKETS_MSB_REG);
	tx_total_pkt_2_LSB        = *(U32 *) (C2_STAT_TX_TOTAL_PACKETS_LSB_REG);
	tx_total_good_pkts_2_MSB  = *(U32 *) (C2_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG);
	tx_total_good_pkts_2_LSB  = *(U32 *) (C2_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG);
	tx_total_bytes_2_MSB      = *(U32 *) (C2_STAT_TX_TOTAL_BYTES_MSB_REG);
	tx_total_bytes_2_LSB      = *(U32 *) (C2_STAT_TX_TOTAL_BYTES_LSB_REG);
	tx_total_good_bytes_2_LSB = *(U32 *) (C2_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG);
	tx_total_good_bytes_2_MSB = *(U32 *) (C2_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG);

	rx_total_pkt_2_MSB        = *(U32 *) (C2_STAT_RX_TOTAL_PACKETS_MSB_REG);
	rx_total_pkt_2_LSB        = *(U32 *) (C2_STAT_RX_TOTAL_PACKETS_LSB_REG);
	rx_total_good_pkts_2_MSB  = *(U32 *) (C2_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG);
	rx_total_good_pkts_2_LSB  = *(U32 *) (C2_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG);
	rx_total_bytes_2_MSB      = *(U32 *) (C2_STAT_RX_TOTAL_BYTES_MSB_REG);
	rx_total_bytes_2_LSB      = *(U32 *) (C2_STAT_RX_TOTAL_BYTES_LSB_REG);
	rx_total_good_bytes_2_LSB = *(U32 *) (C2_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG);
	rx_total_good_bytes_2_MSB = *(U32 *) (C2_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG);
	xil_printf( "\n\rPORT - 2 Statistics           \n\r\n\r" );
	tx_total_pkt_2 = (uint64_t) tx_total_pkt_2_MSB << 32 | tx_total_pkt_2_LSB;
	tx_total_bytes_2 = (uint64_t) tx_total_bytes_2_MSB << 32 | tx_total_bytes_2_LSB;
	tx_total_good_pkts_2 = (uint64_t) tx_total_good_pkts_2_MSB << 32 | tx_total_good_pkts_2_LSB;
	rx_total_pkt_2 = (uint64_t) rx_total_pkt_2_MSB << 32 | rx_total_pkt_2_LSB;
	rx_total_bytes_2 = (uint64_t) rx_total_bytes_2_MSB << 32 | rx_total_bytes_2_LSB;
	rx_total_good_pkts_2 = (uint64_t) rx_total_good_pkts_2_MSB << 32 | rx_total_good_pkts_2_LSB;
	tx_total_good_bytes_2 =(uint64_t) tx_total_good_bytes_2_MSB << 32 | tx_total_good_bytes_2_LSB;
	rx_total_good_bytes_2 =(uint64_t) rx_total_good_bytes_2_MSB << 32 | rx_total_good_bytes_2_LSB;

	xil_printf("  STAT_TX_TOTAL_PACKETS           = %d,     \t STAT_RX_TOTAL_PACKETS           = %d\n\r\n\r", tx_total_pkt_2,rx_total_pkt_2);
	xil_printf("  STAT_TX_TOTAL_GOOD_PACKETS      = %d,     \t STAT_RX_TOTAL_GOOD_PACKETS      = %d\n\r\n\r", tx_total_good_pkts_2,rx_total_good_pkts_2);
	xil_printf("  STAT_TX_TOTAL_BYTES             = %d,     \t STAT_RX_BYTES                   = %d\n\r\n\r", tx_total_bytes_2,rx_total_bytes_2);
	xil_printf("  STAT_TX_TOTAL_GOOD_BYTES        = %d,     \t STAT_RX_TOTAL_GOOD_BYTES        = %d\n\r\n\r", tx_total_good_bytes_2,rx_total_good_bytes_2);
	if ( (tx_total_pkt_2 != 0) && (tx_total_pkt_2 == rx_total_pkt_2) && (tx_total_bytes_2 == rx_total_bytes_2) && (tx_total_good_pkts_2 == rx_total_good_pkts_2) && (tx_total_good_bytes_2 == rx_total_good_bytes_2) )
        {
            stat_match_flag_port_2 = 1;
        } else {
            stat_match_flag_port_2 = 0;
        }
        return stat_match_flag_port_2;
}

// 06: print port3 statistics
//
int print_port3_statistics() {
	int stat_match_flag_port_3;
	uint32_t tx_total_pkt_3_MSB, tx_total_pkt_3_LSB, tx_total_bytes_3_MSB, tx_total_bytes_3_LSB, tx_total_good_pkts_3_MSB, tx_total_good_pkts_3_LSB, tx_total_good_bytes_3_MSB, tx_total_good_bytes_3_LSB;
	uint32_t rx_total_pkt_3_MSB, rx_total_pkt_3_LSB, rx_total_bytes_3_MSB, rx_total_bytes_3_LSB, rx_total_good_pkts_3_MSB, rx_total_good_pkts_3_LSB, rx_total_good_bytes_3_MSB, rx_total_good_bytes_3_LSB;
	uint64_t tx_total_pkt_3, tx_total_bytes_3, tx_total_good_bytes_3, tx_total_good_pkts_3, rx_total_pkt_3, rx_total_bytes_3, rx_total_good_bytes_3, rx_total_good_pkts_3;
	tx_total_pkt_3_MSB        = *(U32 *) (C3_STAT_TX_TOTAL_PACKETS_MSB_REG);
	tx_total_pkt_3_LSB        = *(U32 *) (C3_STAT_TX_TOTAL_PACKETS_LSB_REG);
	tx_total_good_pkts_3_MSB  = *(U32 *) (C3_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG);
	tx_total_good_pkts_3_LSB  = *(U32 *) (C3_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG);
	tx_total_bytes_3_MSB      = *(U32 *) (C3_STAT_TX_TOTAL_BYTES_MSB_REG);
	tx_total_bytes_3_LSB      = *(U32 *) (C3_STAT_TX_TOTAL_BYTES_LSB_REG);
	tx_total_good_bytes_3_LSB = *(U32 *) (C3_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG);
	tx_total_good_bytes_3_MSB = *(U32 *) (C3_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG);

	rx_total_pkt_3_MSB        = *(U32 *) (C3_STAT_RX_TOTAL_PACKETS_MSB_REG);
	rx_total_pkt_3_LSB        = *(U32 *) (C3_STAT_RX_TOTAL_PACKETS_LSB_REG);
	rx_total_good_pkts_3_MSB  = *(U32 *) (C3_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG);
	rx_total_good_pkts_3_LSB  = *(U32 *) (C3_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG);
	rx_total_bytes_3_MSB      = *(U32 *) (C3_STAT_RX_TOTAL_BYTES_MSB_REG);
	rx_total_bytes_3_LSB      = *(U32 *) (C3_STAT_RX_TOTAL_BYTES_LSB_REG);
	rx_total_good_bytes_3_LSB = *(U32 *) (C3_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG);
	rx_total_good_bytes_3_MSB = *(U32 *) (C3_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG);
	xil_printf( "\n\rPORT - 3 Statistics           \n\r\n\r" );
	tx_total_pkt_3 = (uint64_t) tx_total_pkt_3_MSB << 32 | tx_total_pkt_3_LSB;
	tx_total_bytes_3 = (uint64_t) tx_total_bytes_3_MSB << 32 | tx_total_bytes_3_LSB;
	tx_total_good_pkts_3 = (uint64_t) tx_total_good_pkts_3_MSB << 32 | tx_total_good_pkts_3_LSB;
	rx_total_pkt_3 = (uint64_t) rx_total_pkt_3_MSB << 32 | rx_total_pkt_3_LSB;
	rx_total_bytes_3 = (uint64_t) rx_total_bytes_3_MSB << 32 | rx_total_bytes_3_LSB;
	rx_total_good_pkts_3 = (uint64_t) rx_total_good_pkts_3_MSB << 32 | rx_total_good_pkts_3_LSB;
	tx_total_good_bytes_3 =(uint64_t) tx_total_good_bytes_3_MSB << 32 | tx_total_good_bytes_3_LSB;
	rx_total_good_bytes_3 =(uint64_t) rx_total_good_bytes_3_MSB << 32 | rx_total_good_bytes_3_LSB;

	xil_printf("  STAT_TX_TOTAL_PACKETS           = %d,     \t STAT_RX_TOTAL_PACKETS           = %d\n\r\n\r", tx_total_pkt_3,rx_total_pkt_3);
	xil_printf("  STAT_TX_TOTAL_GOOD_PACKETS      = %d,     \t STAT_RX_TOTAL_GOOD_PACKETS      = %d\n\r\n\r", tx_total_good_pkts_3,rx_total_good_pkts_3);
	xil_printf("  STAT_TX_TOTAL_BYTES             = %d,     \t STAT_RX_BYTES                   = %d\n\r\n\r", tx_total_bytes_3,rx_total_bytes_3);
	xil_printf("  STAT_TX_TOTAL_GOOD_BYTES        = %d,     \t STAT_RX_TOTAL_GOOD_BYTES        = %d\n\r\n\r", tx_total_good_bytes_3,rx_total_good_bytes_3);
	if ( (tx_total_pkt_3 != 0) && (tx_total_pkt_3 == rx_total_pkt_3) && (tx_total_bytes_3 == rx_total_bytes_3) && (tx_total_good_pkts_3 == rx_total_good_pkts_3) && (tx_total_good_bytes_3 == rx_total_good_bytes_3) )
        {
            stat_match_flag_port_3 = 1;
        } else {
            stat_match_flag_port_3 = 0;
        }
        return stat_match_flag_port_3;
}

// 07: print port4 statistics
//
int print_port4_statistics() {
	int stat_match_flag_port_4;
	uint32_t tx_total_pkt_4_MSB, tx_total_pkt_4_LSB, tx_total_bytes_4_MSB, tx_total_bytes_4_LSB, tx_total_good_pkts_4_MSB, tx_total_good_pkts_4_LSB, tx_total_good_bytes_4_MSB, tx_total_good_bytes_4_LSB;
	uint32_t rx_total_pkt_4_MSB, rx_total_pkt_4_LSB, rx_total_bytes_4_MSB, rx_total_bytes_4_LSB, rx_total_good_pkts_4_MSB, rx_total_good_pkts_4_LSB, rx_total_good_bytes_4_MSB, rx_total_good_bytes_4_LSB;
	uint64_t tx_total_pkt_4, tx_total_bytes_4, tx_total_good_bytes_4, tx_total_good_pkts_4, rx_total_pkt_4, rx_total_bytes_4, rx_total_good_bytes_4, rx_total_good_pkts_4;
	tx_total_pkt_4_MSB        = *(U32 *) (C4_STAT_TX_TOTAL_PACKETS_MSB_REG);
	tx_total_pkt_4_LSB        = *(U32 *) (C4_STAT_TX_TOTAL_PACKETS_LSB_REG);
	tx_total_good_pkts_4_MSB  = *(U32 *) (C4_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG);
	tx_total_good_pkts_4_LSB  = *(U32 *) (C4_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG);
	tx_total_bytes_4_MSB      = *(U32 *) (C4_STAT_TX_TOTAL_BYTES_MSB_REG);
	tx_total_bytes_4_LSB      = *(U32 *) (C4_STAT_TX_TOTAL_BYTES_LSB_REG);
	tx_total_good_bytes_4_LSB = *(U32 *) (C4_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG);
	tx_total_good_bytes_4_MSB = *(U32 *) (C4_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG);

	rx_total_pkt_4_MSB        = *(U32 *) (C4_STAT_RX_TOTAL_PACKETS_MSB_REG);
	rx_total_pkt_4_LSB        = *(U32 *) (C4_STAT_RX_TOTAL_PACKETS_LSB_REG);
	rx_total_good_pkts_4_MSB  = *(U32 *) (C4_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG);
	rx_total_good_pkts_4_LSB  = *(U32 *) (C4_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG);
	rx_total_bytes_4_MSB      = *(U32 *) (C4_STAT_RX_TOTAL_BYTES_MSB_REG);
	rx_total_bytes_4_LSB      = *(U32 *) (C4_STAT_RX_TOTAL_BYTES_LSB_REG);
	rx_total_good_bytes_4_LSB = *(U32 *) (C4_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG);
	rx_total_good_bytes_4_MSB = *(U32 *) (C4_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG);
	xil_printf( "\n\rPORT - 4 Statistics           \n\r\n\r" );
	tx_total_pkt_4 = (uint64_t) tx_total_pkt_4_MSB << 32 | tx_total_pkt_4_LSB;
	tx_total_bytes_4 = (uint64_t) tx_total_bytes_4_MSB << 32 | tx_total_bytes_4_LSB;
	tx_total_good_pkts_4 = (uint64_t) tx_total_good_pkts_4_MSB << 32 | tx_total_good_pkts_4_LSB;
	rx_total_pkt_4 = (uint64_t) rx_total_pkt_4_MSB << 32 | rx_total_pkt_4_LSB;
	rx_total_bytes_4 = (uint64_t) rx_total_bytes_4_MSB << 32 | rx_total_bytes_4_LSB;
	rx_total_good_pkts_4 = (uint64_t) rx_total_good_pkts_4_MSB << 32 | rx_total_good_pkts_4_LSB;
	tx_total_good_bytes_4 =(uint64_t) tx_total_good_bytes_4_MSB << 32 | tx_total_good_bytes_4_LSB;
	rx_total_good_bytes_4 =(uint64_t) rx_total_good_bytes_4_MSB << 32 | rx_total_good_bytes_4_LSB;

	xil_printf("  STAT_TX_TOTAL_PACKETS           = %d,     \t STAT_RX_TOTAL_PACKETS           = %d\n\r\n\r", tx_total_pkt_4,rx_total_pkt_4);
	xil_printf("  STAT_TX_TOTAL_GOOD_PACKETS      = %d,     \t STAT_RX_TOTAL_GOOD_PACKETS      = %d\n\r\n\r", tx_total_good_pkts_4,rx_total_good_pkts_4);
	xil_printf("  STAT_TX_TOTAL_BYTES             = %d,     \t STAT_RX_BYTES                   = %d\n\r\n\r", tx_total_bytes_4,rx_total_bytes_4);
	xil_printf("  STAT_TX_TOTAL_GOOD_BYTES        = %d,     \t STAT_RX_TOTAL_GOOD_BYTES        = %d\n\r\n\r", tx_total_good_bytes_4,rx_total_good_bytes_4);
	if ( (tx_total_pkt_4 != 0) && (tx_total_pkt_4 == rx_total_pkt_4) && (tx_total_bytes_4 == rx_total_bytes_4) && (tx_total_good_pkts_4 == rx_total_good_pkts_4) && (tx_total_good_bytes_4 == rx_total_good_bytes_4) )
        {
            stat_match_flag_port_4 = 1;
        } else {
            stat_match_flag_port_4 = 0;
        }
        return stat_match_flag_port_4;
}

// 08: print port5 statistics
//
int print_port5_statistics() {
	int stat_match_flag_port_5;
	uint32_t tx_total_pkt_5_MSB, tx_total_pkt_5_LSB, tx_total_bytes_5_MSB, tx_total_bytes_5_LSB, tx_total_good_pkts_5_MSB, tx_total_good_pkts_5_LSB, tx_total_good_bytes_5_MSB, tx_total_good_bytes_5_LSB;
	uint32_t rx_total_pkt_5_MSB, rx_total_pkt_5_LSB, rx_total_bytes_5_MSB, rx_total_bytes_5_LSB, rx_total_good_pkts_5_MSB, rx_total_good_pkts_5_LSB, rx_total_good_bytes_5_MSB, rx_total_good_bytes_5_LSB;
	uint64_t tx_total_pkt_5, tx_total_bytes_5, tx_total_good_bytes_5, tx_total_good_pkts_5, rx_total_pkt_5, rx_total_bytes_5, rx_total_good_bytes_5, rx_total_good_pkts_5;
	tx_total_pkt_5_MSB        = *(U32 *) (C5_STAT_TX_TOTAL_PACKETS_MSB_REG);
	tx_total_pkt_5_LSB        = *(U32 *) (C5_STAT_TX_TOTAL_PACKETS_LSB_REG);
	tx_total_good_pkts_5_MSB  = *(U32 *) (C5_STAT_TX_TOTAL_GOOD_PACKETS_MSB_REG);
	tx_total_good_pkts_5_LSB  = *(U32 *) (C5_STAT_TX_TOTAL_GOOD_PACKETS_LSB_REG);
	tx_total_bytes_5_MSB      = *(U32 *) (C5_STAT_TX_TOTAL_BYTES_MSB_REG);
	tx_total_bytes_5_LSB      = *(U32 *) (C5_STAT_TX_TOTAL_BYTES_LSB_REG);
	tx_total_good_bytes_5_LSB = *(U32 *) (C5_STAT_TX_TOTAL_GOOD_BYTES_LSB_REG);
	tx_total_good_bytes_5_MSB = *(U32 *) (C5_STAT_TX_TOTAL_GOOD_BYTES_MSB_REG);

	rx_total_pkt_5_MSB        = *(U32 *) (C5_STAT_RX_TOTAL_PACKETS_MSB_REG);
	rx_total_pkt_5_LSB        = *(U32 *) (C5_STAT_RX_TOTAL_PACKETS_LSB_REG);
	rx_total_good_pkts_5_MSB  = *(U32 *) (C5_STAT_RX_TOTAL_GOOD_PACKETS_MSB_REG);
	rx_total_good_pkts_5_LSB  = *(U32 *) (C5_STAT_RX_TOTAL_GOOD_PACKETS_LSB_REG);
	rx_total_bytes_5_MSB      = *(U32 *) (C5_STAT_RX_TOTAL_BYTES_MSB_REG);
	rx_total_bytes_5_LSB      = *(U32 *) (C5_STAT_RX_TOTAL_BYTES_LSB_REG);
	rx_total_good_bytes_5_LSB = *(U32 *) (C5_STAT_RX_TOTAL_GOOD_BYTES_LSB_REG);
	rx_total_good_bytes_5_MSB = *(U32 *) (C5_STAT_RX_TOTAL_GOOD_BYTES_MSB_REG);
	xil_printf( "\n\rPORT - 5 Statistics           \n\r\n\r" );
   	tx_total_pkt_5 = (uint64_t) tx_total_pkt_5_MSB << 32 | tx_total_pkt_5_LSB;
	tx_total_bytes_5 = (uint64_t) tx_total_bytes_5_MSB << 32 | tx_total_bytes_5_LSB;
	tx_total_good_pkts_5 = (uint64_t) tx_total_good_pkts_5_MSB << 32 | tx_total_good_pkts_5_LSB;
	rx_total_pkt_5 = (uint64_t) rx_total_pkt_5_MSB << 32 | rx_total_pkt_5_LSB;
	rx_total_bytes_5 = (uint64_t) rx_total_bytes_5_MSB << 32 | rx_total_bytes_5_LSB;
	rx_total_good_pkts_5 = (uint64_t) rx_total_good_pkts_5_MSB << 32 | rx_total_good_pkts_5_LSB;
	tx_total_good_bytes_5 =(uint64_t) tx_total_good_bytes_5_MSB << 32 | tx_total_good_bytes_5_LSB;
	rx_total_good_bytes_5 =(uint64_t) rx_total_good_bytes_5_MSB << 32 | rx_total_good_bytes_5_LSB;

	xil_printf("  STAT_TX_TOTAL_PACKETS           = %d,     \t STAT_RX_TOTAL_PACKETS           = %d\n\r\n\r", tx_total_pkt_5,rx_total_pkt_5);
	xil_printf("  STAT_TX_TOTAL_GOOD_PACKETS      = %d,     \t STAT_RX_TOTAL_GOOD_PACKETS      = %d\n\r\n\r", tx_total_good_pkts_5,rx_total_good_pkts_5);
	xil_printf("  STAT_TX_TOTAL_BYTES             = %d,     \t STAT_RX_BYTES                   = %d\n\r\n\r", tx_total_bytes_5,rx_total_bytes_5);
	xil_printf("  STAT_TX_TOTAL_GOOD_BYTES        = %d,     \t STAT_RX_TOTAL_GOOD_BYTES        = %d\n\r\n\r", tx_total_good_bytes_5,rx_total_good_bytes_5);
	if ( (tx_total_pkt_5 != 0) && (tx_total_pkt_5 == rx_total_pkt_5) && (tx_total_bytes_5 == rx_total_bytes_5) && (tx_total_good_pkts_5 == rx_total_good_pkts_5) && (tx_total_good_bytes_5 == rx_total_good_bytes_5) )
        {
            stat_match_flag_port_5 = 1;
        } else {
            stat_match_flag_port_5 = 0;
        }
        return stat_match_flag_port_5;
}

// 09: latch_all
// 
int latch_all()
{
	*(U32* )(ALL_CHANNEL_MAC_TICK_REG_RX_REG) = 0x00000001;
	*(U32* )(ALL_CHANNEL_MAC_TICK_REG_TX_REG) = 0x00000001;
	*(U32* )(C0_PORT_TICK_REG_RX_REG) = 0x00000001;
	*(U32* )(C1_PORT_TICK_REG_RX_REG) = 0x00000001;
	*(U32* )(C2_PORT_TICK_REG_RX_REG) = 0x00000001;
	*(U32* )(C3_PORT_TICK_REG_RX_REG) = 0x00000001;
	*(U32* )(C4_PORT_TICK_REG_RX_REG) = 0x00000001;
	*(U32* )(C5_PORT_TICK_REG_RX_REG) = 0x00000001;
	*(U32* )(C0_PORT_TICK_REG_TX_REG) = 0x00000001;
	*(U32* )(C1_PORT_TICK_REG_TX_REG) = 0x00000001;
	*(U32* )(C2_PORT_TICK_REG_TX_REG) = 0x00000001;
	*(U32* )(C3_PORT_TICK_REG_TX_REG) = 0x00000001;
	*(U32* )(C4_PORT_TICK_REG_TX_REG) = 0x00000001;
	*(U32* )(C5_PORT_TICK_REG_TX_REG) = 0x00000001;
	//wait(50);
	*(U32* )(ADDR_APB3_2_BASE + 0x0000020C) = 0xFFFFFFFF;
	*(U32* )(ADDR_APB3_2_BASE + 0x00000210) = 0xFFFFFFFF;
	*(U32* )(ADDR_APB3_2_BASE + 0x00000214) = 0xFFFFFFFF;
	*(U32* )(ADDR_APB3_2_BASE + 0x00000218) = 0xFFFFFFFF;
	wait(5);
	return 1;
}

// 10: assert_all_reset
// 
int assert_all_reset()
{
	*(U32* )(GLOBAL_CONTROL_REG_RX_REG)  = 0x7;
	*(U32* )(GLOBAL_CONTROL_REG_TX_REG)  = 0x7;
	*(U32* )(C0_PORT_CONTROL_REG_RX_REG) = 0x3;
	*(U32* )(C1_PORT_CONTROL_REG_RX_REG) = 0x3;
	*(U32* )(C2_PORT_CONTROL_REG_RX_REG) = 0x3;
	*(U32* )(C3_PORT_CONTROL_REG_RX_REG) = 0x3;
	*(U32* )(C4_PORT_CONTROL_REG_RX_REG) = 0x3;
	*(U32* )(C5_PORT_CONTROL_REG_RX_REG) = 0x3;
	*(U32* )(C0_PORT_CONTROL_REG_TX_REG) = 0x3;
	*(U32* )(C1_PORT_CONTROL_REG_TX_REG) = 0x3;
	*(U32* )(C2_PORT_CONTROL_REG_TX_REG) = 0x3;
	*(U32* )(C3_PORT_CONTROL_REG_TX_REG) = 0x3;
	*(U32* )(C4_PORT_CONTROL_REG_TX_REG) = 0x3;
	*(U32* )(C5_PORT_CONTROL_REG_TX_REG) = 0x3;

	return 1;
}

// 11: assert_tx_reset
//
int assert_txreset()
{
	*(U32* )(C0_PORT_CONTROL_REG_TX_REG) = 0x2;
	*(U32* )(C1_PORT_CONTROL_REG_TX_REG) = 0x2;
	*(U32* )(C2_PORT_CONTROL_REG_TX_REG) = 0x2;
	*(U32* )(C3_PORT_CONTROL_REG_TX_REG) = 0x2;
	*(U32* )(C4_PORT_CONTROL_REG_TX_REG) = 0x2;
	*(U32* )(C5_PORT_CONTROL_REG_TX_REG) = 0x2;
	*(U32* )(C0_CHANNEL_CONTROL_REG_TX_REG) = 0x1;
	*(U32* )(C1_CHANNEL_CONTROL_REG_TX_REG) = 0x1;
	*(U32* )(C2_CHANNEL_CONTROL_REG_TX_REG) = 0x1;
	*(U32* )(C3_CHANNEL_CONTROL_REG_TX_REG) = 0x1;
	*(U32* )(C4_CHANNEL_CONTROL_REG_TX_REG) = 0x1;
	*(U32* )(C5_CHANNEL_CONTROL_REG_TX_REG) = 0x1;

	*(U32* )(GLOBAL_CONTROL_REG_TX_REG)  = 0x1;

	return 1;
}

// 12: deassert_txreset
//
int deassert_txreset()
{
	*(U32* )(C0_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C1_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C2_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C3_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C4_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C5_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(GLOBAL_CONTROL_REG_TX_REG)  = 0x0;

        wait(1000);
	*(U32* )(C0_CHANNEL_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C1_CHANNEL_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C2_CHANNEL_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C3_CHANNEL_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C4_CHANNEL_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C5_CHANNEL_CONTROL_REG_TX_REG) = 0x0;

	return 1;
}

// 13: assert_rxreset
//
int assert_rxreset()
{
	*(U32* )(C0_PORT_CONTROL_REG_RX_REG) = 0x2;
	*(U32* )(C1_PORT_CONTROL_REG_RX_REG) = 0x2;
	*(U32* )(C2_PORT_CONTROL_REG_RX_REG) = 0x2;
	*(U32* )(C3_PORT_CONTROL_REG_RX_REG) = 0x2;
	*(U32* )(C4_PORT_CONTROL_REG_RX_REG) = 0x2;
	*(U32* )(C5_PORT_CONTROL_REG_RX_REG) = 0x2;
	*(U32* )(C0_CHANNEL_CONTROL_REG_RX_REG) = 0x1;
	*(U32* )(C1_CHANNEL_CONTROL_REG_RX_REG) = 0x1;
	*(U32* )(C2_CHANNEL_CONTROL_REG_RX_REG) = 0x1;
	*(U32* )(C3_CHANNEL_CONTROL_REG_RX_REG) = 0x1;
	*(U32* )(C4_CHANNEL_CONTROL_REG_RX_REG) = 0x1;
	*(U32* )(C5_CHANNEL_CONTROL_REG_RX_REG) = 0x1;

	*(U32* )(GLOBAL_CONTROL_REG_RX_REG)  = 0x1;

	return 1;
}

// 14: deassert_rxreset
//
int deassert_rxreset()
{
	*(U32* )(GLOBAL_CONTROL_REG_RX_REG)  = 0x0;
	*(U32* )(C0_CHANNEL_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C1_CHANNEL_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C2_CHANNEL_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C3_CHANNEL_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C4_CHANNEL_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C5_CHANNEL_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C0_PORT_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C1_PORT_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C2_PORT_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C3_PORT_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C4_PORT_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C5_PORT_CONTROL_REG_RX_REG) = 0x0;

	return 1;
}

// 15: release_all_reset
//
int release_all_reset()
{
	*(U32* )(GLOBAL_CONTROL_REG_TX_REG)  = 0x0;
	*(U32* )(GLOBAL_CONTROL_REG_RX_REG)  = 0x0;
	*(U32* )(C0_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C1_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C2_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C3_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C4_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C5_PORT_CONTROL_REG_TX_REG) = 0x0;
	*(U32* )(C0_PORT_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C1_PORT_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C2_PORT_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C3_PORT_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C4_PORT_CONTROL_REG_RX_REG) = 0x0;
	*(U32* )(C5_PORT_CONTROL_REG_RX_REG) = 0x0;

	return 1;
}

// 16: assert_channel_resets
//
int assert_channel_resets(uint8_t client, uint8_t client_rate){
	uint8_t num_ports;
	switch(client_rate){
		case R_100G: num_ports = 1;
		break;
		case R_200G: num_ports = 2;
		break;
		case R_400G: num_ports = 4;
		break;
		default: num_ports = 1;
		break;
	}
	for(int i = client; i<client + num_ports ; i++) {
		*(U32* )(C0_CHANNEL_CONTROL_REG_RX_REG + (i << 12)) = 0x00000001;
		*(U32* )(C0_CHANNEL_CONTROL_REG_TX_REG + (i << 12)) = 0x00000001;
		wait(50);
		*(U32* )(C0_PORT_CONTROL_REG_RX_REG + (i << 12)) = 0x00000003;
		*(U32* )(C0_PORT_CONTROL_REG_TX_REG + (i << 12)) = 0x00000003;
	}
	wait(50);
	return 1;
}

// 17: release_channel_resets
//
int release_channel_resets(uint8_t client, uint8_t client_rate){
	uint8_t num_ports;
	switch(client_rate){
		case R_100G: num_ports = 1;
		break;
		case R_200G: num_ports = 2;
		break;
		case R_400G: num_ports = 4;
		break;
		default: num_ports = 1;
		break;
	}
	for(int i = client; i<client + num_ports ; i++) {
		*(U32* )(C0_PORT_CONTROL_REG_RX_REG + (i << 12)) = 0x00000000;
		*(U32* )(C0_PORT_CONTROL_REG_TX_REG + (i << 12)) = 0x00000000;
		wait(50);
		*(U32* )(C0_CHANNEL_CONTROL_REG_TX_REG + (i << 12)) = 0x00000000;
		*(U32* )(C0_CHANNEL_CONTROL_REG_RX_REG + (i << 12)) = 0x00000000;
	}
	wait(50);
	return 1;
}

// 18: config_mac
//
int config_mac()
{
	uint32_t pdata;

	xil_printf("Started MAC configuration \n\r");
	for ( int i = 0x01; i <= 0x06 ; i++ ) {
           *(U32* )(ADDR_AXI4_BASE + 0x00000004 + (i << 12) ) = 0x25800042;
           pdata = *(U32* )(ADDR_AXI4_BASE + 0x00000004 + (i << 12) );
           xil_printf("config_mac :: Wrote %x to address %x\n\r", pdata, (ADDR_AXI4_BASE + 0x00000004 + (i << 12) ));
           wait(10);
	}
	for ( int i = 0x01; i <= 0x06 ; i++ ) {
           *(U32* )(ADDR_AXI4_BASE + 0x00000000 + (i << 12) ) = 0x00000C21;
           pdata = *(U32* )(ADDR_AXI4_BASE + 0x00000000 + (i << 12) );
           xil_printf("config_mac :: Wrote %x to address %x\n\r", pdata, (ADDR_AXI4_BASE + 0x00000000 + (i << 12) ));
           wait(10);
	}
	//for ( int i = 0x01; i <= 0x28 ; i++ ) {
        //   *(U32* )(ADDR_AXI4_BASE + 0x000000AC + (i << 12) ) = 0x00000020;
        //   xil_printf("for addr 0x00ac onwards %d\n\r", i);
        //   wait(2);
	//}

	xil_printf("Finished MAC configuration \n\r");
	return 1;
}

// 19: check_sanity
//
int check_sanity () {
	uint32_t emu_frames_rx[6],emu_frames_tx[6],emu_bytes_tx[6],emu_bytes_rx[6];
	uint32_t emu_prbs_locked[6],emu_prbs_error[6],emu_preamble_error[6];
	uint32_t core_bytes_tx[6],core_bytes_rx[6],core_frames_tx[6],core_frames_rx[6];
	uint8_t fail = 0;
	xil_printf("check_sanity::Reading gen/mon stats counters \n\r");

	for(int i=0; i<6 ;i++)
	{
		if(ch_en[i] > 0) {
			//core bytes and frames data
			core_bytes_tx[i] = *(U32* )(C0_STAT_TX_TOTAL_BYTES_LSB_REG + (i << 12));
			core_bytes_rx[i] = *(U32* )(C0_STAT_RX_TOTAL_BYTES_LSB_REG + (i << 12));
			core_frames_tx[i] = *(U32* )(C0_STAT_TX_TOTAL_PACKETS_LSB_REG + (i << 12));
			core_frames_rx[i] = *(U32* )(C0_STAT_RX_TOTAL_PACKETS_LSB_REG + (i << 12));

			emu_frames_tx[i] = *(U32* )(ADDR_APB3_2_BASE + ((0x0100 + 0x10*i) << 2));
			emu_bytes_tx[i] = *(U32* )(ADDR_APB3_2_BASE + ((0x0100 + 0x10*i + 0x02) << 2));
			emu_frames_rx[i] = *(U32* )(ADDR_APB3_2_BASE + ((0x0100 + 0x10*i + 0x04) << 2));
			emu_bytes_rx[i] = *(U32* )(ADDR_APB3_2_BASE + ((0x0100 + 0x10*i + 0x06) << 2));
			emu_prbs_locked[i] = *(U32* )(ADDR_APB3_2_BASE + ((0x0100 + 0x10*i + 0x08) << 2));
			emu_prbs_error[i] = *(U32* )(ADDR_APB3_2_BASE + ((0x0100 + 0x10*i + 0x09) << 2));
			emu_preamble_error[i] = *(U32* )(ADDR_APB3_2_BASE + ((0x0100 + 0x10*i + 0x0A) << 2));
		}
	}

	for(int i = 0; i < 6 ; i++)
	{
		if(ch_en[i]) {
			//display core statistics
			xil_printf("check_sanity::Channel[%d] sent %d core packets \n\r", i, core_frames_tx[i]);
			xil_printf("check_sanity::Channel[%d] received %d core packets \n\r", i, core_frames_rx[i]);
			xil_printf("check_sanity::Channel[%d] sent %d total bytes \n\r", i, core_bytes_tx[i]);
			xil_printf("check_sanity::Channel[%d] received %d total bytes \n\r", i, core_bytes_rx[i]);

			xil_printf("check_sanity::Channel[%d] sent %d user packets \n\r", i, emu_frames_tx[i]);
			xil_printf("check_sanity::Channel[%d] received %d user packets \n\r", i, emu_frames_rx[i]);
			xil_printf("check_sanity::Channel[%d] sent %d total bytes \n\r", i, emu_bytes_tx[i]);
			xil_printf("check_sanity::Channel[%d] received %d total bytes  \n\r", i, emu_bytes_rx[i]);

			if((emu_frames_tx[i] != emu_frames_rx[i]) || (emu_frames_tx[i] == 0 ) || (emu_frames_rx[i] == 0 )){
				fail = 1;
				xil_printf("check_sanity::ERROR: emu_frames_tx[%d] = %d, emu_frames_rx[%d] = %d \n\r", i, emu_frames_tx[i], i, emu_frames_rx[i]);
			}

			if(emu_bytes_rx[i] != emu_bytes_tx[i]) {
				fail = 1;
				xil_printf("check_sanity::ERROR: emu_bytes_tx[%d] = %d, emu_bytes_rx[%d] = %d \n\r", i, emu_bytes_tx[i], i, emu_bytes_rx[i]);
			}

			if((emu_prbs_locked[i] & 0x00000001) != 1){
				fail = 1;
				xil_printf("check_sanity::ERROR: ch[%d] is not locked \n\r", i);
			}

			if(emu_prbs_error[i] != 0) {
				fail = 1;
				xil_printf("check_sanity::ERROR: emu_prbs_error[%2d] is %d \n\r", i, emu_prbs_error[i]);
			}
		}
	}
	if(fail == 1) return 0;
	else return 1;

}

// 20: cal_rst_val
//
int cal_rst_val(int k)
{
	int val=0;
	for(int i=0;i<k;i++)
	{
		val |= (1<<i);
	}
	//printf("%x",val);
	return val;
}

// 21: cal_stat_match
//
int cal_stat_match()
{
    int stat_val=0;
     for(int i=0;i<6;i++)
     {
         stat_val|=ch_en[i]<<i;
     }
    return stat_val;
}

// 22: set_data_rate
//
int set_data_rate(uint8_t* rate)
{
	uint32_t wdata_tx = 0;
	uint32_t wdata_rx = 0;
	uint32_t pr_txdata = 0;
	uint32_t pr_rxdata = 0;
	for(int i = 0; i < 6 ; i++)
	{
			wdata_tx = 0;
			wdata_rx = 0;
			wdata_tx = wdata_tx | (rate[i] & 0x03) ;
			wdata_rx = wdata_rx | (rate[i] & 0x03) ;
			wdata_tx = wdata_tx | ( 1 << 4 );
			wdata_rx = wdata_rx | ( 1 << 11 );

			wdata_tx = wdata_tx | ( 1 << 10 );
			wdata_rx = wdata_rx | ( 1 << 13 );
			switch(rate[i]){
				case R_100G:
				wdata_tx = (wdata_tx & 0xFFE0FFFF) | (0x04 << 16 );
				wdata_rx = (wdata_rx & 0xFFE0FFFF) | (0x04 << 16 );
				break;
				case R_200G: wdata_tx = (wdata_tx & 0xFFE0FFFF) | (0x08 << 16 );
				             wdata_rx = (wdata_rx & 0xFFE0FFFF) | (0x08 << 16 );
				break;
				case R_400G: wdata_tx = (wdata_tx & 0xFFE0FFFF) | (0x10 << 16 );
				             wdata_rx = (wdata_rx & 0xFFE0FFFF) | (0x10 << 16 );
				break;
				default: wdata_tx = (wdata_tx & 0xFFE0FFFF) | (0x04 << 16 );
				         wdata_rx = (wdata_rx & 0xFFE0FFFF) | (0x04 << 16 );
				break;
			}
			*(U32 *)(C0_TX_MODE_REG_REG + (i << 12)) = wdata_tx;
			pr_txdata = *(U32* )(C0_TX_MODE_REG_REG + (i << 12));
			xil_printf("set_data_rate :: C%d_TX_MODE_REG_REG 0x%d040 %x \n\r", i, (i+1), pr_txdata);
			*(U32 *)(C0_RX_MODE_REG_REG + (i << 12)) = wdata_rx;
			pr_rxdata = *(U32* )(C0_RX_MODE_REG_REG + (i << 12));
			xil_printf("set_data_rate :: C%d_RX_MODE_REG_REG 0x%d044 %x \n\r", i, (i+1), pr_rxdata);
			//xil_printf("Data Rate of channel %d set to %d \n\r" ,i,rate[i]);
	}
	//xil_printf("Finished setting data rates  \n\r");
	return 1;
}

// 23: wait_for_alignment
//
int wait_for_alignment()
{
	uint32_t pr_data = 0;
	uint8_t aligned = 0;
	uint32_t time_out = 0;

	xil_printf("Waiting for active channels Alignment... \n\r");


	for (int i=0; i< 1; i++) aligned = (ch_en[i] == 0)?(aligned | (1 << i)):aligned;


	do
	{

		for(int i =0 ; i < 1; i++)

		{
			if(ch_en[i] > 0 ){
				if((aligned & (1 << i)) == 0)
				{
					usleep(200000);
					*(U32* )(C0_STAT_PORT_RX_PHY_STATUS_REG_REG + (i << 12)) = 0xFFFFFFFF;
					usleep(200000);
					pr_data = *(U32* )(C0_STAT_PORT_RX_PHY_STATUS_REG_REG + (i << 12));
					xil_printf("wait_for_alignment :: C%d_STAT_PORT_RX_PHY_STATUS 0x%dc00 %x \n\r", i, (i+1), pr_data);
					if ((pr_data & 0x00000005) == 0x00000005) {
						aligned = aligned | (1<<i);
						xil_printf("Alignment achieved :: Client[%d] RX achieved alignment {stat_rx_aligned, stat_rx_status} == 2'b11 \n\r", i);
					} else {
						wait(2);
						time_out = time_out + 2;
					}
				}
			}
		}
		time_out = time_out + 1;
	}

	while ((aligned != 0x01) && (time_out < 10000));

	if( time_out >= 10000 ){
		xil_printf (" Alignment not achieved :: Failed to achieve all channel alignment, Alignment attempts timed out \n\r");
		flag_alignment = 0;
		return 0;
	} else {
		//xil_printf ("Alignment achieved :: Alignment done \n\r");
		flag_alignment = 1;
		return 1;
	}
}

// 24: test_chan_40
//
int test_chan_40()
{
	uint32_t WriteData = 0;
	uint32_t pr_data = 0;
	uint32_t time_out = 0;
	uint8_t ch_ready_tx = 0;
	uint8_t ch_ready_rx = 0;
	uint32_t cfg_data [] = {0x11000000,0x11000101,0x11000202,0x11000303,0x11001004,0x11010004,0x11010105,0x11010206,0x11010307,0x11011004,
                                0x11020008,0x11020109,0x1102020a,0x1102030b,0x11021004,0x1103000c,0x1103010d,0x1103020e,0x1103030f,0x11031004,
                                0x11040010,0x11040111,0x11040212,0x11040313,0x11041004,0x11050014,0x11050115,0x11050216,0x11050317,0x11051004,
                                0x11060018,0x11060119,0x1106021a,0x1106031b,0x11061004,0x1107001c,0x1107011d,0x1107021e,0x1107031f,0x11071004,
                                0x11080020,0x11080121,0x11080222,0x11080323,0x11081004,0x11090024,0x11090125,0x11090226,0x11090327,0x11091004,
                                0x110a0028,0x110a0129,0x110a022a,0x110a032b,0x110a1004,0x110b002c,0x110b012d,0x110b022e,0x110b032f,0x110b1004,
                                0x110c0030,0x110c0131,0x110c0232,0x110c0333,0x110c1004,0x110d0034,0x110d0135,0x110d0236,0x110d0337,0x110d1004,
                                0x110e0038,0x110e0139,0x110e023a,0x110e033b,0x110e1004,0x110f003c,0x110f013d,0x110f023e,0x110f033f,0x110f1004,
                                0x11100040,0x11100141,0x11100242,0x11100343,0x11101004,0x11110044,0x11110145,0x11110246,0x11110347,0x11111004,
                                0x11120048,0x11120149,0x1112024a,0x1112034b,0x11121004,0x1113004c,0x1113014d,0x1113024e,0x1113034f,0x11131004,
                                0x11140050,0x11140151,0x11140252,0x11140353,0x11141004,0x11150054,0x11150155,0x11150256,0x11150357,0x11151004,
                                0x11160058,0x11160159,0x1116025a,0x1116035b,0x11161004,0x1117005c,0x1117015d,0x1117025e,0x1117035f,0x11171004,
                                0x11180060,0x11180161,0x11180262,0x11180363,0x11181004,0x11190064,0x11190165,0x11190266,0x11190367,0x11191004,
                                0x111a0068,0x111a0169,0x111a026a,0x111a036b,0x111a1004,0x111b006c,0x111b016d,0x111b026e,0x111b036f,0x111b1004,
                                0x111c0070,0x111c0171,0x111c0272,0x111c0373,0x111c1004,0x111d0074,0x111d0175,0x111d0276,0x111d0377,0x111d1004,
                                0x111e0078,0x111e0179,0x111e027a,0x111e037b,0x111e1004,0x111f007c,0x111f017d,0x111f027e,0x111f037f,0x111f1004,
                                0x11200080,0x11200181,0x11200282,0x11200383,0x11201004,0x11210084,0x11210185,0x11210286,0x11210387,0x11211004,
                                0x11220088,0x11220189,0x1122028a,0x1122038b,0x11221004,0x1123008c,0x1123018d,0x1123028e,0x1123038f,0x11231004,
                                0x11240090,0x11240191,0x11240292,0x11240393,0x11241004,0x11250094,0x11250195,0x11250296,0x11250397,0x11251004,
                                0x11260098,0x11260199,0x1126029a,0x1126039b,0x11261004,0x1127009c,0x1127019d,0x1127029e,0x1127039f,0x11271004};

	// hold everything in reset
	assert_all_reset();
	//xil_printf("#########################################\n\r");
	//xil_printf("# Test Channel 40: 40-channel mode \n\r");
	//xil_printf("#########################################\n\r");

	// config the calendar
	// 0-39 round-robin
	for(int i =0; i<120 ; i++)
	{
		if(i == 0) WriteData = (WriteData & 0xFFFFFFC0);
		else if(((WriteData & 0x3F000000) >> 24 ) < 39) WriteData = (WriteData & 0xFFFFFFC0) + ((WriteData & 0x3F000000) >> 24) + 1;
		else WriteData = (WriteData & 0xFFFFFFC0);
		if((WriteData & 0x0000003F) < 39) WriteData = (WriteData & 0xFFFFF03F) + ((WriteData & 0x0000003F) << 6) + (1 << 6);
		else WriteData = (WriteData & 0xFFFFF03F);
		if(((WriteData & 0x00000FC0) >> 6 ) < 39) WriteData = (WriteData & 0xFFFC0FFF) + ((WriteData & 0x00000FC0) << 6) + (1 << 12) ;
		else WriteData = (WriteData & 0xFFFC0FFF);
		if(((WriteData & 0x0003F000) >> 12) < 39) WriteData = (WriteData & 0xFF03FFFF) + ((WriteData & 0x0003F000) << 6) + (1 << 18) ;
		else WriteData = (WriteData & 0xFF03FFFF);
		if(((WriteData & 0x00FC0000) >> 18) < 39) WriteData = (WriteData & 0xC0FFFFFF) + ((WriteData & 0x00FC0000) << 6) + (1 << 24);
		else WriteData = (WriteData & 0xC0FFFFFF);
		*(U32* )(ADDR_APB3_2_BASE + (i << 2)) = WriteData;
	}
	*(U32 *)(GLOBAL_MODE_REG) = 0x00000033;
	config_mac();
	release_all_reset();
	usleep(2U);
	xil_printf("test_chan_40::Performing Pointer configurations \n\r");
	for ( int i = 0; i < 200 ; i++ ) {
           *(U32* )(MAC_CONFIG_REG_TX_WR_REG) = cfg_data[i];
           //pr_data = *(U32* )(MAC_CONFIG_REG_TX_WR_REG);
           //xil_printf("Test chan 40 :: Wrote %x to 0x0038 register \n\r", pr_data);
           wait(10);
	}
	//xil_printf("test_chan_40::Checking Client0 RX/TX local fault \n\r");
	do
	{
		wait(40);
		for(int i = 0; i < 6 ; i++)
		{
			*(U32* )(C0_STAT_CHAN_TX_MAC_STATUS_REG + (0x1000 * i)) = 0xFFFFFFFF;
			*(U32* )(C0_STAT_CHAN_RX_MAC_STATUS_REG + (0x1000 * i)) = 0xFFFFFFFF;
			*(U32* )(C0_STAT_PORT_TX_FEC_STATUS_REG + (0x1000 * i)) = 0xFFFFFFFF;
			*(U32* )(C0_STAT_PORT_RX_FEC_STATUS_REG + (0x1000 * i)) = 0xFFFFFFFF;
		}
		wait(3);
		for(int i = 0; i < 6 ; i++)
		{
			pr_data = *(U32* )(C0_STAT_CHAN_TX_MAC_STATUS_REG + (0x1000 * i));
			if((pr_data & 0x00000001) == 0) {
				ch_ready_tx = (ch_ready_tx | (1 << i));
				//xil_printf("test_chan_40::TX channel%d local fault is %d \n\r",i,pr_data);
			} else {
				ch_ready_tx = (ch_ready_tx & ~(1 << i));
				//xil_printf("test_chan_40::TX channel%d local fault is %d \n\r",i,pr_data);
			}
		}
		for(int i = 0; i < 6 ; i++)
		{
			pr_data = *(U32* )(C0_STAT_CHAN_RX_MAC_STATUS_REG + (0x1000 * i));
			if((pr_data & 0x00000006) == 0) {
				ch_ready_rx = (ch_ready_rx | (1 << i));
				//xil_printf("test_chan_40::RX channel%d local fault is %d \n\r",i,pr_data);
			} else {
				ch_ready_rx = (ch_ready_rx & (~(1 << i)));
				//xil_printf("test_chan_40::RX channel%d local fault is %d \n\r",i,pr_data);
			}
		}
		time_out = time_out + 4;
	}
	while (((ch_ready_rx & ch_ready_tx) != 0x3F) && (time_out < 10000));
	xil_printf("test_chan_40::PM Tick to clear all registers \n\r");
	*(U32 *)(ALL_CHANNEL_MAC_TICK_REG_RX_REG) = 0x00000001;
	*(U32 *)(ALL_CHANNEL_MAC_TICK_REG_TX_REG) = 0x00000001;
	if(time_out < 10000){
		//xil_printf("test_chan_40::Finished: Checking Client0 RX/TX local fault \n\r");
		return 1;
	} else {
		xil_printf("test_chan_40::Attempts Timed out \n\r");
		return 0;
	}
}


// 25: assert_dcmac_global_port_channel_resets_static
//
int assert_dcmac_global_port_channel_resets_static (){
        // DCMAC Resets - Global, port, and channel
        assert_all_reset();
        //  DCMAC client channel resets
        assert_channel_resets(0, client_rate[0]);

}

// 26: release_dcmac_global_port_channel_resets_static
//
int release_dcmac_global_port_channel_resets_static (){
        // Release DCMAC resets - Global, port, and channel
        release_all_reset();
        //  DCMAC client channel resets
        release_channel_resets(0, client_rate[0]);

}

// 27: init_ch_en_client_rate_static
int init_ch_en_client_rate_static () {


	ch_en[0] = 1;
	client_rate[0] = R_400G;


}

// 28: dcmac_reset_dcmac_phase_fifo
// 
int dcmac_reset_dcmac_phase_fifo (){

    xil_printf( "Assert and release the DCMAC Phase FIFO's \n\r" );

   *(U32 *) (DCMAC_0_PHASE_FIFO_RESET)  = 0xFFFFFF; //Assert Phase FIFO resets
   *(U32 *) (DCMAC_0_PHASE_FIFO_RESET) = 0x000000; //Release Phase FIFO resets
}

// 29: gt_rx_datapathonly_reset
// 
int gt_rx_datapathonly_reset (){
   xil_printf("INFO : Toggle GT RXDATAPATH Reset  \n\r");
   *(U32 *) (DCMAC_0_GT_RX_DATAPATH_RESET) = 0xFFFFFF;
   wait(5000);
   xil_printf("INFO : Toggle DCMAC RX Reset  \n\r");
   *(U32 *) (DCMAC_0_GT_RX_DATAPATH_RESET) = 0x000000;
   *(U32 *) (DCMAC_0_CORE_SERDES_RESET) = 0x0000;

   wait(1000);
}

// 30: wait_gt_txresetdone
//
int wait_gt_txresetdone (int lane_cnt){

	int time_out;
	uint32_t ReadData_GT_TX;

       // Check for GT TX RESET DONE and wait for 20000000 cycles, if not "DONE"
       xil_printf("INFO : Waiting for GT TX Reset done... \n\r");
       time_out =0;
   	do
	{
		ReadData_GT_TX = *(U32 *)(DCMAC_0_GT_TX_RESET_DONE);
		time_out = time_out + 1;
	}
	while (ReadData_GT_TX!= cal_rst_val(lane_cnt) && time_out < 20000000);
	if (time_out>= 20000000)
	{
		xil_printf("INFO : GT TX Reset Done not achieved (Read GT Status = 0x%x) \n\r", ReadData_GT_TX);
		return 0;
	} else {
		xil_printf("INFO : GT TX Reset Done achieved\n\r");
		return 1;
	}
}

// 31: wait_gt_rxresetdone
//
int wait_gt_rxresetdone (int lane_cnt){

	int time_out;
	uint32_t ReadData_GT_RX;

       // Check for GT RX RESET DONE and wait for 20000000 cycles, if not "DONE"
       xil_printf("INFO : Waiting for GT RX Reset done... \n\r");
	time_out =0;
   	do
	{
		ReadData_GT_RX = *(U32 *)(DCMAC_0_GT_RX_RESET_DONE);
		time_out = time_out + 1;
	}
	while (ReadData_GT_RX!= cal_rst_val(lane_cnt) && time_out < 20000000);
	if (time_out>= 20000000)
	{
		xil_printf("INFO : GT RX Reset Done not acheived (Read GT Status = 0x%x) \n\r", ReadData_GT_RX);
		return 0;
	} else {
		xil_printf("INFO : GT RX Reset Done acheived\n\r");
		return 1;
	}
}

// 32: assert_rx_port_reset
//
int assert_rx_port_reset()
{
    *(U32* )(C0_PORT_CONTROL_REG_RX_REG) = 0x2;
    *(U32* )(C1_PORT_CONTROL_REG_RX_REG) = 0x2;
    *(U32* )(C2_PORT_CONTROL_REG_RX_REG) = 0x2;
    *(U32* )(C3_PORT_CONTROL_REG_RX_REG) = 0x2;
    *(U32* )(C4_PORT_CONTROL_REG_RX_REG) = 0x2;
    *(U32* )(C5_PORT_CONTROL_REG_RX_REG) = 0x2;

   return 1;
}

// 33: deassert_rx_port_reset
//
int deassert_rx_port_reset()
{
    *(U32* )(C0_PORT_CONTROL_REG_RX_REG) = 0x0;
    *(U32* )(C1_PORT_CONTROL_REG_RX_REG) = 0x0;
    *(U32* )(C2_PORT_CONTROL_REG_RX_REG) = 0x0;
    *(U32* )(C3_PORT_CONTROL_REG_RX_REG) = 0x0;
    *(U32* )(C4_PORT_CONTROL_REG_RX_REG) = 0x0;
    *(U32* )(C5_PORT_CONTROL_REG_RX_REG) = 0x0;

   return 1;
}

// 34: dcmac_rx_port_reset
//
int dcmac_rx_port_reset (){
	// DCMAC RX Resets
    xil_printf("INFO : Toggle DCMAC RX Port Reset  \n\r");
    assert_rx_port_reset();
    wait(200);
    deassert_rx_port_reset();
    wait(200);
    return 1;
}

// 35: stats_test_check
//
int stats_test_check() {

	uint8_t stat_match_flag_port[6]= {0,0,0,0,0,0};
	uint8_t stat_match_flag = 0;

        ////////////////////////////////////////////////////////////////////////
	// Print port statistics
        ////////////////////////////////////////////////////////////////////////

	stat_match_flag_port[0] = (ch_en[0] != 0)?print_port0_statistics() : 0;
	stat_match_flag_port[1] = (ch_en[1] != 0)?print_port1_statistics() : 0;
	stat_match_flag_port[2] = (ch_en[2] != 0)?print_port2_statistics() : 0;
	stat_match_flag_port[3] = (ch_en[3] != 0)?print_port3_statistics() : 0;
	stat_match_flag_port[4] = (ch_en[4] != 0)?print_port4_statistics() : 0;
	stat_match_flag_port[5] = (ch_en[5] != 0)?print_port5_statistics() : 0;

	for(int i = 6; i > 0 ; i--) {
		if (stat_match_flag_port[i-1] > 0)
                {
		stat_match_flag = stat_match_flag << 1;
		stat_match_flag = stat_match_flag | 1;
                }
                else
                {
		stat_match_flag = stat_match_flag << 1;
                }
	}
	xil_printf("INFO : stat_match_flag %x \n\r",stat_match_flag);
	if (stat_match_flag == cal_stat_match())
	{
		xil_printf( "INFO : Test Completed Successfully and Passed  \n\r" );
		return 1;
	} else {
		xil_printf( "INFO : Test Completed but Failed   \n\r" );

		return 0;

	}

   }

// 36: set_gt_pcs_loopback_and_reset_static
//
   
int set_gt_pcs_loopback_and_reset_static(int mode) {
    ////////////////////////////////////////////////////////////////////////
	// Apply GT Reset all, set NE PCS Loopback and rxcdrhold
    //   This specific process is needed for the GT internal Reset FSM for
    //   NE PCS loopback
    ////////////////////////////////////////////////////////////////////////

    //Add variable to select if NE PCS loopback or External loopback
	// [0] reset all
	// [8:1] line rate
	// [11:9] loopback
	// [17:12] txprecursor
	// [23:18] txpostcursor
	// [30:24] maincursor
	// [31]: rxcdrhold
	// for NE PCS loopback, rxcdrhold has to be 1; for NE PMA loopback or external loopback, rxcdrhold has to be 0

	// Setting NE PCS loopback - For External loopback comment the following line -- rxcdrhold = 1
	//*(U32 *) (DCMAC_0_GT_LINERATE_RESET) = 0x4B243001;
    //wait(100);
	//*(U32 *) (DCMAC_0_GT_LINERATE_RESET) = 0x4B243000;
	//wait(100);
	//xil_printf( "INFO : Setting NE PCS loopback   \n\r" );
	//*(U32 *) (DCMAC_0_GT_LINERATE_RESET) = 0xCB243200;
    // 
	// Setting NE PMA loopback or external loopback -- rxcdrhold = 1
	*(U32 *) (DCMAC_0_GT_LINERATE_RESET) = 0x4B243001;
    wait(100);
	*(U32 *) (DCMAC_0_GT_LINERATE_RESET) = 0x4B243000;
	wait(100);
	// NE PMA loopback
	//xil_printf( "INFO : Setting NE PMA loopback   \n\r" );
	//*(U32 *) (DCMAC_0_GT_LINERATE_RESET) = 0x4B243400;
	// external loopback
	//xil_printf( "INFO : Setting External loopback (Normal mode)   \n\r" );
	//*(U32 *) (DCMAC_0_GT_LINERATE_RESET) = 0x4B243000;
    //wait(100);
	 /*
	 [0]: gt_reset_all = 1'b1
	 [8:1]: gt_line_rate = 8'h0
	 [11:9]: gt_loopback = 3'b000 (External: 3'b000; 	Near-end PCS: 3'b001; Near-end PMA: 3'b010)
	 [17:12]: gt_txprecursor = 6'd3
	 [23:18]: gt_txpostcursor = 6'd9
	 [30:24]: gt_maincursor = 7'd75
	 [31]: gt_rxcdrhold
	 */
	if(mode == 0) // external mode
	{
		xil_printf( "INFO : Setting External loopback (Normal mode)   \n\r" );
		*(U32 *) (DCMAC_0_GT_LINERATE_RESET) = 0x4B243000;
	}
	else if(mode == 1) // NE PCS loopback
	{
		xil_printf( "INFO : Setting NE PCS loopback   \n\r" );
		*(U32 *) (DCMAC_0_GT_LINERATE_RESET) = 0xCB243200;
	}
	else if(mode == 2) // NE PMA loopback
	{
		xil_printf( "INFO : Setting NE PMA loopback   \n\r" );
		*(U32 *) (DCMAC_0_GT_LINERATE_RESET) = 0x4B243400;
	}
    // Ensure the GT TX Datapath Reset is not asserted
	*(U32 *) (DCMAC_0_GT_TX_DATAPATH_RESET) = 0x000000;
    /*
	[23:0]: gt_reset_tx_datapath_in
    [26:24]: config_switch
	*/
	wait(5000);

	return 1;

   }

// 37: program_dcmac
//
int program_dcmac (){


    // Set Rate and enable IEEE std error indications and enable alignment marker flip
    xil_printf( "Setting the DCMAC GLOBAL_MODE_REG ... \n\r" );

	*(U32* )(GLOBAL_MODE_REG ) = 0x07330000;
    // Config the MAC C0-C5 CHANNEL_CONTROL_REG_RX/TX
	config_mac();

    // Set DCMAC rates
	set_data_rate(client_rate);

	return 1;
}

// 38: test_fixe_sanity
//
int test_fixe_sanity(uint8_t ch_en_str)
{


	wait(30);
	// clear status
	latch_all();

	xil_printf("Packets Start \n\r");
	// set packet size range: 64 - 256
	*(U32 *)(ADDR_APB3_2_BASE + 0x00000208) = 0x01000040;
	*(U32 *)(ADDR_APB3_2_BASE + 0x00000204) = (ch_en_str << 24) ;
	usleep(3U);
	*(U32 *)(ADDR_APB3_2_BASE + 0x00000204) = 0x00000000 ;
	xil_printf("Packets Stop \n\r");
	usleep(3U);
	latch_all();

	if(check_sanity() != 0) {
		//xil_printf("1x400GE Mode :: Test Completed Successfully and Passed \n\r");
		return 1;
	} else {
		//xil_printf("1x400GE Mode :: Test Completed but Failed \n\r");
		return 0;
	}
}

// 39: read rev id
int read_rev_id(){
	uint32_t rev_id;
	rev_id = *(U32 *)(REV_ID_REG);
	xil_printf("DCMAC Revision ID: 0x%x \n\r", rev_id);
	return 1;
}
