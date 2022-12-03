package rainy.shaheway.org
package core.backend.writeback
import chisel3._
import core.backend.mema.MemaOutPort
import core.backend.regfile.{CSRWritePort, RegWritePort}
import common.Defines.{CSR_TYPE_LEN, REG_S}

class WriteBack extends Module {
  val io = IO(new Bundle() {
    val wbinfo = Flipped(new MemaOutPort)
    val regWrite = Flipped(new RegWritePort)
    val csrWrite = Flipped(new CSRWritePort)
  })

  io.regWrite.write_addr := io.wbinfo.writeback_addr
  io.regWrite.write_data := io.wbinfo.writeback_data

  when(io.wbinfo.regwrite_enable === REG_S){
    io.regWrite.write_enable := true.asBool
  }.otherwise{
    io.regWrite.write_enable := false.asBool
  }

  io.csrWrite.csr_write_addr := io.wbinfo.csrwrite_addr
  io.csrWrite.csr_write_data := io.wbinfo.csrwrite_data
  when(io.wbinfo.CSRType > 0.U(CSR_TYPE_LEN)){
    io.csrWrite.csr_write_enable := true.asBool
  }.otherwise{
    io.csrWrite.csr_write_enable := false.asBool
  }
}
