package rainy.shaheway.org
import chisel3._
import core.Core
import mem.Memory
import chiseltest._
import org.scalatest._

class Check extends Module {
  val core = Module(new Core)
  val memory = Module(new Memory)

  core.io.instfetch_fetchMem <> memory.io.instReadPort
  core.io.memoryAccess_dataReadPort <> memory.io.dataReadPort
  core.io.memoryAccess_dataWritePort <> memory.io.writePort
}

object Check extends FlatSpec with ChiselScalatestTester {
  "mycpu" should "work through hex" in {
    test(new Top) { c =>
      for (i <- 1 to 5050) {
        c.clock.step(1)
      }
    }
  }
}