#include <stdio.h>
#include <xil_printf.h>
#include <xparameters.h>
#include "xil_exception.h"
#include "xstatus.h"
#include "xil_types.h"
#include "xgpio.h"
#include "sleep.h"

#include "fhg_regs.h"

void main()
{
    xil_printf("dcmac reg rw test...\r\n");
    xil_printf("core type: 0x%08x\r\n", dcmac_read_reg(CORE_TYPE));
}