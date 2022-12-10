package rainy.shaheway.org
package core.backend

import chisel3._
import common.Defines.{CSR_ADDR_LEN_WIDTH, DOUBLE_WORD_LEN_WIDTH, START_ADDR, WORD_LEN_WIDTH}

import chisel3.util.MuxCase
import mem.InstReadPort
import common.Instructions.ECALL
import core.backend.regfile.CSRReadPort
class Instfetch extends Module {
  val io = IO(new Bundle() {
    val branchFlag = Input(Bool())
    val jumpFlag = Input(Bool())
    val stallFlag = Input(Bool())
    val branchTarget = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val jumpTarget = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val instOut = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
    val pcOut = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
    val fetchMem = Flipped(new InstReadPort)
    val envRead = Flipped(new CSRReadPort)
  })

  val progcnter = RegInit(START_ADDR)
  io.fetchMem.read_addr_a := progcnter
  val ecallAddr = 0x305.U(CSR_ADDR_LEN_WIDTH)
  io.envRead.csr_read_addr := ecallAddr
  val pcIncrement = progcnter + 4.U(DOUBLE_WORD_LEN_WIDTH)
  val pcNext = MuxCase(pcIncrement, Seq(
    // 顺序很重要，排序越靠前优先级越高
    io.branchFlag -> io.branchTarget,
    io.jumpFlag -> io.jumpTarget,
    (io.fetchMem.read_inst_a === ECALL) -> io.envRead.csr_read_data,
    io.stallFlag -> progcnter
  ))

  progcnter := pcNext
  io.instOut := io.fetchMem.read_inst_a
  io.pcOut := progcnter
}