package rainy.shaheway.org
package core.backend.decode

import chisel3._
import chisel3.util._
import common.Defines._
import common.Instructions._
class Decode extends Module {
  val io = IO(new Bundle() {
    val inst = Input(UInt(WORD_LEN_WIDTH))
    val alu_exe_fun = Output(UInt(ALU_EXE_FUN_LEN))
    val SrcAType = Output(UInt())
    val SrcBType = Output(UInt())
    val memType = Output(UInt())
    val regType = Output(UInt())
    val wbType = Output(UInt())
    val CSRType = Output(UInt())
  })
  val controlSignals = ListLookup(io.inst, List(ALU_X, SRCA_X, SRCB_X, MEM_X, REG_X, WB_X, CSR_X), Array(
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
  ))
}
