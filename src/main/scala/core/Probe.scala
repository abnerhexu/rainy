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
  val writeback_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val mem_read_addr = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val forwardAtype = Output(UInt(DATAHAZARD_LEN))
  val forwardBtype = Output(UInt(DATAHAZARD_LEN))
  val stallFlag = Output(Bool())
  val branchFlag = Output(Bool())
  val cycleTime = Output(UInt(12.W))
  val branchTarget = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
