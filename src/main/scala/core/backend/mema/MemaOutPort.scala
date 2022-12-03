package rainy.shaheway.org
package core.backend.mema
import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH}

class MemaOutPort extends Bundle {
  val writeback_addr = Output(UInt(REG_ADDR_WIDTH))
  val writeback_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
