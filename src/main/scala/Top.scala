package rainy.shaheway.org
import chisel3._
import core.Core
import mem.Memory

import chisel3.stage.ChiselStage
class Top extends Module {
  val core = Module(new Core)
  val memory = Module(new Memory)

  core.io.instfetch_fetchMem <> memory.io.instReadPort
  core.io.memoryAccess_dataReadPort <> memory.io.dataReadPort
  core.io.memoryAccess_dataWritePort <> memory.io.writePort
}

object Top extends App {
  (new ChiselStage).emitVerilog(new Top())
}