// Author : Sreenivasan J J
//Module : Wrapper Boundary Cells

module wbr_cells (
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


 // cell module instantiate
`ifdef WC_SD1_CII_O
   wc_sd1_cii_o 
`elsif WC_SD1_COI
   wc_sd1_coi
`elsif WC_SD2_CIO
   wc_sd2_cio
`elsif WC_SF1_CII_G
   wc_sf1_cii_g
`elsif WC_SF1_CII
   wc_sf1_cii
`endif
   u_wbr_cell(.clk(clk),
     .arst(arst),
     .cfi(cfi),
     .cfo(cfo),
     .cti(cti),
     .cto(cto),
     .shift(shift),
     .capture(capture),
     .transfer(transfer),
     .update(update),
     .io_face(io_face),
     .mode(mode),
     .safe(safe)
   );

endmodule
