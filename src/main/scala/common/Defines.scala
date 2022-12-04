package rainy.shaheway.org
package common
import chisel3._
import chisel3.util.BitPat
object Defines {
  val WORD_LEN_WIDTH                  = 32.W
  val DOUBLE_WORD_LEN                 = 64
  val DOUBLE_WORD_LEN_WIDTH           = 64.W
  val START_ADDR                      = 0x10004000.U(DOUBLE_WORD_LEN_WIDTH)
  val BYTE_LEN_WIDTH                  = 8.W
  val REG_ADDR_WIDTH                  = 5.W
  val CSR_ADDR_LEN_WIDTH               = 12.W
  val BUBBLE = 0x13000000.U(WORD_LEN_WIDTH) // ADDI x0, x0, 0

  val ALU_EXE_FUN_LEN = 5.W
  val ALU_X = 0.U(ALU_EXE_FUN_LEN)
  val ALU_ADD = 1.U(ALU_EXE_FUN_LEN)
  val ALU_SUB = 2.U(ALU_EXE_FUN_LEN)
  val ALU_AND = 3.U(ALU_EXE_FUN_LEN)
  val ALU_OR = 4.U(ALU_EXE_FUN_LEN)
  val ALU_XOR = 5.U(ALU_EXE_FUN_LEN)
  val ALU_SLL = 6.U(ALU_EXE_FUN_LEN)
  val ALU_SRL = 7.U(ALU_EXE_FUN_LEN)
  val ALU_SRA = 8.U(ALU_EXE_FUN_LEN)
  val ALU_SLT = 9.U(ALU_EXE_FUN_LEN)
  val ALU_SLTU = 10.U(ALU_EXE_FUN_LEN)
  val ALU_JALR = 11.U(ALU_EXE_FUN_LEN)
  val ALU_NOP_CSR = 12.U(ALU_EXE_FUN_LEN)
  val BR_BEQ = 13.U(ALU_EXE_FUN_LEN)
  val BR_BNE = 14.U(ALU_EXE_FUN_LEN)
  val BR_BLTU = 15.U(ALU_EXE_FUN_LEN)
  val BR_BGEU = 16.U(ALU_EXE_FUN_LEN)
  val BR_BLT = 17.U(ALU_EXE_FUN_LEN)
  val BR_BGE = 18.U(ALU_EXE_FUN_LEN)

  // op_src_A
  val SRCA_LEN  = 2.W
  val SRCA_X     = 0.U(SRCA_LEN)
  val SRCA_REG   = 1.U(SRCA_LEN)
  val SRCA_IMM_Z = 2.U(SRCA_LEN)
  val SRCA_PC    = 3.U(SRCA_LEN)

  // op_src_B
  val SRCB_LEN = 3.W
  val SRCB_X = 0.U(SRCB_LEN)
  val SRCB_REG = 1.U(SRCB_LEN)
  val SRCB_IMM_I = 2.U(SRCB_LEN)
  val SRCB_IMM_J = 3.U(SRCB_LEN)
  val SRCB_IMM_S = 4.U(SRCB_LEN)
  val SRCB_IMM_U = 5.U(SRCB_LEN)

  // mem type
  val MEM_TYPE_LEN = 4.W
  val MEM_X = 0.U(MEM_TYPE_LEN)
  val MEM_SB = 4.U(MEM_TYPE_LEN)
  val MEM_SH = 5.U(MEM_TYPE_LEN)
  val MEM_SW = 6.U(MEM_TYPE_LEN)
  val MEM_SD = 7.U(MEM_TYPE_LEN)
  val MEM_V = 1.U(MEM_TYPE_LEN)
  val MEM_LB = 8.U(MEM_TYPE_LEN)
  val MEM_LBU = 9.U(MEM_TYPE_LEN)
  val MEM_LH = 10.U(MEM_TYPE_LEN)
  val MEM_LHU = 11.U(MEM_TYPE_LEN)
  val MEM_LW = 12.U(MEM_TYPE_LEN)
  val MEM_LWU = 13.U(MEM_TYPE_LEN)
  val MEM_LD = 14.U(MEM_TYPE_LEN)

  // reg type
  val REG_TYPE_LEN = 2.W
  val REG_X = 0.U(REG_TYPE_LEN)
  val REG_S = 1.U(REG_TYPE_LEN)
  val REG_V = 2.U(REG_TYPE_LEN)

  // wb type (where the writeback data come from)
  val WB_TYPE_LEN = 3.W
  val WB_X = 0.U(WB_TYPE_LEN)
  val WB_ALU = 1.U(WB_TYPE_LEN)
  val WB_MEM = 2.U(WB_TYPE_LEN)
  val WB_PC = 3.U(WB_TYPE_LEN)
  val WB_CSR = 4.U(WB_TYPE_LEN)
  val WB_MEM_V = 5.U(WB_TYPE_LEN)
  val WB_ALU_V = 6.U(WB_TYPE_LEN)
  val WB_VL = 7.U(WB_TYPE_LEN)

  // CSR type
  val CSR_TYPE_LEN = 3.W
  val CSR_X = 0.U(CSR_TYPE_LEN)
  val CSR_W = 1.U(CSR_TYPE_LEN)
  val CSR_S = 2.U(CSR_TYPE_LEN)
  val CSR_C = 3.U(CSR_TYPE_LEN)
  val CSR_E = 4.U(CSR_TYPE_LEN)
  val CSR_V = 5.U(CSR_TYPE_LEN)

  //AluBMux
  val ALUSRC_MUX_LEN = 2.W
  val ALUSRC_FROM_ID = 0.W
  val ALUSRC_FROM_EX = 1.W
  val ALUSRC_FROM_MEA = 2.W
}
