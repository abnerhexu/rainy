package rainy.shaheway.org
package core.backend.regfile

import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH}

class RegReadPort extends Bundle {
  val read_addr_a = Input(UInt(REG_ADDR_WIDTH))
  val read_addr_b = Input(UInt(REG_ADDR_WIDTH))
  val read_data_a = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val read_data_b = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
