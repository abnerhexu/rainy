package rainy.shaheway.org
package core.backend.regfile

import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH}

class RegWritePort extends Module {
  val write_addr = Input(UInt(REG_ADDR_WIDTH))
  val write_data = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val write_enable = Input(Bool())
}
