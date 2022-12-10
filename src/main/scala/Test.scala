package rainy.shaheway.org
import chisel3._
import core.{Core, Probe}
import mem.Memory

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
  printf(p"Progcounter(if)      : 0x${Hexadecimal(io.probe.progcnter)}\n")
  printf(p"inst(if_id)          : 0x${Hexadecimal(io.probe.inst)}\n")
  printf(p"inst(id)             : 0x${Hexadecimal(io.probe.inst_id)}\n")
  printf(p"srcA(exe)            : 0x${Hexadecimal(io.probe.srcA)}\n")
  printf(p"srcB(exe)            : 0x${Hexadecimal(io.probe.srcB)}\n")
  printf(p"ALU result(exe)      : 0x${Hexadecimal(io.probe.alu_result)}\n")
  printf(p"DatahazardTypeA(exe) : 0x${Hexadecimal(io.probe.datahazardAType)}\n")
//  printf(p"forward_srcb     : 0x${Hexadecimal(io.probe.forward_srcb)}\n")
  printf(p"stall flag(stall)    : 0x${Hexadecimal(io.probe.stall)}\n")
  printf(p"writeback data(wb)   : 0x${Hexadecimal(io.probe.writeback_data)}\n")
  // printf(p"Writeback data: 0x${Hexadecimal(core.writeback.io.wbinfo.writeback_data)}")
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