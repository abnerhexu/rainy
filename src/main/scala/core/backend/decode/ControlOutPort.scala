package rainy.shaheway.org
package core.backend.decode
import chisel3._
import common.Defines.{ALU_EXE_FUN_LEN, CSR_ADDR_LEN_WIDTH, CSR_TYPE_LEN, MEM_TYPE_LEN, REG_TYPE_LEN, WB_TYPE_LEN}
class ControlOutPort extends Bundle {
  val alu_exe_fun = Output(UInt(ALU_EXE_FUN_LEN))
  val memType = Output(UInt(MEM_TYPE_LEN))
  val regType = Output(UInt(REG_TYPE_LEN))
  val wbType = Output(UInt(WB_TYPE_LEN))
  val CSRType = Output(UInt(CSR_TYPE_LEN))
  val csrAddr = Output(UInt(CSR_ADDR_LEN_WIDTH))
}
