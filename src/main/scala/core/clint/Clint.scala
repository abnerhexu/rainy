package rainy.shaheway.org
package core.clint

import chisel3._
import chisel3.util._
import common.Defines.{CSR_ADDR_LEN_WIDTH, CSR_TYPE_LEN, DOUBLE_WORD_LEN, DOUBLE_WORD_LEN_WIDTH, WORD_LEN_WIDTH}

object State {
  val IDLE = 0.U(3.W)
  val MSTATUS = 1.U(3.W)
  val MEPC = 2.U(3.W)
  val MRET = 3.U(3.W)
  val MCAUSE = 4.U(3.W)
  val MTVAL = 5.U(3.W)
}
object mCSR {
  val mtvec = 0x305.U(CSR_ADDR_LEN_WIDTH)
  val mcause = 0x0.U(CSR_ADDR_LEN_WIDTH) // 寄存器的最高位用来表示产生的是中断还是异常，1表示中断0表示异常
  val mepc = 0x341.U(CSR_ADDR_LEN_WIDTH)
  val mtval = 0x343.U(CSR_ADDR_LEN_WIDTH)
  val mstatus = 0x300.U(CSR_ADDR_LEN_WIDTH)
}
// Core Local interruption
class Clint extends Module{
  val io = IO(new Bundle() {
    val cur_pc = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val memAccessAddr = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val cur_instruction = Input(UInt(WORD_LEN_WIDTH))
    val next_instruction = Input(UInt(WORD_LEN_WIDTH))
    val cause = Input(UInt(DOUBLE_WORD_LEN_WIDTH))
    val exceptionFlag = Input(Bool())
    val interruptFlag = Input(Bool())
    val mem_caused_exception = Input(Bool())
    val invalid_instruction_caused_exception = Input(Bool())
    val interruptIO = new CSRInterruptIO
  })
  val PCTarget_mode0 = Cat(io.interruptIO.mtvec_read_data(DOUBLE_WORD_LEN-1, 2), 0.U(2.W))
  val PCTarget_mode1 = PCTarget_mode0 + io.cause(DOUBLE_WORD_LEN-1, 2).asUInt
  val PCTarget = Mux(io.interruptIO.mtvec_read_data(0), PCTarget_mode1, PCTarget_mode0)
  io.interruptIO.mcause_write_addr := mCSR.mcause
  val interrupt_mcause = Cat(1.U(1.W), io.cause(DOUBLE_WORD_LEN-2, 0))
  val exception_mcause = Cat(0.U(1.W), io.cause(DOUBLE_WORD_LEN-2, 0))
  io.interruptIO.mcause_write_data := Mux(io.interruptFlag, interrupt_mcause, exception_mcause)

  io.interruptIO.mepc_write_addr := mCSR.mepc
  io.interruptIO.mepc_write_data := Mux(io.interruptFlag, io.next_instruction, io.cur_pc)

  io.interruptIO.mtval_write_addr := mCSR.mtval
  io.interruptIO.mtval_write_data := Mux(io.mem_caused_exception, io.memAccessAddr, io.cur_instruction)
  io.interruptIO.mstatus_update_addr := mCSR.mstatus
  io.interruptIO.mstatus_update_flag := true.asBool
}
