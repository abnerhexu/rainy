package rainy.shaheway.org
package core.backend.pipereg

import chisel3._
import common.Defines.{CSR_ADDR_LEN_WIDTH, CSR_TYPE_LEN, DOUBLE_WORD_LEN_WIDTH, MEM_TYPE_LEN, REG_ADDR_WIDTH, REG_TYPE_LEN, WB_TYPE_LEN}
import core.backend.alu.{AluConOut, AluOutPort}

class ExecuteToMema extends Module {
  val io = IO(new Bundle() {
    val linkedPC = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val linkedPCPass = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
    val aluOut = Flipped(new AluOutPort)
    val controlSignal = Flipped(new AluConOut)
    val aluOutPass = new AluOutPort
    val controlSignalPass = new AluConOut
  })

  val alu_result = RegNext(0.U(DOUBLE_WORD_LEN_WIDTH), io.aluOut.alu_result)
  val writeback_addr = RegNext(0.U(REG_ADDR_WIDTH), io.aluOut.writeback_addr)
  val regB_data = RegNext(0.U(DOUBLE_WORD_LEN_WIDTH), io.aluOut.regB_data)

  io.aluOutPass.alu_result := alu_result
  io.aluOutPass.writeback_addr := writeback_addr
  io.aluOutPass.regB_data := regB_data

  val memType = RegNext(0.U(MEM_TYPE_LEN), io.controlSignal.memType)
  val regType = RegNext(0.U(REG_TYPE_LEN), io.controlSignal.regType)
  val wbType = RegNext(0.U(WB_TYPE_LEN), io.controlSignal.wbType)
  val CSRType = RegNext(0.U(CSR_TYPE_LEN), io.controlSignal.CSRType)
  val csrAddr = RegNext(0.U(CSR_ADDR_LEN_WIDTH), io.controlSignal.csrAddr)

  io.controlSignalPass.memType := memType
  io.controlSignalPass.regType := regType
  io.controlSignalPass.wbType := wbType
  io.controlSignalPass.CSRType := CSRType
  io.controlSignalPass.csrAddr := csrAddr

  val linkedPC = RegNext(0.U(DOUBLE_WORD_LEN_WIDTH), io.linkedPC)

  io.linkedPCPass := linkedPC
}
