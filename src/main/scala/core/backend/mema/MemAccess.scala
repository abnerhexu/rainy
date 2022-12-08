package rainy.shaheway.org
package core.backend.mema

import common.Defines._
import core.backend.alu.{AluConOut, AluOutPort}
import core.backend.regfile.CSRReadPort
import mem.{DataReadPort, MemWritePort}

import chisel3._
import chisel3.util.{Cat, Fill, MuxCase}
import core.backend.datahazard.{ForwardWithMema, StallWithMema}

class MemAccess extends Module {
  val io = IO(new Bundle() {
    val linkedPC = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val aluOut = Flipped(new AluOutPort)
    val controlSignal = Flipped(new AluConOut)
    val dataReadPort = Flipped(new DataReadPort)
    val dataWritePort = Flipped(new MemWritePort)
    val csrRead = Flipped(new CSRReadPort)
    val forward = Flipped(new ForwardWithMema)
    val stall = Flipped(new StallWithMema)
    val memPass = new MemaOutPort
  })

  // 从CSR中取数并完成计算
  io.csrRead.csr_read_addr := io.controlSignal.csrAddr

  val csr_wdata = MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (io.controlSignal.CSRType === CSR_W) -> io.aluOut.alu_result,
    (io.controlSignal.CSRType === CSR_S) -> (io.csrRead.csr_read_data | io.aluOut.alu_result),
    (io.controlSignal.CSRType === CSR_C) -> (io.csrRead.csr_read_data & (~io.aluOut.alu_result).asUInt),
    (io.controlSignal.CSRType === CSR_E) -> 11.U(DOUBLE_WORD_LEN_WIDTH)
  ))

  // 从主存中取数并完成计算
  io.dataReadPort.read_addr_b := io.aluOut.alu_result
  // io.dataReadPort.read_data_b := io.dataReadPort.read_addr_b
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
    (io.controlSignal.wbType === WB_CSR) -> csr_wdata
  ))

  // 写回内存，针对store指令
  io.dataWritePort.write_addr := io.aluOut.alu_result
  io.dataWritePort.write_data := io.aluOut.regB_data
  when(io.controlSignal.memType(2).asBool){
    io.dataWritePort.write_enable := true.asBool
  }.otherwise{
    io.dataWritePort.write_enable := false.asBool
  }
  io.dataWritePort.write_lenth := io.controlSignal.memType

  io.memPass.writeback_addr := io.aluOut.writeback_addr
  io.memPass.writeback_data := writeback_data
  io.memPass.regwrite_enable := io.controlSignal.regType
  io.memPass.csrwrite_addr := io.controlSignal.csrAddr
  io.memPass.csrwrite_data := csr_wdata
  io.memPass.CSRType := io.controlSignal.CSRType

  // data hazard
  io.forward.wbDataFromMema := writeback_data
  io.forward.wbAddrFromMema := io.aluOut.writeback_addr
  io.forward.regTypeFromMema := io.controlSignal.regType
  io.stall.wbAddrFromMema := writeback_data
  io.stall.regTypeFromMema := io.controlSignal.regType
}
