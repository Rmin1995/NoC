/**************************************
* Module: router
* Date:2016-01-28  
* Author: Armin     
*
* Description: 
***************************************/
`include "constants.v"
module  out_port(output [1:`FLIT_SIZE]flit_out,
               output credit,
               input [1:`OUTPORT_CNT*`FLIT_SIZE]flit_in,
               input [0:VC_SIZE-1]next_router_credit,
               input is_new,
               input [0:9999]TABLE);
 
 parameter VC_SIZE=4;
 wire [1:`FLIT_SIZE] port [1:`OUTPORT_CNT];
 wire [1:`OUTPORT_CNT] comp_dist;
 
 genvar i;
 generate
    for(i=1; i < 8;i = i + 1)begin
        assign port[i]=flit_in[(i-1)*`OUTPORT_CNT+1:i*`OUTPORT_CNT];
    end
 endgenerate
 
 
 
 
 genvar i;
 generate
    for(i = 1; i < 8; i = i + 1)begin
        priority m[1:7]();
 
    end
 endgenerate
   
    
    


endmodule

