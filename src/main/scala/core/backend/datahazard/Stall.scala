package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines.{REG_ADDR_WIDTH, REG_S, REG_TYPE_LEN, WB_MEM}
class Stall extends Module {
  val io = IO(new Bundle() {
    val withIDDE = new StallWithIDDE
    val withEX = new StallWithEX
    // val withExe = new StallWithExe
    val stallFlag = Output(Bool())
  })

  val rsADatahazard = (io.withEX.wbSrcFromEx === WB_MEM) && (io.withIDDE.srcAddrA =/= 0.U) && (io.withIDDE.srcAddrA === io.withEX.wbAddrFromEx)
  val rsBDatahazard = (io.withEX.wbSrcFromEx === WB_MEM) && (io.withIDDE.srcAddrB =/= 0.U) && (io.withIDDE.srcAddrB === io.withEX.wbAddrFromEx)
  val stallFlag = rsADatahazard || rsBDatahazard

  io.stallFlag := stallFlag
}
