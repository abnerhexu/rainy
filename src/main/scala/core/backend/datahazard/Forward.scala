package rainy.shaheway.org
package core.backend.datahazard
import chisel3._
import common.Defines._

import chisel3.util.MuxCase
class Forward extends Module {
  val io = IO(new Bundle() {
    val withDecode = new ForwardWithDecode
    val withExecute = new ForwardWithExecute
    val withMema = new ForwardWithMema
    // probe
    val probe_typeA = Output(UInt(DATAHAZARD_LEN))
  })

  val hazardAType = MuxCase(DATA_NO_HAZARD, Seq(
    ((io.withDecode.srcAddrA === io.withExecute.wbAddrFromExecute) && (io.withExecute.regTypeFromExecute === REG_S)) -> DATA_FROM_EXE,
    ((io.withDecode.srcAddrA === io.withMema.wbAddrFromMema) && (io.withMema.regTypeFromMema === REG_S)) -> DATA_FROM_MEA
  ))
  val hazardBType = MuxCase(DATA_NO_HAZARD, Seq(
    ((io.withDecode.srcAddrB === io.withExecute.wbAddrFromExecute) && (io.withExecute.regTypeFromExecute === REG_S)) -> DATA_FROM_EXE,
    ((io.withDecode.srcAddrB === io.withMema.wbAddrFromMema) && (io.withMema.regTypeFromMema === REG_S)) -> DATA_FROM_MEA
  ))


  val hazardADataMux = MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (hazardAType === DATA_FROM_EXE) -> io.withExecute.wbDataFromExe,
    (hazardAType === DATA_FROM_MEA) -> io.withMema.wbDataFromMema
  ))
  val hazardAData = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  hazardAData := hazardADataMux
  io.withExecute.hazardAData := hazardAData

  val hazardBDataMux = MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (hazardBType === DATA_FROM_EXE) -> io.withExecute.wbDataFromExe,
    (hazardBType === DATA_FROM_MEA) -> io.withMema.wbDataFromMema
  ))
  val hazardBData = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  hazardBData := hazardBDataMux
  io.withExecute.hazardBData := hazardBData

  val AhazardFlag = RegInit(false.asBool)
  AhazardFlag := hazardAType === DATA_FROM_EXE || hazardAType === DATA_FROM_MEA
  io.withExecute.AhazardFlag := AhazardFlag
  val BhazardFlag = RegInit(false.asBool)
  BhazardFlag := hazardBType === DATA_FROM_EXE || hazardBType === DATA_FROM_MEA
  io.withExecute.BhazardFlag := AhazardFlag

  // probe
  io.probe_typeA := hazardAType
}
