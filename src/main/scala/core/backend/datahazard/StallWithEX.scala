package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines.{REG_ADDR_WIDTH, REG_TYPE_LEN}
class StallWithEX extends Bundle{
  val wbAddrFromEx = Input(UInt(REG_ADDR_WIDTH))
  val wbSrcFromEx = Input(UInt(REG_TYPE_LEN))
}
