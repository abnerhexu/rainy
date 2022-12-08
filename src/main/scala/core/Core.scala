package rainy.shaheway.org
package core
import chisel3._
import core.backend.Instfetch
import core.backend.decode.Decode
import core.backend.alu.Alu
import core.backend.mema.MemAccess
import core.backend.writeback.WriteBack
import core.backend.pipereg.{DecodeToExecute, ExecuteToMema, FetchToDecode, MemaToWB}

import core.backend.datahazard.{Forward, Stall}
import core.backend.regfile.{CSRfile, RegFile}
import mem.{DataReadPort, InstReadPort, MemWritePort}
class Core extends Module {

  val io = IO(new Bundle() {
    val instfetch_fetchMem = Flipped(new InstReadPort)
    val memoryAccess_dataReadPort = Flipped(new DataReadPort)
    val memoryAccess_dataWritePort = Flipped(new MemWritePort)
  })

  // inside core
  val instfetch = new Instfetch
  val instfetch_to_decode = new FetchToDecode
  val decode = new Decode
  val decode_to_execute = new DecodeToExecute
  val execute = new Alu
  val execute_to_mema = new ExecuteToMema
  val memoryAccess = new MemAccess
  val mema_to_wb = new MemaToWB
  val writeback = new WriteBack
  val datahazard_forward = new Forward
  val datahazard_stall = new Stall

  // registers
  val regs = new RegFile
  val csrs = new CSRfile

  // 流水线连线
  // instfetch
  instfetch.io.branchFlag := execute.io.branchFlag
  instfetch.io.jumpFlag := execute.io.jumpFlag
  instfetch.io.stallFlag := datahazard_stall.io.stallFlag
  instfetch.io.branchTarget := execute.io.branchTarget
  instfetch.io.jumpTarget := execute.io.alu_out.alu_result
  instfetch.io.fetchMem <> io.instfetch_fetchMem
  instfetch.io.envRead <> csrs.io.envRead
  // instfetch_to_decode
  instfetch_to_decode.io.stallFlag := datahazard_stall.io.stallFlag
  instfetch_to_decode.io.pcIn := instfetch.io.pcOut
  instfetch_to_decode.io.instIn := instfetch.io.instOut
  instfetch_to_decode.io.jumpOrBranchFlag := (execute.io.jumpFlag || execute.io.branchFlag)
  // decode
  decode.io.branchFlag := execute.io.branchFlag
  decode.io.jumpFlag := execute.io.jumpFlag
  decode.io.stallFlag := datahazard_stall.io.stallFlag
  decode.io.inst := instfetch_to_decode.io.instOut
  decode.io.cur_pc := instfetch_to_decode.io.pcOut
  decode.io.forward <> datahazard_forward.io.withDecode
  decode.io.stall <> datahazard_stall.io.withDecode
  // decode_to_execute
  decode_to_execute.io.controlSignal <> decode.io.decodeOut
  decode_to_execute.io.jumpOrBranchFlag := (execute.io.jumpFlag || execute.io.branchFlag)
  decode_to_execute.io.cur_pc := decode.io.pcOut
  decode_to_execute.io.controlSignal <> decode.io.decodeOut
  decode_to_execute.io.opSrc <> decode.io.srcOut
  // execute
  execute.io.cur_pc := decode_to_execute.io.pcOut
  execute.io.alu_in <> decode_to_execute.io.srcPass
  execute.io.controlSignal <> decode_to_execute.io.controlSignalPass
  execute.io.dataHazard <> datahazard_forward.io.withExecute
  // execute_to_mema
  execute_to_mema.io.linkedPC := execute.io.linkedPC
  execute_to_mema.io.aluOut <> execute.io.alu_out
  execute_to_mema.io.controlSignal <> execute.io.controlPass
  // memory access
  memoryAccess.io.linkedPC := execute_to_mema.io.linkedPCPass
  memoryAccess.io.aluOut := execute_to_mema.io.aluOutPass
  memoryAccess.io.controlSignal <> execute_to_mema.io.controlSignalPass
  memoryAccess.io.dataReadPort <> io.memoryAccess_dataReadPort
  memoryAccess.io.dataWritePort <> io.memoryAccess_dataWritePort
  memoryAccess.io.csrRead <> csrs.io.csrRead
  memoryAccess.io.forward <> datahazard_forward.io.withMema
  memoryAccess.io.stall <> datahazard_stall.io.withMema
  // memoryAccess_to_writeback
  mema_to_wb.io.wbinfo <> memoryAccess.io.memPass
  // writeback
  writeback.io.wbinfo <> mema_to_wb.io.wbinfoPass
  writeback.io.regWrite <> regs.io.reg_write
  writeback.io.csrWrite <> csrs.io.csrWrite

  // 控制冒险连线(这里没有)
  // 数据冒险连线
  datahazard_forward.io.regReadPort <> ?

}
