package rainy.shaheway.org
import chisel3._
import core.{Core, Probe}
import mem.Memory
import common.Defines.DOUBLE_WORD_LEN_WIDTH

import chisel3.stage.ChiselStage
import display.Show
class Top extends Module {
  val io = IO(new Bundle() {
    val a = Input(UInt(8.W))
    val segOut = Output(UInt(10.W))
    val segValid = Output(Bool())
    // val segChoice = Output(UInt(2.W))
    val forward_cnt = Output(UInt(12.W))
    val stall_cnt = Output(UInt(12.W))
  })
  val core = Module(new Core)
  val memory = Module(new Memory)
  val seg7 = Module(new Show)

  core.io.instfetch_fetchMem <> memory.io.instReadPort
  core.io.memoryAccess_dataReadPort <> memory.io.dataReadPort
  core.io.memoryAccess_dataWritePort <> memory.io.writePort
  core.io.display_a := io.a
  io.segValid := seg7.io.valid
  io.segOut := seg7.io.out_result
  // io.segChoice := seg7.io.seg_choice
  seg7.io.in_result := core.io.display_ans
  seg7.io.start := Mux(core.io.segStartFlag && (!seg7.io.valid), true.asBool, false.asBool)
  io.forward_cnt := core.io.forward_cnt
  io.stall_cnt := core.io.stall_cnt
}

object Top extends App {
  (new ChiselStage).emitVerilog(new Top())
}
