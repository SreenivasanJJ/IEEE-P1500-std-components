// Author : Sreenivasan J J
//Module : Wrapper Boundary Cell - WC_SF1_CII

module wc_sf1_cii ( 
  clk,
  arst,
  cfi,
  cfo,
  cti,
  cto,
  shift,
  capture,
  transfer,
  update,
  io_face,
  mode,
  safe
);

  input clk;
  input arst;
// Cell Inputs and Outputs
  input cfi;
  input cti;
  
  output cfo;
  output cto;

//Cell Control Signal

  input shift;
  input capture;
  input transfer;
  input update;
  input io_face;
  input mode;
  input safe;

  wire  shift_ip;
  logic  shift_reg; 
// Transfer and IO Face not yet added
  assign shift_ip = (cti & shift) | (cfi & capture) | (shift_reg & ~(shift | capture));
 
  always @(posedge wrck, posedge arst) begin
    if(arst)
      shift_reg <= 'h0;
    else 
      shift_reg <= shift_ip;
  end

  assign cfo = shift_reg;

  assign cto = shift_reg;     
endmodule
