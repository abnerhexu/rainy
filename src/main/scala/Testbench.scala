package rainy.shaheway.org
import chisel3._
import core.{Core, Probe}
import mem.Memory

import chisel3.stage.ChiselStage
import chiseltest._
import org.scalatest._

class Check extends Module {
  val io = IO(new Bundle() {
    val probe = new Probe
  })
  val core = Module(new Core)
  val memory = Module(new Memory)

  core.io.instfetch_fetchMem <> memory.io.instReadPort
  core.io.memoryAccess_dataReadPort <> memory.io.dataReadPort
  core.io.memoryAccess_dataWritePort <> memory.io.writePort

  io.probe := core.io.probe
  printf(p"Cycle: ${Decimal(io.probe.cycleTime)}\n")
  printf(p"Progcounter(if)      : 0x${Hexadecimal(io.probe.progcnter)}\n")
  printf(p"inst(if_id)          : 0x${Hexadecimal(io.probe.inst)}\n")
  printf(p"srcA(exe)            : 0x${Hexadecimal(io.probe.srcA)}\n")
  printf(p"srcB(exe)            : 0x${Hexadecimal(io.probe.srcB)}\n")
  printf(p"ALU result(exe)      : 0x${Hexadecimal(io.probe.alu_result)}\n")
  printf(p"Aforwardtype         : 0x${Hexadecimal(io.probe.forwardAtype)}\n")
  printf(p"Bforwardtype         : 0x${Hexadecimal(io.probe.forwardBtype)}\n")
  printf(p"wb data(wb)          : 0x${Hexadecimal(io.probe.writeback_data)}\n")
  printf(p"stall flag           : 0x${Hexadecimal(io.probe.stallFlag)}\n")
  printf(p"branch flag          : 0x${Hexadecimal(io.probe.branchFlag)}\n")
  printf(p"branchTarget         : 0x${Hexadecimal(io.probe.branchTarget)}\n")
  // printf(p"mem read addr        : 0x${Hexadecimal(io.probe.mem_read_addr)}\n")
  printf("---------\n")
}

class Test extends FlatSpec with ChiselScalatestTester {
  "mycpu" should "work through hex" in {
    test(new Check) { c =>
      for (i <- 1 to 12) {
        c.clock.step(1)
      }
    }
  }
}

object Testbench extends App {
  (new ChiselStage).emitVerilog(new Check())
}