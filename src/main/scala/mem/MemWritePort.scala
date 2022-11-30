package rainy.shaheway.org
package mem
import chisel3._
import common.Defines.DOUBLE_WORD_LEN_WIDTH
class MemWritePort extends Bundle {
  // write data to memory - I/O connection
  val write_addr = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val write_data = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val write_enable = Input(Bool())
}