package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines.{REG_ADDR_WIDTH, REG_S, REG_TYPE_LEN, WB_MEM}
class Stall extends Module {
  val io = IO(new Bundle() {
    val withDecode = new StallWithDecode
    val withExe = new StallWithExe
    val stallFlag = Output(Bool())
  })

  val rsADatahazard = (io.withExe.wbSrcFromEx === WB_MEM) && (io.withDecode.srcAddrA =/= 0.U) && (io.withDecode.srcAddrA === io.withExe.wbAddrFromEx)
  val rsBDatahazard = (io.withExe.wbSrcFromEx === WB_MEM) && (io.withDecode.srcAddrB =/= 0.U) && (io.withDecode.srcAddrB === io.withExe.wbAddrFromEx)
  val stallFlag = rsADatahazard || rsBDatahazard
  val stallFlagReg = RegInit(false.asBool)
  stallFlagReg := stallFlag

  io.stallFlag := stallFlagReg
}
