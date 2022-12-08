package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines.{REG_ADDR_WIDTH, REG_TYPE_LEN, REG_S}
class Stall extends Module {
  val io = IO(new Bundle() {
    val withDecode = new StallWithDecode
    val withMema = new StallWithMema
    val stallFlag = Output(Bool())
  })

  val rsADatahazard = (io.withMema.regTypeFromMema === REG_S) && (io.withDecode.srcAddrA =/= 0.U) && (io.withDecode.srcAddrA === io.withMema.wbAddrFromMema)
  val rsBDatahazard = (io.withMema.regTypeFromMema === REG_S) && (io.withDecode.srcAddrB =/= 0.U) && (io.withDecode.srcAddrB === io.withMema.wbAddrFromMema)
  val stallFlag = rsADatahazard || rsBDatahazard
  val stallFlagReg = RegNext(false.asBool, stallFlag)

  io.stallFlag := stallFlagReg
}
