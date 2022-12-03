package rainy.shaheway.org
package core.backend.regfile
import chisel3._
import common.Defines.DOUBLE_WORD_LEN_WIDTH
class CSRfile extends Module {
  val io = IO(new Bundle() {
    val csrRead = new CSRReadPort
    val csrWrite = new CSRWritePort
  })

  val CSRregisters = Mem(4096, UInt(DOUBLE_WORD_LEN_WIDTH))
  io.csrRead.csr_read_data := CSRregisters.read(io.csrRead.csr_read_addr)
  when(io.csrWrite.csr_write_enable){
    CSRregisters.write(io.csrWrite.csr_write_addr, io.csrWrite.csr_write_data)
  }
}
