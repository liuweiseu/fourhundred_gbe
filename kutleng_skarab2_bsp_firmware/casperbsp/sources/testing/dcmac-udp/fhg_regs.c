#include <xparameters.h>
#include "fhg_regs.h"

unsigned int dcmac_read_reg(unsigned int addr)
{
    return *(volatile unsigned int *)(addr);
}

void dcmac_write_reg(unsigned int addr, unsigned int data)
{
    *(volatile unsigned int *)(addr) = data;
}