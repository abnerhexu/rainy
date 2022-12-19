module Seg7(
  input        clock,
  input        reset,
  output [1:0] io_segChoice
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] p; // @[Seg7.scala 15:18]
  wire [1:0] _p_T_1 = p + 2'h1; // @[Seg7.scala 16:10]
  assign io_segChoice = p; // @[Seg7.scala 54:16]
  always @(posedge clock) begin
    if (reset) begin // @[Seg7.scala 15:18]
      p <= 2'h0; // @[Seg7.scala 15:18]
    end else begin
      p <= _p_T_1; // @[Seg7.scala 16:5]
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
  p = _RAND_0[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Top(
  input         clock,
  input         reset,
  input  [7:0]  io_a,
  output [15:0] io_segOut,
  output [1:0]  io_segChoice
);
  wire  seg7_clock; // @[Top.scala 17:20]
  wire  seg7_reset; // @[Top.scala 17:20]
  wire [1:0] seg7_io_segChoice; // @[Top.scala 17:20]
  Seg7 seg7 ( // @[Top.scala 17:20]
    .clock(seg7_clock),
    .reset(seg7_reset),
    .io_segChoice(seg7_io_segChoice)
  );
  assign io_segOut = 16'h0; // @[Top.scala 24:13]
  assign io_segChoice = seg7_io_segChoice; // @[Top.scala 25:16]
  assign seg7_clock = clock;
  assign seg7_reset = reset;
endmodule
