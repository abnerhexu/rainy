package rainy.shaheway.org
package core.backend.forward
import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH}
class ForwardData extends Module {
  val fromEX = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val fromMema = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val fromDecode = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
  val regSrcAddrA = Input(UInt(REG_ADDR_WIDTH))
  val regSrcAddrB = Input(UInt(REG_ADDR_WIDTH))
  val toAluA = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
  val toAluB = Output(UInt(DOUBLE_WORD_LEN_WIDTH))
}
