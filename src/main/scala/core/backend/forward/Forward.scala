package rainy.shaheway.org
package core.backend.forward

import common.Defines._

import chisel3._
class Forward extends Module {
  val io = IO(new Bundle() {
    val controlSignal = new ForwardControlSignal
    val data = new ForwardData
  })


}
