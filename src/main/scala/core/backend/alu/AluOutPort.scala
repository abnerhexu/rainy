package rainy.shaheway.org
package core.backend.alu

import chisel3._
import common.Defines.DOUBLE_WORD_LEN_WIDTH

class AluOutPort extends Bundle {
  val is_zero = Output(Bool())
  val alu_result = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}

