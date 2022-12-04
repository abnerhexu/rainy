package rainy.shaheway.org
package mem
import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, MEM_TYPE_LEN, REG_ADDR_WIDTH}
class DataReadPort extends Bundle {
  // read data and instructions from memory - I/O connection
  val read_addr_b = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val read_data_b = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
