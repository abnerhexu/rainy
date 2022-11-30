package rainy.shaheway.org
package core.backend.alu

import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, ALU_EXE_FUN_LEN}
class AluInPort extends Bundle {
  val aluSrc_a = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val aluSrc_b = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val alu_op = Input(UInt(ALU_EXE_FUN_LEN))
}
