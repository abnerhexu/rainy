package rainy.shaheway.org
package core.backend
import chisel3._
class Perf extends Module {
  val io = IO(new Bundle() {
    val stallFlag = Input(Bool())
    val forwardFlag = Input(Bool())
    val stall_cnt = Output(UInt(12.W))
    val forward_cnt = Output(UInt(12.W))
  })

  val stall_cnt = RegInit(0.U(12.W))
  stall_cnt := Mux(io.stallFlag, stall_cnt+1.U(12.W), stall_cnt)
  io.stall_cnt := stall_cnt
  val forward_cnt = RegInit(0.U(12.W))
  forward_cnt := Mux(io.forwardFlag, forward_cnt+1.U(12.W), forward_cnt)
  io.forward_cnt := forward_cnt
}
