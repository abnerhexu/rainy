package rainy.shaheway.org
package core.backend.regfile

import chisel3._
import common.Defines.DOUBLE_WORD_LEN_WIDTH
class RegFile extends Module {
  val io = IO(new Bundle() {
    val reg_read = new RegReadPort
    val reg_write = new RegWritePort
  })

  val registers = Mem(32, UInt(DOUBLE_WORD_LEN_WIDTH))
  io.reg_read.read_data_a := registers.read(io.reg_read.read_addr_a)
  io.reg_read.read_data_b := registers.read(io.reg_read.read_addr_b)
  when(io.reg_write.write_enable){
    registers.write(idx = io.reg_write.write_addr, data = io.reg_write.write_data)
  }
}
