package rainy.shaheway.org
package core.clint
import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, INTERRUPT_FLAG_WIDTH, WORD_LEN_WIDTH}
class ClintIO extends Bundle {
  val interruptFlag = Input(UInt(INTERRUPT_FLAG_WIDTH))
  val cur_instruction = Input(UInt(WORD_LEN_WIDTH))
  val cur_instructionAddr = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val exceptionSignal = Input(Bool())
  val cause_instruction = Input(UInt(WORD_LEN_WIDTH))
  val cause_instructionAddr = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val exceptionVal = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
}
