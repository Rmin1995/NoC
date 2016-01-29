/**************************************
* Module: in_port
* Date:2016-01-27  
* Author: armin     
*
* Description: input port
***************************************/
`include "constants.v"
`include "vc.v"
module  in_port(output [0:VC_NUM-1] credit,
                output [1:`FLIT_SIZE] flit_out,
                output is_new,
                input [1:`FLIT_SIZE] flit_in,
                input [0:VC_NUM-1] credit_next_router,
                input clock,
                input reset,
                input initialize,
                input load,
                input [3:0]port_num
);
parameter CREDIT_DELAY = 16;
parameter VC_NUM = 4;

reg [3:0] input_port_num;
wire[3:0] n_input_port_num;

always @(posedge clock or posedge reset)
begin
    if(reset == 1'b1)
        input_port_num <= 4'd0;
    else
        input_port_num <= n_input_port_num;
end

assign n_input_port_num = (reset == 1'b0 ? ((initialize == 1'b1 & load == 1'b1) ? port_num : input_port_num) : 4'd0);

wire [1:`FLIT_SIZE] vc_out [0:VC_NUM-1];
wire [0:VC_NUM-1] vc_new;
wire [0:VC_NUM-1] vc_credit_in;
wire [0:VC_NUM-1] vc_load;

wire [2:0] firstPriority;

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
                 .flit_buff(vc_out[i]),
             .credit(credit[i]),
             .is_new(vc_new[i]),
             .flit(flit_in),
             .next_router_credit(vc_credit_in[i]),
             .load(vc_load[i]),
             .clock(clock),
             .reset(reset));
    end
endgenerate

wire prior[0:VC_NUM];
wire [2:0] fPrior [0:VC_NUM];
assign prior[0]=1'b0;
assign fPrior[0] = 3'b0;

generate
    for(i=0; i < VC_NUM; i=i+1) begin : GEN_PRIOR
        priority_vc P(.isNew(prior[i+1]),
               .firstPriority(fPrior[i+1]),
               .num(num[i]),
               .prevPriority(fPrior[i]),
               .prevIsNew(prior[i]),
               .vc_isNew(vc_new[i])
        );
    end
endgenerate

assign firstPriority = fPrior[VC_NUM];

generate
    for(i=0;i<VC_NUM;i=i+1) begin : GEN_VC_CREDITS
        assign vc_credit_in [i] = ((i == firstPriority) ? credit_next_router[i] : 1'b0);
    end
endgenerate

assign flit_out = vc_out[firstPriority];

endmodule