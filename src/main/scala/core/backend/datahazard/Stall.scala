package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines.{REG_ADDR_WIDTH, REG_S, REG_TYPE_LEN, WB_MEM}
class Stall extends Module {
  val io = IO(new Bundle() {
    val withDecode = new StallWithIDDE
    val withIDEX = new StallWithIDEX
    // val withExe = new StallWithExe
    val stallFlag = Output(Bool())
  })

  val rsADatahazard = (io.withIDEX.wbSrcFromEx === WB_MEM) && (io.withDecode.srcAddrA =/= 0.U) && (io.withDecode.srcAddrA === io.withIDEX.wbAddrFromEx)
  val rsBDatahazard = (io.withIDEX.wbSrcFromEx === WB_MEM) && (io.withDecode.srcAddrB =/= 0.U) && (io.withDecode.srcAddrB === io.withIDEX.wbAddrFromEx)
  val stallFlag = rsADatahazard || rsBDatahazard
  // val stallFlagReg = RegInit(false.asBool)
  // stallFlagReg := stallFlag

  io.stallFlag := stallFlag
}
