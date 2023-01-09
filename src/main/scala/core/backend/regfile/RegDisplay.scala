package rainy.shaheway.org
package core.backend.regfile
import chisel3._
class RegDisplay extends Bundle {
  val in = Input(UInt(8.W))
  val out = Output(UInt(64.W))
  val startFlag = Output(Bool())
}
