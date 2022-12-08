package rainy.shaheway.org
package mem
import chisel3._
import chisel3.util._
import common.Defines.{BYTE_LEN_WIDTH, DOUBLE_WORD_LEN_WIDTH}
class Memory extends Module {
  val io = IO(new Bundle() {
    val instReadPort = new InstReadPort
    val dataReadPort = new DataReadPort
    val writePort = new MemWritePort
  })

  val memory = SyncReadMem(4096, UInt(BYTE_LEN_WIDTH)) // 32KB Memory
  io.instReadPort.read_inst_a := memory.read(io.instReadPort.read_addr_a)
  io.dataReadPort.read_data_b := memory.read(io.dataReadPort.read_addr_b)
  when(io.writePort.write_enable) {
    memory.write(idx = io.writePort.write_addr, data = io.writePort.write_data)
  }
}
