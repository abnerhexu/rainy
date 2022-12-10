module Instfetch(
  input         clock,
  input         reset,
  input         io_branchFlag,
  input         io_jumpFlag,
  input         io_stallFlag,
  input  [63:0] io_branchTarget,
  input  [63:0] io_jumpTarget,
  output [63:0] io_instOut,
  output [63:0] io_pcOut,
  output [63:0] io_fetchMem_read_addr_a,
  input  [31:0] io_fetchMem_read_inst_a,
  input  [63:0] io_envRead_csr_read_data
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] progcnter; // @[Instfetch.scala 23:26]
  wire [63:0] pcIncrement = progcnter + 64'h4; // @[Instfetch.scala 26:31]
  wire  _pcNext_T_1 = 32'h73 == io_fetchMem_read_inst_a; // @[Instfetch.scala 31:30]
  wire [63:0] _pcNext_T_2 = io_stallFlag ? progcnter : pcIncrement; // @[Mux.scala 101:16]
  assign io_instOut = {{32'd0}, io_fetchMem_read_inst_a}; // @[Instfetch.scala 36:14]
  assign io_pcOut = progcnter; // @[Instfetch.scala 37:12]
  assign io_fetchMem_read_addr_a = progcnter; // @[Instfetch.scala 35:27]
  always @(posedge clock) begin
    if (reset) begin // @[Instfetch.scala 23:26]
      progcnter <= 64'h0; // @[Instfetch.scala 23:26]
    end else if (io_branchFlag) begin // @[Mux.scala 101:16]
      progcnter <= io_branchTarget;
    end else if (io_jumpFlag) begin // @[Mux.scala 101:16]
      progcnter <= io_jumpTarget;
    end else if (_pcNext_T_1) begin // @[Mux.scala 101:16]
      progcnter <= io_envRead_csr_read_data;
    end else begin
      progcnter <= _pcNext_T_2;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  progcnter = _RAND_0[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module FetchToDecode(
  input         clock,
  input         reset,
  input         io_stallFlag,
  input  [63:0] io_pcIn,
  input  [31:0] io_instIn,
  input         io_jumpOrBranchFlag,
  output [31:0] io_instOut,
  output [63:0] io_pcOut
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] progcnter; // @[FetchToDecode.scala 17:26]
  reg [31:0] instReg; // @[FetchToDecode.scala 18:24]
  assign io_instOut = instReg; // @[FetchToDecode.scala 28:14]
  assign io_pcOut = progcnter; // @[FetchToDecode.scala 29:12]
  always @(posedge clock) begin
    if (reset) begin // @[FetchToDecode.scala 17:26]
      progcnter <= 64'h0; // @[FetchToDecode.scala 17:26]
    end else if (!(io_stallFlag)) begin // @[FetchToDecode.scala 25:18]
      progcnter <= io_pcIn;
    end
    if (reset) begin // @[FetchToDecode.scala 18:24]
      instReg <= 32'h0; // @[FetchToDecode.scala 18:24]
    end else if (io_jumpOrBranchFlag) begin // @[Mux.scala 101:16]
      instReg <= 32'h13000000;
    end else if (!(io_stallFlag)) begin // @[Mux.scala 101:16]
      instReg <= io_instIn;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  progcnter = _RAND_0[63:0];
  _RAND_1 = {1{`RANDOM}};
  instReg = _RAND_1[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Decode(
  input         io_branchFlag,
  input         io_jumpFlag,
  input         io_stallFlag,
  input  [31:0] io_inst,
  input  [63:0] io_cur_pc,
  output [63:0] io_pcOut,
  output [4:0]  io_decodeOut_alu_exe_fun,
  output [3:0]  io_decodeOut_memType,
  output [1:0]  io_decodeOut_regType,
  output [2:0]  io_decodeOut_wbType,
  output [2:0]  io_decodeOut_CSRType,
  output [11:0] io_decodeOut_csrAddr,
  output [63:0] io_srcOut_aluSrc_a,
  output [63:0] io_srcOut_aluSrc_b,
  output [63:0] io_srcOut_regB_data,
  output [4:0]  io_srcOut_writeback_addr,
  output [63:0] io_srcOut_imm_b,
  output [4:0]  io_forward_srcAddrA,
  output [4:0]  io_forward_srcAddrB,
  input  [63:0] io_forward_hazardAData,
  input  [63:0] io_forward_hazardBData,
  output [4:0]  io_stall_srcAddrA,
  output [4:0]  io_stall_srcAddrB
);
  wire [31:0] de_inst = io_stallFlag | io_branchFlag | io_jumpFlag ? 32'h13000000 : io_inst; // @[Decode.scala 24:20]
  wire [4:0] rsA_addr = de_inst[19:15]; // @[Decode.scala 26:25]
  wire [4:0] write_back_reg_addr = de_inst[11:7]; // @[Decode.scala 38:36]
  wire [11:0] imm_i = de_inst[31:20]; // @[Decode.scala 41:22]
  wire [51:0] _imm_i_sext_T_2 = imm_i[11] ? 52'hfffffffffffff : 52'h0; // @[Bitwise.scala 74:12]
  wire [63:0] imm_i_sext = {_imm_i_sext_T_2,imm_i}; // @[Cat.scala 31:58]
  wire [11:0] imm_s = {de_inst[31:25],write_back_reg_addr}; // @[Cat.scala 31:58]
  wire [51:0] _imm_s_sext_T_2 = imm_s[11] ? 52'hfffffffffffff : 52'h0; // @[Bitwise.scala 74:12]
  wire [63:0] imm_s_sext = {_imm_s_sext_T_2,de_inst[31:25],write_back_reg_addr}; // @[Cat.scala 31:58]
  wire [11:0] imm_b = {de_inst[31],de_inst[7],de_inst[30:25],de_inst[11:8]}; // @[Cat.scala 31:58]
  wire [50:0] _imm_b_sext_T_2 = imm_b[11] ? 51'h7ffffffffffff : 51'h0; // @[Bitwise.scala 74:12]
  wire [62:0] imm_b_sext_hi = {_imm_b_sext_T_2,de_inst[31],de_inst[7],de_inst[30:25],de_inst[11:8]}; // @[Cat.scala 31:58]
  wire [19:0] imm_j = {de_inst[31],de_inst[19:12],de_inst[20],de_inst[30:21]}; // @[Cat.scala 31:58]
  wire [42:0] _imm_j_sext_T_2 = imm_j[19] ? 43'h7ffffffffff : 43'h0; // @[Bitwise.scala 74:12]
  wire [63:0] imm_j_sext = {_imm_j_sext_T_2,de_inst[31],de_inst[19:12],de_inst[20],de_inst[30:21],1'h0}; // @[Cat.scala 31:58]
  wire [19:0] imm_u = de_inst[31:12]; // @[Decode.scala 49:22]
  wire [31:0] imm_u_shifted = {imm_u,12'h0}; // @[Cat.scala 31:58]
  wire [63:0] imm_z_uext = {59'h0,rsA_addr}; // @[Cat.scala 31:58]
  wire [31:0] _controlSignals_T = de_inst & 32'hfe00707f; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_1 = 32'h33 == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_3 = 32'h3b == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_5 = 32'h40000033 == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_7 = 32'h4000003b == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_9 = 32'h7033 == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_11 = 32'h6033 == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_13 = 32'h4033 == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_15 = 32'h1033 == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_17 = 32'h103b == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_19 = 32'h5033 == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_21 = 32'h503b == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_23 = 32'h40005033 == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_25 = 32'h5000503b == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_27 = 32'h2033 == _controlSignals_T; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_29 = 32'h3033 == _controlSignals_T; // @[Lookup.scala 31:38]
  wire [31:0] _controlSignals_T_30 = de_inst & 32'h707f; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_31 = 32'h13 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_33 = 32'h1b == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_35 = 32'h7013 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_39 = 32'h6013 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_41 = 32'h4013 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire [31:0] _controlSignals_T_42 = de_inst & 32'hfc00707f; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_43 = 32'h1013 == _controlSignals_T_42; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_45 = 32'h101b == _controlSignals_T_42; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_47 = 32'h5013 == _controlSignals_T_42; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_49 = 32'h501b == _controlSignals_T_42; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_51 = 32'h40005013 == _controlSignals_T_42; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_53 = 32'h4000501b == _controlSignals_T_42; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_55 = 32'h2013 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_57 = 32'h3013 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_59 = 32'h3 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_61 = 32'h4003 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_63 = 32'h1003 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_65 = 32'h5003 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_67 = 32'h2003 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_69 = 32'h6003 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_71 = 32'h3003 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_73 = 32'h23 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_75 = 32'h1023 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_77 = 32'h2023 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_79 = 32'h3023 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_81 = 32'h63 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_83 = 32'h5063 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_85 = 32'h7063 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_87 = 32'h4063 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_89 = 32'h6063 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_91 = 32'h1063 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire [31:0] _controlSignals_T_92 = de_inst & 32'h7f; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_93 = 32'h6f == _controlSignals_T_92; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_95 = 32'h67 == _controlSignals_T_30; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_97 = 32'h17 == _controlSignals_T_92; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_99 = 32'h37 == _controlSignals_T_92; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_101 = 32'h100073 == de_inst; // @[Lookup.scala 31:38]
  wire  _controlSignals_T_103 = 32'h73 == de_inst; // @[Lookup.scala 31:38]
  wire [4:0] _controlSignals_T_106 = _controlSignals_T_99 ? 5'h1 : 5'h0; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_107 = _controlSignals_T_97 ? 5'h1 : _controlSignals_T_106; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_108 = _controlSignals_T_95 ? 5'hb : _controlSignals_T_107; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_109 = _controlSignals_T_93 ? 5'h1 : _controlSignals_T_108; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_110 = _controlSignals_T_91 ? 5'he : _controlSignals_T_109; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_111 = _controlSignals_T_89 ? 5'hf : _controlSignals_T_110; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_112 = _controlSignals_T_87 ? 5'h11 : _controlSignals_T_111; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_113 = _controlSignals_T_85 ? 5'h10 : _controlSignals_T_112; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_114 = _controlSignals_T_83 ? 5'h12 : _controlSignals_T_113; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_115 = _controlSignals_T_81 ? 5'hd : _controlSignals_T_114; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_116 = _controlSignals_T_79 ? 5'h1 : _controlSignals_T_115; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_117 = _controlSignals_T_77 ? 5'h1 : _controlSignals_T_116; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_118 = _controlSignals_T_75 ? 5'h1 : _controlSignals_T_117; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_119 = _controlSignals_T_73 ? 5'h1 : _controlSignals_T_118; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_120 = _controlSignals_T_71 ? 5'h1 : _controlSignals_T_119; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_121 = _controlSignals_T_69 ? 5'h1 : _controlSignals_T_120; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_122 = _controlSignals_T_67 ? 5'h1 : _controlSignals_T_121; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_123 = _controlSignals_T_65 ? 5'h1 : _controlSignals_T_122; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_124 = _controlSignals_T_63 ? 5'h1 : _controlSignals_T_123; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_125 = _controlSignals_T_61 ? 5'h1 : _controlSignals_T_124; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_126 = _controlSignals_T_59 ? 5'h1 : _controlSignals_T_125; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_127 = _controlSignals_T_57 ? 5'h9 : _controlSignals_T_126; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_128 = _controlSignals_T_55 ? 5'h9 : _controlSignals_T_127; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_129 = _controlSignals_T_53 ? 5'h8 : _controlSignals_T_128; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_130 = _controlSignals_T_51 ? 5'h8 : _controlSignals_T_129; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_131 = _controlSignals_T_49 ? 5'h7 : _controlSignals_T_130; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_132 = _controlSignals_T_47 ? 5'h7 : _controlSignals_T_131; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_133 = _controlSignals_T_45 ? 5'h6 : _controlSignals_T_132; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_134 = _controlSignals_T_43 ? 5'h6 : _controlSignals_T_133; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_135 = _controlSignals_T_41 ? 5'h5 : _controlSignals_T_134; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_136 = _controlSignals_T_39 ? 5'h4 : _controlSignals_T_135; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_137 = _controlSignals_T_35 ? 5'h3 : _controlSignals_T_136; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_138 = _controlSignals_T_35 ? 5'h3 : _controlSignals_T_137; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_139 = _controlSignals_T_33 ? 5'h1 : _controlSignals_T_138; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_140 = _controlSignals_T_31 ? 5'h1 : _controlSignals_T_139; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_141 = _controlSignals_T_29 ? 5'h9 : _controlSignals_T_140; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_142 = _controlSignals_T_27 ? 5'h9 : _controlSignals_T_141; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_143 = _controlSignals_T_25 ? 5'h8 : _controlSignals_T_142; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_144 = _controlSignals_T_23 ? 5'h8 : _controlSignals_T_143; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_145 = _controlSignals_T_21 ? 5'h7 : _controlSignals_T_144; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_146 = _controlSignals_T_19 ? 5'h7 : _controlSignals_T_145; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_147 = _controlSignals_T_17 ? 5'h6 : _controlSignals_T_146; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_148 = _controlSignals_T_15 ? 5'h6 : _controlSignals_T_147; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_149 = _controlSignals_T_13 ? 5'h5 : _controlSignals_T_148; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_150 = _controlSignals_T_11 ? 5'h4 : _controlSignals_T_149; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_151 = _controlSignals_T_9 ? 5'h3 : _controlSignals_T_150; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_152 = _controlSignals_T_7 ? 5'h2 : _controlSignals_T_151; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_153 = _controlSignals_T_5 ? 5'h2 : _controlSignals_T_152; // @[Lookup.scala 34:39]
  wire [4:0] _controlSignals_T_154 = _controlSignals_T_3 ? 5'h1 : _controlSignals_T_153; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_158 = _controlSignals_T_97 ? 2'h3 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_159 = _controlSignals_T_95 ? 2'h3 : _controlSignals_T_158; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_160 = _controlSignals_T_93 ? 2'h3 : _controlSignals_T_159; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_161 = _controlSignals_T_91 ? 2'h1 : _controlSignals_T_160; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_162 = _controlSignals_T_89 ? 2'h1 : _controlSignals_T_161; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_163 = _controlSignals_T_87 ? 2'h1 : _controlSignals_T_162; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_164 = _controlSignals_T_85 ? 2'h1 : _controlSignals_T_163; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_165 = _controlSignals_T_83 ? 2'h1 : _controlSignals_T_164; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_166 = _controlSignals_T_81 ? 2'h1 : _controlSignals_T_165; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_167 = _controlSignals_T_79 ? 2'h1 : _controlSignals_T_166; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_168 = _controlSignals_T_77 ? 2'h1 : _controlSignals_T_167; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_169 = _controlSignals_T_75 ? 2'h1 : _controlSignals_T_168; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_170 = _controlSignals_T_73 ? 2'h1 : _controlSignals_T_169; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_171 = _controlSignals_T_71 ? 2'h1 : _controlSignals_T_170; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_172 = _controlSignals_T_69 ? 2'h1 : _controlSignals_T_171; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_173 = _controlSignals_T_67 ? 2'h1 : _controlSignals_T_172; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_174 = _controlSignals_T_65 ? 2'h1 : _controlSignals_T_173; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_175 = _controlSignals_T_63 ? 2'h1 : _controlSignals_T_174; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_176 = _controlSignals_T_61 ? 2'h1 : _controlSignals_T_175; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_177 = _controlSignals_T_59 ? 2'h1 : _controlSignals_T_176; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_178 = _controlSignals_T_57 ? 2'h1 : _controlSignals_T_177; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_179 = _controlSignals_T_55 ? 2'h1 : _controlSignals_T_178; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_180 = _controlSignals_T_53 ? 2'h1 : _controlSignals_T_179; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_181 = _controlSignals_T_51 ? 2'h1 : _controlSignals_T_180; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_182 = _controlSignals_T_49 ? 2'h1 : _controlSignals_T_181; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_183 = _controlSignals_T_47 ? 2'h1 : _controlSignals_T_182; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_184 = _controlSignals_T_45 ? 2'h1 : _controlSignals_T_183; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_185 = _controlSignals_T_43 ? 2'h1 : _controlSignals_T_184; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_186 = _controlSignals_T_41 ? 2'h1 : _controlSignals_T_185; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_187 = _controlSignals_T_39 ? 2'h1 : _controlSignals_T_186; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_188 = _controlSignals_T_35 ? 2'h1 : _controlSignals_T_187; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_189 = _controlSignals_T_35 ? 2'h1 : _controlSignals_T_188; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_190 = _controlSignals_T_33 ? 2'h1 : _controlSignals_T_189; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_191 = _controlSignals_T_31 ? 2'h1 : _controlSignals_T_190; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_192 = _controlSignals_T_29 ? 2'h1 : _controlSignals_T_191; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_193 = _controlSignals_T_27 ? 2'h1 : _controlSignals_T_192; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_194 = _controlSignals_T_25 ? 2'h1 : _controlSignals_T_193; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_195 = _controlSignals_T_23 ? 2'h1 : _controlSignals_T_194; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_196 = _controlSignals_T_21 ? 2'h1 : _controlSignals_T_195; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_197 = _controlSignals_T_19 ? 2'h1 : _controlSignals_T_196; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_198 = _controlSignals_T_17 ? 2'h1 : _controlSignals_T_197; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_199 = _controlSignals_T_15 ? 2'h1 : _controlSignals_T_198; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_200 = _controlSignals_T_13 ? 2'h1 : _controlSignals_T_199; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_201 = _controlSignals_T_11 ? 2'h1 : _controlSignals_T_200; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_202 = _controlSignals_T_9 ? 2'h1 : _controlSignals_T_201; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_203 = _controlSignals_T_7 ? 2'h1 : _controlSignals_T_202; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_204 = _controlSignals_T_5 ? 2'h1 : _controlSignals_T_203; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_205 = _controlSignals_T_3 ? 2'h1 : _controlSignals_T_204; // @[Lookup.scala 34:39]
  wire [1:0] controlSignals_1 = _controlSignals_T_1 ? 2'h1 : _controlSignals_T_205; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_208 = _controlSignals_T_99 ? 3'h5 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_209 = _controlSignals_T_97 ? 3'h5 : _controlSignals_T_208; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_210 = _controlSignals_T_95 ? 3'h3 : _controlSignals_T_209; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_211 = _controlSignals_T_93 ? 3'h3 : _controlSignals_T_210; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_212 = _controlSignals_T_91 ? 3'h1 : _controlSignals_T_211; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_213 = _controlSignals_T_89 ? 3'h1 : _controlSignals_T_212; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_214 = _controlSignals_T_87 ? 3'h1 : _controlSignals_T_213; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_215 = _controlSignals_T_85 ? 3'h1 : _controlSignals_T_214; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_216 = _controlSignals_T_83 ? 3'h1 : _controlSignals_T_215; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_217 = _controlSignals_T_81 ? 3'h1 : _controlSignals_T_216; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_218 = _controlSignals_T_79 ? 3'h4 : _controlSignals_T_217; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_219 = _controlSignals_T_77 ? 3'h4 : _controlSignals_T_218; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_220 = _controlSignals_T_75 ? 3'h4 : _controlSignals_T_219; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_221 = _controlSignals_T_73 ? 3'h4 : _controlSignals_T_220; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_222 = _controlSignals_T_71 ? 3'h2 : _controlSignals_T_221; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_223 = _controlSignals_T_69 ? 3'h2 : _controlSignals_T_222; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_224 = _controlSignals_T_67 ? 3'h2 : _controlSignals_T_223; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_225 = _controlSignals_T_65 ? 3'h2 : _controlSignals_T_224; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_226 = _controlSignals_T_63 ? 3'h2 : _controlSignals_T_225; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_227 = _controlSignals_T_61 ? 3'h2 : _controlSignals_T_226; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_228 = _controlSignals_T_59 ? 3'h2 : _controlSignals_T_227; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_229 = _controlSignals_T_57 ? 3'h2 : _controlSignals_T_228; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_230 = _controlSignals_T_55 ? 3'h2 : _controlSignals_T_229; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_231 = _controlSignals_T_53 ? 3'h2 : _controlSignals_T_230; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_232 = _controlSignals_T_51 ? 3'h2 : _controlSignals_T_231; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_233 = _controlSignals_T_49 ? 3'h2 : _controlSignals_T_232; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_234 = _controlSignals_T_47 ? 3'h2 : _controlSignals_T_233; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_235 = _controlSignals_T_45 ? 3'h2 : _controlSignals_T_234; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_236 = _controlSignals_T_43 ? 3'h2 : _controlSignals_T_235; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_237 = _controlSignals_T_41 ? 3'h2 : _controlSignals_T_236; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_238 = _controlSignals_T_39 ? 3'h2 : _controlSignals_T_237; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_239 = _controlSignals_T_35 ? 3'h2 : _controlSignals_T_238; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_240 = _controlSignals_T_35 ? 3'h2 : _controlSignals_T_239; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_241 = _controlSignals_T_33 ? 3'h2 : _controlSignals_T_240; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_242 = _controlSignals_T_31 ? 3'h2 : _controlSignals_T_241; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_243 = _controlSignals_T_29 ? 3'h1 : _controlSignals_T_242; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_244 = _controlSignals_T_27 ? 3'h1 : _controlSignals_T_243; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_245 = _controlSignals_T_25 ? 3'h1 : _controlSignals_T_244; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_246 = _controlSignals_T_23 ? 3'h1 : _controlSignals_T_245; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_247 = _controlSignals_T_21 ? 3'h1 : _controlSignals_T_246; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_248 = _controlSignals_T_19 ? 3'h1 : _controlSignals_T_247; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_249 = _controlSignals_T_17 ? 3'h1 : _controlSignals_T_248; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_250 = _controlSignals_T_15 ? 3'h1 : _controlSignals_T_249; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_251 = _controlSignals_T_13 ? 3'h1 : _controlSignals_T_250; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_252 = _controlSignals_T_11 ? 3'h1 : _controlSignals_T_251; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_253 = _controlSignals_T_9 ? 3'h1 : _controlSignals_T_252; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_254 = _controlSignals_T_7 ? 3'h1 : _controlSignals_T_253; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_255 = _controlSignals_T_5 ? 3'h1 : _controlSignals_T_254; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_256 = _controlSignals_T_3 ? 3'h1 : _controlSignals_T_255; // @[Lookup.scala 34:39]
  wire [2:0] controlSignals_2 = _controlSignals_T_1 ? 3'h1 : _controlSignals_T_256; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_269 = _controlSignals_T_79 ? 4'h7 : 4'h0; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_270 = _controlSignals_T_77 ? 4'h6 : _controlSignals_T_269; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_271 = _controlSignals_T_75 ? 4'h5 : _controlSignals_T_270; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_272 = _controlSignals_T_73 ? 4'h4 : _controlSignals_T_271; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_273 = _controlSignals_T_71 ? 4'he : _controlSignals_T_272; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_274 = _controlSignals_T_69 ? 4'hd : _controlSignals_T_273; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_275 = _controlSignals_T_67 ? 4'hc : _controlSignals_T_274; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_276 = _controlSignals_T_65 ? 4'hb : _controlSignals_T_275; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_277 = _controlSignals_T_63 ? 4'ha : _controlSignals_T_276; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_278 = _controlSignals_T_61 ? 4'h9 : _controlSignals_T_277; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_279 = _controlSignals_T_59 ? 4'h8 : _controlSignals_T_278; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_280 = _controlSignals_T_57 ? 4'h0 : _controlSignals_T_279; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_281 = _controlSignals_T_55 ? 4'h0 : _controlSignals_T_280; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_282 = _controlSignals_T_53 ? 4'h0 : _controlSignals_T_281; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_283 = _controlSignals_T_51 ? 4'h0 : _controlSignals_T_282; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_284 = _controlSignals_T_49 ? 4'h0 : _controlSignals_T_283; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_285 = _controlSignals_T_47 ? 4'h0 : _controlSignals_T_284; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_286 = _controlSignals_T_45 ? 4'h0 : _controlSignals_T_285; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_287 = _controlSignals_T_43 ? 4'h0 : _controlSignals_T_286; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_288 = _controlSignals_T_41 ? 4'h0 : _controlSignals_T_287; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_289 = _controlSignals_T_39 ? 4'h0 : _controlSignals_T_288; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_290 = _controlSignals_T_35 ? 4'h0 : _controlSignals_T_289; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_291 = _controlSignals_T_35 ? 4'h0 : _controlSignals_T_290; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_292 = _controlSignals_T_33 ? 4'h0 : _controlSignals_T_291; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_293 = _controlSignals_T_31 ? 4'h0 : _controlSignals_T_292; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_294 = _controlSignals_T_29 ? 4'h0 : _controlSignals_T_293; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_295 = _controlSignals_T_27 ? 4'h0 : _controlSignals_T_294; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_296 = _controlSignals_T_25 ? 4'h0 : _controlSignals_T_295; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_297 = _controlSignals_T_23 ? 4'h0 : _controlSignals_T_296; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_298 = _controlSignals_T_21 ? 4'h0 : _controlSignals_T_297; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_299 = _controlSignals_T_19 ? 4'h0 : _controlSignals_T_298; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_300 = _controlSignals_T_17 ? 4'h0 : _controlSignals_T_299; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_301 = _controlSignals_T_15 ? 4'h0 : _controlSignals_T_300; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_302 = _controlSignals_T_13 ? 4'h0 : _controlSignals_T_301; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_303 = _controlSignals_T_11 ? 4'h0 : _controlSignals_T_302; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_304 = _controlSignals_T_9 ? 4'h0 : _controlSignals_T_303; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_305 = _controlSignals_T_7 ? 4'h0 : _controlSignals_T_304; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_306 = _controlSignals_T_5 ? 4'h0 : _controlSignals_T_305; // @[Lookup.scala 34:39]
  wire [3:0] _controlSignals_T_307 = _controlSignals_T_3 ? 4'h0 : _controlSignals_T_306; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_310 = _controlSignals_T_99 ? 2'h1 : 2'h0; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_311 = _controlSignals_T_97 ? 2'h1 : _controlSignals_T_310; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_312 = _controlSignals_T_95 ? 2'h1 : _controlSignals_T_311; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_313 = _controlSignals_T_93 ? 2'h1 : _controlSignals_T_312; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_314 = _controlSignals_T_91 ? 2'h0 : _controlSignals_T_313; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_315 = _controlSignals_T_89 ? 2'h0 : _controlSignals_T_314; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_316 = _controlSignals_T_87 ? 2'h0 : _controlSignals_T_315; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_317 = _controlSignals_T_85 ? 2'h0 : _controlSignals_T_316; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_318 = _controlSignals_T_83 ? 2'h0 : _controlSignals_T_317; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_319 = _controlSignals_T_81 ? 2'h0 : _controlSignals_T_318; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_320 = _controlSignals_T_79 ? 2'h0 : _controlSignals_T_319; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_321 = _controlSignals_T_77 ? 2'h0 : _controlSignals_T_320; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_322 = _controlSignals_T_75 ? 2'h0 : _controlSignals_T_321; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_323 = _controlSignals_T_73 ? 2'h0 : _controlSignals_T_322; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_324 = _controlSignals_T_71 ? 2'h1 : _controlSignals_T_323; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_325 = _controlSignals_T_69 ? 2'h1 : _controlSignals_T_324; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_326 = _controlSignals_T_67 ? 2'h1 : _controlSignals_T_325; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_327 = _controlSignals_T_65 ? 2'h1 : _controlSignals_T_326; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_328 = _controlSignals_T_63 ? 2'h1 : _controlSignals_T_327; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_329 = _controlSignals_T_61 ? 2'h1 : _controlSignals_T_328; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_330 = _controlSignals_T_59 ? 2'h1 : _controlSignals_T_329; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_331 = _controlSignals_T_57 ? 2'h1 : _controlSignals_T_330; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_332 = _controlSignals_T_55 ? 2'h1 : _controlSignals_T_331; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_333 = _controlSignals_T_53 ? 2'h1 : _controlSignals_T_332; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_334 = _controlSignals_T_51 ? 2'h1 : _controlSignals_T_333; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_335 = _controlSignals_T_49 ? 2'h1 : _controlSignals_T_334; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_336 = _controlSignals_T_47 ? 2'h1 : _controlSignals_T_335; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_337 = _controlSignals_T_45 ? 2'h1 : _controlSignals_T_336; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_338 = _controlSignals_T_43 ? 2'h1 : _controlSignals_T_337; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_339 = _controlSignals_T_41 ? 2'h1 : _controlSignals_T_338; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_340 = _controlSignals_T_39 ? 2'h1 : _controlSignals_T_339; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_341 = _controlSignals_T_35 ? 2'h1 : _controlSignals_T_340; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_342 = _controlSignals_T_35 ? 2'h1 : _controlSignals_T_341; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_343 = _controlSignals_T_33 ? 2'h1 : _controlSignals_T_342; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_344 = _controlSignals_T_31 ? 2'h1 : _controlSignals_T_343; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_345 = _controlSignals_T_29 ? 2'h1 : _controlSignals_T_344; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_346 = _controlSignals_T_27 ? 2'h1 : _controlSignals_T_345; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_347 = _controlSignals_T_25 ? 2'h1 : _controlSignals_T_346; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_348 = _controlSignals_T_23 ? 2'h1 : _controlSignals_T_347; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_349 = _controlSignals_T_21 ? 2'h1 : _controlSignals_T_348; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_350 = _controlSignals_T_19 ? 2'h1 : _controlSignals_T_349; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_351 = _controlSignals_T_17 ? 2'h1 : _controlSignals_T_350; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_352 = _controlSignals_T_15 ? 2'h1 : _controlSignals_T_351; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_353 = _controlSignals_T_13 ? 2'h1 : _controlSignals_T_352; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_354 = _controlSignals_T_11 ? 2'h1 : _controlSignals_T_353; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_355 = _controlSignals_T_9 ? 2'h1 : _controlSignals_T_354; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_356 = _controlSignals_T_7 ? 2'h1 : _controlSignals_T_355; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_357 = _controlSignals_T_5 ? 2'h1 : _controlSignals_T_356; // @[Lookup.scala 34:39]
  wire [1:0] _controlSignals_T_358 = _controlSignals_T_3 ? 2'h1 : _controlSignals_T_357; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_361 = _controlSignals_T_99 ? 3'h1 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_362 = _controlSignals_T_97 ? 3'h1 : _controlSignals_T_361; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_363 = _controlSignals_T_95 ? 3'h3 : _controlSignals_T_362; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_364 = _controlSignals_T_93 ? 3'h3 : _controlSignals_T_363; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_365 = _controlSignals_T_91 ? 3'h0 : _controlSignals_T_364; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_366 = _controlSignals_T_89 ? 3'h0 : _controlSignals_T_365; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_367 = _controlSignals_T_87 ? 3'h0 : _controlSignals_T_366; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_368 = _controlSignals_T_85 ? 3'h0 : _controlSignals_T_367; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_369 = _controlSignals_T_83 ? 3'h0 : _controlSignals_T_368; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_370 = _controlSignals_T_81 ? 3'h0 : _controlSignals_T_369; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_371 = _controlSignals_T_79 ? 3'h0 : _controlSignals_T_370; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_372 = _controlSignals_T_77 ? 3'h0 : _controlSignals_T_371; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_373 = _controlSignals_T_75 ? 3'h0 : _controlSignals_T_372; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_374 = _controlSignals_T_73 ? 3'h0 : _controlSignals_T_373; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_375 = _controlSignals_T_71 ? 3'h2 : _controlSignals_T_374; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_376 = _controlSignals_T_69 ? 3'h2 : _controlSignals_T_375; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_377 = _controlSignals_T_67 ? 3'h2 : _controlSignals_T_376; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_378 = _controlSignals_T_65 ? 3'h2 : _controlSignals_T_377; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_379 = _controlSignals_T_63 ? 3'h2 : _controlSignals_T_378; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_380 = _controlSignals_T_61 ? 3'h2 : _controlSignals_T_379; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_381 = _controlSignals_T_59 ? 3'h2 : _controlSignals_T_380; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_382 = _controlSignals_T_57 ? 3'h1 : _controlSignals_T_381; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_383 = _controlSignals_T_55 ? 3'h1 : _controlSignals_T_382; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_384 = _controlSignals_T_53 ? 3'h1 : _controlSignals_T_383; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_385 = _controlSignals_T_51 ? 3'h1 : _controlSignals_T_384; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_386 = _controlSignals_T_49 ? 3'h1 : _controlSignals_T_385; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_387 = _controlSignals_T_47 ? 3'h1 : _controlSignals_T_386; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_388 = _controlSignals_T_45 ? 3'h1 : _controlSignals_T_387; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_389 = _controlSignals_T_43 ? 3'h1 : _controlSignals_T_388; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_390 = _controlSignals_T_41 ? 3'h1 : _controlSignals_T_389; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_391 = _controlSignals_T_39 ? 3'h1 : _controlSignals_T_390; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_392 = _controlSignals_T_35 ? 3'h1 : _controlSignals_T_391; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_393 = _controlSignals_T_35 ? 3'h1 : _controlSignals_T_392; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_394 = _controlSignals_T_33 ? 3'h1 : _controlSignals_T_393; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_395 = _controlSignals_T_31 ? 3'h1 : _controlSignals_T_394; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_396 = _controlSignals_T_29 ? 3'h1 : _controlSignals_T_395; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_397 = _controlSignals_T_27 ? 3'h1 : _controlSignals_T_396; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_398 = _controlSignals_T_25 ? 3'h1 : _controlSignals_T_397; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_399 = _controlSignals_T_23 ? 3'h1 : _controlSignals_T_398; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_400 = _controlSignals_T_21 ? 3'h1 : _controlSignals_T_399; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_401 = _controlSignals_T_19 ? 3'h1 : _controlSignals_T_400; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_402 = _controlSignals_T_17 ? 3'h1 : _controlSignals_T_401; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_403 = _controlSignals_T_15 ? 3'h1 : _controlSignals_T_402; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_404 = _controlSignals_T_13 ? 3'h1 : _controlSignals_T_403; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_405 = _controlSignals_T_11 ? 3'h1 : _controlSignals_T_404; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_406 = _controlSignals_T_9 ? 3'h1 : _controlSignals_T_405; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_407 = _controlSignals_T_7 ? 3'h1 : _controlSignals_T_406; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_408 = _controlSignals_T_5 ? 3'h1 : _controlSignals_T_407; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_409 = _controlSignals_T_3 ? 3'h1 : _controlSignals_T_408; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_410 = _controlSignals_T_103 ? 3'h4 : 3'h0; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_411 = _controlSignals_T_101 ? 3'h4 : _controlSignals_T_410; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_412 = _controlSignals_T_99 ? 3'h0 : _controlSignals_T_411; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_413 = _controlSignals_T_97 ? 3'h0 : _controlSignals_T_412; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_414 = _controlSignals_T_95 ? 3'h0 : _controlSignals_T_413; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_415 = _controlSignals_T_93 ? 3'h0 : _controlSignals_T_414; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_416 = _controlSignals_T_91 ? 3'h0 : _controlSignals_T_415; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_417 = _controlSignals_T_89 ? 3'h0 : _controlSignals_T_416; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_418 = _controlSignals_T_87 ? 3'h0 : _controlSignals_T_417; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_419 = _controlSignals_T_85 ? 3'h0 : _controlSignals_T_418; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_420 = _controlSignals_T_83 ? 3'h0 : _controlSignals_T_419; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_421 = _controlSignals_T_81 ? 3'h0 : _controlSignals_T_420; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_422 = _controlSignals_T_79 ? 3'h0 : _controlSignals_T_421; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_423 = _controlSignals_T_77 ? 3'h0 : _controlSignals_T_422; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_424 = _controlSignals_T_75 ? 3'h0 : _controlSignals_T_423; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_425 = _controlSignals_T_73 ? 3'h0 : _controlSignals_T_424; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_426 = _controlSignals_T_71 ? 3'h0 : _controlSignals_T_425; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_427 = _controlSignals_T_69 ? 3'h0 : _controlSignals_T_426; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_428 = _controlSignals_T_67 ? 3'h0 : _controlSignals_T_427; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_429 = _controlSignals_T_65 ? 3'h0 : _controlSignals_T_428; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_430 = _controlSignals_T_63 ? 3'h0 : _controlSignals_T_429; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_431 = _controlSignals_T_61 ? 3'h0 : _controlSignals_T_430; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_432 = _controlSignals_T_59 ? 3'h0 : _controlSignals_T_431; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_433 = _controlSignals_T_57 ? 3'h0 : _controlSignals_T_432; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_434 = _controlSignals_T_55 ? 3'h0 : _controlSignals_T_433; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_435 = _controlSignals_T_53 ? 3'h0 : _controlSignals_T_434; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_436 = _controlSignals_T_51 ? 3'h0 : _controlSignals_T_435; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_437 = _controlSignals_T_49 ? 3'h0 : _controlSignals_T_436; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_438 = _controlSignals_T_47 ? 3'h0 : _controlSignals_T_437; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_439 = _controlSignals_T_45 ? 3'h0 : _controlSignals_T_438; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_440 = _controlSignals_T_43 ? 3'h0 : _controlSignals_T_439; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_441 = _controlSignals_T_41 ? 3'h0 : _controlSignals_T_440; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_442 = _controlSignals_T_39 ? 3'h0 : _controlSignals_T_441; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_443 = _controlSignals_T_35 ? 3'h0 : _controlSignals_T_442; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_444 = _controlSignals_T_35 ? 3'h0 : _controlSignals_T_443; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_445 = _controlSignals_T_33 ? 3'h0 : _controlSignals_T_444; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_446 = _controlSignals_T_31 ? 3'h0 : _controlSignals_T_445; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_447 = _controlSignals_T_29 ? 3'h0 : _controlSignals_T_446; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_448 = _controlSignals_T_27 ? 3'h0 : _controlSignals_T_447; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_449 = _controlSignals_T_25 ? 3'h0 : _controlSignals_T_448; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_450 = _controlSignals_T_23 ? 3'h0 : _controlSignals_T_449; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_451 = _controlSignals_T_21 ? 3'h0 : _controlSignals_T_450; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_452 = _controlSignals_T_19 ? 3'h0 : _controlSignals_T_451; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_453 = _controlSignals_T_17 ? 3'h0 : _controlSignals_T_452; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_454 = _controlSignals_T_15 ? 3'h0 : _controlSignals_T_453; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_455 = _controlSignals_T_13 ? 3'h0 : _controlSignals_T_454; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_456 = _controlSignals_T_11 ? 3'h0 : _controlSignals_T_455; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_457 = _controlSignals_T_9 ? 3'h0 : _controlSignals_T_456; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_458 = _controlSignals_T_7 ? 3'h0 : _controlSignals_T_457; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_459 = _controlSignals_T_5 ? 3'h0 : _controlSignals_T_458; // @[Lookup.scala 34:39]
  wire [2:0] _controlSignals_T_460 = _controlSignals_T_3 ? 3'h0 : _controlSignals_T_459; // @[Lookup.scala 34:39]
  wire [2:0] controlSignals_6 = _controlSignals_T_1 ? 3'h0 : _controlSignals_T_460; // @[Lookup.scala 34:39]
  wire  _srcAdata_T = controlSignals_1 == 2'h1; // @[Decode.scala 111:15]
  wire  _srcAdata_T_1 = controlSignals_1 == 2'h2; // @[Decode.scala 112:15]
  wire  _srcAdata_T_2 = controlSignals_1 == 2'h3; // @[Decode.scala 113:15]
  wire [63:0] _srcAdata_T_3 = _srcAdata_T_2 ? io_cur_pc : 64'h0; // @[Mux.scala 101:16]
  wire [63:0] _srcAdata_T_4 = _srcAdata_T_1 ? imm_z_uext : _srcAdata_T_3; // @[Mux.scala 101:16]
  wire  _srcBdata_T = controlSignals_2 == 3'h1; // @[Decode.scala 117:15]
  wire  _srcBdata_T_1 = controlSignals_2 == 3'h2; // @[Decode.scala 118:15]
  wire  _srcBdata_T_2 = controlSignals_2 == 3'h3; // @[Decode.scala 119:15]
  wire  _srcBdata_T_3 = controlSignals_2 == 3'h5; // @[Decode.scala 120:15]
  wire  _srcBdata_T_4 = controlSignals_2 == 3'h4; // @[Decode.scala 121:15]
  wire [63:0] _srcBdata_T_5 = _srcBdata_T_4 ? imm_s_sext : 64'h0; // @[Mux.scala 101:16]
  wire [63:0] _srcBdata_T_6 = _srcBdata_T_3 ? {{32'd0}, imm_u_shifted} : _srcBdata_T_5; // @[Mux.scala 101:16]
  wire [63:0] _srcBdata_T_7 = _srcBdata_T_2 ? imm_j_sext : _srcBdata_T_6; // @[Mux.scala 101:16]
  wire [63:0] _srcBdata_T_8 = _srcBdata_T_1 ? imm_i_sext : _srcBdata_T_7; // @[Mux.scala 101:16]
  assign io_pcOut = io_cur_pc; // @[Decode.scala 139:12]
  assign io_decodeOut_alu_exe_fun = _controlSignals_T_1 ? 5'h1 : _controlSignals_T_154; // @[Lookup.scala 34:39]
  assign io_decodeOut_memType = _controlSignals_T_1 ? 4'h0 : _controlSignals_T_307; // @[Lookup.scala 34:39]
  assign io_decodeOut_regType = _controlSignals_T_1 ? 2'h1 : _controlSignals_T_358; // @[Lookup.scala 34:39]
  assign io_decodeOut_wbType = _controlSignals_T_1 ? 3'h1 : _controlSignals_T_409; // @[Lookup.scala 34:39]
  assign io_decodeOut_CSRType = _controlSignals_T_1 ? 3'h0 : _controlSignals_T_460; // @[Lookup.scala 34:39]
  assign io_decodeOut_csrAddr = controlSignals_6 == 3'h4 ? 12'h342 : imm_i; // @[Decode.scala 124:21]
  assign io_srcOut_aluSrc_a = _srcAdata_T ? io_forward_hazardAData : _srcAdata_T_4; // @[Mux.scala 101:16]
  assign io_srcOut_aluSrc_b = _srcBdata_T ? io_forward_hazardBData : _srcBdata_T_8; // @[Mux.scala 101:16]
  assign io_srcOut_regB_data = io_forward_hazardBData; // @[Decode.scala 129:23]
  assign io_srcOut_writeback_addr = de_inst[11:7]; // @[Decode.scala 38:36]
  assign io_srcOut_imm_b = {imm_b_sext_hi,1'h0}; // @[Cat.scala 31:58]
  assign io_forward_srcAddrA = de_inst[19:15]; // @[Decode.scala 26:25]
  assign io_forward_srcAddrB = de_inst[24:20]; // @[Decode.scala 27:25]
  assign io_stall_srcAddrA = de_inst[19:15]; // @[Decode.scala 26:25]
  assign io_stall_srcAddrB = de_inst[24:20]; // @[Decode.scala 27:25]
endmodule
module DecodeToExecute(
  input         clock,
  input         reset,
  input         io_jumpOrBranchFlag,
  input  [63:0] io_cur_pc,
  output [63:0] io_pcOut,
  input  [4:0]  io_controlSignal_alu_exe_fun,
  input  [3:0]  io_controlSignal_memType,
  input  [1:0]  io_controlSignal_regType,
  input  [2:0]  io_controlSignal_wbType,
  input  [2:0]  io_controlSignal_CSRType,
  input  [11:0] io_controlSignal_csrAddr,
  input  [63:0] io_opSrc_aluSrc_a,
  input  [63:0] io_opSrc_aluSrc_b,
  input  [63:0] io_opSrc_regB_data,
  input  [4:0]  io_opSrc_writeback_addr,
  input  [63:0] io_opSrc_imm_b,
  output [4:0]  io_controlSignalPass_alu_exe_fun,
  output [3:0]  io_controlSignalPass_memType,
  output [1:0]  io_controlSignalPass_regType,
  output [2:0]  io_controlSignalPass_wbType,
  output [2:0]  io_controlSignalPass_CSRType,
  output [11:0] io_controlSignalPass_csrAddr,
  output [63:0] io_srcPass_aluSrc_a,
  output [63:0] io_srcPass_aluSrc_b,
  output [63:0] io_srcPass_regB_data,
  output [4:0]  io_srcPass_writeback_addr,
  output [63:0] io_srcPass_imm_b
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [63:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [63:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [63:0] _RAND_10;
  reg [63:0] _RAND_11;
`endif // RANDOMIZE_REG_INIT
  reg [4:0] alu_exe_fun; // @[DecodeToExecute.scala 21:28]
  reg [3:0] memType; // @[DecodeToExecute.scala 23:24]
  reg [1:0] regType; // @[DecodeToExecute.scala 25:24]
  reg [2:0] wbType; // @[DecodeToExecute.scala 27:23]
  reg [2:0] CSRType; // @[DecodeToExecute.scala 29:24]
  reg [11:0] csrAddr; // @[DecodeToExecute.scala 30:24]
  reg [63:0] srcA; // @[DecodeToExecute.scala 40:21]
  reg [63:0] srcB; // @[DecodeToExecute.scala 42:21]
  reg [63:0] regBData; // @[DecodeToExecute.scala 43:25]
  reg [4:0] writebackAddr; // @[DecodeToExecute.scala 45:30]
  reg [63:0] imm_b; // @[DecodeToExecute.scala 46:22]
  reg [63:0] progcnter; // @[DecodeToExecute.scala 54:26]
  assign io_pcOut = progcnter; // @[DecodeToExecute.scala 55:12]
  assign io_controlSignalPass_alu_exe_fun = alu_exe_fun; // @[DecodeToExecute.scala 32:36]
  assign io_controlSignalPass_memType = memType; // @[DecodeToExecute.scala 33:32]
  assign io_controlSignalPass_regType = regType; // @[DecodeToExecute.scala 34:32]
  assign io_controlSignalPass_wbType = wbType; // @[DecodeToExecute.scala 35:31]
  assign io_controlSignalPass_CSRType = CSRType; // @[DecodeToExecute.scala 36:32]
  assign io_controlSignalPass_csrAddr = csrAddr; // @[DecodeToExecute.scala 37:32]
  assign io_srcPass_aluSrc_a = srcA; // @[DecodeToExecute.scala 48:23]
  assign io_srcPass_aluSrc_b = srcB; // @[DecodeToExecute.scala 49:23]
  assign io_srcPass_regB_data = regBData; // @[DecodeToExecute.scala 50:24]
  assign io_srcPass_writeback_addr = writebackAddr; // @[DecodeToExecute.scala 51:29]
  assign io_srcPass_imm_b = imm_b; // @[DecodeToExecute.scala 52:20]
  always @(posedge clock) begin
    if (reset) begin // @[DecodeToExecute.scala 21:28]
      if (io_jumpOrBranchFlag) begin // @[DecodeToExecute.scala 20:19]
        alu_exe_fun <= 5'h1;
      end else begin
        alu_exe_fun <= io_controlSignal_alu_exe_fun;
      end
    end else begin
      alu_exe_fun <= 5'h0; // @[DecodeToExecute.scala 21:28]
    end
    if (reset) begin // @[DecodeToExecute.scala 23:24]
      if (io_jumpOrBranchFlag) begin // @[DecodeToExecute.scala 22:23]
        memType <= 4'h0;
      end else begin
        memType <= io_controlSignal_memType;
      end
    end else begin
      memType <= 4'h0; // @[DecodeToExecute.scala 23:24]
    end
    if (reset) begin // @[DecodeToExecute.scala 25:24]
      if (io_jumpOrBranchFlag) begin // @[DecodeToExecute.scala 24:23]
        regType <= 2'h1;
      end else begin
        regType <= io_controlSignal_regType;
      end
    end else begin
      regType <= 2'h0; // @[DecodeToExecute.scala 25:24]
    end
    if (reset) begin // @[DecodeToExecute.scala 27:23]
      if (io_jumpOrBranchFlag) begin // @[DecodeToExecute.scala 26:22]
        wbType <= 3'h1;
      end else begin
        wbType <= io_controlSignal_wbType;
      end
    end else begin
      wbType <= 3'h0; // @[DecodeToExecute.scala 27:23]
    end
    if (reset) begin // @[DecodeToExecute.scala 29:24]
      if (io_jumpOrBranchFlag) begin // @[DecodeToExecute.scala 28:23]
        CSRType <= 3'h0;
      end else begin
        CSRType <= io_controlSignal_CSRType;
      end
    end else begin
      CSRType <= 3'h0; // @[DecodeToExecute.scala 29:24]
    end
    if (reset) begin // @[DecodeToExecute.scala 30:24]
      csrAddr <= io_controlSignal_csrAddr; // @[DecodeToExecute.scala 30:24]
    end else begin
      csrAddr <= 12'h0; // @[DecodeToExecute.scala 30:24]
    end
    if (reset) begin // @[DecodeToExecute.scala 40:21]
      if (io_jumpOrBranchFlag) begin // @[DecodeToExecute.scala 39:20]
        srcA <= 64'h0;
      end else begin
        srcA <= io_opSrc_aluSrc_a;
      end
    end else begin
      srcA <= 64'h0; // @[DecodeToExecute.scala 40:21]
    end
    if (reset) begin // @[DecodeToExecute.scala 42:21]
      if (io_jumpOrBranchFlag) begin // @[DecodeToExecute.scala 41:20]
        srcB <= 64'h0;
      end else begin
        srcB <= io_opSrc_aluSrc_b;
      end
    end else begin
      srcB <= 64'h0; // @[DecodeToExecute.scala 42:21]
    end
    if (reset) begin // @[DecodeToExecute.scala 43:25]
      regBData <= io_opSrc_regB_data; // @[DecodeToExecute.scala 43:25]
    end else begin
      regBData <= 64'h0; // @[DecodeToExecute.scala 43:25]
    end
    if (reset) begin // @[DecodeToExecute.scala 45:30]
      if (io_jumpOrBranchFlag) begin // @[DecodeToExecute.scala 44:29]
        writebackAddr <= 5'h0;
      end else begin
        writebackAddr <= io_opSrc_writeback_addr;
      end
    end else begin
      writebackAddr <= 5'h0; // @[DecodeToExecute.scala 45:30]
    end
    if (reset) begin // @[DecodeToExecute.scala 46:22]
      imm_b <= io_opSrc_imm_b; // @[DecodeToExecute.scala 46:22]
    end else begin
      imm_b <= 64'h0; // @[DecodeToExecute.scala 46:22]
    end
    if (reset) begin // @[DecodeToExecute.scala 54:26]
      progcnter <= io_cur_pc; // @[DecodeToExecute.scala 54:26]
    end else begin
      progcnter <= 64'h0; // @[DecodeToExecute.scala 54:26]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  alu_exe_fun = _RAND_0[4:0];
  _RAND_1 = {1{`RANDOM}};
  memType = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  regType = _RAND_2[1:0];
  _RAND_3 = {1{`RANDOM}};
  wbType = _RAND_3[2:0];
  _RAND_4 = {1{`RANDOM}};
  CSRType = _RAND_4[2:0];
  _RAND_5 = {1{`RANDOM}};
  csrAddr = _RAND_5[11:0];
  _RAND_6 = {2{`RANDOM}};
  srcA = _RAND_6[63:0];
  _RAND_7 = {2{`RANDOM}};
  srcB = _RAND_7[63:0];
  _RAND_8 = {2{`RANDOM}};
  regBData = _RAND_8[63:0];
  _RAND_9 = {1{`RANDOM}};
  writebackAddr = _RAND_9[4:0];
  _RAND_10 = {2{`RANDOM}};
  imm_b = _RAND_10[63:0];
  _RAND_11 = {2{`RANDOM}};
  progcnter = _RAND_11[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Alu(
  input  [63:0] io_cur_pc,
  output        io_jumpFlag,
  output        io_branchFlag,
  output [63:0] io_linkedPC,
  output [63:0] io_branchTarget,
  input  [63:0] io_alu_in_aluSrc_a,
  input  [63:0] io_alu_in_aluSrc_b,
  input  [63:0] io_alu_in_regB_data,
  input  [4:0]  io_alu_in_writeback_addr,
  input  [63:0] io_alu_in_imm_b,
  output [63:0] io_alu_out_alu_result,
  output [4:0]  io_alu_out_writeback_addr,
  output [63:0] io_alu_out_regB_data,
  output [3:0]  io_controlPass_memType,
  output [1:0]  io_controlPass_regType,
  output [2:0]  io_controlPass_wbType,
  output [2:0]  io_controlPass_CSRType,
  output [11:0] io_controlPass_csrAddr,
  input  [4:0]  io_controlSignal_alu_exe_fun,
  input  [3:0]  io_controlSignal_memType,
  input  [1:0]  io_controlSignal_regType,
  input  [2:0]  io_controlSignal_wbType,
  input  [2:0]  io_controlSignal_CSRType,
  input  [11:0] io_controlSignal_csrAddr,
  output [4:0]  io_dataHazard_wbAddrFromExecute,
  output [1:0]  io_dataHazard_regTypeFromExecute,
  output [63:0] io_dataHazard_wbDataFromExe
);
  wire  _alu_out_T = io_controlSignal_alu_exe_fun == 5'h1; // @[Alu.scala 28:35]
  wire [63:0] _alu_out_T_2 = io_alu_in_aluSrc_a + io_alu_in_aluSrc_b; // @[Alu.scala 28:70]
  wire  _alu_out_T_3 = io_controlSignal_alu_exe_fun == 5'h2; // @[Alu.scala 29:35]
  wire [63:0] _alu_out_T_5 = io_alu_in_aluSrc_a - io_alu_in_aluSrc_b; // @[Alu.scala 29:70]
  wire  _alu_out_T_6 = io_controlSignal_alu_exe_fun == 5'h3; // @[Alu.scala 30:35]
  wire [63:0] _alu_out_T_7 = io_alu_in_aluSrc_a & io_alu_in_aluSrc_b; // @[Alu.scala 30:71]
  wire  _alu_out_T_8 = io_controlSignal_alu_exe_fun == 5'h4; // @[Alu.scala 31:35]
  wire [63:0] _alu_out_T_9 = io_alu_in_aluSrc_a | io_alu_in_aluSrc_b; // @[Alu.scala 31:71]
  wire  _alu_out_T_10 = io_controlSignal_alu_exe_fun == 5'h5; // @[Alu.scala 32:35]
  wire [63:0] _alu_out_T_11 = io_alu_in_aluSrc_a ^ io_alu_in_aluSrc_b; // @[Alu.scala 32:71]
  wire  _alu_out_T_12 = io_controlSignal_alu_exe_fun == 5'h6; // @[Alu.scala 33:35]
  wire [94:0] _GEN_0 = {{31'd0}, io_alu_in_aluSrc_a}; // @[Alu.scala 33:71]
  wire [94:0] _alu_out_T_14 = _GEN_0 << io_alu_in_aluSrc_b[4:0]; // @[Alu.scala 33:71]
  wire  _alu_out_T_15 = io_controlSignal_alu_exe_fun == 5'h7; // @[Alu.scala 34:35]
  wire [63:0] _alu_out_T_17 = io_alu_in_aluSrc_a >> io_alu_in_aluSrc_b[4:0]; // @[Alu.scala 34:71]
  wire  _alu_out_T_18 = io_controlSignal_alu_exe_fun == 5'h8; // @[Alu.scala 35:35]
  wire [63:0] _alu_out_T_22 = $signed(io_alu_in_aluSrc_a) >>> io_alu_in_aluSrc_b[4:0]; // @[Alu.scala 35:107]
  wire  _alu_out_T_23 = io_controlSignal_alu_exe_fun == 5'h9; // @[Alu.scala 36:35]
  wire  _alu_out_T_26 = $signed(io_alu_in_aluSrc_a) < $signed(io_alu_in_aluSrc_b); // @[Alu.scala 36:78]
  wire  _alu_out_T_27 = io_controlSignal_alu_exe_fun == 5'ha; // @[Alu.scala 37:35]
  wire  _alu_out_T_28 = io_alu_in_aluSrc_a < io_alu_in_aluSrc_b; // @[Alu.scala 37:79]
  wire  _alu_out_T_29 = io_controlSignal_alu_exe_fun == 5'hb; // @[Alu.scala 38:35]
  wire [63:0] _alu_out_T_32 = _alu_out_T_2 & 64'hfffffffffffffffe; // @[Alu.scala 38:93]
  wire  _alu_out_T_33 = io_controlSignal_alu_exe_fun == 5'hc; // @[Alu.scala 39:35]
  wire [63:0] _alu_out_T_34 = _alu_out_T_33 ? io_alu_in_aluSrc_a : 64'h0; // @[Mux.scala 101:16]
  wire [63:0] _alu_out_T_35 = _alu_out_T_29 ? _alu_out_T_32 : _alu_out_T_34; // @[Mux.scala 101:16]
  wire [63:0] _alu_out_T_36 = _alu_out_T_27 ? {{63'd0}, _alu_out_T_28} : _alu_out_T_35; // @[Mux.scala 101:16]
  wire [63:0] _alu_out_T_37 = _alu_out_T_23 ? {{63'd0}, _alu_out_T_26} : _alu_out_T_36; // @[Mux.scala 101:16]
  wire [63:0] _alu_out_T_38 = _alu_out_T_18 ? _alu_out_T_22 : _alu_out_T_37; // @[Mux.scala 101:16]
  wire [63:0] _alu_out_T_39 = _alu_out_T_15 ? _alu_out_T_17 : _alu_out_T_38; // @[Mux.scala 101:16]
  wire [94:0] _alu_out_T_40 = _alu_out_T_12 ? _alu_out_T_14 : {{31'd0}, _alu_out_T_39}; // @[Mux.scala 101:16]
  wire [94:0] _alu_out_T_41 = _alu_out_T_10 ? {{31'd0}, _alu_out_T_11} : _alu_out_T_40; // @[Mux.scala 101:16]
  wire [94:0] _alu_out_T_42 = _alu_out_T_8 ? {{31'd0}, _alu_out_T_9} : _alu_out_T_41; // @[Mux.scala 101:16]
  wire [94:0] _alu_out_T_43 = _alu_out_T_6 ? {{31'd0}, _alu_out_T_7} : _alu_out_T_42; // @[Mux.scala 101:16]
  wire [94:0] _alu_out_T_44 = _alu_out_T_3 ? {{31'd0}, _alu_out_T_5} : _alu_out_T_43; // @[Mux.scala 101:16]
  wire [94:0] alu_out = _alu_out_T ? {{31'd0}, _alu_out_T_2} : _alu_out_T_44; // @[Mux.scala 101:16]
  wire  _branch_flag_T = io_controlSignal_alu_exe_fun == 5'hd; // @[Alu.scala 48:35]
  wire  _branch_flag_T_1 = io_alu_in_aluSrc_a == io_alu_in_aluSrc_b; // @[Alu.scala 48:70]
  wire  _branch_flag_T_3 = io_controlSignal_alu_exe_fun == 5'he; // @[Alu.scala 49:35]
  wire  _branch_flag_T_4 = io_alu_in_aluSrc_a != io_alu_in_aluSrc_b; // @[Alu.scala 49:70]
  wire  _branch_flag_T_6 = io_controlSignal_alu_exe_fun == 5'hf; // @[Alu.scala 50:35]
  wire  _branch_flag_T_9 = io_controlSignal_alu_exe_fun == 5'h11; // @[Alu.scala 51:35]
  wire  _branch_flag_T_14 = io_controlSignal_alu_exe_fun == 5'h10; // @[Alu.scala 52:35]
  wire  _branch_flag_T_15 = io_alu_in_aluSrc_a >= io_alu_in_aluSrc_b; // @[Alu.scala 52:71]
  wire  _branch_flag_T_17 = io_controlSignal_alu_exe_fun == 5'h12; // @[Alu.scala 53:35]
  wire  _branch_flag_T_20 = $signed(io_alu_in_aluSrc_a) >= $signed(io_alu_in_aluSrc_b); // @[Alu.scala 53:77]
  wire  _branch_flag_T_23 = _branch_flag_T_14 ? _branch_flag_T_15 : _branch_flag_T_17 & _branch_flag_T_20; // @[Mux.scala 101:16]
  wire  _branch_flag_T_24 = _branch_flag_T_9 ? _alu_out_T_26 : _branch_flag_T_23; // @[Mux.scala 101:16]
  wire  _branch_flag_T_25 = _branch_flag_T_6 ? _alu_out_T_28 : _branch_flag_T_24; // @[Mux.scala 101:16]
  wire  _branch_flag_T_26 = _branch_flag_T_3 ? _branch_flag_T_4 : _branch_flag_T_25; // @[Mux.scala 101:16]
  assign io_jumpFlag = io_controlSignal_wbType == 3'h3; // @[Alu.scala 68:44]
  assign io_branchFlag = _branch_flag_T ? _branch_flag_T_1 : _branch_flag_T_26; // @[Mux.scala 101:16]
  assign io_linkedPC = io_cur_pc + 64'h4; // @[Alu.scala 63:28]
  assign io_branchTarget = io_alu_in_imm_b + io_cur_pc; // @[Alu.scala 71:38]
  assign io_alu_out_alu_result = alu_out[63:0]; // @[Alu.scala 65:25]
  assign io_alu_out_writeback_addr = io_alu_in_writeback_addr; // @[Alu.scala 66:29]
  assign io_alu_out_regB_data = io_alu_in_regB_data; // @[Alu.scala 67:24]
  assign io_controlPass_memType = io_controlSignal_memType; // @[Alu.scala 61:26]
  assign io_controlPass_regType = io_controlSignal_regType; // @[Alu.scala 57:26]
  assign io_controlPass_wbType = io_controlSignal_wbType; // @[Alu.scala 58:25]
  assign io_controlPass_CSRType = io_controlSignal_CSRType; // @[Alu.scala 59:26]
  assign io_controlPass_csrAddr = io_controlSignal_csrAddr; // @[Alu.scala 60:26]
  assign io_dataHazard_wbAddrFromExecute = io_alu_in_writeback_addr; // @[Alu.scala 75:35]
  assign io_dataHazard_regTypeFromExecute = io_controlSignal_regType; // @[Alu.scala 76:36]
  assign io_dataHazard_wbDataFromExe = alu_out[63:0]; // @[Alu.scala 74:31]
endmodule
module ExecuteToMema(
  input         clock,
  input         reset,
  input  [63:0] io_linkedPC,
  output [63:0] io_linkedPCPass,
  input  [63:0] io_aluOut_alu_result,
  input  [4:0]  io_aluOut_writeback_addr,
  input  [63:0] io_aluOut_regB_data,
  input  [3:0]  io_controlSignal_memType,
  input  [1:0]  io_controlSignal_regType,
  input  [2:0]  io_controlSignal_wbType,
  input  [2:0]  io_controlSignal_CSRType,
  input  [11:0] io_controlSignal_csrAddr,
  output [63:0] io_aluOutPass_alu_result,
  output [4:0]  io_aluOutPass_writeback_addr,
  output [63:0] io_aluOutPass_regB_data,
  output [3:0]  io_controlSignalPass_memType,
  output [1:0]  io_controlSignalPass_regType,
  output [2:0]  io_controlSignalPass_wbType,
  output [2:0]  io_controlSignalPass_CSRType,
  output [11:0] io_controlSignalPass_csrAddr
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [63:0] _RAND_8;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] alu_result; // @[ExecuteToMema.scala 18:27]
  reg [4:0] writeback_addr; // @[ExecuteToMema.scala 19:31]
  reg [63:0] regB_data; // @[ExecuteToMema.scala 20:26]
  reg [3:0] memType; // @[ExecuteToMema.scala 26:24]
  reg [1:0] regType; // @[ExecuteToMema.scala 27:24]
  reg [2:0] wbType; // @[ExecuteToMema.scala 28:23]
  reg [2:0] CSRType; // @[ExecuteToMema.scala 29:24]
  reg [11:0] csrAddr; // @[ExecuteToMema.scala 30:24]
  reg [63:0] linkedPC; // @[ExecuteToMema.scala 38:25]
  assign io_linkedPCPass = linkedPC; // @[ExecuteToMema.scala 40:19]
  assign io_aluOutPass_alu_result = alu_result; // @[ExecuteToMema.scala 22:28]
  assign io_aluOutPass_writeback_addr = writeback_addr; // @[ExecuteToMema.scala 23:32]
  assign io_aluOutPass_regB_data = regB_data; // @[ExecuteToMema.scala 24:27]
  assign io_controlSignalPass_memType = memType; // @[ExecuteToMema.scala 32:32]
  assign io_controlSignalPass_regType = regType; // @[ExecuteToMema.scala 33:32]
  assign io_controlSignalPass_wbType = wbType; // @[ExecuteToMema.scala 34:31]
  assign io_controlSignalPass_CSRType = CSRType; // @[ExecuteToMema.scala 35:32]
  assign io_controlSignalPass_csrAddr = csrAddr; // @[ExecuteToMema.scala 36:32]
  always @(posedge clock) begin
    if (reset) begin // @[ExecuteToMema.scala 18:27]
      alu_result <= io_aluOut_alu_result; // @[ExecuteToMema.scala 18:27]
    end else begin
      alu_result <= 64'h0; // @[ExecuteToMema.scala 18:27]
    end
    if (reset) begin // @[ExecuteToMema.scala 19:31]
      writeback_addr <= io_aluOut_writeback_addr; // @[ExecuteToMema.scala 19:31]
    end else begin
      writeback_addr <= 5'h0; // @[ExecuteToMema.scala 19:31]
    end
    if (reset) begin // @[ExecuteToMema.scala 20:26]
      regB_data <= io_aluOut_regB_data; // @[ExecuteToMema.scala 20:26]
    end else begin
      regB_data <= 64'h0; // @[ExecuteToMema.scala 20:26]
    end
    if (reset) begin // @[ExecuteToMema.scala 26:24]
      memType <= io_controlSignal_memType; // @[ExecuteToMema.scala 26:24]
    end else begin
      memType <= 4'h0; // @[ExecuteToMema.scala 26:24]
    end
    if (reset) begin // @[ExecuteToMema.scala 27:24]
      regType <= io_controlSignal_regType; // @[ExecuteToMema.scala 27:24]
    end else begin
      regType <= 2'h0; // @[ExecuteToMema.scala 27:24]
    end
    if (reset) begin // @[ExecuteToMema.scala 28:23]
      wbType <= io_controlSignal_wbType; // @[ExecuteToMema.scala 28:23]
    end else begin
      wbType <= 3'h0; // @[ExecuteToMema.scala 28:23]
    end
    if (reset) begin // @[ExecuteToMema.scala 29:24]
      CSRType <= io_controlSignal_CSRType; // @[ExecuteToMema.scala 29:24]
    end else begin
      CSRType <= 3'h0; // @[ExecuteToMema.scala 29:24]
    end
    if (reset) begin // @[ExecuteToMema.scala 30:24]
      csrAddr <= io_controlSignal_csrAddr; // @[ExecuteToMema.scala 30:24]
    end else begin
      csrAddr <= 12'h0; // @[ExecuteToMema.scala 30:24]
    end
    if (reset) begin // @[ExecuteToMema.scala 38:25]
      linkedPC <= io_linkedPC; // @[ExecuteToMema.scala 38:25]
    end else begin
      linkedPC <= 64'h0; // @[ExecuteToMema.scala 38:25]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  alu_result = _RAND_0[63:0];
  _RAND_1 = {1{`RANDOM}};
  writeback_addr = _RAND_1[4:0];
  _RAND_2 = {2{`RANDOM}};
  regB_data = _RAND_2[63:0];
  _RAND_3 = {1{`RANDOM}};
  memType = _RAND_3[3:0];
  _RAND_4 = {1{`RANDOM}};
  regType = _RAND_4[1:0];
  _RAND_5 = {1{`RANDOM}};
  wbType = _RAND_5[2:0];
  _RAND_6 = {1{`RANDOM}};
  CSRType = _RAND_6[2:0];
  _RAND_7 = {1{`RANDOM}};
  csrAddr = _RAND_7[11:0];
  _RAND_8 = {2{`RANDOM}};
  linkedPC = _RAND_8[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module MemAccess(
  input  [63:0] io_linkedPC,
  input  [63:0] io_aluOut_alu_result,
  input  [4:0]  io_aluOut_writeback_addr,
  input  [63:0] io_aluOut_regB_data,
  input  [3:0]  io_controlSignal_memType,
  input  [1:0]  io_controlSignal_regType,
  input  [2:0]  io_controlSignal_wbType,
  input  [2:0]  io_controlSignal_CSRType,
  input  [11:0] io_controlSignal_csrAddr,
  input  [63:0] io_dataReadPort_read_data_b,
  output [63:0] io_dataWritePort_write_addr,
  output [63:0] io_dataWritePort_write_data,
  output [3:0]  io_dataWritePort_write_lenth,
  output        io_dataWritePort_write_enable,
  output [11:0] io_csrRead_csr_read_addr,
  input  [63:0] io_csrRead_csr_read_data,
  output [4:0]  io_forward_wbAddrFromMema,
  output [1:0]  io_forward_regTypeFromMema,
  output [63:0] io_forward_wbDataFromMema,
  output [4:0]  io_stall_wbAddrFromMema,
  output [1:0]  io_stall_regTypeFromMema,
  output [4:0]  io_memPass_writeback_addr,
  output [63:0] io_memPass_writeback_data,
  output [1:0]  io_memPass_regwrite_enable,
  output [11:0] io_memPass_csrwrite_addr,
  output [63:0] io_memPass_csrwrite_data,
  output [2:0]  io_memPass_CSRType
);
  wire  _csr_wdata_T = io_controlSignal_CSRType == 3'h1; // @[MemAccess.scala 30:31]
  wire  _csr_wdata_T_1 = io_controlSignal_CSRType == 3'h2; // @[MemAccess.scala 31:31]
  wire [63:0] _csr_wdata_T_2 = io_csrRead_csr_read_data | io_aluOut_alu_result; // @[MemAccess.scala 31:71]
  wire  _csr_wdata_T_3 = io_controlSignal_CSRType == 3'h3; // @[MemAccess.scala 32:31]
  wire [63:0] _csr_wdata_T_4 = ~io_aluOut_alu_result; // @[MemAccess.scala 32:74]
  wire [63:0] _csr_wdata_T_5 = io_csrRead_csr_read_data & _csr_wdata_T_4; // @[MemAccess.scala 32:71]
  wire  _csr_wdata_T_6 = io_controlSignal_CSRType == 3'h4; // @[MemAccess.scala 33:31]
  wire [63:0] _csr_wdata_T_7 = _csr_wdata_T_6 ? 64'hb : 64'h0; // @[Mux.scala 101:16]
  wire [63:0] _csr_wdata_T_8 = _csr_wdata_T_3 ? _csr_wdata_T_5 : _csr_wdata_T_7; // @[Mux.scala 101:16]
  wire [63:0] _csr_wdata_T_9 = _csr_wdata_T_1 ? _csr_wdata_T_2 : _csr_wdata_T_8; // @[Mux.scala 101:16]
  wire [63:0] csr_wdata = _csr_wdata_T ? io_aluOut_alu_result : _csr_wdata_T_9; // @[Mux.scala 101:16]
  wire  _load_data_T = io_controlSignal_memType == 4'h8; // @[MemAccess.scala 40:31]
  wire [55:0] _load_data_T_3 = io_dataReadPort_read_data_b[7] ? 56'hffffffffffffff : 56'h0; // @[Bitwise.scala 74:12]
  wire [63:0] _load_data_T_5 = {_load_data_T_3,io_dataReadPort_read_data_b[7:0]}; // @[Cat.scala 31:58]
  wire  _load_data_T_6 = io_controlSignal_memType == 4'h9; // @[MemAccess.scala 41:31]
  wire [63:0] _load_data_T_9 = {56'h0,io_dataReadPort_read_data_b[7:0]}; // @[Cat.scala 31:58]
  wire  _load_data_T_10 = io_controlSignal_memType == 4'ha; // @[MemAccess.scala 42:31]
  wire [47:0] _load_data_T_13 = io_dataReadPort_read_data_b[15] ? 48'hffffffffffff : 48'h0; // @[Bitwise.scala 74:12]
  wire [63:0] _load_data_T_15 = {_load_data_T_13,io_dataReadPort_read_data_b[15:0]}; // @[Cat.scala 31:58]
  wire  _load_data_T_16 = io_controlSignal_memType == 4'hb; // @[MemAccess.scala 43:31]
  wire [71:0] _load_data_T_19 = {56'h0,io_dataReadPort_read_data_b[15:0]}; // @[Cat.scala 31:58]
  wire  _load_data_T_20 = io_controlSignal_memType == 4'hc; // @[MemAccess.scala 44:31]
  wire [31:0] _load_data_T_23 = io_dataReadPort_read_data_b[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 74:12]
  wire [63:0] _load_data_T_25 = {_load_data_T_23,io_dataReadPort_read_data_b[31:0]}; // @[Cat.scala 31:58]
  wire  _load_data_T_26 = io_controlSignal_memType == 4'hd; // @[MemAccess.scala 45:31]
  wire [63:0] _load_data_T_29 = {32'h0,io_dataReadPort_read_data_b[31:0]}; // @[Cat.scala 31:58]
  wire [63:0] _load_data_T_32 = _load_data_T_26 ? _load_data_T_29 : io_dataReadPort_read_data_b; // @[Mux.scala 101:16]
  wire [63:0] _load_data_T_33 = _load_data_T_20 ? _load_data_T_25 : _load_data_T_32; // @[Mux.scala 101:16]
  wire [71:0] _load_data_T_34 = _load_data_T_16 ? _load_data_T_19 : {{8'd0}, _load_data_T_33}; // @[Mux.scala 101:16]
  wire [71:0] _load_data_T_35 = _load_data_T_10 ? {{8'd0}, _load_data_T_15} : _load_data_T_34; // @[Mux.scala 101:16]
  wire [71:0] _load_data_T_36 = _load_data_T_6 ? {{8'd0}, _load_data_T_9} : _load_data_T_35; // @[Mux.scala 101:16]
  wire [71:0] load_data = _load_data_T ? {{8'd0}, _load_data_T_5} : _load_data_T_36; // @[Mux.scala 101:16]
  wire  _writeback_data_T = io_controlSignal_wbType == 3'h2; // @[MemAccess.scala 50:30]
  wire  _writeback_data_T_1 = io_controlSignal_wbType == 3'h3; // @[MemAccess.scala 51:30]
  wire  _writeback_data_T_2 = io_controlSignal_wbType == 3'h4; // @[MemAccess.scala 52:30]
  wire [63:0] _writeback_data_T_3 = _writeback_data_T_2 ? csr_wdata : io_aluOut_alu_result; // @[Mux.scala 101:16]
  wire [63:0] _writeback_data_T_4 = _writeback_data_T_1 ? io_linkedPC : _writeback_data_T_3; // @[Mux.scala 101:16]
  wire [71:0] writeback_data = _writeback_data_T ? load_data : {{8'd0}, _writeback_data_T_4}; // @[Mux.scala 101:16]
  assign io_dataWritePort_write_addr = io_aluOut_alu_result; // @[MemAccess.scala 56:31]
  assign io_dataWritePort_write_data = io_aluOut_regB_data; // @[MemAccess.scala 57:31]
  assign io_dataWritePort_write_lenth = io_controlSignal_memType; // @[MemAccess.scala 63:32]
  assign io_dataWritePort_write_enable = io_controlSignal_memType[2]; // @[MemAccess.scala 58:32]
  assign io_csrRead_csr_read_addr = io_controlSignal_csrAddr; // @[MemAccess.scala 27:28]
  assign io_forward_wbAddrFromMema = io_aluOut_writeback_addr; // @[MemAccess.scala 74:29]
  assign io_forward_regTypeFromMema = io_controlSignal_regType; // @[MemAccess.scala 75:30]
  assign io_forward_wbDataFromMema = writeback_data[63:0]; // @[MemAccess.scala 73:29]
  assign io_stall_wbAddrFromMema = writeback_data[4:0]; // @[MemAccess.scala 76:27]
  assign io_stall_regTypeFromMema = io_controlSignal_regType; // @[MemAccess.scala 77:28]
  assign io_memPass_writeback_addr = io_aluOut_writeback_addr; // @[MemAccess.scala 65:29]
  assign io_memPass_writeback_data = writeback_data[63:0]; // @[MemAccess.scala 66:29]
  assign io_memPass_regwrite_enable = io_controlSignal_regType; // @[MemAccess.scala 67:30]
  assign io_memPass_csrwrite_addr = io_controlSignal_csrAddr; // @[MemAccess.scala 68:28]
  assign io_memPass_csrwrite_data = _csr_wdata_T ? io_aluOut_alu_result : _csr_wdata_T_9; // @[Mux.scala 101:16]
  assign io_memPass_CSRType = io_controlSignal_CSRType; // @[MemAccess.scala 70:22]
endmodule
module MemaToWB(
  input         clock,
  input         reset,
  input  [4:0]  io_wbinfo_writeback_addr,
  input  [63:0] io_wbinfo_writeback_data,
  input  [1:0]  io_wbinfo_regwrite_enable,
  input  [11:0] io_wbinfo_csrwrite_addr,
  input  [63:0] io_wbinfo_csrwrite_data,
  input  [2:0]  io_wbinfo_CSRType,
  output [4:0]  io_wbinfoPass_writeback_addr,
  output [63:0] io_wbinfoPass_writeback_data,
  output [1:0]  io_wbinfoPass_regwrite_enable,
  output [11:0] io_wbinfoPass_csrwrite_addr,
  output [63:0] io_wbinfoPass_csrwrite_data,
  output [2:0]  io_wbinfoPass_CSRType
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [63:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  reg [4:0] writeback_addr; // @[MemaToWB.scala 14:31]
  reg [63:0] writeback_data; // @[MemaToWB.scala 15:31]
  reg [1:0] regwrite_enable; // @[MemaToWB.scala 16:32]
  reg [11:0] csrwrite_addr; // @[MemaToWB.scala 17:30]
  reg [63:0] csrwrite_data; // @[MemaToWB.scala 18:30]
  reg [2:0] CSRType; // @[MemaToWB.scala 19:24]
  assign io_wbinfoPass_writeback_addr = writeback_addr; // @[MemaToWB.scala 21:32]
  assign io_wbinfoPass_writeback_data = writeback_data; // @[MemaToWB.scala 22:32]
  assign io_wbinfoPass_regwrite_enable = regwrite_enable; // @[MemaToWB.scala 23:33]
  assign io_wbinfoPass_csrwrite_addr = csrwrite_addr; // @[MemaToWB.scala 24:31]
  assign io_wbinfoPass_csrwrite_data = csrwrite_data; // @[MemaToWB.scala 25:31]
  assign io_wbinfoPass_CSRType = CSRType; // @[MemaToWB.scala 26:25]
  always @(posedge clock) begin
    if (reset) begin // @[MemaToWB.scala 14:31]
      writeback_addr <= io_wbinfo_writeback_addr; // @[MemaToWB.scala 14:31]
    end else begin
      writeback_addr <= 5'h0; // @[MemaToWB.scala 14:31]
    end
    if (reset) begin // @[MemaToWB.scala 15:31]
      writeback_data <= io_wbinfo_writeback_data; // @[MemaToWB.scala 15:31]
    end else begin
      writeback_data <= 64'h0; // @[MemaToWB.scala 15:31]
    end
    if (reset) begin // @[MemaToWB.scala 16:32]
      regwrite_enable <= io_wbinfo_regwrite_enable; // @[MemaToWB.scala 16:32]
    end else begin
      regwrite_enable <= 2'h0; // @[MemaToWB.scala 16:32]
    end
    if (reset) begin // @[MemaToWB.scala 17:30]
      csrwrite_addr <= io_wbinfo_csrwrite_addr; // @[MemaToWB.scala 17:30]
    end else begin
      csrwrite_addr <= 12'h0; // @[MemaToWB.scala 17:30]
    end
    if (reset) begin // @[MemaToWB.scala 18:30]
      csrwrite_data <= io_wbinfo_csrwrite_data; // @[MemaToWB.scala 18:30]
    end else begin
      csrwrite_data <= 64'h0; // @[MemaToWB.scala 18:30]
    end
    if (reset) begin // @[MemaToWB.scala 19:24]
      CSRType <= io_wbinfo_CSRType; // @[MemaToWB.scala 19:24]
    end else begin
      CSRType <= 3'h0; // @[MemaToWB.scala 19:24]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  writeback_addr = _RAND_0[4:0];
  _RAND_1 = {2{`RANDOM}};
  writeback_data = _RAND_1[63:0];
  _RAND_2 = {1{`RANDOM}};
  regwrite_enable = _RAND_2[1:0];
  _RAND_3 = {1{`RANDOM}};
  csrwrite_addr = _RAND_3[11:0];
  _RAND_4 = {2{`RANDOM}};
  csrwrite_data = _RAND_4[63:0];
  _RAND_5 = {1{`RANDOM}};
  CSRType = _RAND_5[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module WriteBack(
  input  [4:0]  io_wbinfo_writeback_addr,
  input  [63:0] io_wbinfo_writeback_data,
  input  [1:0]  io_wbinfo_regwrite_enable,
  input  [11:0] io_wbinfo_csrwrite_addr,
  input  [63:0] io_wbinfo_csrwrite_data,
  input  [2:0]  io_wbinfo_CSRType,
  output [4:0]  io_regWrite_write_addr,
  output [63:0] io_regWrite_write_data,
  output        io_regWrite_write_enable,
  output [11:0] io_csrWrite_csr_write_addr,
  output [63:0] io_csrWrite_csr_write_data,
  output        io_csrWrite_csr_write_enable
);
  assign io_regWrite_write_addr = io_wbinfo_writeback_addr; // @[WriteBack.scala 15:26]
  assign io_regWrite_write_data = io_wbinfo_writeback_data; // @[WriteBack.scala 16:26]
  assign io_regWrite_write_enable = io_wbinfo_regwrite_enable == 2'h1; // @[WriteBack.scala 18:34]
  assign io_csrWrite_csr_write_addr = io_wbinfo_csrwrite_addr; // @[WriteBack.scala 24:30]
  assign io_csrWrite_csr_write_data = io_wbinfo_csrwrite_data; // @[WriteBack.scala 25:30]
  assign io_csrWrite_csr_write_enable = io_wbinfo_CSRType > 3'h0; // @[WriteBack.scala 26:26]
endmodule
module Forward(
  input  [4:0]  io_withDecode_srcAddrA,
  input  [4:0]  io_withDecode_srcAddrB,
  output [63:0] io_withDecode_hazardAData,
  output [63:0] io_withDecode_hazardBData,
  input  [4:0]  io_withExecute_wbAddrFromExecute,
  input  [1:0]  io_withExecute_regTypeFromExecute,
  input  [63:0] io_withExecute_wbDataFromExe,
  input  [4:0]  io_withMema_wbAddrFromMema,
  input  [1:0]  io_withMema_regTypeFromMema,
  input  [63:0] io_withMema_wbDataFromMema,
  output [4:0]  io_regReadPort_read_addr_a,
  output [4:0]  io_regReadPort_read_addr_b,
  input  [63:0] io_regReadPort_read_data_a,
  input  [63:0] io_regReadPort_read_data_b
);
  wire  _hazardAType_T_1 = io_withExecute_regTypeFromExecute == 2'h1; // @[Forward.scala 17:106]
  wire  _hazardAType_T_2 = io_withDecode_srcAddrA == io_withExecute_wbAddrFromExecute &
    io_withExecute_regTypeFromExecute == 2'h1; // @[Forward.scala 17:68]
  wire  _hazardAType_T_4 = io_withMema_regTypeFromMema == 2'h1; // @[Forward.scala 18:94]
  wire  _hazardAType_T_5 = io_withDecode_srcAddrA == io_withMema_wbAddrFromMema & io_withMema_regTypeFromMema == 2'h1; // @[Forward.scala 18:62]
  wire [63:0] _hazardAType_T_6 = _hazardAType_T_5 ? io_withMema_wbDataFromMema : 64'h0; // @[Mux.scala 101:16]
  wire [63:0] hazardAType = _hazardAType_T_2 ? io_withExecute_wbDataFromExe : _hazardAType_T_6; // @[Mux.scala 101:16]
  wire  _hazardBType_T_2 = io_withDecode_srcAddrB == io_withExecute_wbAddrFromExecute & _hazardAType_T_1; // @[Forward.scala 21:68]
  wire  _hazardBType_T_5 = io_withDecode_srcAddrB == io_withMema_wbAddrFromMema & _hazardAType_T_4; // @[Forward.scala 22:62]
  wire [63:0] _hazardBType_T_6 = _hazardBType_T_5 ? io_withMema_wbDataFromMema : 64'h0; // @[Mux.scala 101:16]
  wire [63:0] hazardBType = _hazardBType_T_2 ? io_withExecute_wbDataFromExe : _hazardBType_T_6; // @[Mux.scala 101:16]
  wire [63:0] srcDataA = io_withDecode_srcAddrA == 5'h0 ? 64'h0 : io_regReadPort_read_data_a; // @[Forward.scala 26:21]
  wire [63:0] srcDataB = io_withDecode_srcAddrB == 5'h0 ? 64'h0 : io_regReadPort_read_data_b; // @[Forward.scala 28:21]
  wire  _io_withDecode_hazardAData_T = hazardAType == 64'h1; // @[Forward.scala 31:18]
  wire  _io_withDecode_hazardAData_T_1 = hazardAType == 64'h2; // @[Forward.scala 32:18]
  wire [63:0] _io_withDecode_hazardAData_T_2 = _io_withDecode_hazardAData_T_1 ? io_withMema_wbDataFromMema : srcDataA; // @[Mux.scala 101:16]
  wire  _io_withDecode_hazardBData_T = hazardBType == 64'h1; // @[Forward.scala 35:18]
  wire  _io_withDecode_hazardBData_T_1 = hazardBType == 64'h2; // @[Forward.scala 36:18]
  wire [63:0] _io_withDecode_hazardBData_T_2 = _io_withDecode_hazardBData_T_1 ? io_withMema_wbDataFromMema : srcDataB; // @[Mux.scala 101:16]
  assign io_withDecode_hazardAData = _io_withDecode_hazardAData_T ? io_withExecute_wbDataFromExe :
    _io_withDecode_hazardAData_T_2; // @[Mux.scala 101:16]
  assign io_withDecode_hazardBData = _io_withDecode_hazardBData_T ? io_withExecute_wbDataFromExe :
    _io_withDecode_hazardBData_T_2; // @[Mux.scala 101:16]
  assign io_regReadPort_read_addr_a = io_withDecode_srcAddrA; // @[Forward.scala 25:30]
  assign io_regReadPort_read_addr_b = io_withDecode_srcAddrB; // @[Forward.scala 27:30]
endmodule
module Stall(
  input        clock,
  input        reset,
  input  [4:0] io_withDecode_srcAddrA,
  input  [4:0] io_withDecode_srcAddrB,
  input  [4:0] io_withMema_wbAddrFromMema,
  input  [1:0] io_withMema_regTypeFromMema,
  output       io_stallFlag
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire  _rsADatahazard_T = io_withMema_regTypeFromMema == 2'h1; // @[Stall.scala 12:52]
  wire  rsADatahazard = io_withMema_regTypeFromMema == 2'h1 & io_withDecode_srcAddrA != 5'h0 & io_withDecode_srcAddrA
     == io_withMema_wbAddrFromMema; // @[Stall.scala 12:99]
  wire  rsBDatahazard = _rsADatahazard_T & io_withDecode_srcAddrB != 5'h0 & io_withDecode_srcAddrB ==
    io_withMema_wbAddrFromMema; // @[Stall.scala 13:99]
  wire  stallFlag = rsADatahazard | rsBDatahazard; // @[Stall.scala 14:33]
  reg  stallFlagReg; // @[Stall.scala 15:29]
  assign io_stallFlag = stallFlagReg; // @[Stall.scala 17:16]
  always @(posedge clock) begin
    stallFlagReg <= reset & stallFlag; // @[Stall.scala 15:{29,29,29}]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  stallFlagReg = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module RegFile(
  input         clock,
  input  [4:0]  io_reg_read_read_addr_a,
  input  [4:0]  io_reg_read_read_addr_b,
  output [63:0] io_reg_read_read_data_a,
  output [63:0] io_reg_read_read_data_b,
  input  [4:0]  io_reg_write_write_addr,
  input  [63:0] io_reg_write_write_data,
  input         io_reg_write_write_enable
);
`ifdef RANDOMIZE_MEM_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
  reg [63:0] registers [0:31]; // @[RegFile.scala 12:22]
  wire  registers_io_reg_read_read_data_a_MPORT_en; // @[RegFile.scala 12:22]
  wire [4:0] registers_io_reg_read_read_data_a_MPORT_addr; // @[RegFile.scala 12:22]
  wire [63:0] registers_io_reg_read_read_data_a_MPORT_data; // @[RegFile.scala 12:22]
  wire  registers_io_reg_read_read_data_b_MPORT_en; // @[RegFile.scala 12:22]
  wire [4:0] registers_io_reg_read_read_data_b_MPORT_addr; // @[RegFile.scala 12:22]
  wire [63:0] registers_io_reg_read_read_data_b_MPORT_data; // @[RegFile.scala 12:22]
  wire [63:0] registers_MPORT_data; // @[RegFile.scala 12:22]
  wire [4:0] registers_MPORT_addr; // @[RegFile.scala 12:22]
  wire  registers_MPORT_mask; // @[RegFile.scala 12:22]
  wire  registers_MPORT_en; // @[RegFile.scala 12:22]
  assign registers_io_reg_read_read_data_a_MPORT_en = 1'h1;
  assign registers_io_reg_read_read_data_a_MPORT_addr = io_reg_read_read_addr_a;
  assign registers_io_reg_read_read_data_a_MPORT_data = registers[registers_io_reg_read_read_data_a_MPORT_addr]; // @[RegFile.scala 12:22]
  assign registers_io_reg_read_read_data_b_MPORT_en = 1'h1;
  assign registers_io_reg_read_read_data_b_MPORT_addr = io_reg_read_read_addr_b;
  assign registers_io_reg_read_read_data_b_MPORT_data = registers[registers_io_reg_read_read_data_b_MPORT_addr]; // @[RegFile.scala 12:22]
  assign registers_MPORT_data = io_reg_write_write_data;
  assign registers_MPORT_addr = io_reg_write_write_addr;
  assign registers_MPORT_mask = 1'h1;
  assign registers_MPORT_en = io_reg_write_write_enable;
  assign io_reg_read_read_data_a = registers_io_reg_read_read_data_a_MPORT_data; // @[RegFile.scala 13:27]
  assign io_reg_read_read_data_b = registers_io_reg_read_read_data_b_MPORT_data; // @[RegFile.scala 14:27]
  always @(posedge clock) begin
    if (registers_MPORT_en & registers_MPORT_mask) begin
      registers[registers_MPORT_addr] <= registers_MPORT_data; // @[RegFile.scala 12:22]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {2{`RANDOM}};
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    registers[initvar] = _RAND_0[63:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CSRfile(
  input         clock,
  input  [11:0] io_csrRead_csr_read_addr,
  output [63:0] io_csrRead_csr_read_data,
  output [63:0] io_envRead_csr_read_data,
  input  [11:0] io_csrWrite_csr_write_addr,
  input  [63:0] io_csrWrite_csr_write_data,
  input         io_csrWrite_csr_write_enable
);
`ifdef RANDOMIZE_MEM_INIT
  reg [63:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
  reg [63:0] CSRregisters [0:4095]; // @[CSRfile.scala 12:25]
  wire  CSRregisters_io_csrRead_csr_read_data_MPORT_en; // @[CSRfile.scala 12:25]
  wire [11:0] CSRregisters_io_csrRead_csr_read_data_MPORT_addr; // @[CSRfile.scala 12:25]
  wire [63:0] CSRregisters_io_csrRead_csr_read_data_MPORT_data; // @[CSRfile.scala 12:25]
  wire  CSRregisters_io_envRead_csr_read_data_MPORT_en; // @[CSRfile.scala 12:25]
  wire [11:0] CSRregisters_io_envRead_csr_read_data_MPORT_addr; // @[CSRfile.scala 12:25]
  wire [63:0] CSRregisters_io_envRead_csr_read_data_MPORT_data; // @[CSRfile.scala 12:25]
  wire [63:0] CSRregisters_MPORT_data; // @[CSRfile.scala 12:25]
  wire [11:0] CSRregisters_MPORT_addr; // @[CSRfile.scala 12:25]
  wire  CSRregisters_MPORT_mask; // @[CSRfile.scala 12:25]
  wire  CSRregisters_MPORT_en; // @[CSRfile.scala 12:25]
  assign CSRregisters_io_csrRead_csr_read_data_MPORT_en = 1'h1;
  assign CSRregisters_io_csrRead_csr_read_data_MPORT_addr = io_csrRead_csr_read_addr;
  assign CSRregisters_io_csrRead_csr_read_data_MPORT_data =
    CSRregisters[CSRregisters_io_csrRead_csr_read_data_MPORT_addr]; // @[CSRfile.scala 12:25]
  assign CSRregisters_io_envRead_csr_read_data_MPORT_en = 1'h1;
  assign CSRregisters_io_envRead_csr_read_data_MPORT_addr = 12'h305;
  assign CSRregisters_io_envRead_csr_read_data_MPORT_data =
    CSRregisters[CSRregisters_io_envRead_csr_read_data_MPORT_addr]; // @[CSRfile.scala 12:25]
  assign CSRregisters_MPORT_data = io_csrWrite_csr_write_data;
  assign CSRregisters_MPORT_addr = io_csrWrite_csr_write_addr;
  assign CSRregisters_MPORT_mask = 1'h1;
  assign CSRregisters_MPORT_en = io_csrWrite_csr_write_enable;
  assign io_csrRead_csr_read_data = CSRregisters_io_csrRead_csr_read_data_MPORT_data; // @[CSRfile.scala 13:28]
  assign io_envRead_csr_read_data = CSRregisters_io_envRead_csr_read_data_MPORT_data; // @[CSRfile.scala 14:28]
  always @(posedge clock) begin
    if (CSRregisters_MPORT_en & CSRregisters_MPORT_mask) begin
      CSRregisters[CSRregisters_MPORT_addr] <= CSRregisters_MPORT_data; // @[CSRfile.scala 12:25]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {2{`RANDOM}};
  for (initvar = 0; initvar < 4096; initvar = initvar+1)
    CSRregisters[initvar] = _RAND_0[63:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Core(
  input         clock,
  input         reset,
  output [63:0] io_instfetch_fetchMem_read_addr_a,
  input  [31:0] io_instfetch_fetchMem_read_inst_a,
  input  [63:0] io_memoryAccess_dataReadPort_read_data_b,
  output [63:0] io_memoryAccess_dataWritePort_write_addr,
  output [63:0] io_memoryAccess_dataWritePort_write_data,
  output [3:0]  io_memoryAccess_dataWritePort_write_lenth,
  output        io_memoryAccess_dataWritePort_write_enable,
  output [63:0] io_probe
);
  wire  instfetch_clock; // @[Core.scala 23:25]
  wire  instfetch_reset; // @[Core.scala 23:25]
  wire  instfetch_io_branchFlag; // @[Core.scala 23:25]
  wire  instfetch_io_jumpFlag; // @[Core.scala 23:25]
  wire  instfetch_io_stallFlag; // @[Core.scala 23:25]
  wire [63:0] instfetch_io_branchTarget; // @[Core.scala 23:25]
  wire [63:0] instfetch_io_jumpTarget; // @[Core.scala 23:25]
  wire [63:0] instfetch_io_instOut; // @[Core.scala 23:25]
  wire [63:0] instfetch_io_pcOut; // @[Core.scala 23:25]
  wire [63:0] instfetch_io_fetchMem_read_addr_a; // @[Core.scala 23:25]
  wire [31:0] instfetch_io_fetchMem_read_inst_a; // @[Core.scala 23:25]
  wire [63:0] instfetch_io_envRead_csr_read_data; // @[Core.scala 23:25]
  wire  instfetch_to_decode_clock; // @[Core.scala 24:35]
  wire  instfetch_to_decode_reset; // @[Core.scala 24:35]
  wire  instfetch_to_decode_io_stallFlag; // @[Core.scala 24:35]
  wire [63:0] instfetch_to_decode_io_pcIn; // @[Core.scala 24:35]
  wire [31:0] instfetch_to_decode_io_instIn; // @[Core.scala 24:35]
  wire  instfetch_to_decode_io_jumpOrBranchFlag; // @[Core.scala 24:35]
  wire [31:0] instfetch_to_decode_io_instOut; // @[Core.scala 24:35]
  wire [63:0] instfetch_to_decode_io_pcOut; // @[Core.scala 24:35]
  wire  decode_io_branchFlag; // @[Core.scala 25:22]
  wire  decode_io_jumpFlag; // @[Core.scala 25:22]
  wire  decode_io_stallFlag; // @[Core.scala 25:22]
  wire [31:0] decode_io_inst; // @[Core.scala 25:22]
  wire [63:0] decode_io_cur_pc; // @[Core.scala 25:22]
  wire [63:0] decode_io_pcOut; // @[Core.scala 25:22]
  wire [4:0] decode_io_decodeOut_alu_exe_fun; // @[Core.scala 25:22]
  wire [3:0] decode_io_decodeOut_memType; // @[Core.scala 25:22]
  wire [1:0] decode_io_decodeOut_regType; // @[Core.scala 25:22]
  wire [2:0] decode_io_decodeOut_wbType; // @[Core.scala 25:22]
  wire [2:0] decode_io_decodeOut_CSRType; // @[Core.scala 25:22]
  wire [11:0] decode_io_decodeOut_csrAddr; // @[Core.scala 25:22]
  wire [63:0] decode_io_srcOut_aluSrc_a; // @[Core.scala 25:22]
  wire [63:0] decode_io_srcOut_aluSrc_b; // @[Core.scala 25:22]
  wire [63:0] decode_io_srcOut_regB_data; // @[Core.scala 25:22]
  wire [4:0] decode_io_srcOut_writeback_addr; // @[Core.scala 25:22]
  wire [63:0] decode_io_srcOut_imm_b; // @[Core.scala 25:22]
  wire [4:0] decode_io_forward_srcAddrA; // @[Core.scala 25:22]
  wire [4:0] decode_io_forward_srcAddrB; // @[Core.scala 25:22]
  wire [63:0] decode_io_forward_hazardAData; // @[Core.scala 25:22]
  wire [63:0] decode_io_forward_hazardBData; // @[Core.scala 25:22]
  wire [4:0] decode_io_stall_srcAddrA; // @[Core.scala 25:22]
  wire [4:0] decode_io_stall_srcAddrB; // @[Core.scala 25:22]
  wire  decode_to_execute_clock; // @[Core.scala 26:33]
  wire  decode_to_execute_reset; // @[Core.scala 26:33]
  wire  decode_to_execute_io_jumpOrBranchFlag; // @[Core.scala 26:33]
  wire [63:0] decode_to_execute_io_cur_pc; // @[Core.scala 26:33]
  wire [63:0] decode_to_execute_io_pcOut; // @[Core.scala 26:33]
  wire [4:0] decode_to_execute_io_controlSignal_alu_exe_fun; // @[Core.scala 26:33]
  wire [3:0] decode_to_execute_io_controlSignal_memType; // @[Core.scala 26:33]
  wire [1:0] decode_to_execute_io_controlSignal_regType; // @[Core.scala 26:33]
  wire [2:0] decode_to_execute_io_controlSignal_wbType; // @[Core.scala 26:33]
  wire [2:0] decode_to_execute_io_controlSignal_CSRType; // @[Core.scala 26:33]
  wire [11:0] decode_to_execute_io_controlSignal_csrAddr; // @[Core.scala 26:33]
  wire [63:0] decode_to_execute_io_opSrc_aluSrc_a; // @[Core.scala 26:33]
  wire [63:0] decode_to_execute_io_opSrc_aluSrc_b; // @[Core.scala 26:33]
  wire [63:0] decode_to_execute_io_opSrc_regB_data; // @[Core.scala 26:33]
  wire [4:0] decode_to_execute_io_opSrc_writeback_addr; // @[Core.scala 26:33]
  wire [63:0] decode_to_execute_io_opSrc_imm_b; // @[Core.scala 26:33]
  wire [4:0] decode_to_execute_io_controlSignalPass_alu_exe_fun; // @[Core.scala 26:33]
  wire [3:0] decode_to_execute_io_controlSignalPass_memType; // @[Core.scala 26:33]
  wire [1:0] decode_to_execute_io_controlSignalPass_regType; // @[Core.scala 26:33]
  wire [2:0] decode_to_execute_io_controlSignalPass_wbType; // @[Core.scala 26:33]
  wire [2:0] decode_to_execute_io_controlSignalPass_CSRType; // @[Core.scala 26:33]
  wire [11:0] decode_to_execute_io_controlSignalPass_csrAddr; // @[Core.scala 26:33]
  wire [63:0] decode_to_execute_io_srcPass_aluSrc_a; // @[Core.scala 26:33]
  wire [63:0] decode_to_execute_io_srcPass_aluSrc_b; // @[Core.scala 26:33]
  wire [63:0] decode_to_execute_io_srcPass_regB_data; // @[Core.scala 26:33]
  wire [4:0] decode_to_execute_io_srcPass_writeback_addr; // @[Core.scala 26:33]
  wire [63:0] decode_to_execute_io_srcPass_imm_b; // @[Core.scala 26:33]
  wire [63:0] execute_io_cur_pc; // @[Core.scala 27:23]
  wire  execute_io_jumpFlag; // @[Core.scala 27:23]
  wire  execute_io_branchFlag; // @[Core.scala 27:23]
  wire [63:0] execute_io_linkedPC; // @[Core.scala 27:23]
  wire [63:0] execute_io_branchTarget; // @[Core.scala 27:23]
  wire [63:0] execute_io_alu_in_aluSrc_a; // @[Core.scala 27:23]
  wire [63:0] execute_io_alu_in_aluSrc_b; // @[Core.scala 27:23]
  wire [63:0] execute_io_alu_in_regB_data; // @[Core.scala 27:23]
  wire [4:0] execute_io_alu_in_writeback_addr; // @[Core.scala 27:23]
  wire [63:0] execute_io_alu_in_imm_b; // @[Core.scala 27:23]
  wire [63:0] execute_io_alu_out_alu_result; // @[Core.scala 27:23]
  wire [4:0] execute_io_alu_out_writeback_addr; // @[Core.scala 27:23]
  wire [63:0] execute_io_alu_out_regB_data; // @[Core.scala 27:23]
  wire [3:0] execute_io_controlPass_memType; // @[Core.scala 27:23]
  wire [1:0] execute_io_controlPass_regType; // @[Core.scala 27:23]
  wire [2:0] execute_io_controlPass_wbType; // @[Core.scala 27:23]
  wire [2:0] execute_io_controlPass_CSRType; // @[Core.scala 27:23]
  wire [11:0] execute_io_controlPass_csrAddr; // @[Core.scala 27:23]
  wire [4:0] execute_io_controlSignal_alu_exe_fun; // @[Core.scala 27:23]
  wire [3:0] execute_io_controlSignal_memType; // @[Core.scala 27:23]
  wire [1:0] execute_io_controlSignal_regType; // @[Core.scala 27:23]
  wire [2:0] execute_io_controlSignal_wbType; // @[Core.scala 27:23]
  wire [2:0] execute_io_controlSignal_CSRType; // @[Core.scala 27:23]
  wire [11:0] execute_io_controlSignal_csrAddr; // @[Core.scala 27:23]
  wire [4:0] execute_io_dataHazard_wbAddrFromExecute; // @[Core.scala 27:23]
  wire [1:0] execute_io_dataHazard_regTypeFromExecute; // @[Core.scala 27:23]
  wire [63:0] execute_io_dataHazard_wbDataFromExe; // @[Core.scala 27:23]
  wire  execute_to_mema_clock; // @[Core.scala 28:31]
  wire  execute_to_mema_reset; // @[Core.scala 28:31]
  wire [63:0] execute_to_mema_io_linkedPC; // @[Core.scala 28:31]
  wire [63:0] execute_to_mema_io_linkedPCPass; // @[Core.scala 28:31]
  wire [63:0] execute_to_mema_io_aluOut_alu_result; // @[Core.scala 28:31]
  wire [4:0] execute_to_mema_io_aluOut_writeback_addr; // @[Core.scala 28:31]
  wire [63:0] execute_to_mema_io_aluOut_regB_data; // @[Core.scala 28:31]
  wire [3:0] execute_to_mema_io_controlSignal_memType; // @[Core.scala 28:31]
  wire [1:0] execute_to_mema_io_controlSignal_regType; // @[Core.scala 28:31]
  wire [2:0] execute_to_mema_io_controlSignal_wbType; // @[Core.scala 28:31]
  wire [2:0] execute_to_mema_io_controlSignal_CSRType; // @[Core.scala 28:31]
  wire [11:0] execute_to_mema_io_controlSignal_csrAddr; // @[Core.scala 28:31]
  wire [63:0] execute_to_mema_io_aluOutPass_alu_result; // @[Core.scala 28:31]
  wire [4:0] execute_to_mema_io_aluOutPass_writeback_addr; // @[Core.scala 28:31]
  wire [63:0] execute_to_mema_io_aluOutPass_regB_data; // @[Core.scala 28:31]
  wire [3:0] execute_to_mema_io_controlSignalPass_memType; // @[Core.scala 28:31]
  wire [1:0] execute_to_mema_io_controlSignalPass_regType; // @[Core.scala 28:31]
  wire [2:0] execute_to_mema_io_controlSignalPass_wbType; // @[Core.scala 28:31]
  wire [2:0] execute_to_mema_io_controlSignalPass_CSRType; // @[Core.scala 28:31]
  wire [11:0] execute_to_mema_io_controlSignalPass_csrAddr; // @[Core.scala 28:31]
  wire [63:0] memoryAccess_io_linkedPC; // @[Core.scala 29:28]
  wire [63:0] memoryAccess_io_aluOut_alu_result; // @[Core.scala 29:28]
  wire [4:0] memoryAccess_io_aluOut_writeback_addr; // @[Core.scala 29:28]
  wire [63:0] memoryAccess_io_aluOut_regB_data; // @[Core.scala 29:28]
  wire [3:0] memoryAccess_io_controlSignal_memType; // @[Core.scala 29:28]
  wire [1:0] memoryAccess_io_controlSignal_regType; // @[Core.scala 29:28]
  wire [2:0] memoryAccess_io_controlSignal_wbType; // @[Core.scala 29:28]
  wire [2:0] memoryAccess_io_controlSignal_CSRType; // @[Core.scala 29:28]
  wire [11:0] memoryAccess_io_controlSignal_csrAddr; // @[Core.scala 29:28]
  wire [63:0] memoryAccess_io_dataReadPort_read_data_b; // @[Core.scala 29:28]
  wire [63:0] memoryAccess_io_dataWritePort_write_addr; // @[Core.scala 29:28]
  wire [63:0] memoryAccess_io_dataWritePort_write_data; // @[Core.scala 29:28]
  wire [3:0] memoryAccess_io_dataWritePort_write_lenth; // @[Core.scala 29:28]
  wire  memoryAccess_io_dataWritePort_write_enable; // @[Core.scala 29:28]
  wire [11:0] memoryAccess_io_csrRead_csr_read_addr; // @[Core.scala 29:28]
  wire [63:0] memoryAccess_io_csrRead_csr_read_data; // @[Core.scala 29:28]
  wire [4:0] memoryAccess_io_forward_wbAddrFromMema; // @[Core.scala 29:28]
  wire [1:0] memoryAccess_io_forward_regTypeFromMema; // @[Core.scala 29:28]
  wire [63:0] memoryAccess_io_forward_wbDataFromMema; // @[Core.scala 29:28]
  wire [4:0] memoryAccess_io_stall_wbAddrFromMema; // @[Core.scala 29:28]
  wire [1:0] memoryAccess_io_stall_regTypeFromMema; // @[Core.scala 29:28]
  wire [4:0] memoryAccess_io_memPass_writeback_addr; // @[Core.scala 29:28]
  wire [63:0] memoryAccess_io_memPass_writeback_data; // @[Core.scala 29:28]
  wire [1:0] memoryAccess_io_memPass_regwrite_enable; // @[Core.scala 29:28]
  wire [11:0] memoryAccess_io_memPass_csrwrite_addr; // @[Core.scala 29:28]
  wire [63:0] memoryAccess_io_memPass_csrwrite_data; // @[Core.scala 29:28]
  wire [2:0] memoryAccess_io_memPass_CSRType; // @[Core.scala 29:28]
  wire  mema_to_wb_clock; // @[Core.scala 30:26]
  wire  mema_to_wb_reset; // @[Core.scala 30:26]
  wire [4:0] mema_to_wb_io_wbinfo_writeback_addr; // @[Core.scala 30:26]
  wire [63:0] mema_to_wb_io_wbinfo_writeback_data; // @[Core.scala 30:26]
  wire [1:0] mema_to_wb_io_wbinfo_regwrite_enable; // @[Core.scala 30:26]
  wire [11:0] mema_to_wb_io_wbinfo_csrwrite_addr; // @[Core.scala 30:26]
  wire [63:0] mema_to_wb_io_wbinfo_csrwrite_data; // @[Core.scala 30:26]
  wire [2:0] mema_to_wb_io_wbinfo_CSRType; // @[Core.scala 30:26]
  wire [4:0] mema_to_wb_io_wbinfoPass_writeback_addr; // @[Core.scala 30:26]
  wire [63:0] mema_to_wb_io_wbinfoPass_writeback_data; // @[Core.scala 30:26]
  wire [1:0] mema_to_wb_io_wbinfoPass_regwrite_enable; // @[Core.scala 30:26]
  wire [11:0] mema_to_wb_io_wbinfoPass_csrwrite_addr; // @[Core.scala 30:26]
  wire [63:0] mema_to_wb_io_wbinfoPass_csrwrite_data; // @[Core.scala 30:26]
  wire [2:0] mema_to_wb_io_wbinfoPass_CSRType; // @[Core.scala 30:26]
  wire [4:0] writeback_io_wbinfo_writeback_addr; // @[Core.scala 31:25]
  wire [63:0] writeback_io_wbinfo_writeback_data; // @[Core.scala 31:25]
  wire [1:0] writeback_io_wbinfo_regwrite_enable; // @[Core.scala 31:25]
  wire [11:0] writeback_io_wbinfo_csrwrite_addr; // @[Core.scala 31:25]
  wire [63:0] writeback_io_wbinfo_csrwrite_data; // @[Core.scala 31:25]
  wire [2:0] writeback_io_wbinfo_CSRType; // @[Core.scala 31:25]
  wire [4:0] writeback_io_regWrite_write_addr; // @[Core.scala 31:25]
  wire [63:0] writeback_io_regWrite_write_data; // @[Core.scala 31:25]
  wire  writeback_io_regWrite_write_enable; // @[Core.scala 31:25]
  wire [11:0] writeback_io_csrWrite_csr_write_addr; // @[Core.scala 31:25]
  wire [63:0] writeback_io_csrWrite_csr_write_data; // @[Core.scala 31:25]
  wire  writeback_io_csrWrite_csr_write_enable; // @[Core.scala 31:25]
  wire [4:0] datahazard_forward_io_withDecode_srcAddrA; // @[Core.scala 32:34]
  wire [4:0] datahazard_forward_io_withDecode_srcAddrB; // @[Core.scala 32:34]
  wire [63:0] datahazard_forward_io_withDecode_hazardAData; // @[Core.scala 32:34]
  wire [63:0] datahazard_forward_io_withDecode_hazardBData; // @[Core.scala 32:34]
  wire [4:0] datahazard_forward_io_withExecute_wbAddrFromExecute; // @[Core.scala 32:34]
  wire [1:0] datahazard_forward_io_withExecute_regTypeFromExecute; // @[Core.scala 32:34]
  wire [63:0] datahazard_forward_io_withExecute_wbDataFromExe; // @[Core.scala 32:34]
  wire [4:0] datahazard_forward_io_withMema_wbAddrFromMema; // @[Core.scala 32:34]
  wire [1:0] datahazard_forward_io_withMema_regTypeFromMema; // @[Core.scala 32:34]
  wire [63:0] datahazard_forward_io_withMema_wbDataFromMema; // @[Core.scala 32:34]
  wire [4:0] datahazard_forward_io_regReadPort_read_addr_a; // @[Core.scala 32:34]
  wire [4:0] datahazard_forward_io_regReadPort_read_addr_b; // @[Core.scala 32:34]
  wire [63:0] datahazard_forward_io_regReadPort_read_data_a; // @[Core.scala 32:34]
  wire [63:0] datahazard_forward_io_regReadPort_read_data_b; // @[Core.scala 32:34]
  wire  datahazard_stall_clock; // @[Core.scala 33:32]
  wire  datahazard_stall_reset; // @[Core.scala 33:32]
  wire [4:0] datahazard_stall_io_withDecode_srcAddrA; // @[Core.scala 33:32]
  wire [4:0] datahazard_stall_io_withDecode_srcAddrB; // @[Core.scala 33:32]
  wire [4:0] datahazard_stall_io_withMema_wbAddrFromMema; // @[Core.scala 33:32]
  wire [1:0] datahazard_stall_io_withMema_regTypeFromMema; // @[Core.scala 33:32]
  wire  datahazard_stall_io_stallFlag; // @[Core.scala 33:32]
  wire  regs_clock; // @[Core.scala 36:20]
  wire [4:0] regs_io_reg_read_read_addr_a; // @[Core.scala 36:20]
  wire [4:0] regs_io_reg_read_read_addr_b; // @[Core.scala 36:20]
  wire [63:0] regs_io_reg_read_read_data_a; // @[Core.scala 36:20]
  wire [63:0] regs_io_reg_read_read_data_b; // @[Core.scala 36:20]
  wire [4:0] regs_io_reg_write_write_addr; // @[Core.scala 36:20]
  wire [63:0] regs_io_reg_write_write_data; // @[Core.scala 36:20]
  wire  regs_io_reg_write_write_enable; // @[Core.scala 36:20]
  wire  csrs_clock; // @[Core.scala 37:20]
  wire [11:0] csrs_io_csrRead_csr_read_addr; // @[Core.scala 37:20]
  wire [63:0] csrs_io_csrRead_csr_read_data; // @[Core.scala 37:20]
  wire [63:0] csrs_io_envRead_csr_read_data; // @[Core.scala 37:20]
  wire [11:0] csrs_io_csrWrite_csr_write_addr; // @[Core.scala 37:20]
  wire [63:0] csrs_io_csrWrite_csr_write_data; // @[Core.scala 37:20]
  wire  csrs_io_csrWrite_csr_write_enable; // @[Core.scala 37:20]
  Instfetch instfetch ( // @[Core.scala 23:25]
    .clock(instfetch_clock),
    .reset(instfetch_reset),
    .io_branchFlag(instfetch_io_branchFlag),
    .io_jumpFlag(instfetch_io_jumpFlag),
    .io_stallFlag(instfetch_io_stallFlag),
    .io_branchTarget(instfetch_io_branchTarget),
    .io_jumpTarget(instfetch_io_jumpTarget),
    .io_instOut(instfetch_io_instOut),
    .io_pcOut(instfetch_io_pcOut),
    .io_fetchMem_read_addr_a(instfetch_io_fetchMem_read_addr_a),
    .io_fetchMem_read_inst_a(instfetch_io_fetchMem_read_inst_a),
    .io_envRead_csr_read_data(instfetch_io_envRead_csr_read_data)
  );
  FetchToDecode instfetch_to_decode ( // @[Core.scala 24:35]
    .clock(instfetch_to_decode_clock),
    .reset(instfetch_to_decode_reset),
    .io_stallFlag(instfetch_to_decode_io_stallFlag),
    .io_pcIn(instfetch_to_decode_io_pcIn),
    .io_instIn(instfetch_to_decode_io_instIn),
    .io_jumpOrBranchFlag(instfetch_to_decode_io_jumpOrBranchFlag),
    .io_instOut(instfetch_to_decode_io_instOut),
    .io_pcOut(instfetch_to_decode_io_pcOut)
  );
  Decode decode ( // @[Core.scala 25:22]
    .io_branchFlag(decode_io_branchFlag),
    .io_jumpFlag(decode_io_jumpFlag),
    .io_stallFlag(decode_io_stallFlag),
    .io_inst(decode_io_inst),
    .io_cur_pc(decode_io_cur_pc),
    .io_pcOut(decode_io_pcOut),
    .io_decodeOut_alu_exe_fun(decode_io_decodeOut_alu_exe_fun),
    .io_decodeOut_memType(decode_io_decodeOut_memType),
    .io_decodeOut_regType(decode_io_decodeOut_regType),
    .io_decodeOut_wbType(decode_io_decodeOut_wbType),
    .io_decodeOut_CSRType(decode_io_decodeOut_CSRType),
    .io_decodeOut_csrAddr(decode_io_decodeOut_csrAddr),
    .io_srcOut_aluSrc_a(decode_io_srcOut_aluSrc_a),
    .io_srcOut_aluSrc_b(decode_io_srcOut_aluSrc_b),
    .io_srcOut_regB_data(decode_io_srcOut_regB_data),
    .io_srcOut_writeback_addr(decode_io_srcOut_writeback_addr),
    .io_srcOut_imm_b(decode_io_srcOut_imm_b),
    .io_forward_srcAddrA(decode_io_forward_srcAddrA),
    .io_forward_srcAddrB(decode_io_forward_srcAddrB),
    .io_forward_hazardAData(decode_io_forward_hazardAData),
    .io_forward_hazardBData(decode_io_forward_hazardBData),
    .io_stall_srcAddrA(decode_io_stall_srcAddrA),
    .io_stall_srcAddrB(decode_io_stall_srcAddrB)
  );
  DecodeToExecute decode_to_execute ( // @[Core.scala 26:33]
    .clock(decode_to_execute_clock),
    .reset(decode_to_execute_reset),
    .io_jumpOrBranchFlag(decode_to_execute_io_jumpOrBranchFlag),
    .io_cur_pc(decode_to_execute_io_cur_pc),
    .io_pcOut(decode_to_execute_io_pcOut),
    .io_controlSignal_alu_exe_fun(decode_to_execute_io_controlSignal_alu_exe_fun),
    .io_controlSignal_memType(decode_to_execute_io_controlSignal_memType),
    .io_controlSignal_regType(decode_to_execute_io_controlSignal_regType),
    .io_controlSignal_wbType(decode_to_execute_io_controlSignal_wbType),
    .io_controlSignal_CSRType(decode_to_execute_io_controlSignal_CSRType),
    .io_controlSignal_csrAddr(decode_to_execute_io_controlSignal_csrAddr),
    .io_opSrc_aluSrc_a(decode_to_execute_io_opSrc_aluSrc_a),
    .io_opSrc_aluSrc_b(decode_to_execute_io_opSrc_aluSrc_b),
    .io_opSrc_regB_data(decode_to_execute_io_opSrc_regB_data),
    .io_opSrc_writeback_addr(decode_to_execute_io_opSrc_writeback_addr),
    .io_opSrc_imm_b(decode_to_execute_io_opSrc_imm_b),
    .io_controlSignalPass_alu_exe_fun(decode_to_execute_io_controlSignalPass_alu_exe_fun),
    .io_controlSignalPass_memType(decode_to_execute_io_controlSignalPass_memType),
    .io_controlSignalPass_regType(decode_to_execute_io_controlSignalPass_regType),
    .io_controlSignalPass_wbType(decode_to_execute_io_controlSignalPass_wbType),
    .io_controlSignalPass_CSRType(decode_to_execute_io_controlSignalPass_CSRType),
    .io_controlSignalPass_csrAddr(decode_to_execute_io_controlSignalPass_csrAddr),
    .io_srcPass_aluSrc_a(decode_to_execute_io_srcPass_aluSrc_a),
    .io_srcPass_aluSrc_b(decode_to_execute_io_srcPass_aluSrc_b),
    .io_srcPass_regB_data(decode_to_execute_io_srcPass_regB_data),
    .io_srcPass_writeback_addr(decode_to_execute_io_srcPass_writeback_addr),
    .io_srcPass_imm_b(decode_to_execute_io_srcPass_imm_b)
  );
  Alu execute ( // @[Core.scala 27:23]
    .io_cur_pc(execute_io_cur_pc),
    .io_jumpFlag(execute_io_jumpFlag),
    .io_branchFlag(execute_io_branchFlag),
    .io_linkedPC(execute_io_linkedPC),
    .io_branchTarget(execute_io_branchTarget),
    .io_alu_in_aluSrc_a(execute_io_alu_in_aluSrc_a),
    .io_alu_in_aluSrc_b(execute_io_alu_in_aluSrc_b),
    .io_alu_in_regB_data(execute_io_alu_in_regB_data),
    .io_alu_in_writeback_addr(execute_io_alu_in_writeback_addr),
    .io_alu_in_imm_b(execute_io_alu_in_imm_b),
    .io_alu_out_alu_result(execute_io_alu_out_alu_result),
    .io_alu_out_writeback_addr(execute_io_alu_out_writeback_addr),
    .io_alu_out_regB_data(execute_io_alu_out_regB_data),
    .io_controlPass_memType(execute_io_controlPass_memType),
    .io_controlPass_regType(execute_io_controlPass_regType),
    .io_controlPass_wbType(execute_io_controlPass_wbType),
    .io_controlPass_CSRType(execute_io_controlPass_CSRType),
    .io_controlPass_csrAddr(execute_io_controlPass_csrAddr),
    .io_controlSignal_alu_exe_fun(execute_io_controlSignal_alu_exe_fun),
    .io_controlSignal_memType(execute_io_controlSignal_memType),
    .io_controlSignal_regType(execute_io_controlSignal_regType),
    .io_controlSignal_wbType(execute_io_controlSignal_wbType),
    .io_controlSignal_CSRType(execute_io_controlSignal_CSRType),
    .io_controlSignal_csrAddr(execute_io_controlSignal_csrAddr),
    .io_dataHazard_wbAddrFromExecute(execute_io_dataHazard_wbAddrFromExecute),
    .io_dataHazard_regTypeFromExecute(execute_io_dataHazard_regTypeFromExecute),
    .io_dataHazard_wbDataFromExe(execute_io_dataHazard_wbDataFromExe)
  );
  ExecuteToMema execute_to_mema ( // @[Core.scala 28:31]
    .clock(execute_to_mema_clock),
    .reset(execute_to_mema_reset),
    .io_linkedPC(execute_to_mema_io_linkedPC),
    .io_linkedPCPass(execute_to_mema_io_linkedPCPass),
    .io_aluOut_alu_result(execute_to_mema_io_aluOut_alu_result),
    .io_aluOut_writeback_addr(execute_to_mema_io_aluOut_writeback_addr),
    .io_aluOut_regB_data(execute_to_mema_io_aluOut_regB_data),
    .io_controlSignal_memType(execute_to_mema_io_controlSignal_memType),
    .io_controlSignal_regType(execute_to_mema_io_controlSignal_regType),
    .io_controlSignal_wbType(execute_to_mema_io_controlSignal_wbType),
    .io_controlSignal_CSRType(execute_to_mema_io_controlSignal_CSRType),
    .io_controlSignal_csrAddr(execute_to_mema_io_controlSignal_csrAddr),
    .io_aluOutPass_alu_result(execute_to_mema_io_aluOutPass_alu_result),
    .io_aluOutPass_writeback_addr(execute_to_mema_io_aluOutPass_writeback_addr),
    .io_aluOutPass_regB_data(execute_to_mema_io_aluOutPass_regB_data),
    .io_controlSignalPass_memType(execute_to_mema_io_controlSignalPass_memType),
    .io_controlSignalPass_regType(execute_to_mema_io_controlSignalPass_regType),
    .io_controlSignalPass_wbType(execute_to_mema_io_controlSignalPass_wbType),
    .io_controlSignalPass_CSRType(execute_to_mema_io_controlSignalPass_CSRType),
    .io_controlSignalPass_csrAddr(execute_to_mema_io_controlSignalPass_csrAddr)
  );
  MemAccess memoryAccess ( // @[Core.scala 29:28]
    .io_linkedPC(memoryAccess_io_linkedPC),
    .io_aluOut_alu_result(memoryAccess_io_aluOut_alu_result),
    .io_aluOut_writeback_addr(memoryAccess_io_aluOut_writeback_addr),
    .io_aluOut_regB_data(memoryAccess_io_aluOut_regB_data),
    .io_controlSignal_memType(memoryAccess_io_controlSignal_memType),
    .io_controlSignal_regType(memoryAccess_io_controlSignal_regType),
    .io_controlSignal_wbType(memoryAccess_io_controlSignal_wbType),
    .io_controlSignal_CSRType(memoryAccess_io_controlSignal_CSRType),
    .io_controlSignal_csrAddr(memoryAccess_io_controlSignal_csrAddr),
    .io_dataReadPort_read_data_b(memoryAccess_io_dataReadPort_read_data_b),
    .io_dataWritePort_write_addr(memoryAccess_io_dataWritePort_write_addr),
    .io_dataWritePort_write_data(memoryAccess_io_dataWritePort_write_data),
    .io_dataWritePort_write_lenth(memoryAccess_io_dataWritePort_write_lenth),
    .io_dataWritePort_write_enable(memoryAccess_io_dataWritePort_write_enable),
    .io_csrRead_csr_read_addr(memoryAccess_io_csrRead_csr_read_addr),
    .io_csrRead_csr_read_data(memoryAccess_io_csrRead_csr_read_data),
    .io_forward_wbAddrFromMema(memoryAccess_io_forward_wbAddrFromMema),
    .io_forward_regTypeFromMema(memoryAccess_io_forward_regTypeFromMema),
    .io_forward_wbDataFromMema(memoryAccess_io_forward_wbDataFromMema),
    .io_stall_wbAddrFromMema(memoryAccess_io_stall_wbAddrFromMema),
    .io_stall_regTypeFromMema(memoryAccess_io_stall_regTypeFromMema),
    .io_memPass_writeback_addr(memoryAccess_io_memPass_writeback_addr),
    .io_memPass_writeback_data(memoryAccess_io_memPass_writeback_data),
    .io_memPass_regwrite_enable(memoryAccess_io_memPass_regwrite_enable),
    .io_memPass_csrwrite_addr(memoryAccess_io_memPass_csrwrite_addr),
    .io_memPass_csrwrite_data(memoryAccess_io_memPass_csrwrite_data),
    .io_memPass_CSRType(memoryAccess_io_memPass_CSRType)
  );
  MemaToWB mema_to_wb ( // @[Core.scala 30:26]
    .clock(mema_to_wb_clock),
    .reset(mema_to_wb_reset),
    .io_wbinfo_writeback_addr(mema_to_wb_io_wbinfo_writeback_addr),
    .io_wbinfo_writeback_data(mema_to_wb_io_wbinfo_writeback_data),
    .io_wbinfo_regwrite_enable(mema_to_wb_io_wbinfo_regwrite_enable),
    .io_wbinfo_csrwrite_addr(mema_to_wb_io_wbinfo_csrwrite_addr),
    .io_wbinfo_csrwrite_data(mema_to_wb_io_wbinfo_csrwrite_data),
    .io_wbinfo_CSRType(mema_to_wb_io_wbinfo_CSRType),
    .io_wbinfoPass_writeback_addr(mema_to_wb_io_wbinfoPass_writeback_addr),
    .io_wbinfoPass_writeback_data(mema_to_wb_io_wbinfoPass_writeback_data),
    .io_wbinfoPass_regwrite_enable(mema_to_wb_io_wbinfoPass_regwrite_enable),
    .io_wbinfoPass_csrwrite_addr(mema_to_wb_io_wbinfoPass_csrwrite_addr),
    .io_wbinfoPass_csrwrite_data(mema_to_wb_io_wbinfoPass_csrwrite_data),
    .io_wbinfoPass_CSRType(mema_to_wb_io_wbinfoPass_CSRType)
  );
  WriteBack writeback ( // @[Core.scala 31:25]
    .io_wbinfo_writeback_addr(writeback_io_wbinfo_writeback_addr),
    .io_wbinfo_writeback_data(writeback_io_wbinfo_writeback_data),
    .io_wbinfo_regwrite_enable(writeback_io_wbinfo_regwrite_enable),
    .io_wbinfo_csrwrite_addr(writeback_io_wbinfo_csrwrite_addr),
    .io_wbinfo_csrwrite_data(writeback_io_wbinfo_csrwrite_data),
    .io_wbinfo_CSRType(writeback_io_wbinfo_CSRType),
    .io_regWrite_write_addr(writeback_io_regWrite_write_addr),
    .io_regWrite_write_data(writeback_io_regWrite_write_data),
    .io_regWrite_write_enable(writeback_io_regWrite_write_enable),
    .io_csrWrite_csr_write_addr(writeback_io_csrWrite_csr_write_addr),
    .io_csrWrite_csr_write_data(writeback_io_csrWrite_csr_write_data),
    .io_csrWrite_csr_write_enable(writeback_io_csrWrite_csr_write_enable)
  );
  Forward datahazard_forward ( // @[Core.scala 32:34]
    .io_withDecode_srcAddrA(datahazard_forward_io_withDecode_srcAddrA),
    .io_withDecode_srcAddrB(datahazard_forward_io_withDecode_srcAddrB),
    .io_withDecode_hazardAData(datahazard_forward_io_withDecode_hazardAData),
    .io_withDecode_hazardBData(datahazard_forward_io_withDecode_hazardBData),
    .io_withExecute_wbAddrFromExecute(datahazard_forward_io_withExecute_wbAddrFromExecute),
    .io_withExecute_regTypeFromExecute(datahazard_forward_io_withExecute_regTypeFromExecute),
    .io_withExecute_wbDataFromExe(datahazard_forward_io_withExecute_wbDataFromExe),
    .io_withMema_wbAddrFromMema(datahazard_forward_io_withMema_wbAddrFromMema),
    .io_withMema_regTypeFromMema(datahazard_forward_io_withMema_regTypeFromMema),
    .io_withMema_wbDataFromMema(datahazard_forward_io_withMema_wbDataFromMema),
    .io_regReadPort_read_addr_a(datahazard_forward_io_regReadPort_read_addr_a),
    .io_regReadPort_read_addr_b(datahazard_forward_io_regReadPort_read_addr_b),
    .io_regReadPort_read_data_a(datahazard_forward_io_regReadPort_read_data_a),
    .io_regReadPort_read_data_b(datahazard_forward_io_regReadPort_read_data_b)
  );
  Stall datahazard_stall ( // @[Core.scala 33:32]
    .clock(datahazard_stall_clock),
    .reset(datahazard_stall_reset),
    .io_withDecode_srcAddrA(datahazard_stall_io_withDecode_srcAddrA),
    .io_withDecode_srcAddrB(datahazard_stall_io_withDecode_srcAddrB),
    .io_withMema_wbAddrFromMema(datahazard_stall_io_withMema_wbAddrFromMema),
    .io_withMema_regTypeFromMema(datahazard_stall_io_withMema_regTypeFromMema),
    .io_stallFlag(datahazard_stall_io_stallFlag)
  );
  RegFile regs ( // @[Core.scala 36:20]
    .clock(regs_clock),
    .io_reg_read_read_addr_a(regs_io_reg_read_read_addr_a),
    .io_reg_read_read_addr_b(regs_io_reg_read_read_addr_b),
    .io_reg_read_read_data_a(regs_io_reg_read_read_data_a),
    .io_reg_read_read_data_b(regs_io_reg_read_read_data_b),
    .io_reg_write_write_addr(regs_io_reg_write_write_addr),
    .io_reg_write_write_data(regs_io_reg_write_write_data),
    .io_reg_write_write_enable(regs_io_reg_write_write_enable)
  );
  CSRfile csrs ( // @[Core.scala 37:20]
    .clock(csrs_clock),
    .io_csrRead_csr_read_addr(csrs_io_csrRead_csr_read_addr),
    .io_csrRead_csr_read_data(csrs_io_csrRead_csr_read_data),
    .io_envRead_csr_read_data(csrs_io_envRead_csr_read_data),
    .io_csrWrite_csr_write_addr(csrs_io_csrWrite_csr_write_addr),
    .io_csrWrite_csr_write_data(csrs_io_csrWrite_csr_write_data),
    .io_csrWrite_csr_write_enable(csrs_io_csrWrite_csr_write_enable)
  );
  assign io_instfetch_fetchMem_read_addr_a = instfetch_io_fetchMem_read_addr_a; // @[Core.scala 74:25]
  assign io_memoryAccess_dataWritePort_write_addr = memoryAccess_io_dataWritePort_write_addr; // @[Core.scala 109:33]
  assign io_memoryAccess_dataWritePort_write_data = memoryAccess_io_dataWritePort_write_data; // @[Core.scala 109:33]
  assign io_memoryAccess_dataWritePort_write_lenth = memoryAccess_io_dataWritePort_write_lenth; // @[Core.scala 109:33]
  assign io_memoryAccess_dataWritePort_write_enable = memoryAccess_io_dataWritePort_write_enable; // @[Core.scala 109:33]
  assign io_probe = writeback_io_wbinfo_writeback_data; // @[Core.scala 125:12]
  assign instfetch_clock = clock;
  assign instfetch_reset = reset;
  assign instfetch_io_branchFlag = execute_io_branchFlag; // @[Core.scala 69:27]
  assign instfetch_io_jumpFlag = execute_io_jumpFlag; // @[Core.scala 70:25]
  assign instfetch_io_stallFlag = datahazard_stall_io_stallFlag; // @[Core.scala 71:26]
  assign instfetch_io_branchTarget = execute_io_branchTarget; // @[Core.scala 72:29]
  assign instfetch_io_jumpTarget = execute_io_alu_out_alu_result; // @[Core.scala 73:27]
  assign instfetch_io_fetchMem_read_inst_a = io_instfetch_fetchMem_read_inst_a; // @[Core.scala 74:25]
  assign instfetch_io_envRead_csr_read_data = csrs_io_envRead_csr_read_data; // @[Core.scala 75:24]
  assign instfetch_to_decode_clock = clock;
  assign instfetch_to_decode_reset = reset;
  assign instfetch_to_decode_io_stallFlag = datahazard_stall_io_stallFlag; // @[Core.scala 77:36]
  assign instfetch_to_decode_io_pcIn = instfetch_io_pcOut; // @[Core.scala 78:31]
  assign instfetch_to_decode_io_instIn = instfetch_io_instOut[31:0]; // @[Core.scala 79:33]
  assign instfetch_to_decode_io_jumpOrBranchFlag = execute_io_jumpFlag | execute_io_branchFlag; // @[Core.scala 80:67]
  assign decode_io_branchFlag = execute_io_branchFlag; // @[Core.scala 82:24]
  assign decode_io_jumpFlag = execute_io_jumpFlag; // @[Core.scala 83:22]
  assign decode_io_stallFlag = datahazard_stall_io_stallFlag; // @[Core.scala 84:23]
  assign decode_io_inst = instfetch_to_decode_io_instOut; // @[Core.scala 85:18]
  assign decode_io_cur_pc = instfetch_to_decode_io_pcOut; // @[Core.scala 86:20]
  assign decode_io_forward_hazardAData = datahazard_forward_io_withDecode_hazardAData; // @[Core.scala 87:21]
  assign decode_io_forward_hazardBData = datahazard_forward_io_withDecode_hazardBData; // @[Core.scala 87:21]
  assign decode_to_execute_clock = clock;
  assign decode_to_execute_reset = reset;
  assign decode_to_execute_io_jumpOrBranchFlag = execute_io_jumpFlag | execute_io_branchFlag; // @[Core.scala 91:65]
  assign decode_to_execute_io_cur_pc = decode_io_pcOut; // @[Core.scala 92:31]
  assign decode_to_execute_io_controlSignal_alu_exe_fun = decode_io_decodeOut_alu_exe_fun; // @[Core.scala 93:38]
  assign decode_to_execute_io_controlSignal_memType = decode_io_decodeOut_memType; // @[Core.scala 93:38]
  assign decode_to_execute_io_controlSignal_regType = decode_io_decodeOut_regType; // @[Core.scala 93:38]
  assign decode_to_execute_io_controlSignal_wbType = decode_io_decodeOut_wbType; // @[Core.scala 93:38]
  assign decode_to_execute_io_controlSignal_CSRType = decode_io_decodeOut_CSRType; // @[Core.scala 93:38]
  assign decode_to_execute_io_controlSignal_csrAddr = decode_io_decodeOut_csrAddr; // @[Core.scala 93:38]
  assign decode_to_execute_io_opSrc_aluSrc_a = decode_io_srcOut_aluSrc_a; // @[Core.scala 94:30]
  assign decode_to_execute_io_opSrc_aluSrc_b = decode_io_srcOut_aluSrc_b; // @[Core.scala 94:30]
  assign decode_to_execute_io_opSrc_regB_data = decode_io_srcOut_regB_data; // @[Core.scala 94:30]
  assign decode_to_execute_io_opSrc_writeback_addr = decode_io_srcOut_writeback_addr; // @[Core.scala 94:30]
  assign decode_to_execute_io_opSrc_imm_b = decode_io_srcOut_imm_b; // @[Core.scala 94:30]
  assign execute_io_cur_pc = decode_to_execute_io_pcOut; // @[Core.scala 96:21]
  assign execute_io_alu_in_aluSrc_a = decode_to_execute_io_srcPass_aluSrc_a; // @[Core.scala 97:21]
  assign execute_io_alu_in_aluSrc_b = decode_to_execute_io_srcPass_aluSrc_b; // @[Core.scala 97:21]
  assign execute_io_alu_in_regB_data = decode_to_execute_io_srcPass_regB_data; // @[Core.scala 97:21]
  assign execute_io_alu_in_writeback_addr = decode_to_execute_io_srcPass_writeback_addr; // @[Core.scala 97:21]
  assign execute_io_alu_in_imm_b = decode_to_execute_io_srcPass_imm_b; // @[Core.scala 97:21]
  assign execute_io_controlSignal_alu_exe_fun = decode_to_execute_io_controlSignalPass_alu_exe_fun; // @[Core.scala 98:28]
  assign execute_io_controlSignal_memType = decode_to_execute_io_controlSignalPass_memType; // @[Core.scala 98:28]
  assign execute_io_controlSignal_regType = decode_to_execute_io_controlSignalPass_regType; // @[Core.scala 98:28]
  assign execute_io_controlSignal_wbType = decode_to_execute_io_controlSignalPass_wbType; // @[Core.scala 98:28]
  assign execute_io_controlSignal_CSRType = decode_to_execute_io_controlSignalPass_CSRType; // @[Core.scala 98:28]
  assign execute_io_controlSignal_csrAddr = decode_to_execute_io_controlSignalPass_csrAddr; // @[Core.scala 98:28]
  assign execute_to_mema_clock = clock;
  assign execute_to_mema_reset = reset;
  assign execute_to_mema_io_linkedPC = execute_io_linkedPC; // @[Core.scala 101:31]
  assign execute_to_mema_io_aluOut_alu_result = execute_io_alu_out_alu_result; // @[Core.scala 102:29]
  assign execute_to_mema_io_aluOut_writeback_addr = execute_io_alu_out_writeback_addr; // @[Core.scala 102:29]
  assign execute_to_mema_io_aluOut_regB_data = execute_io_alu_out_regB_data; // @[Core.scala 102:29]
  assign execute_to_mema_io_controlSignal_memType = execute_io_controlPass_memType; // @[Core.scala 103:36]
  assign execute_to_mema_io_controlSignal_regType = execute_io_controlPass_regType; // @[Core.scala 103:36]
  assign execute_to_mema_io_controlSignal_wbType = execute_io_controlPass_wbType; // @[Core.scala 103:36]
  assign execute_to_mema_io_controlSignal_CSRType = execute_io_controlPass_CSRType; // @[Core.scala 103:36]
  assign execute_to_mema_io_controlSignal_csrAddr = execute_io_controlPass_csrAddr; // @[Core.scala 103:36]
  assign memoryAccess_io_linkedPC = execute_to_mema_io_linkedPCPass; // @[Core.scala 105:28]
  assign memoryAccess_io_aluOut_alu_result = execute_to_mema_io_aluOutPass_alu_result; // @[Core.scala 106:26]
  assign memoryAccess_io_aluOut_writeback_addr = execute_to_mema_io_aluOutPass_writeback_addr; // @[Core.scala 106:26]
  assign memoryAccess_io_aluOut_regB_data = execute_to_mema_io_aluOutPass_regB_data; // @[Core.scala 106:26]
  assign memoryAccess_io_controlSignal_memType = execute_to_mema_io_controlSignalPass_memType; // @[Core.scala 107:33]
  assign memoryAccess_io_controlSignal_regType = execute_to_mema_io_controlSignalPass_regType; // @[Core.scala 107:33]
  assign memoryAccess_io_controlSignal_wbType = execute_to_mema_io_controlSignalPass_wbType; // @[Core.scala 107:33]
  assign memoryAccess_io_controlSignal_CSRType = execute_to_mema_io_controlSignalPass_CSRType; // @[Core.scala 107:33]
  assign memoryAccess_io_controlSignal_csrAddr = execute_to_mema_io_controlSignalPass_csrAddr; // @[Core.scala 107:33]
  assign memoryAccess_io_dataReadPort_read_data_b = io_memoryAccess_dataReadPort_read_data_b; // @[Core.scala 108:32]
  assign memoryAccess_io_csrRead_csr_read_data = csrs_io_csrRead_csr_read_data; // @[Core.scala 110:27]
  assign mema_to_wb_clock = clock;
  assign mema_to_wb_reset = reset;
  assign mema_to_wb_io_wbinfo_writeback_addr = memoryAccess_io_memPass_writeback_addr; // @[Core.scala 114:24]
  assign mema_to_wb_io_wbinfo_writeback_data = memoryAccess_io_memPass_writeback_data; // @[Core.scala 114:24]
  assign mema_to_wb_io_wbinfo_regwrite_enable = memoryAccess_io_memPass_regwrite_enable; // @[Core.scala 114:24]
  assign mema_to_wb_io_wbinfo_csrwrite_addr = memoryAccess_io_memPass_csrwrite_addr; // @[Core.scala 114:24]
  assign mema_to_wb_io_wbinfo_csrwrite_data = memoryAccess_io_memPass_csrwrite_data; // @[Core.scala 114:24]
  assign mema_to_wb_io_wbinfo_CSRType = memoryAccess_io_memPass_CSRType; // @[Core.scala 114:24]
  assign writeback_io_wbinfo_writeback_addr = mema_to_wb_io_wbinfoPass_writeback_addr; // @[Core.scala 116:23]
  assign writeback_io_wbinfo_writeback_data = mema_to_wb_io_wbinfoPass_writeback_data; // @[Core.scala 116:23]
  assign writeback_io_wbinfo_regwrite_enable = mema_to_wb_io_wbinfoPass_regwrite_enable; // @[Core.scala 116:23]
  assign writeback_io_wbinfo_csrwrite_addr = mema_to_wb_io_wbinfoPass_csrwrite_addr; // @[Core.scala 116:23]
  assign writeback_io_wbinfo_csrwrite_data = mema_to_wb_io_wbinfoPass_csrwrite_data; // @[Core.scala 116:23]
  assign writeback_io_wbinfo_CSRType = mema_to_wb_io_wbinfoPass_CSRType; // @[Core.scala 116:23]
  assign datahazard_forward_io_withDecode_srcAddrA = decode_io_forward_srcAddrA; // @[Core.scala 87:21]
  assign datahazard_forward_io_withDecode_srcAddrB = decode_io_forward_srcAddrB; // @[Core.scala 87:21]
  assign datahazard_forward_io_withExecute_wbAddrFromExecute = execute_io_dataHazard_wbAddrFromExecute; // @[Core.scala 99:25]
  assign datahazard_forward_io_withExecute_regTypeFromExecute = execute_io_dataHazard_regTypeFromExecute; // @[Core.scala 99:25]
  assign datahazard_forward_io_withExecute_wbDataFromExe = execute_io_dataHazard_wbDataFromExe; // @[Core.scala 99:25]
  assign datahazard_forward_io_withMema_wbAddrFromMema = memoryAccess_io_forward_wbAddrFromMema; // @[Core.scala 111:27]
  assign datahazard_forward_io_withMema_regTypeFromMema = memoryAccess_io_forward_regTypeFromMema; // @[Core.scala 111:27]
  assign datahazard_forward_io_withMema_wbDataFromMema = memoryAccess_io_forward_wbDataFromMema; // @[Core.scala 111:27]
  assign datahazard_forward_io_regReadPort_read_data_a = regs_io_reg_read_read_data_a; // @[Core.scala 122:37]
  assign datahazard_forward_io_regReadPort_read_data_b = regs_io_reg_read_read_data_b; // @[Core.scala 122:37]
  assign datahazard_stall_clock = clock;
  assign datahazard_stall_reset = reset;
  assign datahazard_stall_io_withDecode_srcAddrA = decode_io_stall_srcAddrA; // @[Core.scala 88:19]
  assign datahazard_stall_io_withDecode_srcAddrB = decode_io_stall_srcAddrB; // @[Core.scala 88:19]
  assign datahazard_stall_io_withMema_wbAddrFromMema = memoryAccess_io_stall_wbAddrFromMema; // @[Core.scala 112:25]
  assign datahazard_stall_io_withMema_regTypeFromMema = memoryAccess_io_stall_regTypeFromMema; // @[Core.scala 112:25]
  assign regs_clock = clock;
  assign regs_io_reg_read_read_addr_a = datahazard_forward_io_regReadPort_read_addr_a; // @[Core.scala 122:37]
  assign regs_io_reg_read_read_addr_b = datahazard_forward_io_regReadPort_read_addr_b; // @[Core.scala 122:37]
  assign regs_io_reg_write_write_addr = writeback_io_regWrite_write_addr; // @[Core.scala 117:21]
  assign regs_io_reg_write_write_data = writeback_io_regWrite_write_data; // @[Core.scala 117:21]
  assign regs_io_reg_write_write_enable = writeback_io_regWrite_write_enable; // @[Core.scala 117:21]
  assign csrs_clock = clock;
  assign csrs_io_csrRead_csr_read_addr = memoryAccess_io_csrRead_csr_read_addr; // @[Core.scala 110:27]
  assign csrs_io_csrWrite_csr_write_addr = writeback_io_csrWrite_csr_write_addr; // @[Core.scala 118:20]
  assign csrs_io_csrWrite_csr_write_data = writeback_io_csrWrite_csr_write_data; // @[Core.scala 118:20]
  assign csrs_io_csrWrite_csr_write_enable = writeback_io_csrWrite_csr_write_enable; // @[Core.scala 118:20]
endmodule
module Memory(
  input         clock,
  input  [63:0] io_instReadPort_read_addr_a,
  output [31:0] io_instReadPort_read_inst_a,
  output [63:0] io_dataReadPort_read_data_b,
  input  [63:0] io_writePort_write_addr,
  input  [63:0] io_writePort_write_data,
  input  [3:0]  io_writePort_write_lenth,
  input         io_writePort_write_enable
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] memory [0:4095]; // @[Memory.scala 15:27]
  wire  memory_io_instReadPort_read_inst_a_MPORT_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_instReadPort_read_inst_a_MPORT_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_instReadPort_read_inst_a_MPORT_data; // @[Memory.scala 15:27]
  wire  memory_io_instReadPort_read_inst_a_MPORT_1_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_instReadPort_read_inst_a_MPORT_1_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_instReadPort_read_inst_a_MPORT_1_data; // @[Memory.scala 15:27]
  wire  memory_io_instReadPort_read_inst_a_MPORT_2_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_instReadPort_read_inst_a_MPORT_2_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_instReadPort_read_inst_a_MPORT_2_data; // @[Memory.scala 15:27]
  wire  memory_io_instReadPort_read_inst_a_MPORT_3_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_instReadPort_read_inst_a_MPORT_3_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_instReadPort_read_inst_a_MPORT_3_data; // @[Memory.scala 15:27]
  wire  memory_io_dataReadPort_read_data_b_MPORT_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_dataReadPort_read_data_b_MPORT_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_dataReadPort_read_data_b_MPORT_data; // @[Memory.scala 15:27]
  wire  memory_io_dataReadPort_read_data_b_MPORT_1_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_dataReadPort_read_data_b_MPORT_1_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_dataReadPort_read_data_b_MPORT_1_data; // @[Memory.scala 15:27]
  wire  memory_io_dataReadPort_read_data_b_MPORT_2_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_dataReadPort_read_data_b_MPORT_2_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_dataReadPort_read_data_b_MPORT_2_data; // @[Memory.scala 15:27]
  wire  memory_io_dataReadPort_read_data_b_MPORT_3_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_dataReadPort_read_data_b_MPORT_3_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_dataReadPort_read_data_b_MPORT_3_data; // @[Memory.scala 15:27]
  wire  memory_io_dataReadPort_read_data_b_MPORT_4_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_dataReadPort_read_data_b_MPORT_4_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_dataReadPort_read_data_b_MPORT_4_data; // @[Memory.scala 15:27]
  wire  memory_io_dataReadPort_read_data_b_MPORT_5_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_dataReadPort_read_data_b_MPORT_5_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_dataReadPort_read_data_b_MPORT_5_data; // @[Memory.scala 15:27]
  wire  memory_io_dataReadPort_read_data_b_MPORT_6_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_dataReadPort_read_data_b_MPORT_6_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_dataReadPort_read_data_b_MPORT_6_data; // @[Memory.scala 15:27]
  wire  memory_io_dataReadPort_read_data_b_MPORT_7_en; // @[Memory.scala 15:27]
  wire [11:0] memory_io_dataReadPort_read_data_b_MPORT_7_addr; // @[Memory.scala 15:27]
  wire [7:0] memory_io_dataReadPort_read_data_b_MPORT_7_data; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_1_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_1_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_1_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_1_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_2_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_2_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_2_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_2_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_3_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_3_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_3_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_3_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_4_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_4_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_4_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_4_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_5_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_5_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_5_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_5_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_6_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_6_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_6_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_6_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_7_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_7_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_7_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_7_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_8_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_8_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_8_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_8_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_9_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_9_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_9_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_9_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_10_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_10_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_10_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_10_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_11_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_11_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_11_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_11_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_12_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_12_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_12_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_12_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_13_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_13_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_13_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_13_en; // @[Memory.scala 15:27]
  wire [7:0] memory_MPORT_14_data; // @[Memory.scala 15:27]
  wire [11:0] memory_MPORT_14_addr; // @[Memory.scala 15:27]
  wire  memory_MPORT_14_mask; // @[Memory.scala 15:27]
  wire  memory_MPORT_14_en; // @[Memory.scala 15:27]
  reg  memory_io_instReadPort_read_inst_a_MPORT_en_pipe_0;
  reg [11:0] memory_io_instReadPort_read_inst_a_MPORT_addr_pipe_0;
  reg  memory_io_instReadPort_read_inst_a_MPORT_1_en_pipe_0;
  reg [11:0] memory_io_instReadPort_read_inst_a_MPORT_1_addr_pipe_0;
  reg  memory_io_instReadPort_read_inst_a_MPORT_2_en_pipe_0;
  reg [11:0] memory_io_instReadPort_read_inst_a_MPORT_2_addr_pipe_0;
  reg  memory_io_instReadPort_read_inst_a_MPORT_3_en_pipe_0;
  reg [11:0] memory_io_instReadPort_read_inst_a_MPORT_3_addr_pipe_0;
  reg  memory_io_dataReadPort_read_data_b_MPORT_en_pipe_0;
  reg [11:0] memory_io_dataReadPort_read_data_b_MPORT_addr_pipe_0;
  reg  memory_io_dataReadPort_read_data_b_MPORT_1_en_pipe_0;
  reg [11:0] memory_io_dataReadPort_read_data_b_MPORT_1_addr_pipe_0;
  reg  memory_io_dataReadPort_read_data_b_MPORT_2_en_pipe_0;
  reg [11:0] memory_io_dataReadPort_read_data_b_MPORT_2_addr_pipe_0;
  reg  memory_io_dataReadPort_read_data_b_MPORT_3_en_pipe_0;
  reg [11:0] memory_io_dataReadPort_read_data_b_MPORT_3_addr_pipe_0;
  reg  memory_io_dataReadPort_read_data_b_MPORT_4_en_pipe_0;
  reg [11:0] memory_io_dataReadPort_read_data_b_MPORT_4_addr_pipe_0;
  reg  memory_io_dataReadPort_read_data_b_MPORT_5_en_pipe_0;
  reg [11:0] memory_io_dataReadPort_read_data_b_MPORT_5_addr_pipe_0;
  reg  memory_io_dataReadPort_read_data_b_MPORT_6_en_pipe_0;
  reg [11:0] memory_io_dataReadPort_read_data_b_MPORT_6_addr_pipe_0;
  reg  memory_io_dataReadPort_read_data_b_MPORT_7_en_pipe_0;
  reg [11:0] memory_io_dataReadPort_read_data_b_MPORT_7_addr_pipe_0;
  wire [63:0] _io_instReadPort_read_inst_a_T_1 = io_instReadPort_read_addr_a + 64'h3; // @[Memory.scala 17:78]
  wire [63:0] _io_instReadPort_read_inst_a_T_5 = io_instReadPort_read_addr_a + 64'h2; // @[Memory.scala 18:45]
  wire [63:0] _io_instReadPort_read_inst_a_T_9 = io_instReadPort_read_addr_a + 64'h1; // @[Memory.scala 19:45]
  wire [15:0] io_instReadPort_read_inst_a_lo = {memory_io_instReadPort_read_inst_a_MPORT_2_data,
    memory_io_instReadPort_read_inst_a_MPORT_3_data}; // @[Cat.scala 31:58]
  wire [15:0] io_instReadPort_read_inst_a_hi = {memory_io_instReadPort_read_inst_a_MPORT_data,
    memory_io_instReadPort_read_inst_a_MPORT_1_data}; // @[Cat.scala 31:58]
  wire [63:0] _io_dataReadPort_read_data_b_T_1 = io_instReadPort_read_addr_a + 64'h7; // @[Memory.scala 21:78]
  wire [63:0] _io_dataReadPort_read_data_b_T_5 = io_instReadPort_read_addr_a + 64'h6; // @[Memory.scala 22:45]
  wire [63:0] _io_dataReadPort_read_data_b_T_9 = io_instReadPort_read_addr_a + 64'h5; // @[Memory.scala 23:45]
  wire [63:0] _io_dataReadPort_read_data_b_T_13 = io_instReadPort_read_addr_a + 64'h4; // @[Memory.scala 24:45]
  wire [31:0] io_dataReadPort_read_data_b_lo = {memory_io_dataReadPort_read_data_b_MPORT_4_data,
    memory_io_dataReadPort_read_data_b_MPORT_5_data,memory_io_dataReadPort_read_data_b_MPORT_6_data,
    memory_io_dataReadPort_read_data_b_MPORT_7_data}; // @[Cat.scala 31:58]
  wire [31:0] io_dataReadPort_read_data_b_hi = {memory_io_dataReadPort_read_data_b_MPORT_data,
    memory_io_dataReadPort_read_data_b_MPORT_1_data,memory_io_dataReadPort_read_data_b_MPORT_2_data,
    memory_io_dataReadPort_read_data_b_MPORT_3_data}; // @[Cat.scala 31:58]
  wire  _T = io_writePort_write_lenth == 4'h4; // @[Memory.scala 30:35]
  wire  _T_3 = io_writePort_write_lenth == 4'h5; // @[Memory.scala 32:41]
  wire [63:0] _T_7 = io_writePort_write_addr + 64'h1; // @[Memory.scala 34:50]
  wire  _T_10 = io_writePort_write_lenth == 4'h6; // @[Memory.scala 35:41]
  wire [63:0] _T_18 = io_writePort_write_addr + 64'h2; // @[Memory.scala 38:50]
  wire [63:0] _T_22 = io_writePort_write_addr + 64'h3; // @[Memory.scala 39:50]
  wire  _T_25 = io_writePort_write_lenth == 4'h7; // @[Memory.scala 40:41]
  wire [63:0] _T_41 = io_writePort_write_addr + 64'h4; // @[Memory.scala 45:50]
  wire [63:0] _T_45 = io_writePort_write_addr + 64'h5; // @[Memory.scala 46:50]
  wire [63:0] _T_49 = io_writePort_write_addr + 64'h6; // @[Memory.scala 47:50]
  wire [63:0] _T_53 = io_writePort_write_addr + 64'h7; // @[Memory.scala 48:50]
  wire  _GEN_57 = io_writePort_write_lenth == 4'h6 ? 1'h0 : _T_25; // @[Memory.scala 15:27 35:52]
  wire  _GEN_83 = io_writePort_write_lenth == 4'h5 ? 1'h0 : _T_10; // @[Memory.scala 15:27 32:52]
  wire  _GEN_94 = io_writePort_write_lenth == 4'h5 ? 1'h0 : _GEN_57; // @[Memory.scala 15:27 32:52]
  wire  _GEN_118 = io_writePort_write_lenth == 4'h4 ? 1'h0 : _T_3; // @[Memory.scala 15:27 30:46]
  wire  _GEN_125 = io_writePort_write_lenth == 4'h4 ? 1'h0 : _GEN_83; // @[Memory.scala 15:27 30:46]
  wire  _GEN_136 = io_writePort_write_lenth == 4'h4 ? 1'h0 : _GEN_94; // @[Memory.scala 15:27 30:46]
  assign memory_io_instReadPort_read_inst_a_MPORT_en = memory_io_instReadPort_read_inst_a_MPORT_en_pipe_0;
  assign memory_io_instReadPort_read_inst_a_MPORT_addr = memory_io_instReadPort_read_inst_a_MPORT_addr_pipe_0;
  assign memory_io_instReadPort_read_inst_a_MPORT_data = memory[memory_io_instReadPort_read_inst_a_MPORT_addr]; // @[Memory.scala 15:27]
  assign memory_io_instReadPort_read_inst_a_MPORT_1_en = memory_io_instReadPort_read_inst_a_MPORT_1_en_pipe_0;
  assign memory_io_instReadPort_read_inst_a_MPORT_1_addr = memory_io_instReadPort_read_inst_a_MPORT_1_addr_pipe_0;
  assign memory_io_instReadPort_read_inst_a_MPORT_1_data = memory[memory_io_instReadPort_read_inst_a_MPORT_1_addr]; // @[Memory.scala 15:27]
  assign memory_io_instReadPort_read_inst_a_MPORT_2_en = memory_io_instReadPort_read_inst_a_MPORT_2_en_pipe_0;
  assign memory_io_instReadPort_read_inst_a_MPORT_2_addr = memory_io_instReadPort_read_inst_a_MPORT_2_addr_pipe_0;
  assign memory_io_instReadPort_read_inst_a_MPORT_2_data = memory[memory_io_instReadPort_read_inst_a_MPORT_2_addr]; // @[Memory.scala 15:27]
  assign memory_io_instReadPort_read_inst_a_MPORT_3_en = memory_io_instReadPort_read_inst_a_MPORT_3_en_pipe_0;
  assign memory_io_instReadPort_read_inst_a_MPORT_3_addr = memory_io_instReadPort_read_inst_a_MPORT_3_addr_pipe_0;
  assign memory_io_instReadPort_read_inst_a_MPORT_3_data = memory[memory_io_instReadPort_read_inst_a_MPORT_3_addr]; // @[Memory.scala 15:27]
  assign memory_io_dataReadPort_read_data_b_MPORT_en = memory_io_dataReadPort_read_data_b_MPORT_en_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_addr = memory_io_dataReadPort_read_data_b_MPORT_addr_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_data = memory[memory_io_dataReadPort_read_data_b_MPORT_addr]; // @[Memory.scala 15:27]
  assign memory_io_dataReadPort_read_data_b_MPORT_1_en = memory_io_dataReadPort_read_data_b_MPORT_1_en_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_1_addr = memory_io_dataReadPort_read_data_b_MPORT_1_addr_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_1_data = memory[memory_io_dataReadPort_read_data_b_MPORT_1_addr]; // @[Memory.scala 15:27]
  assign memory_io_dataReadPort_read_data_b_MPORT_2_en = memory_io_dataReadPort_read_data_b_MPORT_2_en_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_2_addr = memory_io_dataReadPort_read_data_b_MPORT_2_addr_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_2_data = memory[memory_io_dataReadPort_read_data_b_MPORT_2_addr]; // @[Memory.scala 15:27]
  assign memory_io_dataReadPort_read_data_b_MPORT_3_en = memory_io_dataReadPort_read_data_b_MPORT_3_en_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_3_addr = memory_io_dataReadPort_read_data_b_MPORT_3_addr_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_3_data = memory[memory_io_dataReadPort_read_data_b_MPORT_3_addr]; // @[Memory.scala 15:27]
  assign memory_io_dataReadPort_read_data_b_MPORT_4_en = memory_io_dataReadPort_read_data_b_MPORT_4_en_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_4_addr = memory_io_dataReadPort_read_data_b_MPORT_4_addr_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_4_data = memory[memory_io_dataReadPort_read_data_b_MPORT_4_addr]; // @[Memory.scala 15:27]
  assign memory_io_dataReadPort_read_data_b_MPORT_5_en = memory_io_dataReadPort_read_data_b_MPORT_5_en_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_5_addr = memory_io_dataReadPort_read_data_b_MPORT_5_addr_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_5_data = memory[memory_io_dataReadPort_read_data_b_MPORT_5_addr]; // @[Memory.scala 15:27]
  assign memory_io_dataReadPort_read_data_b_MPORT_6_en = memory_io_dataReadPort_read_data_b_MPORT_6_en_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_6_addr = memory_io_dataReadPort_read_data_b_MPORT_6_addr_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_6_data = memory[memory_io_dataReadPort_read_data_b_MPORT_6_addr]; // @[Memory.scala 15:27]
  assign memory_io_dataReadPort_read_data_b_MPORT_7_en = memory_io_dataReadPort_read_data_b_MPORT_7_en_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_7_addr = memory_io_dataReadPort_read_data_b_MPORT_7_addr_pipe_0;
  assign memory_io_dataReadPort_read_data_b_MPORT_7_data = memory[memory_io_dataReadPort_read_data_b_MPORT_7_addr]; // @[Memory.scala 15:27]
  assign memory_MPORT_data = io_writePort_write_data[7:0];
  assign memory_MPORT_addr = io_writePort_write_addr[11:0];
  assign memory_MPORT_mask = 1'h1;
  assign memory_MPORT_en = io_writePort_write_enable & _T;
  assign memory_MPORT_1_data = io_writePort_write_data[7:0];
  assign memory_MPORT_1_addr = io_writePort_write_addr[11:0];
  assign memory_MPORT_1_mask = 1'h1;
  assign memory_MPORT_1_en = io_writePort_write_enable & _GEN_118;
  assign memory_MPORT_2_data = io_writePort_write_data[15:8];
  assign memory_MPORT_2_addr = _T_7[11:0];
  assign memory_MPORT_2_mask = 1'h1;
  assign memory_MPORT_2_en = io_writePort_write_enable & _GEN_118;
  assign memory_MPORT_3_data = io_writePort_write_data[7:0];
  assign memory_MPORT_3_addr = io_writePort_write_addr[11:0];
  assign memory_MPORT_3_mask = 1'h1;
  assign memory_MPORT_3_en = io_writePort_write_enable & _GEN_125;
  assign memory_MPORT_4_data = io_writePort_write_data[15:8];
  assign memory_MPORT_4_addr = _T_7[11:0];
  assign memory_MPORT_4_mask = 1'h1;
  assign memory_MPORT_4_en = io_writePort_write_enable & _GEN_125;
  assign memory_MPORT_5_data = io_writePort_write_data[23:16];
  assign memory_MPORT_5_addr = _T_18[11:0];
  assign memory_MPORT_5_mask = 1'h1;
  assign memory_MPORT_5_en = io_writePort_write_enable & _GEN_125;
  assign memory_MPORT_6_data = io_writePort_write_data[31:24];
  assign memory_MPORT_6_addr = _T_22[11:0];
  assign memory_MPORT_6_mask = 1'h1;
  assign memory_MPORT_6_en = io_writePort_write_enable & _GEN_125;
  assign memory_MPORT_7_data = io_writePort_write_data[7:0];
  assign memory_MPORT_7_addr = io_writePort_write_addr[11:0];
  assign memory_MPORT_7_mask = 1'h1;
  assign memory_MPORT_7_en = io_writePort_write_enable & _GEN_136;
  assign memory_MPORT_8_data = io_writePort_write_data[15:8];
  assign memory_MPORT_8_addr = _T_7[11:0];
  assign memory_MPORT_8_mask = 1'h1;
  assign memory_MPORT_8_en = io_writePort_write_enable & _GEN_136;
  assign memory_MPORT_9_data = io_writePort_write_data[23:16];
  assign memory_MPORT_9_addr = _T_18[11:0];
  assign memory_MPORT_9_mask = 1'h1;
  assign memory_MPORT_9_en = io_writePort_write_enable & _GEN_136;
  assign memory_MPORT_10_data = io_writePort_write_data[31:24];
  assign memory_MPORT_10_addr = _T_22[11:0];
  assign memory_MPORT_10_mask = 1'h1;
  assign memory_MPORT_10_en = io_writePort_write_enable & _GEN_136;
  assign memory_MPORT_11_data = io_writePort_write_data[39:32];
  assign memory_MPORT_11_addr = _T_41[11:0];
  assign memory_MPORT_11_mask = 1'h1;
  assign memory_MPORT_11_en = io_writePort_write_enable & _GEN_136;
  assign memory_MPORT_12_data = io_writePort_write_data[47:40];
  assign memory_MPORT_12_addr = _T_45[11:0];
  assign memory_MPORT_12_mask = 1'h1;
  assign memory_MPORT_12_en = io_writePort_write_enable & _GEN_136;
  assign memory_MPORT_13_data = io_writePort_write_data[55:48];
  assign memory_MPORT_13_addr = _T_49[11:0];
  assign memory_MPORT_13_mask = 1'h1;
  assign memory_MPORT_13_en = io_writePort_write_enable & _GEN_136;
  assign memory_MPORT_14_data = io_writePort_write_data[63:56];
  assign memory_MPORT_14_addr = _T_53[11:0];
  assign memory_MPORT_14_mask = 1'h1;
  assign memory_MPORT_14_en = io_writePort_write_enable & _GEN_136;
  assign io_instReadPort_read_inst_a = {io_instReadPort_read_inst_a_hi,io_instReadPort_read_inst_a_lo}; // @[Cat.scala 31:58]
  assign io_dataReadPort_read_data_b = {io_dataReadPort_read_data_b_hi,io_dataReadPort_read_data_b_lo}; // @[Cat.scala 31:58]
  always @(posedge clock) begin
    if (memory_MPORT_en & memory_MPORT_mask) begin
      memory[memory_MPORT_addr] <= memory_MPORT_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_1_en & memory_MPORT_1_mask) begin
      memory[memory_MPORT_1_addr] <= memory_MPORT_1_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_2_en & memory_MPORT_2_mask) begin
      memory[memory_MPORT_2_addr] <= memory_MPORT_2_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_3_en & memory_MPORT_3_mask) begin
      memory[memory_MPORT_3_addr] <= memory_MPORT_3_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_4_en & memory_MPORT_4_mask) begin
      memory[memory_MPORT_4_addr] <= memory_MPORT_4_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_5_en & memory_MPORT_5_mask) begin
      memory[memory_MPORT_5_addr] <= memory_MPORT_5_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_6_en & memory_MPORT_6_mask) begin
      memory[memory_MPORT_6_addr] <= memory_MPORT_6_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_7_en & memory_MPORT_7_mask) begin
      memory[memory_MPORT_7_addr] <= memory_MPORT_7_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_8_en & memory_MPORT_8_mask) begin
      memory[memory_MPORT_8_addr] <= memory_MPORT_8_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_9_en & memory_MPORT_9_mask) begin
      memory[memory_MPORT_9_addr] <= memory_MPORT_9_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_10_en & memory_MPORT_10_mask) begin
      memory[memory_MPORT_10_addr] <= memory_MPORT_10_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_11_en & memory_MPORT_11_mask) begin
      memory[memory_MPORT_11_addr] <= memory_MPORT_11_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_12_en & memory_MPORT_12_mask) begin
      memory[memory_MPORT_12_addr] <= memory_MPORT_12_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_13_en & memory_MPORT_13_mask) begin
      memory[memory_MPORT_13_addr] <= memory_MPORT_13_data; // @[Memory.scala 15:27]
    end
    if (memory_MPORT_14_en & memory_MPORT_14_mask) begin
      memory[memory_MPORT_14_addr] <= memory_MPORT_14_data; // @[Memory.scala 15:27]
    end
    memory_io_instReadPort_read_inst_a_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_instReadPort_read_inst_a_MPORT_addr_pipe_0 <= _io_instReadPort_read_inst_a_T_1[11:0];
    end
    memory_io_instReadPort_read_inst_a_MPORT_1_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_instReadPort_read_inst_a_MPORT_1_addr_pipe_0 <= _io_instReadPort_read_inst_a_T_5[11:0];
    end
    memory_io_instReadPort_read_inst_a_MPORT_2_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_instReadPort_read_inst_a_MPORT_2_addr_pipe_0 <= _io_instReadPort_read_inst_a_T_9[11:0];
    end
    memory_io_instReadPort_read_inst_a_MPORT_3_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_instReadPort_read_inst_a_MPORT_3_addr_pipe_0 <= io_instReadPort_read_addr_a[11:0];
    end
    memory_io_dataReadPort_read_data_b_MPORT_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_dataReadPort_read_data_b_MPORT_addr_pipe_0 <= _io_dataReadPort_read_data_b_T_1[11:0];
    end
    memory_io_dataReadPort_read_data_b_MPORT_1_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_dataReadPort_read_data_b_MPORT_1_addr_pipe_0 <= _io_dataReadPort_read_data_b_T_5[11:0];
    end
    memory_io_dataReadPort_read_data_b_MPORT_2_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_dataReadPort_read_data_b_MPORT_2_addr_pipe_0 <= _io_dataReadPort_read_data_b_T_9[11:0];
    end
    memory_io_dataReadPort_read_data_b_MPORT_3_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_dataReadPort_read_data_b_MPORT_3_addr_pipe_0 <= _io_dataReadPort_read_data_b_T_13[11:0];
    end
    memory_io_dataReadPort_read_data_b_MPORT_4_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_dataReadPort_read_data_b_MPORT_4_addr_pipe_0 <= _io_instReadPort_read_inst_a_T_1[11:0];
    end
    memory_io_dataReadPort_read_data_b_MPORT_5_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_dataReadPort_read_data_b_MPORT_5_addr_pipe_0 <= _io_instReadPort_read_inst_a_T_5[11:0];
    end
    memory_io_dataReadPort_read_data_b_MPORT_6_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_dataReadPort_read_data_b_MPORT_6_addr_pipe_0 <= _io_instReadPort_read_inst_a_T_9[11:0];
    end
    memory_io_dataReadPort_read_data_b_MPORT_7_en_pipe_0 <= 1'h1;
    if (1'h1) begin
      memory_io_dataReadPort_read_data_b_MPORT_7_addr_pipe_0 <= io_instReadPort_read_addr_a[11:0];
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
  integer initvar;
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  memory_io_instReadPort_read_inst_a_MPORT_en_pipe_0 = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  memory_io_instReadPort_read_inst_a_MPORT_addr_pipe_0 = _RAND_1[11:0];
  _RAND_2 = {1{`RANDOM}};
  memory_io_instReadPort_read_inst_a_MPORT_1_en_pipe_0 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  memory_io_instReadPort_read_inst_a_MPORT_1_addr_pipe_0 = _RAND_3[11:0];
  _RAND_4 = {1{`RANDOM}};
  memory_io_instReadPort_read_inst_a_MPORT_2_en_pipe_0 = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  memory_io_instReadPort_read_inst_a_MPORT_2_addr_pipe_0 = _RAND_5[11:0];
  _RAND_6 = {1{`RANDOM}};
  memory_io_instReadPort_read_inst_a_MPORT_3_en_pipe_0 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  memory_io_instReadPort_read_inst_a_MPORT_3_addr_pipe_0 = _RAND_7[11:0];
  _RAND_8 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_en_pipe_0 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_addr_pipe_0 = _RAND_9[11:0];
  _RAND_10 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_1_en_pipe_0 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_1_addr_pipe_0 = _RAND_11[11:0];
  _RAND_12 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_2_en_pipe_0 = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_2_addr_pipe_0 = _RAND_13[11:0];
  _RAND_14 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_3_en_pipe_0 = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_3_addr_pipe_0 = _RAND_15[11:0];
  _RAND_16 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_4_en_pipe_0 = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_4_addr_pipe_0 = _RAND_17[11:0];
  _RAND_18 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_5_en_pipe_0 = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_5_addr_pipe_0 = _RAND_19[11:0];
  _RAND_20 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_6_en_pipe_0 = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_6_addr_pipe_0 = _RAND_21[11:0];
  _RAND_22 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_7_en_pipe_0 = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  memory_io_dataReadPort_read_data_b_MPORT_7_addr_pipe_0 = _RAND_23[11:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
  $readmemh("memoryFile.hex", memory);
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Top(
  input         clock,
  input         reset,
  output [63:0] io_probe
);
  wire  core_clock; // @[Top.scala 11:20]
  wire  core_reset; // @[Top.scala 11:20]
  wire [63:0] core_io_instfetch_fetchMem_read_addr_a; // @[Top.scala 11:20]
  wire [31:0] core_io_instfetch_fetchMem_read_inst_a; // @[Top.scala 11:20]
  wire [63:0] core_io_memoryAccess_dataReadPort_read_data_b; // @[Top.scala 11:20]
  wire [63:0] core_io_memoryAccess_dataWritePort_write_addr; // @[Top.scala 11:20]
  wire [63:0] core_io_memoryAccess_dataWritePort_write_data; // @[Top.scala 11:20]
  wire [3:0] core_io_memoryAccess_dataWritePort_write_lenth; // @[Top.scala 11:20]
  wire  core_io_memoryAccess_dataWritePort_write_enable; // @[Top.scala 11:20]
  wire [63:0] core_io_probe; // @[Top.scala 11:20]
  wire  memory_clock; // @[Top.scala 12:22]
  wire [63:0] memory_io_instReadPort_read_addr_a; // @[Top.scala 12:22]
  wire [31:0] memory_io_instReadPort_read_inst_a; // @[Top.scala 12:22]
  wire [63:0] memory_io_dataReadPort_read_data_b; // @[Top.scala 12:22]
  wire [63:0] memory_io_writePort_write_addr; // @[Top.scala 12:22]
  wire [63:0] memory_io_writePort_write_data; // @[Top.scala 12:22]
  wire [3:0] memory_io_writePort_write_lenth; // @[Top.scala 12:22]
  wire  memory_io_writePort_write_enable; // @[Top.scala 12:22]
  Core core ( // @[Top.scala 11:20]
    .clock(core_clock),
    .reset(core_reset),
    .io_instfetch_fetchMem_read_addr_a(core_io_instfetch_fetchMem_read_addr_a),
    .io_instfetch_fetchMem_read_inst_a(core_io_instfetch_fetchMem_read_inst_a),
    .io_memoryAccess_dataReadPort_read_data_b(core_io_memoryAccess_dataReadPort_read_data_b),
    .io_memoryAccess_dataWritePort_write_addr(core_io_memoryAccess_dataWritePort_write_addr),
    .io_memoryAccess_dataWritePort_write_data(core_io_memoryAccess_dataWritePort_write_data),
    .io_memoryAccess_dataWritePort_write_lenth(core_io_memoryAccess_dataWritePort_write_lenth),
    .io_memoryAccess_dataWritePort_write_enable(core_io_memoryAccess_dataWritePort_write_enable),
    .io_probe(core_io_probe)
  );
  Memory memory ( // @[Top.scala 12:22]
    .clock(memory_clock),
    .io_instReadPort_read_addr_a(memory_io_instReadPort_read_addr_a),
    .io_instReadPort_read_inst_a(memory_io_instReadPort_read_inst_a),
    .io_dataReadPort_read_data_b(memory_io_dataReadPort_read_data_b),
    .io_writePort_write_addr(memory_io_writePort_write_addr),
    .io_writePort_write_data(memory_io_writePort_write_data),
    .io_writePort_write_lenth(memory_io_writePort_write_lenth),
    .io_writePort_write_enable(memory_io_writePort_write_enable)
  );
  assign io_probe = core_io_probe; // @[Top.scala 18:12]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_instfetch_fetchMem_read_inst_a = memory_io_instReadPort_read_inst_a; // @[Top.scala 14:30]
  assign core_io_memoryAccess_dataReadPort_read_data_b = memory_io_dataReadPort_read_data_b; // @[Top.scala 15:37]
  assign memory_clock = clock;
  assign memory_io_instReadPort_read_addr_a = core_io_instfetch_fetchMem_read_addr_a; // @[Top.scala 14:30]
  assign memory_io_writePort_write_addr = core_io_memoryAccess_dataWritePort_write_addr; // @[Top.scala 16:38]
  assign memory_io_writePort_write_data = core_io_memoryAccess_dataWritePort_write_data; // @[Top.scala 16:38]
  assign memory_io_writePort_write_lenth = core_io_memoryAccess_dataWritePort_write_lenth; // @[Top.scala 16:38]
  assign memory_io_writePort_write_enable = core_io_memoryAccess_dataWritePort_write_enable; // @[Top.scala 16:38]
endmodule
