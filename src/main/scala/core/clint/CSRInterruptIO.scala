package rainy.shaheway.org
package core.clint
import chisel3._
import common.Defines.{CSR_ADDR_LEN_WIDTH, DOUBLE_WORD_LEN_WIDTH}
class CSRInterruptIO extends Bundle {
  val mtvec_read_data = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val mtvec_read_addr = Output(UInt(CSR_ADDR_LEN_WIDTH))
  val mcause_write_addr = Output(UInt(CSR_ADDR_LEN_WIDTH))
  val mcause_write_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val mepc_write_addr = Output(UInt(CSR_ADDR_LEN_WIDTH))
  val mepc_write_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val mtval_write_addr = Output(UInt(CSR_ADDR_LEN_WIDTH))
  val mtval_write_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val mstatus_update_addr = Output(UInt(CSR_ADDR_LEN_WIDTH))
  val mstatus_update_flag = Output(Bool())
  val enable = Output(Bool())
}
