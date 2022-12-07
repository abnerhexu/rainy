package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines.REG_ADDR_WIDTH
class StallWithDecode extends Bundle{
  val srcAddrA = Input(UInt(REG_ADDR_WIDTH))
  val srcAddrB = Input(UInt(REG_ADDR_WIDTH))
}
