package rainy.shaheway.org
package core.backend.regfile

import common.Defines.{CSR_ADDR_LEN_WIDTH, DOUBLE_WORD_LEN_WIDTH}

import chisel3._

class CSRReadPort extends Bundle{
  val csr_read_addr = Input(UInt(CSR_ADDR_LEN_WIDTH))
  val csr_read_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
