package rainy.shaheway.org
package core.backend.pipereg
import chisel3._
import core.backend.decode.{ControlOutPort, SrcOutPort}
import common.Defines._
class DecodeToExecute extends Module {
  val io = IO(new Bundle() {
    val controlSignal = Flipped(new ControlOutPort)
    val opSrc = Flipped(new SrcOutPort)
    val controlSignalPass = new ControlOutPort
    val srcPass = new SrcOutPort
  })

  val alu_exe_fun = RegNext(0.U(ALU_EXE_FUN_LEN), io.controlSignal.alu_exe_fun)
  val memType = RegNext(0.U(MEM_TYPE_LEN), io.controlSignal.memType)
  val regType = RegNext(0.U(REG_TYPE_LEN), io.controlSignal.regType)
  val wbType = RegNext(0.U(WB_TYPE_LEN), io.controlSignal.wbType)
  val CSRType = RegNext(0.U(CSR_TYPE_LEN), io.controlSignal.CSRType)
  val csrAddr = RegNext(0.U(CSR_ADDR_LEN_WIDTH), io.controlSignal.csrAddr)


  io.controlSignal <> io.controlSignalPass

  val srcA = RegNext(0.U(DOUBLE_WORD_LEN_WIDTH), io.opSrc.aluSrc_a)
  val srcB = RegNext(0.U(DOUBLE_WORD_LEN_WIDTH), io.opSrc.aluSrc_b)
  val regBData = RegNext(0.U(DOUBLE_WORD_LEN_WIDTH), io.opSrc.regB_data)
  val writebackAddr = RegNext(0.U(REG_ADDR_WIDTH), io.opSrc.writeback_addr)
  io.opSrc <> io.srcPass
}
