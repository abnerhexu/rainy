package rainy.shaheway.org
package core.backend.branchhazard
import chisel3._
import chisel3.util.MuxCase

object BranchState {
  val strong_not_taken = 0.U(2.W)
  val weak_not_taken = 1.U(2.W)
  val weak_taken = 2.U(2.W)
  val strong_taken = 3.U(2.W)
}
class BranchPredict extends Module {
  val io = IO(new Bundle() {
    val branchFlag = Input(Bool())
    val predictResult = Output(Bool())
  })

  val branch_state = RegInit(0.U(2.W))
  val predict_result = RegInit(false.asBool)
  when(branch_state === BranchState.strong_not_taken){
    when(io.branchFlag){
      branch_state := BranchState.weak_not_taken
    }.otherwise{
      branch_state := BranchState.strong_not_taken
    }
  }.elsewhen(branch_state === BranchState.weak_not_taken){
    when(io.branchFlag){
      branch_state := BranchState.weak_taken
    }.otherwise{
      branch_state := BranchState.strong_not_taken
    }
  }.elsewhen(branch_state === BranchState.weak_taken){
    when(io.branchFlag){
      branch_state := BranchState.strong_taken
    }.otherwise{
      branch_state := BranchState.weak_not_taken
    }
  }.otherwise{
    when(io.branchFlag){
      branch_state := BranchState.strong_taken
    }.otherwise{
      branch_state := BranchState.weak_taken
    }
  }

  io.predictResult := MuxCase(false.asBool, Seq(
    (branch_state === BranchState.strong_not_taken) -> false.asBool,
    (branch_state === BranchState.weak_not_taken) -> false.asBool,
    (branch_state === BranchState.weak_taken) -> true.asBool,
    (branch_state === BranchState.strong_taken) -> true.asBool
  ))
}
