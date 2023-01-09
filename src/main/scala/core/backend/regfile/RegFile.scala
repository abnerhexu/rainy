package rainy.shaheway.org
package core.backend.regfile

import chisel3._
import common.Defines.{DOUBLE_WORD_LEN_WIDTH, REG_ADDR_WIDTH}
class RegFile extends Module {
  val io = IO(new Bundle() {
    val reg_read = new RegReadPort
    val reg_write = new RegWritePort
    val display = new RegDisplay
  })
  val registers = Mem(32, UInt(DOUBLE_WORD_LEN_WIDTH))
  registers.write(19.U(5.W), io.display.in)
  io.display.out := registers.read(8.U(5.W))
  io.display.startFlag := (registers.read(11.U(5.W)) === 1.U(64.W))
  io.reg_read.read_data_a := Mux(io.reg_read.read_addr_a === 0.U(REG_ADDR_WIDTH), 0.U(DOUBLE_WORD_LEN_WIDTH), registers.read(io.reg_read.read_addr_a))
  io.reg_read.read_data_b := Mux(io.reg_read.read_addr_b === 0.U(REG_ADDR_WIDTH), 0.U(DOUBLE_WORD_LEN_WIDTH), registers.read(io.reg_read.read_addr_b))
  when(io.reg_write.write_enable){
    registers.write(idx = io.reg_write.write_addr, data = io.reg_write.write_data)
  }
}
