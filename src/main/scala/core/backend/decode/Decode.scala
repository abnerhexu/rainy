package rainy.shaheway.org
package core.backend.decode

import chisel3._
import chisel3.util._
import common.Defines._
import common.Instructions._
import core.backend.datahazard.ForwardWithDecode

import core.backend.regfile.RegReadPort
class Decode extends Module {
  val io = IO(new Bundle() {
    val jumpFlag = Input(Bool())
    val stallFlag = Input(Bool())
    val inst = Input(UInt(WORD_LEN_WIDTH))
    val cur_pc = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val pcOut = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
    val decodeOut = new ControlOutPort
    val srcOut = new SrcOutPort
    val forward = Flipped(new ForwardWithDecode)
    val readReg = Flipped(new RegReadPort)
    val branch = new Branch
    // probe
    val inst_id = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  })

  // 正常情况
  val de_inst = Mux(io.jumpFlag || io.stallFlag, BUBBLE, io.inst)

  val rsA_addr = de_inst(19, 15)
  val rsB_addr = de_inst(24, 20)
  // forward
  io.forward.srcAddrA := rsA_addr
  io.forward.srcAddrB := rsB_addr
  // 取数
  io.readReg.read_addr_a := rsA_addr
  io.readReg.read_addr_b := rsB_addr
  val regA_data = Mux(io.forward.AhazardFlag, io.forward.hazardAData, io.readReg.read_data_a)
  val regB_data = Mux(io.forward.BhazardFlag, io.forward.hazardBData, io.readReg.read_data_b)

  // 写回地址
  val write_back_reg_addr = de_inst(11, 7)

  // 立即数
  val imm_i = de_inst(31, 20)
  val imm_i_sext = Cat(Fill(52, imm_i(11)), imm_i)
  val imm_s = Cat(de_inst(31, 25), de_inst(11, 7))
  val imm_s_sext = Cat(Fill(52, imm_s(11)), imm_s)
  val imm_b = Cat(de_inst(31), de_inst(7), de_inst(30, 25), de_inst(11, 8))
  val imm_b_sext = Cat(Fill(51, imm_b(11)), imm_b, 0.U(1.U))
  val imm_j = Cat(de_inst(31), de_inst(19, 12), de_inst(20), de_inst(30, 21))
  val imm_j_sext = Cat(Fill(43, imm_j(19)), imm_j, 0.U(1.U))
  val imm_u = de_inst(31, 12)
  val imm_u_shifted = Cat(imm_u, Fill(12, 0.U))
  val imm_z = de_inst(19, 15)
  val imm_z_uext = Cat(Fill(59, 0.U), imm_z)

  io.inst_id := de_inst // probe

  val controlSignals = ListLookup(de_inst, List(ALU_X, SRCA_X, SRCB_X, MEM_X, REG_X, WB_X, CSR_X), Array(
    R_ADD      -> List(ALU_ADD, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_ADDW     -> List(ALU_ADD, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_SUB      -> List(ALU_SUB, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_SUBW     -> List(ALU_SUB, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_AND      -> List(ALU_AND, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_OR       -> List(ALU_OR, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_XOR      -> List(ALU_XOR, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_SLL      -> List(ALU_SLL, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_SLLW     -> List(ALU_SLL, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_SRL      -> List(ALU_SRL, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_SRLW     -> List(ALU_SRL, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_SRA      -> List(ALU_SRA, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_SRAW     -> List(ALU_SRA, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_SLT      -> List(ALU_SLT, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    R_SLTU     -> List(ALU_SLT, SRCA_REG, SRCB_REG, MEM_X, REG_S, WB_ALU, CSR_X),
    I_ADDI     -> List(ALU_ADD, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_ADDIW    -> List(ALU_ADD, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_ANDI     -> List(ALU_AND, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_ANDI     -> List(ALU_AND, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_ORI      -> List(ALU_OR, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_XORI     -> List(ALU_XOR, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_SLLI     -> List(ALU_SLL, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_SLLIW    -> List(ALU_SLL, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_SRLI     -> List(ALU_SRL, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_SRLIW    -> List(ALU_SRL, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_SRAI     -> List(ALU_SRA, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_SRAIW    -> List(ALU_SRA, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_SLTI     -> List(ALU_SLT, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_SLTIU    -> List(ALU_SLT, SRCA_REG, SRCB_IMM_I, MEM_X, REG_S, WB_ALU, CSR_X),
    I_LB       -> List(ALU_ADD, SRCA_REG, SRCB_IMM_I, MEM_LB, REG_S, WB_MEM, CSR_X),
    I_LBU      -> List(ALU_ADD, SRCA_REG, SRCB_IMM_I, MEM_LBU, REG_S, WB_MEM, CSR_X),
    I_LH       -> List(ALU_ADD, SRCA_REG, SRCB_IMM_I, MEM_LH, REG_S, WB_MEM, CSR_X),
    I_LHU      -> List(ALU_ADD, SRCA_REG, SRCB_IMM_I, MEM_LHU, REG_S, WB_MEM, CSR_X),
    I_LW       -> List(ALU_ADD, SRCA_REG, SRCB_IMM_I, MEM_LW, REG_S, WB_MEM, CSR_X),
    I_LWU      -> List(ALU_ADD, SRCA_REG, SRCB_IMM_I, MEM_LWU, REG_S, WB_MEM, CSR_X),
    I_LD       -> List(ALU_ADD, SRCA_REG, SRCB_IMM_I, MEM_LD, REG_S, WB_MEM, CSR_X),
    S_SB       -> List(ALU_ADD, SRCA_REG, SRCB_IMM_S, MEM_SB, REG_X, WB_X, CSR_X),
    S_SH       -> List(ALU_ADD, SRCA_REG, SRCB_IMM_S, MEM_SH, REG_X, WB_X, CSR_X),
    S_SW       -> List(ALU_ADD, SRCA_REG, SRCB_IMM_S, MEM_SW, REG_X, WB_X, CSR_X),
    S_SD       -> List(ALU_ADD, SRCA_REG, SRCB_IMM_S, MEM_SD, REG_X, WB_X, CSR_X),
    B_BEQ      -> List(BR_BEQ, SRCA_REG, SRCB_REG, MEM_X, REG_X, WB_X, CSR_X),
    B_BGE      -> List(BR_BGE, SRCA_REG, SRCB_REG, MEM_X, REG_X, WB_X, CSR_X),
    B_BGEU     -> List(BR_BGEU, SRCA_REG, SRCB_REG, MEM_X, REG_X, WB_X, CSR_X),
    B_BLT      -> List(BR_BLT, SRCA_REG, SRCB_REG, MEM_X, REG_X, WB_X, CSR_X),
    B_BLTU     -> List(BR_BLTU, SRCA_REG, SRCB_REG, MEM_X, REG_X, WB_X, CSR_X),
    B_BNE      -> List(BR_BNE, SRCA_REG, SRCB_REG, MEM_X, REG_X, WB_X, CSR_X),
    J_JAL      -> List(ALU_ADD, SRCA_PC, SRCB_IMM_J, MEM_X, REG_S, WB_PC, CSR_X),
    I_JALR     -> List(ALU_JALR, SRCA_PC, SRCB_IMM_J, MEM_X, REG_S, WB_PC, CSR_X),
    U_AUIPC    -> List(ALU_ADD, SRCA_PC, SRCB_IMM_U, MEM_X, REG_S, WB_ALU, CSR_X),
    U_LUI      -> List(ALU_ADD, SRCA_X, SRCB_IMM_U, MEM_X, REG_S, WB_ALU, CSR_X),
    EBREAK     -> List(ALU_X, SRCA_X, SRCB_X, MEM_X, REG_X, WB_X, CSR_E),
    ECALL      -> List(ALU_X, SRCA_X, SRCB_X, MEM_X, REG_X, WB_X, CSR_E)
  ))

  val alu_exe_fun :: srcAType :: srcBtype :: memType :: regType :: wbType :: csrType :: Nil = controlSignals

  val srcAdata = MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (srcAType === SRCA_REG) -> regA_data,
    (srcAType === SRCA_IMM_Z) -> imm_z_uext,
    (srcAType === SRCA_PC) -> io.cur_pc
  ))

  val srcBdata = MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (srcBtype === SRCB_REG) -> regB_data,
    (srcBtype === SRCB_IMM_I) -> imm_i_sext,
    (srcBtype === SRCB_IMM_J) -> imm_j_sext,
    (srcBtype === SRCB_IMM_U) -> imm_u_shifted,
    (srcBtype === SRCB_IMM_S) -> imm_s_sext
  ))

  val csr_addr = Mux(csrType === CSR_E, 0x342.U(CSR_ADDR_LEN_WIDTH), de_inst(31, 20))

  io.srcOut.aluSrc_a := srcAdata
  io.srcOut.aluSrc_b := srcBdata
  io.srcOut.regB_data := regB_data
  io.srcOut.writeback_addr := write_back_reg_addr

  io.decodeOut.csrAddr := csr_addr
  io.decodeOut.alu_exe_fun := alu_exe_fun
  io.decodeOut.memType := memType
  io.decodeOut.regType := regType
  io.decodeOut.wbType := wbType
  io.decodeOut.CSRType := csrType

  io.pcOut := io.cur_pc

  // branch
  val branch_flag = MuxCase(false.asBool, Seq(
    (alu_exe_fun === BR_BEQ) -> (srcAdata === srcBdata).asBool,
    (alu_exe_fun === BR_BNE) -> (srcAdata =/= srcBdata).asBool,
    (alu_exe_fun === BR_BLTU) -> (srcAdata < srcBdata).asBool,
    (alu_exe_fun === BR_BLT) -> (srcAdata.asSInt < srcBdata.asSInt).asBool,
    (alu_exe_fun === BR_BGEU) -> (srcAdata >= srcBdata).asBool,
    (alu_exe_fun === BR_BGE) -> (srcAdata.asSInt >= srcBdata.asSInt).asBool
  ))
  val branchTarget = imm_b_sext + io.cur_pc
  io.branch.branchFlag := branch_flag
  io.branch.branchTarget := branchTarget
}
