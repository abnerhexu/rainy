package rainy.shaheway.org
package core.backend.alu

import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH}

class AluOutPort extends Bundle {
  val alu_result = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val writeback_addr = Output(UInt(REG_ADDR_WIDTH))
  val regB_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}

