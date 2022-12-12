package rainy.shaheway.org
package core.backend.pipereg

import chisel3._
import common.Defines.{CSR_ADDR_LEN_WIDTH, CSR_TYPE_LEN, DOUBLE_WORD_LEN_WIDTH, MEM_TYPE_LEN, REG_ADDR_WIDTH, REG_TYPE_LEN, WB_TYPE_LEN}
import core.backend.alu.{AluConOut, AluOutPort}

import core.backend.mema.MemaExtend

class ExecuteToMema extends Module {
  val io = IO(new Bundle() {
    val linkedPC = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val linkedPCPass = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
    val aluOut = Flipped(new AluOutPort)
    val controlSignal = Flipped(new AluConOut)
    val aluOutPass = new MemaExtend
    val controlSignalPass = new AluConOut
    val jumpFlag = Output(Bool())
    val jumpTarget = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  })

  val alu_result = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  alu_result := io.aluOut.alu_result
  val writeback_addr = RegInit(0.U(REG_ADDR_WIDTH))
  writeback_addr := io.aluOut.writeback_addr
  val regB_data = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  regB_data := io.aluOut.regB_data

  io.aluOutPass.alu_result := alu_result
  io.aluOutPass.writeback_addr := writeback_addr
  io.aluOutPass.regB_data := regB_data

  val memType = RegInit(0.U(MEM_TYPE_LEN))
  memType := io.controlSignal.memType
  val regType = RegInit(0.U(REG_TYPE_LEN))
  regType := io.controlSignal.regType
  val wbType = RegInit(0.U(WB_TYPE_LEN))
  wbType := io.controlSignal.wbType
  val CSRType = RegInit(0.U(CSR_TYPE_LEN))
  CSRType := io.controlSignal.CSRType
  val csrAddr = RegInit(0.U(CSR_ADDR_LEN_WIDTH))
  csrAddr := io.controlSignal.csrAddr

  io.controlSignalPass.memType := memType
  io.controlSignalPass.regType := regType
  io.controlSignalPass.wbType := wbType
  io.controlSignalPass.CSRType := CSRType
  io.controlSignalPass.csrAddr := csrAddr

  val linkedPC = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  linkedPC := io.linkedPC

  io.linkedPCPass := linkedPC

  val jumpFlag = RegInit(false.asBool)
  jumpFlag := io.aluOut.jumpFlag
  io.jumpFlag := jumpFlag
  val jumpTarget = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  jumpTarget := io.aluOut.jumpTarget
  io.jumpTarget := jumpTarget
}
