package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines._

import chisel3.util.MuxCase
import core.backend.regfile.RegReadPort
class Forward extends Module {
  val io = IO(new Bundle() {
    val withDecode = new ForwardWithDecode
    val withExecute = new ForwardWithExecute
    val withMema = new ForwardWithMema
    val regReadPort = Flipped(new RegReadPort)
  })

  val hazardAType = MuxCase(DATA_NO_HAZARD, Seq(
    ((io.withDecode.srcAddrA === io.withExecute.wbAddrFromExecute) && (io.withExecute.regTypeFromExecute === REG_S)) -> io.withExecute.wbDataFromExe,
    ((io.withDecode.srcAddrA === io.withMema.wbAddrFromMema) && (io.withMema.regTypeFromMema === REG_S)) -> io.withMema.wbDataFromMema
  ))
  val hazardBType = MuxCase(DATA_NO_HAZARD, Seq(
    ((io.withDecode.srcAddrB === io.withExecute.wbAddrFromExecute) && (io.withExecute.regTypeFromExecute === REG_S)) -> io.withExecute.wbDataFromExe,
    ((io.withDecode.srcAddrB === io.withMema.wbAddrFromMema) && (io.withMema.regTypeFromMema === REG_S)) -> io.withMema.wbDataFromMema
  ))

  io.regReadPort.read_addr_a := io.withDecode.srcAddrA
  val srcDataA = Mux(io.withDecode.srcAddrA === 0.U(REG_ADDR_WIDTH), 0.U(DOUBLE_WORD_LEN_WIDTH), io.regReadPort.read_data_a)
  io.regReadPort.read_addr_b := io.withDecode.srcAddrB
  val srcDataB = Mux(io.withDecode.srcAddrB === 0.U(REG_ADDR_WIDTH), 0.U(DOUBLE_WORD_LEN_WIDTH), io.regReadPort.read_data_b)

  io.withDecode.hazardAData := MuxCase(srcDataA, Seq(
    (hazardAType === DATA_FROM_EXE) -> io.withExecute.wbDataFromExe,
    (hazardAType === DATA_FROM_MEA) -> io.withMema.wbDataFromMema
  ))
  io.withDecode.hazardBData := MuxCase(srcDataB, Seq(
    (hazardBType === DATA_FROM_EXE) -> io.withExecute.wbDataFromExe,
    (hazardBType === DATA_FROM_MEA) -> io.withMema.wbDataFromMema
  ))
}
