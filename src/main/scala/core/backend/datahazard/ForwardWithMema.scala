package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH, REG_TYPE_LEN}

class ForwardWithMema extends Bundle{
  val wbAddrFromMema = Input(UInt(REG_ADDR_WIDTH))
  val regTypeFromMema = Input(UInt(REG_TYPE_LEN))
  val wbDataFromMema = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
}
