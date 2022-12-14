package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import rainy.shaheway.org.common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH, REG_TYPE_LEN}
class ForwardWithWriteback extends Bundle{
  val wbAddrFromWB = Input(UInt(REG_ADDR_WIDTH))
  val regTypeFromWB = Input(UInt(REG_TYPE_LEN))
  val wbDataFromWB = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
}
