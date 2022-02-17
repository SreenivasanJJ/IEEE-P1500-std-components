// Author : Sreenivasan J J
//Module : Wrapper Boundary Cell - WC_SD2_CIO

module wc_sd2_cio ( 
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

  wire [1:0] shift_ip;
  logic [1:0] shift_reg; // 2 bits


  assign shift_ip[0] = (cti & shift) | (shift_reg[1] & transfer) | (shift_reg[0] & ~(transfer | shift));

  assign shift_ip[1] = (cfi & (capture & ~io_face)) | (shift_reg[0] & (shift | (io_face & transfer))) | (shift_reg[1] & ~((capture & ~io_face) | (shift | (io_face & transfer))));


  always @(posedge wrck, posedge arst) begin
    if(arst)
      shift_reg <= 'h0;
    else 
      shift_reg <= shift_ip;
  end

  always @(*) begin
    if(!mode)
      cfo = cfi;
    else
      cfo = shift_reg[1];
  end
   
  assign cto = shift_reg[1]; 
endmodule
