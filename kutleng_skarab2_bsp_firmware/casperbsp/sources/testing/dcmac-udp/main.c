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

extern int flag_alignment;

void main()
{
    xil_printf("dcmac reg rw test...\r\n");
    xil_printf("core type: 0x%08x\r\n", *(uint32_t *) AXI_REG_BASE);

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
    xil_printf("rst_cnt = %d\n\r", rst_cnt);
    xil_printf("Done.\r\n");

    usleep(20U);
	ch_en_str = get_chstr();
	//sleep(5);
	//test_fixe_sanity(ch_en_str);
	//wait(100);

    stats_test_check();

	xil_printf("\n\r*******Test Completed        \n\r");

	return 1;
}
