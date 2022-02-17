// Author : Sreenivasan J J
//Module : Wrapper Bypass Circuit

module wby_design #(WBY_WIDTH = 8) (
  wrck,
  shiftwby,
  wsi,
  wby_wso
);

  input wrck;
  input shiftwby;
  input wsi;

  output wby_wso;

  // Atleast 1 bit of shift data
  logic [WBY_WIDTH-1:0] wby_shift_reg;
 
  always @(posedge wrck) begin
    if(shiftwby)
      for(integer i=1; i<WBY_WIDTH; i=i+1)
        wir_shift_reg[i] <= wir_shift_reg[i-1];
      end       
  end

  always @(negedge wrck) begin
    wby_wso <= wir_shift_reg[WBY_WIDTH-1];
  end


endmodule
