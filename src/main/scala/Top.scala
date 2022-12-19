package rainy.shaheway.org
import chisel3._
import core.{Core, Probe}
import mem.Memory
import common.Defines.DOUBLE_WORD_LEN_WIDTH

import chisel3.stage.ChiselStage
import rainy.shaheway.org.core.backend.Seg7
class Top extends Module {
  val io = IO(new Bundle() {
    val a = Input(UInt(8.W))
    val segOut = Output(UInt(16.W))
    val segChoice = Output(UInt(2.W))
  })
  val core = Module(new Core)
  val memory = Module(new Memory)
  val seg7 = Module(new Seg7)

  core.io.instfetch_fetchMem <> memory.io.instReadPort
  core.io.memoryAccess_dataReadPort <> memory.io.dataReadPort
  core.io.memoryAccess_dataWritePort <> memory.io.writePort
  core.io.display.in := io.a
  seg7.io.ans := core.io.display.out(15, 0)
  io.segOut := seg7.io.segOut
  io.segChoice := seg7.io.segChoice
}

object Top extends App {
  (new ChiselStage).emitVerilog(new Top())
}
