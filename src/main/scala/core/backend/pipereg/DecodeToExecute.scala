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
    // branch
    val jumpOrBranchFlag = Input(Bool())
  })

  // I_ADDI     -> List(ALU_ADD, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
  val funMux = Mux(io.jumpOrBranchFlag, ALU_ADD, io.controlSignal.alu_exe_fun)
  val alu_exe_fun = RegNext(0.U(ALU_EXE_FUN_LEN), funMux)
  val memTypeMux = Mux(io.jumpOrBranchFlag, MEM_X, io.controlSignal.memType)
  val memType = RegNext(0.U(MEM_TYPE_LEN), memTypeMux)
  val regTypeMux = Mux(io.jumpOrBranchFlag, REG_S, io.controlSignal.regType)
  val regType = RegNext(0.U(REG_TYPE_LEN), regTypeMux)
  val wbTypeMux = Mux(io.jumpOrBranchFlag, WB_ALU, io.controlSignal.wbType)
  val wbType = RegNext(0.U(WB_TYPE_LEN), wbTypeMux)
  val CSRTypeMux = Mux(io.jumpOrBranchFlag, CSR_X, io.controlSignal.CSRType)
  val CSRType = RegNext(0.U(CSR_TYPE_LEN), CSRTypeMux)
  val csrAddr = RegNext(0.U(CSR_ADDR_LEN_WIDTH), io.controlSignal.csrAddr) // 不用做处理

  io.controlSignalPass.alu_exe_fun := alu_exe_fun
  io.controlSignalPass.memType := memType
  io.controlSignalPass.regType := regType
  io.controlSignalPass.wbType := wbType
  io.controlSignalPass.CSRType := CSRType
  io.controlSignalPass.csrAddr := csrAddr

  val srcAMux = Mux(io.jumpOrBranchFlag, 0.U(DOUBLE_WORD_LEN_WIDTH), io.opSrc.aluSrc_a)
  val srcA = RegNext(0.U(DOUBLE_WORD_LEN_WIDTH), srcAMux)
  val srcBMux = Mux(io.jumpOrBranchFlag, 0.U(DOUBLE_WORD_LEN_WIDTH), io.opSrc.aluSrc_b)
  val srcB = RegNext(0.U(DOUBLE_WORD_LEN_WIDTH), srcBMux)
  val regBData = RegNext(0.U(DOUBLE_WORD_LEN_WIDTH), io.opSrc.regB_data) // 不用做处理
  val writebackAddrMux = Mux(io.jumpOrBranchFlag, 0.U(REG_ADDR_WIDTH), io.opSrc.writeback_addr)
  val writebackAddr = RegNext(0.U(REG_ADDR_WIDTH), writebackAddrMux)

  io.srcPass.aluSrc_a := srcA
  io.srcPass.aluSrc_b := srcB
  io.srcPass.regB_data := regBData
  io.srcPass.writeback_addr := writebackAddr
}
