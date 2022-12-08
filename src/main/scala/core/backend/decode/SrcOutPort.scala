package rainy.shaheway.org
package core.backend.decode

import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH}

class SrcOutPort extends Bundle {
  val aluSrc_a = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val aluSrc_b = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val regB_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH)) // For store instructions
  val writeback_addr = Output(UInt(REG_ADDR_WIDTH))
  val imm_b = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
