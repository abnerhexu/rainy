package rainy.shaheway.org
package core.backend.pipereg
import chisel3._
import core.backend.mema.MemaOutPort

import rainy.shaheway.org.common.Defines.{CSR_ADDR_LEN_WIDTH, CSR_TYPE_LEN, DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH, REG_TYPE_LEN}

class MemaToWB extends Module {
  val io = IO(new Bundle() {
    val wbinfo = Flipped(new MemaOutPort)
    val wbinfoPass = new MemaOutPort
  })

  val writeback_addr = RegInit(0.U(REG_ADDR_WIDTH))
  writeback_addr := io.wbinfo.writeback_addr
  val writeback_data = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  writeback_data := io.wbinfo.writeback_data
  val regwrite_enable = RegInit(0.U(REG_TYPE_LEN))
  regwrite_enable := io.wbinfo.regwrite_enable
  val csrwrite_addr = RegInit(0.U(CSR_ADDR_LEN_WIDTH))
  csrwrite_addr := io.wbinfo.csrwrite_addr
  val csrwrite_data = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  csrwrite_data := io.wbinfo.csrwrite_data
  val CSRType = RegInit(0.U(CSR_TYPE_LEN))
  CSRType := io.wbinfo.CSRType

  io.wbinfoPass.writeback_addr := writeback_addr
  io.wbinfoPass.writeback_data := writeback_data
  io.wbinfoPass.regwrite_enable := regwrite_enable
  io.wbinfoPass.csrwrite_addr := csrwrite_addr
  io.wbinfoPass.csrwrite_data := csrwrite_data
  io.wbinfoPass.CSRType := CSRType
}
