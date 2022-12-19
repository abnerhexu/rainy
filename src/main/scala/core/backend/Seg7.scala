package rainy.shaheway.org
package core.backend
import chisel3._
import chisel3.util.MuxCase
class Seg7 extends Module{
  val io = IO(new Bundle() {
    val ans = Input(UInt(16.W))
    val segOut = Output(UInt(4.W))
    val segChoice = Output(UInt(2.W))
  })
  val d3 = 0.U(4.W)
  val d2 = 0.U(4.W)
  val d1 = 0.U(4.W)
  val d0 = 0.U(4.W)
  val p = RegInit(0.U(2.W))
  p := p + 1.U(2.W)
  for(i <- 15 to 0){
    when(d3 >= 5.U(4.W)) {
      d3 := d3 + 3.U(4.W)
    }.otherwise {
      d3 := d3
    }
    when(d2 >= 5.U(4.W)) {
      d2 := d2 + 3.U(4.W)
    }.otherwise {
      d2 := d2
    }
    when(d1 >= 5.U(4.W)) {
      d1 := d1 + 3.U(4.W)
    }.otherwise {
      d1 := d1
    }
    when(d0 >= 5.U(4.W)) {
      d0 := d0 + 3.U(4.W)
    }.otherwise {
      d0 := d0
    }
    d3 := (d3 << 1.U(4.W)).asUInt
    d3(0) := d2(3)
    d2 := (d2 << 1.U(4.W)).asUInt
    d2(0) := d1(3)
    d1 := (d1 << 1.U(4.W)).asUInt
    d1(0) := d0(3)
    d0 := (d0 << 1.U(4.W)).asUInt
    d0(0) := io.ans(i)
  }

  io.segOut := MuxCase(0.U(4.W), Seq(
    (p === 0.U(2.W)) -> d0,
    (p === 1.U(2.W)) -> d1,
    (p === 2.U(2.W)) -> d2,
    (p === 3.U(2.W)) -> d3
  ))
  io.segChoice := p
}
