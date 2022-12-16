package rainy.shaheway.org
package vga
import chisel3._

class VGA extends Module {
  val io = IO(new Bundle() {
    val clock = Input(Bool())
    val data = Input(UInt(16.W))
    val addr = Input(UInt(12.W))
    val vga_hs = Output(UInt(1.W)) // high voltage indicates a new line
    val vga_vs = Output(UInt(1.W)) // high voltage indicates a new frame
    val vga_rgb = Output(UInt(12.W))
  })
  val vga_reg = RegInit(0.U(4.W))
  vga_reg := vga_reg + 1.U(4.W)
  val vga_time = RegInit(0.U(1.W))
  when(vga_reg === 3.U(4.W)){
    vga_time := (~vga_time).asUInt
  }

}
