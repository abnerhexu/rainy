package rainy.shaheway.org
package core.backend.regfile
import common.Defines.{CSR_ADDR_LEN_WIDTH, DOUBLE_WORD_LEN_WIDTH}

import chisel3._
class CSRWritePort extends Bundle {
  val csr_write_addr = Input(UInt(CSR_ADDR_LEN_WIDTH))
  val csr_write_data = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val csr_write_enable = Input(Bool())
}
