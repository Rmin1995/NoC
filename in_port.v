/**************************************
* Module: in_port
* Date:2016-01-27  
* Author: armin     
*
* Description: input port
***************************************/
`include "constants.v"
`include "vc.v"
module  in_port(credit, flit_out, is_new, flit_in, credit_next_router, clock, reset);

parameter CREDIT_DELAY = 16;
parameter VC_NUM = 4;

    output [0:VC_NUM-1] credit;
    output [1:`FLIT_SIZE*VC_NUM] flit_out;
    output [0:VC_NUM-1] is_new;
    input [1:`FLIT_SIZE] flit_in;
    input [0:VC_NUM-1] credit_next_router;
    input clock;
    input reset;

wire [0:VC_NUM-1] vc_load;

wire [2:0] num[7:0];
assign num[0]=3'd0;
assign num[1]=3'd1;
assign num[2]=3'd2;
assign num[3]=3'd3;
assign num[4]=3'd4;
assign num[5]=3'd5;
assign num[6]=3'd6;
assign num[7]=3'd7;

generate
    genvar i;
    for(i=0; i<VC_NUM; i=i+1) begin : GEN_VC_LOAD
        assign vc_load[i] = |((flit_in `FLIT_VC) ^ num[i][2:0]) ? 1'b0 : 1'b1;
    end
endgenerate

generate
    for (i=0; i<VC_NUM; i=i+1)
    begin : GEN_VC
        vc #(.CREDIT_DELAY(CREDIT_DELAY)) V(
                 .flit_buff(flit_out[i*`FLIT_SIZE+1:(i+1)*`FLIT_SIZE]),
             .credit(credit[i]),
             .is_new(is_new[i]),
             .flit(flit_in),
             .next_router_credit(credit_next_router[i]),
             .load(vc_load[i]),
             .clock(clock),
             .reset(reset));
    end
endgenerate

endmodule