package rainy.shaheway.org
package core.clint
import chisel3._
import rainy.shaheway.org.common.Defines.{DOUBLE_WORD_LEN_WIDTH, WORD_LEN_WIDTH}
class ClintWithIFID extends Bundle{
  // Interrupt signals from peripherals
  val interruptFlag = Input(UInt(DOUBLE_WORD_LEN_WIDTH)) // 64bit, from if_to_id
  // Current instruction from instruction decode
  val cur_instruction = Input(UInt(WORD_LEN_WIDTH)) // from if_to_de
}
