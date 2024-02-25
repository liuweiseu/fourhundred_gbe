#include <xparameters.h>
#include "fhg_regs.h"

uint32_t dcmac_read_reg(uint32_t addr)
{
    return *(uint32_t *)(addr);
}

void dcmac_write_reg(uint32_t addr, uint32_t data)
{
    *(uint32_t *)(addr) = data;
}