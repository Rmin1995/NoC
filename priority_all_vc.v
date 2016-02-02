/**************************************
* Module: priority_all_vc
* Date:2016-02-01  
* Author: armin     
*
* Description: 
***************************************/
`include "priority_vc_inputs.v"
module  priority_all_vc(outputs_out, occupieds_out, credit_for_inputs, nxt_routers_credits, flit_in, occupieds_in, is_new_flit, TABLE);
  parameter VC_NUM = 4;
        output [1:`FLIT_SIZE * `IN_OUTPORT_CNT] outputs_out;
        output [0:`OCCUPIEDS_SIZE*`IN_OUTPORT_CNT-1] occupieds_out;
        output [0:`IN_OUTPORT_CNT * VC_NUM -1] credit_for_inputs;   // important : [0 : `IN_OUTPORT_CNT-1] for vc 0, [`IN_OUTPORT_CNT : 2*`IN_OUTPORT_CNT-1] for vc 1, ...
        input [0:`IN_OUTPORT_CNT * VC_NUM -1] nxt_routers_credits;  // important : [0 : `IN_OUTPORT_CNT-1] for vc 0, [`IN_OUTPORT_CNT : 2*`IN_OUTPORT_CNT-1] for vc 1, ...
        input [1:`FLIT_SIZE * `IN_OUTPORT_CNT] flit_in;
        input [0:`OCCUPIEDS_SIZE*`IN_OUTPORT_CNT-1] occupieds_in;
        input [0:VC_NUM*`IN_OUTPORT_CNT-1] is_new_flit;
        input [0:`TABLE_SIZE-1] TABLE;


genvar util_genvar;
`MAKE_ARRAY(credit_for_inputs_array, credit_for_inputs, VC_NUM, `IN_OUTPORT_CNT, GEN_CREDIT_FOR_INPUTS)

`MAKE_ARRAY(nxt_routers_credits_array, nxt_routers_credits, VC_NUM, `IN_OUTPORT_CNT, GEN_NXT_ROUTERS_CREDITS)

`MAKE_ARRAY(is_new_flit_array, is_new_flit, VC_NUM, `IN_OUTPORT_CNT, GEN_IS_NEW_FLIT)

wire [0:`IN_OUTPORT_CNT-1] selected_inputs_chain [0:VC_NUM];
assign selected_inputs_chain[0] = {`IN_OUTPORT_CNT{1'b0}};

wire [0:`IN_OUTPORT_CNT-1] selected_outputs_chain [0:VC_NUM];
assign selected_outputs_chain[0] = {`IN_OUTPORT_CNT{1'b0}};

wire [1:`FLIT_SIZE * `IN_OUTPORT_CNT] outputs_chain[0:VC_NUM];
assign outputs_chain[0] = {`FLIT_SIZE*`IN_OUTPORT_CNT{1'b0}};
assign outputs_out = outputs_chain[VC_NUM];

wire [0:`OCCUPIEDS_SIZE*`IN_OUTPORT_CNT-1] occupieds_chain [0:VC_NUM];
assign occupieds_chain[0] = occupieds_in;
assign occupieds_out = occupieds_chain[VC_NUM];


genvar i;
generate
    for(i=0;i<VC_NUM;i=i+1)
    begin : GEN_PRIORITY_ALL_VC
        priority_vc_inputs #(.VC_NUM(VC_NUM)) p(
                .selected_inputs_out(selected_inputs_chain[i+1]),
                .selected_outputs_out(selected_outputs_chain[i+1]),
                .outputs_out(outputs_chain[i+1]),
                .credit_for_inputs(credit_for_inputs_array[i]),
                .occupieds_out(occupieds_chain[i+1]),
                .is_new_flit(is_new_flit_array[i]),
                .selected_inputs_in(selected_inputs_chain[i]),
                .selected_outputs_in(selected_outputs_chain[i]),
                .nxt_routers_credit(nxt_routers_credits_array[i]),
                .flit_in(flit_in),
                .outputs_in(outputs_chain[i]),
                .occupieds_in(occupieds_chain[i]),
                .TABLE(TABLE)
        );
    end
endgenerate

endmodule
