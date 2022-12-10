package rainy.shaheway.org
package mem
import chisel3._
import chisel3.util._
import common.Defines.{BYTE_LEN_WIDTH, DOUBLE_WORD_LEN_WIDTH, MEM_SB, MEM_SD, MEM_SH, MEM_SW}

import chisel3.util.experimental.loadMemoryFromFileInline
class Memory extends Module {
  val io = IO(new Bundle() {
    val instReadPort = new InstReadPort
    val dataReadPort = new DataReadPort
    val writePort = new MemWritePort
  })

  val memory = Mem(4096, UInt(BYTE_LEN_WIDTH)) // 32KB Memory
  loadMemoryFromFileInline(memory, "memoryFile.hex")
  io.instReadPort.read_inst_a := Cat(memory.read(io.instReadPort.read_addr_a + 3.U(DOUBLE_WORD_LEN_WIDTH)),
    memory.read(io.instReadPort.read_addr_a + 2.U(DOUBLE_WORD_LEN_WIDTH)),
    memory.read(io.instReadPort.read_addr_a + 1.U(DOUBLE_WORD_LEN_WIDTH)),
    memory.read(io.instReadPort.read_addr_a))
  io.dataReadPort.read_data_b := Cat(memory.read(io.instReadPort.read_addr_a + 7.U(DOUBLE_WORD_LEN_WIDTH)),
    memory.read(io.instReadPort.read_addr_a + 6.U(DOUBLE_WORD_LEN_WIDTH)),
    memory.read(io.instReadPort.read_addr_a + 5.U(DOUBLE_WORD_LEN_WIDTH)),
    memory.read(io.instReadPort.read_addr_a + 4.U(DOUBLE_WORD_LEN_WIDTH)),
    memory.read(io.instReadPort.read_addr_a + 3.U(DOUBLE_WORD_LEN_WIDTH)),
    memory.read(io.instReadPort.read_addr_a + 2.U(DOUBLE_WORD_LEN_WIDTH)),
    memory.read(io.instReadPort.read_addr_a + 1.U(DOUBLE_WORD_LEN_WIDTH)),
    memory.read(io.instReadPort.read_addr_a))
  when(io.writePort.write_enable) {
    when(io.writePort.write_lenth === MEM_SB){
      memory.write(idx = io.writePort.write_addr, data = io.writePort.write_data(7, 0))
    }.elsewhen(io.writePort.write_lenth === MEM_SH){
      memory.write(idx = io.writePort.write_addr, data = io.writePort.write_data(7, 0))
      memory.write(idx = io.writePort.write_addr + 1.U(DOUBLE_WORD_LEN_WIDTH), data = io.writePort.write_data(15, 8))
    }.elsewhen(io.writePort.write_lenth === MEM_SW){
      memory.write(idx = io.writePort.write_addr, data = io.writePort.write_data(7, 0))
      memory.write(idx = io.writePort.write_addr + 1.U(DOUBLE_WORD_LEN_WIDTH), data = io.writePort.write_data(15, 8))
      memory.write(idx = io.writePort.write_addr + 2.U(DOUBLE_WORD_LEN_WIDTH), data = io.writePort.write_data(23, 16))
      memory.write(idx = io.writePort.write_addr + 3.U(DOUBLE_WORD_LEN_WIDTH), data = io.writePort.write_data(31, 24))
    }.elsewhen(io.writePort.write_lenth === MEM_SD) {
      memory.write(idx = io.writePort.write_addr, data = io.writePort.write_data(7, 0))
      memory.write(idx = io.writePort.write_addr + 1.U(DOUBLE_WORD_LEN_WIDTH), data = io.writePort.write_data(15, 8))
      memory.write(idx = io.writePort.write_addr + 2.U(DOUBLE_WORD_LEN_WIDTH), data = io.writePort.write_data(23, 16))
      memory.write(idx = io.writePort.write_addr + 3.U(DOUBLE_WORD_LEN_WIDTH), data = io.writePort.write_data(31, 24))
      memory.write(idx = io.writePort.write_addr + 4.U(DOUBLE_WORD_LEN_WIDTH), data = io.writePort.write_data(39, 32))
      memory.write(idx = io.writePort.write_addr + 5.U(DOUBLE_WORD_LEN_WIDTH), data = io.writePort.write_data(47, 40))
      memory.write(idx = io.writePort.write_addr + 6.U(DOUBLE_WORD_LEN_WIDTH), data = io.writePort.write_data(55, 48))
      memory.write(idx = io.writePort.write_addr + 7.U(DOUBLE_WORD_LEN_WIDTH), data = io.writePort.write_data(63, 56))
    }
  }
}
