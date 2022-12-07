package rainy.shaheway.org
package core.backend.pipereg
import chisel3._
import common.Defines.{BUBBLE, DOUBLE_WORD_LEN_WIDTH, START_ADDR, WORD_LEN_WIDTH}

import chisel3.util.MuxCase
class FetchToDecode extends Module {
  val io = IO(new Bundle() {
    val stallFlag = Input(Bool())
    val pcIn = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val instIn = Input(UInt(WORD_LEN_WIDTH))
    val jumpOrBranchFlag = Input(Bool())
    val instOut = Output(UInt(WORD_LEN_WIDTH))
    val pcOut = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  })

  val progcnter = RegInit(START_ADDR)
  val instReg = RegInit(0.U(WORD_LEN_WIDTH))
  val instUpdate = MuxCase(io.instIn, Seq(
    io.jumpOrBranchFlag -> BUBBLE,
    io.stallFlag -> instReg
  ))
  instReg := instUpdate

  val pcMux = Mux(io.stallFlag, progcnter , io.pcIn)
  progcnter := pcMux

  io.instOut := instReg
  io.pcOut := progcnter
}
