package rainy.shaheway.org
package core.backend.alu

import chisel3._
import chisel3.util.{Cat, Fill}
import common.Defines._

import chisel3.util.MuxCase
import core.backend.decode.{ControlOutPort, SrcOutPort}

import core.backend.datahazard.ForwardWithExecute

class Alu extends Module {
  val io = IO(new Bundle() {
    val cur_pc = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val jumpFlag = Output(Bool())
    val branchFlag = Output(Bool())
    val linkedPC = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
    val branchTarget = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
    val alu_in = new SrcOutPort
    val alu_out = new AluOutPort
    val controlPass = new AluConOut
    val controlSignal = Flipped(new ControlOutPort)
    val dataHazard = Flipped(new ForwardWithExecute)
  })
  val inv_one = Cat(Fill(DOUBLE_WORD_LEN-1, 1.U(1.W)), 0.U(1.U))
  val alu_out = MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (io.controlSignal.alu_exe_fun === ALU_ADD) -> (io.alu_in.aluSrc_a+io.alu_in.aluSrc_b),
    (io.controlSignal.alu_exe_fun === ALU_SUB) -> (io.alu_in.aluSrc_a-io.alu_in.aluSrc_b),
    (io.controlSignal.alu_exe_fun === ALU_AND) -> (io.alu_in.aluSrc_a & io.alu_in.aluSrc_b),
    (io.controlSignal.alu_exe_fun === ALU_OR)  -> (io.alu_in.aluSrc_a | io.alu_in.aluSrc_b),
    (io.controlSignal.alu_exe_fun === ALU_XOR) -> (io.alu_in.aluSrc_a ^ io.alu_in.aluSrc_b),
    (io.controlSignal.alu_exe_fun === ALU_SLL) -> (io.alu_in.aluSrc_a << io.alu_in.aluSrc_b(4, 0)).asUInt,
    (io.controlSignal.alu_exe_fun === ALU_SRL) -> (io.alu_in.aluSrc_a >> io.alu_in.aluSrc_b(4, 0)).asUInt,
    (io.controlSignal.alu_exe_fun === ALU_SRA) -> (io.alu_in.aluSrc_a.asSInt >> io.alu_in.aluSrc_b(4, 0)).asUInt,
    (io.controlSignal.alu_exe_fun === ALU_SLT) -> (io.alu_in.aluSrc_a.asSInt < io.alu_in.aluSrc_b.asSInt).asUInt,
    (io.controlSignal.alu_exe_fun === ALU_SLTU) -> (io.alu_in.aluSrc_a.asUInt < io.alu_in.aluSrc_b.asUInt).asUInt,
    (io.controlSignal.alu_exe_fun === ALU_JALR) -> ((io.alu_in.aluSrc_a+io.alu_in.aluSrc_b) & inv_one),
    (io.controlSignal.alu_exe_fun === ALU_NOP_CSR) -> (io.alu_in.aluSrc_a)
  ))
  /*
  val is_zero = (alu_out & Cat(Fill(DOUBLE_WORD_LEN, 1.U(1.W)))).asBool
  io.alu_out.alu_result := alu_out
  io.alu_out.is_zero := is_zero
   */

  val branch_flag = MuxCase(false.asBool, Seq(
    (io.controlSignal.alu_exe_fun === BR_BEQ) -> (io.alu_in.aluSrc_a === io.alu_in.aluSrc_b).asBool,
    (io.controlSignal.alu_exe_fun === BR_BNE) -> (io.alu_in.aluSrc_a =/= io.alu_in.aluSrc_b).asBool,
    (io.controlSignal.alu_exe_fun === BR_BLTU) -> (io.alu_in.aluSrc_a < io.alu_in.aluSrc_b).asBool,
    (io.controlSignal.alu_exe_fun === BR_BLT) -> (io.alu_in.aluSrc_a.asSInt < io.alu_in.aluSrc_b.asSInt).asBool,
    (io.controlSignal.alu_exe_fun === BR_BGEU) -> (io.alu_in.aluSrc_a >= io.alu_in.aluSrc_b).asBool,
    (io.controlSignal.alu_exe_fun === BR_BGE) -> (io.alu_in.aluSrc_a.asSInt >= io.alu_in.aluSrc_b.asSInt).asBool
  ))

  io.branchFlag := branch_flag
  io.controlPass.regType := io.controlSignal.regType
  io.controlPass.wbType := io.controlSignal.wbType
  io.controlPass.CSRType := io.controlSignal.CSRType
  io.controlPass.csrAddr := io.controlSignal.csrAddr
  io.controlPass.memType := io.controlSignal.memType

  io.linkedPC := io.cur_pc + 4.U(DOUBLE_WORD_LEN_WIDTH)

  io.alu_out.alu_result := alu_out
  io.alu_out.writeback_addr := io.alu_in.writeback_addr
  io.alu_out.regB_data := io.alu_in.regB_data
  val jump_flag = (io.controlSignal.wbType === WB_PC).asBool
  io.jumpFlag := jump_flag

  val branchTarget = io.alu_in.imm_b + io.cur_pc

  // data hazard
  io.dataHazard.wbDataFromExe := alu_out
  io.dataHazard.wbAddrFromExecute := io.alu_in.writeback_addr
  io.dataHazard.regTypeFromExecute := io.controlSignal.regType
}
