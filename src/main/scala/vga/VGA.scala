package rainy.shaheway.org
package vga
import chisel3._
class VGA extends Module {
  val io = IO(new Bundle() {
    val data = Input(UInt(16.W))
    val addr = Input(UInt(12.W))
    val vga_hs = Output(UInt(1.W))
    val vga_vs = Output(UInt(1.W))
    val vga_rgb = Output(UInt(12.W))
  })
}
