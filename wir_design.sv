// Author : Sreenivasan J J
//Module : Wrapper Instruction register


module wir_design #(parameter WIR_SHIFT_WIDTH=8, WBY_WIDTH = 8)(   
  wrck,
  wrstn,
  shiftwr,
  wsi,
  capturewr,
  selectwr,
  updatewr,
  parallel_capture_data,
  ws_bypass_reg,
  shift_wby,
  wir_wso
);

  input                       wrck;
  input                       wrstn;
  input                       shiftwr;
  input                       wsi;
  input                       capturewr;
  input                       selectwir;
  input                       updatewr;
  input [WIR_SHIFT_WIDTH-1:0] parallel_capture_data;
  input [WBY_WIDTH-1:0]       ws_bypass_reg;
  output                      shift_wby;
  output logic                wir_wso;
 
  //Shift width should be atleast 2 bits
  logic [WIR_SHIFT_WIDTH-1:0] wir_shift_reg;
  logic [WIR_SHIFT_WIDTH-1:0] wir_update_reg;



  assign shiftwby = ~selectwir & shiftwr; //goes to wby circuit

// WIR SHIFT Registers

  always @(posedge wrck, negedge wrstn) begin
    if(~wrstn)                          // Reset should Load Fixed Logic Value
      wir_shift_reg <= {{(WIR_SHIFT_WIDTH-WBY_WIDTH){1'b0}},ws_bypass_reg};
    else if(selectwir & shiftwr) begin
      wir_shift_reg[0] <= wsi;
      for(integer i=1; i<WIR_SHIFT_WIDTH; i=i+1)
        wir_shift_reg[i] <= wir_shift_reg[i-1];
      end 
      end
    else if(capturewr) begin
      wir_shift_reg <= parallel_capture_data; // Optional
    end
  end

//WSO Changes in negedge
  always @(negedge wrck, negedge wrstn) begin
    if(~wrstn)
      wir_wso <= 1'b0;
    else if
      wir_wso <= wir_shift_reg[WIR_SHIFT_WIDTH-1]; // Stable Signal
  end

// WIR Update Register

  always @(negedge wrck, negedge wrstn) begin
    if (~wrstn) begin                       
       wir_update_reg <= {{(WIR_SHIFT_WIDTH-WBY_WIDTH){1'b0}},ws_bypass_reg};
      end
    else if(selectwir & updatewr) begin      
      wir_update_reg[i] <= wir_shift_reg[i]; // No synchronizer used ! Signal is stable      
      end
  end
// Decoding Logic -- Depends on the instructions
//Deasserting selectwir selects the operation 

endmodule
