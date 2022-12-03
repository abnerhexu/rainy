package rainy.shaheway.org
package mem
import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH}
class InstReadPort extends Bundle {
  // read data and instructions from memory - I/O connection
  val read_addr_a = Input(UInt(REG_ADDR_WIDTH))
  val read_data_a = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
