package rainy.shaheway.org
package core.backend.pipereg
import chisel3._
import common.Defines.{BUBBLE, WORD_LEN_WIDTH}

import chisel3.util.MuxCase
class FetchToDecode extends Module {
  val io = IO(new Bundle() {
    val instIn = Input(UInt(WORD_LEN_WIDTH))
    val jumpOrBranchFlag = Input(Bool())
    val instOut = Output(UInt(WORD_LEN_WIDTH))
  })

  val branchFlush = Mux(io.jumpOrBranchFlag, BUBBLE, io.instOut)
  val instReg = RegNext(0.U(WORD_LEN_WIDTH), branchFlush)
  io.instOut := instReg
}
