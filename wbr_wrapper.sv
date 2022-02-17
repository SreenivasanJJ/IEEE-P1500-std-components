// Author : Sreenivasan J J
//Module : Wrapper Boundary Register Circuit

module wbr_wrapper #(parameter PARALLEL_INTF_CFG = 1,parameter NUM_IP= 6,parameter NUM_OP=6)(
  wrck,
  wfi,
  wfo,
  ti,
  to,
  ip_cfo,
  op_cfi
);
  
  input wrck;
  input [NUM_IP-1:0] wfi;
  output [NUM_IP-1:0] ip_cfo;
  input [NUM_OP-1:0] op_cfi;
  output [NUM_OP-1:0] wfo;
  input [PARALLEL_INTF_CFG:0] ti;
  output [PARALLEL_INTF_CFG:0] to;

  wire [NUM_IP-1:0] ip_cti_conn;
  wire [NUM_IP-1:0] ip_cto_conn;

  wire [NUM_OP-1:0] op_cti_conn;
  wire [NUM_OP-1:0] op_cto_conn;

  assign ip_cti_conn[NUM_IP-1] = ti[0];
  assign to[0] = op_cto_conn[NUM_OP-1];

  genvar i,j;
  
  generate for(i=0;i<NUM_IP;i=i+1) begin
     if(i!=(NUM_IP-1))
       assign ip_cti_conn[i]= ip_cto_conn[i+1];
     
     wbr_cells u_wbr_cells_ip(
       .clk(clk),
       .arst(arst),
       .cfi(wfi[i]),
       .cfo(ip_cfo[i]),
       .cti(ip_cti_conn[i]),
       .cto(ip_cto_conn[i]),
       .shift(shift),
       .capture(capture),
       .transfer(transfer),
       .update(update),
       .io_face(io_face),
       .mode(mode),
       .safe(safe)
     );
  end
  endgenerate

  generate for(j=0;j<NUM_OP;j=j+1) begin
     if(j!=0)
       assign op_cti_conn[j] = op_cto_conn[j-1];
 
     wbr_cells u_wbr_cells_ip(
       .clk(clk),
       .arst(arst),
       .cfi(op_cfi[j]),
       .cfo(wfo[j]),
       .cti(op_cti_conn[j]),
       .cto(op_cto_conn[j]),
       .shift(shift),
       .capture(capture),
       .transfer(transfer),
       .update(update),
       .io_face(io_face),
       .mode(mode),
       .safe(safe)
     );
  end
  endgenerate

  generate 
    if(PARALLEL_INTF_CFG ==1) begin
        assign to[PARALLEL_INTF_CFG] = ip_cto_conn[NUM_IP-1];
        assign op_cti_conn[0] = to[PARALLEL_INTF_CFG];
      end
    else begin 
        assign op_cti_conn[0] = ip_cto_conn[NUM_IP-1];
      end
  endgenerate

endmodule
