package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH, REG_TYPE_LEN}
class ForwardWithExecute extends Bundle {
  val wbAddrFromExecute = Input(UInt(REG_ADDR_WIDTH))
  val regTypeFromExecute = Input(UInt(REG_TYPE_LEN))
  val wbDataFromExe = Input(UInt(DOUBLE_WORD_LEN_WIDTH))

}
