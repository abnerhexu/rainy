package rainy.shaheway.org
package core.clint

import chisel3._
import chisel3.util._
import common.Defines.{CSR_ADDR_LEN_WIDTH, CSR_TYPE_LEN, DOUBLE_WORD_LEN, DOUBLE_WORD_LEN_WIDTH, WORD_LEN_WIDTH}
import common.Instructions.{CSRRC, EBREAK, ECALL, MRET}
object CSRState {
  val IDLE = 0.U(3.W)
  val MSTATUS = 1.U(3.W)
  val MEPC = 2.U(3.W)
  val MRET = 3.U(3.W)
  val MCAUSE = 4.U(3.W)
  val MTVAL = 5.U(3.W)
}
object CSRAddr {
  val mtvec = 0x305.U(CSR_ADDR_LEN_WIDTH)
  val mcause = 0x0.U(CSR_ADDR_LEN_WIDTH) // 寄存器的最高位用来表示产生的是中断还是异常，1表示中断0表示异常
  val mepc = 0x341.U(CSR_ADDR_LEN_WIDTH)
  val mtval = 0x343.U(CSR_ADDR_LEN_WIDTH)
  val mstatus = 0x300.U(CSR_ADDR_LEN_WIDTH)
}

object interruptStatus {
  val none = 0x0.U(8.W)
  val timer = 0x1.U(8.W)
  val ret = 0xff.U(8.W)
}

object interruptEntry {
  val timer = 0x4.U(8.W)
}

object interruptState {
  val IDLE = 0x0.U(2.W)
  val SYNCASSERT = 0x1.U(2.W)
  val ASYNASSERT = 0x2.U(2.W)
  val MRET = 0x3.U(2.W)
}
// Core Local interruption controller
class Clint extends Module{
  val io = IO(new Bundle() {
    val cur_instruction_addr = Input(UInt(DOUBLE_WORD_LEN_WIDTH)) // from if
    val ctrlStallFlag = Output(Bool())
    val withDecode = new ClintWithDecode
    val withCSR = new ClintWithCSR
    val withIFID = new ClintWithIFID
    // val withMMU = new ClintWithMMU
  })

  val interrupt_state = WireInit(0.U(8.W))
  val csr_state = RegInit(CSRState.IDLE)
  val instruction_addr = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  val cause = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  val trap_val = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  val interrupt_assert = RegInit(false.asBool)
  val interrupt_handler_addr = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  val csr_write_enable = RegInit(false.asBool)
  val csr_write_addr = RegInit(0.U(CSR_ADDR_LEN_WIDTH))
  val csr_write_data = RegInit(0.U(DOUBLE_WORD_LEN_WIDTH))
  val exception_token = RegInit(false.asBool)
  val exceptionFlag = RegInit(false.asBool)

  io.ctrlStallFlag := (interrupt_state =/= interruptState.IDLE || csr_state =/= CSRState.IDLE) && !exceptionFlag
  // io.withMMU.exception_token := exception_token
  when(exceptionFlag && csr_state === CSRState.MCAUSE){
    exception_token := true.asBool
  }.otherwise{
    exception_token := true.asBool
  }

  when(exception_token){
    exceptionFlag := false.asBool
  }.otherwise{
    exceptionFlag := true.asBool
  }

  // Interrupt FSM
  //exception cause SyncAssert
  when(exceptionFlag || io.withIFID.cur_instruction === ECALL || io.withIFID.cur_instruction === EBREAK){
    interrupt_state := interruptState.SYNCASSERT
  }.elsewhen(io.withIFID.interruptFlag =/= interruptStatus.none && io.withCSR.global_interrupt_enabled){
    interrupt_state := interruptState.ASYNASSERT
  }.elsewhen(io.withIFID.cur_instruction === MRET){
    interrupt_state := interruptState.MRET
  }.otherwise{
    interrupt_state := interruptState.IDLE
  }

  // CSR FSM
  when(csr_state === CSRState.IDLE){
    when(interrupt_state === interruptState.SYNCASSERT){
      csr_state := CSRState.MEPC
      instruction_addr := Mux(io.withDecode.jumpFlag, io.withDecode.jumpTarget - 4.U(3.W), io.cur_instruction_addr)
      /*
      instruction_addr := Mux(exceptionFlag, io.withMMU.instruction_addr_cause_exception, Mux(
        io.withDecode.jumpFlag, io.withDecode.jumpTarget - 4.U(3.W), io.cur_instruction_addr
      ))

      cause := Mux(exceptionFlag, io.withMMU.exception_cause, MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
        (io.withIFID.cur_instruction === ECALL) -> 11.U(DOUBLE_WORD_LEN_WIDTH),
        (io.withIFID.cur_instruction === EBREAK) -> 3.U(DOUBLE_WORD_LEN_WIDTH)
      )))*/
      cause := MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
        (io.withIFID.cur_instruction === ECALL) -> 11.U(DOUBLE_WORD_LEN_WIDTH),
        (io.withIFID.cur_instruction === EBREAK) -> 3.U(DOUBLE_WORD_LEN_WIDTH)
      ))

      //trap_val := Mux(exceptionFlag, io.withMMU.exceptionFlag, 0.U(DOUBLE_WORD_LEN_WIDTH))
      trap_val := 0.U((DOUBLE_WORD_LEN_WIDTH))
    }.elsewhen(interrupt_state === interruptState.ASYNASSERT){
      cause := 0x8000000BL.U // Interrupt from peripherals : Uart
      when(io.withIFID.interruptFlag(0)){
        cause := 0x80000007L.U  // Interrupt from timer
      }
      trap_val := 0.U(DOUBLE_WORD_LEN_WIDTH)
      csr_state := CSRState.MEPC
      instruction_addr := Mux(io.withDecode.jumpFlag, io.withDecode.jumpTarget, io.cur_instruction_addr)
    }.elsewhen(interrupt_state === interruptState.MRET){
      // interrupt return
      csr_state := CSRState.MRET
    }
  }.elsewhen(csr_state === CSRState.MEPC){
    csr_state := CSRState.MSTATUS
  }.elsewhen(csr_state === CSRState.MSTATUS){
    csr_state := CSRState.MTVAL
  }.elsewhen(csr_state === CSRState.MTVAL){
    csr_state := CSRState.MCAUSE
  }.elsewhen(csr_state === CSRState.MCAUSE) {
    csr_state := CSRState.IDLE
  }.elsewhen(csr_state === CSRState.MRET) {
    csr_state := CSRState.IDLE
  }.otherwise {
    csr_state := CSRState.IDLE
  }

  csr_write_enable := csr_state =/= CSRState.IDLE
  csr_write_addr := MuxCase(0.U(CSR_ADDR_LEN_WIDTH), Seq(
    (csr_state === CSRState.MEPC) -> CSRAddr.mepc,
    (csr_state === CSRState.MCAUSE) -> CSRAddr.mcause,
    (csr_state === CSRState.MSTATUS) -> CSRAddr.mstatus,
    (csr_state === CSRState.MRET) -> CSRAddr.mstatus,
    (csr_state === CSRState.MTVAL) -> CSRAddr.mtval
  ))
  csr_write_data := MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (csr_state === CSRState.MEPC) -> instruction_addr,
    (csr_state === CSRState.MCAUSE) -> cause,
    (csr_state === CSRState.MSTATUS) -> Cat(io.withCSR.csr_mstatus(63, 4), 0.U(1.W), io.withCSR.csr_mstatus(2, 0)),
    (csr_state === CSRState.MRET) -> Cat(io.withCSR.csr_mstatus(63, 4), io.withCSR.csr_mstatus(7), io.withCSR.csr_mstatus(2, 0)),
    (csr_state === CSRState.MTVAL) -> trap_val
  ))
  io.withCSR.csr_write_enable:= csr_write_enable
  io.withCSR.csr_write_addr := csr_write_addr
  io.withCSR.csr_write_data := csr_write_data

  interrupt_assert := csr_state === CSRState.MCAUSE || csr_state === CSRState.MRET
  interrupt_handler_addr := MuxCase(0.U(DOUBLE_WORD_LEN_WIDTH), Seq(
    (csr_state === CSRState.MCAUSE) -> io.withCSR.csr_mtvec,
    (csr_state === CSRState.MRET) -> io.withCSR.csr_mepc
  ))

  io.withDecode.id_interrupt_assert := interrupt_assert
  io.withDecode.id_interrupt_handler_addr := interrupt_handler_addr
}
