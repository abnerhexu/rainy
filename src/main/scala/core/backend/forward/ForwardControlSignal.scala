package rainy.shaheway.org
package core.backend.forward
import chisel3._
import common.Defines._
class ForwardControlSignal extends Bundle {
  val exTomem_wbType = Input(UInt(WB_TYPE_LEN))
  val memTowb_wbType = Input(UInt(WB_TYPE_LEN))
  val aluBmux = Output(UInt(ALUSRC_MUX_LEN))
  val aluAmux = Output(UInt(ALUSRC_MUX_LEN))
}
