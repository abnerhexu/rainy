package rainy.shaheway.org
package mem
import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, WORD_LEN_WIDTH}
class InstReadPort extends Bundle {
  // read data and instructions from memory - I/O connection
  val read_addr_a = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val read_inst_a = Output(UInt(WORD_LEN_WIDTH))
}
