package rainy.shaheway.org
package core.clint
import chisel3._
import rainy.shaheway.org.common.Defines.DOUBLE_WORD_LEN_WIDTH
class ClintWithMMU extends Bundle{
  // exception signals from MMU etc
  val exceptionFlag = Input(Bool())
  val instruction_addr_cause_exception = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val exception_cause = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val exception_val = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  // trick for page-fault, synchronous with mmu
  val exception_token = Output(Bool())
}
