package rainy.shaheway.org
package vga
import chisel3._
class VGAtime extends Module {
  val io = IO(new Bundle() {
    val VGAclock = Output(Bool())
  })
  val VGAreg = RegInit(0.U(2.W))
  VGAreg := VGAreg + 1.U(2.W)
  io.VGAclock := VGAreg(3)
}
