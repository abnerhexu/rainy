package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH}

class ForwardWithDecode extends Bundle {
  val srcAddrA = Input(UInt(REG_ADDR_WIDTH))
  val srcAddrB = Input(UInt(REG_ADDR_WIDTH))
  val hazardAData = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val hazardBData = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
