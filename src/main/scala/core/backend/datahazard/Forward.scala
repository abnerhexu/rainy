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
    val withWriteback = new ForwardWithWriteback
    // probe
    val probe_typeA = Output(UInt(DATAHAZARD_LEN))
    val probe_typeB = Output(UInt(DATAHAZARD_LEN))
  })

  val hazardAType = Mux(
    (io.withDecode.srcAddrA === io.withExecute.wbAddrFromExecute) && (io.withExecute.regTypeFromExecute === REG_S), DATA_FROM_EXE, Mux(
      (io.withDecode.srcAddrA === io.withMema.wbAddrFromMema) && (io.withMema.regTypeFromMema === REG_S), DATA_FROM_MEA, Mux(
        (io.withDecode.srcAddrA === io.withWriteback.wbAddrFromWB) && (io.withWriteback.regTypeFromWB === REG_S), DATA_FROM_WB, DATA_NO_HAZARD
      )
    )
  )
  val hazardBType = Mux(
    (io.withDecode.srcAddrB === io.withExecute.wbAddrFromExecute) && (io.withExecute.regTypeFromExecute === REG_S), DATA_FROM_EXE, Mux(
      (io.withDecode.srcAddrB === io.withMema.wbAddrFromMema) && (io.withMema.regTypeFromMema === REG_S), DATA_FROM_MEA, Mux(
        (io.withDecode.srcAddrB === io.withWriteback.wbAddrFromWB) && (io.withWriteback.regTypeFromWB === REG_S), DATA_FROM_WB, DATA_NO_HAZARD
      )
    )
  )

  val hazardADataMux = MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (hazardAType === DATA_FROM_EXE) -> io.withExecute.wbDataFromExe,
    (hazardAType === DATA_FROM_MEA) -> io.withMema.wbDataFromMema,
    (hazardAType === DATA_FROM_WB)  -> io.withWriteback.wbDataFromWB
  ))
  // val hazardAData = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  // hazardAData := hazardADataMux
  io.withDecode.hazardAData := hazardADataMux

  val hazardBDataMux = MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (hazardBType === DATA_FROM_EXE) -> io.withExecute.wbDataFromExe,
    (hazardBType === DATA_FROM_MEA) -> io.withMema.wbDataFromMema,
    (hazardBType === DATA_FROM_WB)  -> io.withWriteback.wbDataFromWB
  ))
  // val hazardBData = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  // hazardBData := hazardBDataMux
  io.withDecode.hazardBData := hazardBDataMux

  // val AhazardFlag = RegInit(false.asBool)
  val AhazardFlag = (hazardAType === DATA_FROM_EXE || hazardAType === DATA_FROM_MEA || hazardAType === DATA_FROM_WB)
  io.withDecode.AhazardFlag := AhazardFlag
  // val BhazardFlag = RegInit(false.asBool)
  val BhazardFlag = (hazardBType === DATA_FROM_EXE || hazardBType === DATA_FROM_MEA || hazardBType === DATA_FROM_WB)
  io.withDecode.BhazardFlag := AhazardFlag

  // probe
  io.probe_typeA := hazardAType
  io.probe_typeB := hazardBType
}
