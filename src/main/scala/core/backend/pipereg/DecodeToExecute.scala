package rainy.shaheway.org
package core.backend.pipereg
import chisel3._
import core.backend.decode.{ControlOutPort, SrcOutPort}
import common.Defines._

class DecodeToExecute extends Module {
  val io = IO(new Bundle() {
    // branch
    val jumpOrBranchFlag = Input(Bool())
    // val stallFlag = Input(Bool())
    val cur_pc = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val pcOut = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
    val controlSignal = Flipped(new ControlOutPort)
    val opSrc = Flipped(new SrcOutPort)
    val controlSignalPass = new ControlOutPort
    val srcPass = new SrcOutPort
  })

  // I_ADDI     -> List(ALU_ADD, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
  val funMux = Mux(io.jumpOrBranchFlag, ALU_ADD, io.controlSignal.alu_exe_fun)
  val alu_exe_fun = RegInit(0.U(ALU_EXE_FUN_LEN))
  alu_exe_fun := funMux
  val memTypeMux = Mux(io.jumpOrBranchFlag, MEM_X, io.controlSignal.memType)
  val memType = RegInit(0.U(MEM_TYPE_LEN))
  memType := memTypeMux
  val regTypeMux = Mux(io.jumpOrBranchFlag, REG_S, io.controlSignal.regType)
  val regType = RegInit(0.U(REG_TYPE_LEN))
  regType := regTypeMux
  val wbTypeMux = Mux(io.jumpOrBranchFlag, WB_ALU, io.controlSignal.wbType)
  val wbType = RegInit(0.U(WB_TYPE_LEN))
  wbType := wbTypeMux
  val CSRTypeMux = Mux(io.jumpOrBranchFlag, CSR_X, io.controlSignal.CSRType)
  val CSRType = RegInit(0.U(CSR_TYPE_LEN))
  CSRType := CSRTypeMux
  val csrAddr = RegInit(0.U(CSR_ADDR_LEN_WIDTH)) // 不用做处理
  csrAddr := io.controlSignal.csrAddr

  io.controlSignalPass.alu_exe_fun := alu_exe_fun
  io.controlSignalPass.memType := memType
  io.controlSignalPass.regType := regType
  io.controlSignalPass.wbType := wbType
  io.controlSignalPass.CSRType := CSRType
  io.controlSignalPass.csrAddr := csrAddr

  val srcAMux = Mux(io.jumpOrBranchFlag, 0.U(DOUBLE_WORD_LEN_WIDTH), io.opSrc.aluSrc_a)
  val srcA = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  srcA := srcAMux
  val srcBMux = Mux(io.jumpOrBranchFlag, 0.U(DOUBLE_WORD_LEN_WIDTH), io.opSrc.aluSrc_b)
  val srcB = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  srcB := srcBMux
  val regBData = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH)) // 不用做处理
  regBData := io.opSrc.regB_data
  val writebackAddrMux = Mux(io.jumpOrBranchFlag, 0.U(REG_ADDR_WIDTH), io.opSrc.writeback_addr)
  val writebackAddr = RegInit(0.U(REG_ADDR_WIDTH))
  writebackAddr := writebackAddrMux
  val imm_b = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  imm_b := io.opSrc.imm_b

  io.srcPass.aluSrc_a := srcA
  io.srcPass.aluSrc_b := srcB
  io.srcPass.regB_data := regBData
  io.srcPass.writeback_addr := writebackAddr
  io.srcPass.imm_b := imm_b

  val progcnter = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  progcnter := io.cur_pc
  io.pcOut := progcnter
}
