package rainy.shaheway.org
package core.backend

import chisel3._
import common.Defines.{CSR_ADDR_LEN_WIDTH, DOUBLE_WORD_LEN_WIDTH, START_ADDR}

import chisel3.util.MuxCase
import mem.InstReadPort
import common.Instructions.ECALL
import core.backend.regfile.CSRReadPort
class Instfetch extends Module {
  val io = IO(new Bundle() {
    val branchFlag = Input(Bool())
    val branchTarget = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val jumpFlag = Input(Bool())
    val jumpTarget = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val fetchMem = Flipped(new InstReadPort)
    val instOut = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
    val envRead = Flipped(new CSRReadPort)
  })
  val progcnter = RegInit(START_ADDR)
  val ecallAddr = 0x305.U(CSR_ADDR_LEN_WIDTH)
  io.envRead.csr_read_addr := ecallAddr
  val pcIncrement = progcnter + 4.U(DOUBLE_WORD_LEN_WIDTH)
  val pcNext = MuxCase(pcIncrement, Seq(
    io.branchFlag -> io.branchTarget,
    io.jumpFlag -> io.jumpTarget,
    (io.fetchMem.read_inst_a === ECALL) -> io.envRead.csr_read_data
  ))
  progcnter := pcNext
  io.fetchMem.read_addr_a := progcnter
  io.instOut := io.fetchMem.read_inst_a
}
