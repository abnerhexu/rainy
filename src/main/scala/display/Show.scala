package rainy.shaheway.org
package display
import chisel3._
import chisel3.util.{Cat, MuxLookup}
class Show extends Module{
  val io = IO(new Bundle() {
    val start = Input(Bool())
    val in_result = Input(UInt(64.W))
    val out_result = Output(UInt(7.W))
    val valid = Output(Bool())
    val seg_choice = Output(UInt(2.W))
  })
  val bin = RegInit(0.U(64.W))
  bin := io.in_result
  val cnt = RegInit(0.U(4.W))
  val op = RegInit(false.asBool)
  op := Mux(cnt === 12.U(4.W), false.asBool, true.asBool)
  cnt := Mux(op === false.asBool, 0.U(4.W), cnt + 1.U(4.W))
  // val bcd = RegInit(0.U(16.W))
  val bcd0 = RegInit(0.U(1.W))
  val bcd41 = RegInit(0.U(4.W))
  val bcd85 = RegInit(0.U(4.W))
  val bcd129 = RegInit(0.U(4.W))
  val bcd1513 = RegInit(0.U(3.W))
  bcd0 := Mux(io.start, Mux(op === true.asBool, bin(13.U(4.W)-cnt), 0.U(1.W)), bcd0)
  bcd41 := Mux(io.start, Mux(op === true.asBool, Mux(Cat(bcd41(2, 0), bcd0) > 4.U(4.W), Cat(bcd41(2, 0), bcd0)+3.U(4.W), Cat(bcd41(2, 0), bcd0)), 0.U(4.W)), bcd41)
  bcd85 := Mux(io.start, Mux(op === true.asBool, Mux(Cat(bcd85(2, 0), bcd41(3)) > 4.U(4.W), Cat(bcd85(2, 0), bcd41(3))+3.U(4.W), Cat(bcd85(2, 0), bcd41(3))), 0.U(4.W)), bcd85)
  bcd129 := Mux(io.start, Mux(op === true.asBool, Mux(Cat(bcd129(2, 0), bcd85(3)) > 4.U(4.W), Cat(bcd129(2, 0), bcd85(3))+3.U(4.W), Cat(bcd129(2, 0), bcd85(3))), 0.U(4.W)), bcd129)
  bcd1513 := Mux(io.start, Mux(op === true.asBool, Mux(Cat(bcd1513(2, 0), bcd129(3)) > 4.U(4.W), (Cat(bcd1513(2, 0), bcd129(3))+3.U(4.W))(2, 0), (Cat(bcd1513(2, 0), bcd129(3)))(2, 0)), 0.U(3.W)), bcd1513)
  val valid = RegInit(false.asBool)
  valid := Mux(cnt === 12.U(4.W), true.asBool, false.asBool)
  io.valid := valid
  io.out_result := Cat(bcd1513, bcd129, bcd85, bcd41, bcd0)
  val seg_choice = RegInit(0.U(2.W))
  val slow_clock = RegInit(0.U(4.W))
  slow_clock := slow_clock + 1.U(4.W)
  seg_choice := seg_choice + slow_clock(3)
  io.seg_choice := seg_choice
  val show_result = MuxLookup(seg_choice, 0.U(4.W), IndexedSeq(
    0.U(2.W) -> Cat(bcd41(2, 0), bcd0),
    1.U(2.W) -> Cat(bcd85(2, 0), bcd41(3)),
    2.U(2.W) -> Cat(bcd129(2, 0), bcd85(3)),
    3.U(2.W) -> Cat(bcd1513, bcd129(3))
  ))
  io.out_result := MuxLookup(show_result, 0.U(7.W), IndexedSeq(
    0.U(4.W) -> 64.U(7.W),
    1.U(4.W) -> 121.U(7.W),
    2.U(4.W) -> 36.U(7.W),
    3.U(4.W) -> 48.U(7.W),
    4.U(4.W) -> 25.U(7.W),
    5.U(4.W) -> 18.U(7.W),
    6.U(4.W) -> 2.U(7.W),
    7.U(4.W) -> 120.U(7.W),
    8.U(4.W) -> 0.U(7.W),
    9.U(4.W) -> 16.U(7.W)
  ))
}
