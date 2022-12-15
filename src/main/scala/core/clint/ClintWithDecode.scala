package rainy.shaheway.org
package core.clint
import chisel3._
import rainy.shaheway.org.common.Defines.DOUBLE_WORD_LEN_WIDTH
class ClintWithDecode extends Bundle {
  val id_interrupt_handler_addr = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val id_interrupt_assert = Output(Bool())
  val jumpFlag = Input(Bool())
  val jumpTarget = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
}
