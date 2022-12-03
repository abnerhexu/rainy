package rainy.shaheway.org
package core.backend.mema
import chisel3._
import common.Defines.{CSR_ADDR_LEN_WIDTH, CSR_TYPE_LEN, DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH, REG_TYPE_LEN}

class MemaOutPort extends Bundle {
  val writeback_addr = Output(UInt(REG_ADDR_WIDTH))
  val writeback_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val regwrite_enable = Output(UInt(REG_TYPE_LEN))
  val csrwrite_addr = Output(UInt(CSR_ADDR_LEN_WIDTH))
  val csrwrite_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val CSRType = Output(UInt(CSR_TYPE_LEN))
}
