package rainy.shaheway.org
package core.clint
import chisel3._
import common.Defines.{CSR_ADDR_LEN_WIDTH, DOUBLE_WORD_LEN_WIDTH}
class ClintWithCSR extends Bundle {
  val csr_mtvec = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val csr_mepc = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val csr_mstatus = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  // Is global interrupt enabled? (from MSTATUS)
  val global_interrupt_enabled = Input(Bool())
  val csr_write_enable = Output(Bool())
  val csr_write_addr = Output(UInt(CSR_ADDR_LEN_WIDTH))
  val csr_write_data = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
