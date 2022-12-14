package rainy.shaheway.org
package core.backend.alu

import chisel3._
import chisel3.util.{Cat, Fill}
import common.Defines._

import chisel3.util.MuxCase
import core.backend.decode.{ControlOutPort, SrcOutPort}
import core.backend.datahazard.{ForwardWithExecute, StallWithEX}

class Alu extends Module {
  val io = IO(new Bundle() {
    val cur_pc = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val linkedPC = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
    val alu_in = Flipped(new SrcOutPort)
    val alu_out = new AluOutPort
    val controlPass = new AluConOut
    val controlSignal = Flipped(new ControlOutPort)
    val forward = Flipped(new ForwardWithExecute)
    val stall = Flipped(new StallWithEX)
    // probe
    val srcA = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
    val srcB = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  })
  val inv_one = Cat(Fill(DOUBLE_WORD_LEN-1, 1.U(1.W)), 0.U(1.U))
  val aluSrc_a = io.alu_in.aluSrc_a
  val aluSrc_b = io.alu_in.aluSrc_b
  val alu_out = MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (io.controlSignal.alu_exe_fun === ALU_ADD) -> (aluSrc_a+aluSrc_b),
    (io.controlSignal.alu_exe_fun === ALU_SUB) -> (aluSrc_a-aluSrc_b),
    (io.controlSignal.alu_exe_fun === ALU_AND) -> (aluSrc_a & aluSrc_b),
    (io.controlSignal.alu_exe_fun === ALU_OR)  -> (aluSrc_a | aluSrc_b),
    (io.controlSignal.alu_exe_fun === ALU_XOR) -> (aluSrc_a ^ aluSrc_b),
    (io.controlSignal.alu_exe_fun === ALU_SLL) -> (aluSrc_a << aluSrc_b(4, 0)).asUInt,
    (io.controlSignal.alu_exe_fun === ALU_SRL) -> (aluSrc_a >> aluSrc_b(4, 0)).asUInt,
    (io.controlSignal.alu_exe_fun === ALU_SRA) -> (aluSrc_a.asSInt >> aluSrc_b(4, 0)).asUInt,
    (io.controlSignal.alu_exe_fun === ALU_SLT) -> (aluSrc_a.asSInt < aluSrc_b.asSInt).asUInt,
    (io.controlSignal.alu_exe_fun === ALU_SLTU) -> (aluSrc_a.asUInt < aluSrc_b.asUInt).asUInt,
    (io.controlSignal.alu_exe_fun === ALU_JALR) -> ((aluSrc_a+aluSrc_b) & inv_one),
    (io.controlSignal.alu_exe_fun === ALU_NOP_CSR) -> (aluSrc_a)
  ))
  /*
  val is_zero = (alu_out & Cat(Fill(DOUBLE_WORD_LEN, 1.U(1.W)))).asBool
  io.alu_out.alu_result := alu_out
  io.alu_out.is_zero := is_zero
   */



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
  io.alu_out.jumpFlag := jump_flag
  io.alu_out.jumpTarget := alu_out

  // data hazard
//  val aluOutReg = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
//  aluOutReg := alu_out
  io.forward.wbDataFromExe := alu_out
  io.forward.wbAddrFromExecute := io.alu_in.writeback_addr
  io.forward.regTypeFromExecute := io.controlSignal.regType

//  io.stall.wbSrcFromEx := io.controlSignal.wbType
//  io.stall.wbAddrFromEx := io.alu_in.writeback_addr
  io.stall.wbAddrFromEx := io.alu_in.writeback_addr
  io.stall.wbSrcFromEx := io.controlSignal.wbType
  // probe
  io.srcA := aluSrc_a
  io.srcB := aluSrc_b
}
