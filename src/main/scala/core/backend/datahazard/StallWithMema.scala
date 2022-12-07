package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines.{REG_ADDR_WIDTH, REG_TYPE_LEN}
class StallWithMema extends Bundle{
  val wbAddrFromMema = Input(UInt(REG_ADDR_WIDTH))
  val regTypeFromMema = Input(UInt(REG_TYPE_LEN))
}
