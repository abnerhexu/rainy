package rainy.shaheway.org
package core.backend.alu

import chisel3._
import chisel3.util.{Cat, Fill}
import common.Defines._
import chisel3.util.MuxCase

class Alu extends Module {
  val io = IO(new Bundle() {
    val alu_in = new AluInPort
    val alu_out = new AluOutPort
  })
  val inv_one = Cat(Fill(DOUBLE_WORD_LEN-1, 1.U(1.W)), 0.U(1.U))
  val alu_out = MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (io.alu_in.alu_op === ALU_ADD) -> (io.alu_in.aluSrc_a+io.alu_in.aluSrc_b),
    (io.alu_in.alu_op === ALU_SUB) -> (io.alu_in.aluSrc_a-io.alu_in.aluSrc_b),
    (io.alu_in.alu_op === ALU_AND) -> (io.alu_in.aluSrc_a & io.alu_in.aluSrc_b),
    (io.alu_in.alu_op === ALU_OR)  -> (io.alu_in.aluSrc_a | io.alu_in.aluSrc_b),
    (io.alu_in.alu_op === ALU_XOR) -> (io.alu_in.aluSrc_a ^ io.alu_in.aluSrc_b),
    (io.alu_in.alu_op === ALU_SLL) -> (io.alu_in.aluSrc_a << io.alu_in.aluSrc_b(4, 0)).asUInt,
    (io.alu_in.alu_op === ALU_SRL) -> (io.alu_in.aluSrc_a >> io.alu_in.aluSrc_b(4, 0)).asUInt,
    (io.alu_in.alu_op === ALU_SRA) -> (io.alu_in.aluSrc_a.asSInt >> io.alu_in.aluSrc_b(4, 0)).asUInt,
    (io.alu_in.alu_op === ALU_SLT) -> (io.alu_in.aluSrc_a.asSInt < io.alu_in.aluSrc_b.asSInt).asUInt,
    (io.alu_in.alu_op === ALU_SLTU) -> (io.alu_in.aluSrc_a.asUInt < io.alu_in.aluSrc_b.asUInt).asUInt,
    (io.alu_in.alu_op === ALU_JALR) -> ((io.alu_in.aluSrc_a+io.alu_in.aluSrc_b) & inv_one),
    (io.alu_in.alu_op === ALU_NOP_CSR) -> (io.alu_in.aluSrc_a)
  ))
  val is_zero = (alu_out & Cat(Fill(DOUBLE_WORD_LEN, 1.U(1.W)))).asBool
  io.alu_out.alu_result := alu_out
  io.alu_out.is_zero := is_zero
}
