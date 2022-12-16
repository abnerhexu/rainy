package rainy.shaheway.org
package vga
import chisel3._
class VGAmem extends Module {
  val io = IO(new Bundle() {
    val readAddr = Input(UInt(12.W))
    val readData = Output(UInt(16.W))
    val writeAddr = Input(UInt(12.W))
    val writeData = Output(UInt(16.W))
  })
  val vgamem = Mem(1024, UInt(16.W))
  io.readData := vgamem.read(io.readAddr)
  vgamem.write(io.writeAddr, io.writeData)
}
