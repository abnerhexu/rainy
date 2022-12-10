package rainy.shaheway.org
package core

import chisel3._
import common.Defines._
class Probe extends Bundle{
  val progcnter = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val inst = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val srcA = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val srcB = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val alu_result = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val forward_srcb = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val stall = Output(Bool())
  val writeback_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val datahazardAType = Output(UInt(DATAHAZARD_LEN))
  val inst_id = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
