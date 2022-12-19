package rainy.shaheway.org
import chisel3._
import core.{Core, Probe}
import mem.Memory
import common.Defines.DOUBLE_WORD_LEN_WIDTH

import chisel3.stage.ChiselStage
class Top extends Module {
  val io = IO(new Bundle() {
    val a = Input(UInt(8.W))
    val ans = Output(UInt(16.W))
  })
  val core = Module(new Core)
  val memory = Module(new Memory)

  core.io.instfetch_fetchMem <> memory.io.instReadPort
  core.io.memoryAccess_dataReadPort <> memory.io.dataReadPort
  core.io.memoryAccess_dataWritePort <> memory.io.writePort
  core.io.display.in := io.a
  io.ans := core.io.display.out

}

object Top extends App {
  (new ChiselStage).emitVerilog(new Top())
}
