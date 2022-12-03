package rainy.shaheway.org
package core.backend.mema

import common.Defines._
import core.backend.alu.{AluConOut, AluOutPort}
import core.backend.regfile.CSRReadPort
import mem.{DataReadPort, MemWritePort}

import chisel3._
import chisel3.util.{Cat, Fill, MuxCase}

class MemAccess extends Module {
  val io = IO(new Bundle() {
    val aluOut = Flipped(new AluOutPort)
    val controlSignal = Flipped(new AluConOut)
    val dataReadPort = Flipped(new DataReadPort)
    val dataWritePort = Flipped(new MemWritePort)
    val linkedPC = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val csrRead = Flipped(new CSRReadPort)
    val memPass = new MemaOutPort
  })

  // 从CSR寄存器或主存中取数
  io.csrRead.csr_read_addr := io.controlSignal.csrAddr
  io.dataReadPort.read_addr_b := io.dataReadPort.read_addr_b
  val load_data = MuxCase(io.dataReadPort.read_data_b, Seq(
    (io.controlSignal.memType === MEM_LB) -> Cat(Fill(56, io.dataReadPort.read_data_b(7)), io.dataReadPort.read_data_b(7,0)),
    (io.controlSignal.memType === MEM_LBU) -> Cat(Fill(56, 0.U(1.W)), io.dataReadPort.read_data_b(7,0)),
    (io.controlSignal.memType === MEM_LH) -> Cat(Fill(48, io.dataReadPort.read_data_b(15)), io.dataReadPort.read_data_b(15,0)),
    (io.controlSignal.memType === MEM_LHU) -> Cat(Fill(56, 0.U(1.W)), io.dataReadPort.read_data_b(15,0)),
    (io.controlSignal.memType === MEM_LW) -> Cat(Fill(32, io.dataReadPort.read_data_b(31)), io.dataReadPort.read_data_b(31, 0)),
    (io.controlSignal.memType === MEM_LWU) -> Cat(Fill(32, 0.U(1.W)), io.dataReadPort.read_data_b(31, 0)),
    (io.controlSignal.memType === MEM_LD) -> io.dataReadPort.read_data_b
  ))

  val writeback_data = MuxCase(io.aluOut.alu_result, Seq(
    (io.controlSignal.wbType === WB_MEM) -> load_data,
    (io.controlSignal.wbType === WB_PC) -> io.linkedPC,
    (io.controlSignal.wbType === WB_CSR) -> io.csrRead.csr_read_data
  ))

  // 写回内存，针对store指令
  io.dataWritePort.write_addr := io.aluOut.alu_result
  io.dataWritePort.write_data := io.aluOut.regB_data
  when(io.controlSignal.memType(2).asBool){
    io.dataWritePort.write_enable := true.asBool
  }
  io.dataWritePort.write_lenth := io.controlSignal.memType

  io.memPass.writeback_addr := io.aluOut.writeback_addr
  io.memPass.writeback_data := writeback_data
}
