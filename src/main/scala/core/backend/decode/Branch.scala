package rainy.shaheway.org
package core.backend.decode
import chisel3._
import rainy.shaheway.org.common.Defines.DOUBLE_WORD_LEN_WIDTH
class Branch extends Bundle {
  val branchFlag = Output(Bool())
  val branchTarget = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
