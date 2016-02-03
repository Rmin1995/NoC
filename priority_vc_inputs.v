/**************************************
* Module: priority_vc_inputs
* Date:2016-02-01  
* Author: armin     
*
* Description: 
***************************************/
`include "priority_vc_perInput.v"
// for one vc, and every input
module  priority_vc_inputs(
                        output [0:`IN_OUTPORT_CNT-1] selected_inputs_out,
                        output [0:`IN_OUTPORT_CNT-1] selected_outputs_out,
                        output [1:`FLIT_SIZE * `IN_OUTPORT_CNT] outputs_out,
                        output [0:`IN_OUTPORT_CNT-1] credit_for_inputs,
                        output [0:`OCCUPIEDS_SIZE*`IN_OUTPORT_CNT-1] occupieds_out,
                        input [0:`IN_OUTPORT_CNT-1] is_new_flit,
                        input [0:`IN_OUTPORT_CNT-1] selected_inputs_in,
                        input [0:`IN_OUTPORT_CNT-1] selected_outputs_in,
                        input [0:`IN_OUTPORT_CNT - 1] nxt_routers_credit,
                        input [1:`FLIT_SIZE * `IN_OUTPORT_CNT] flit_in,
                        input [0:`FLIT_SIZE * `IN_OUTPORT_CNT - 1] outputs_in,
                        input [0:`OCCUPIEDS_SIZE*`IN_OUTPORT_CNT-1] occupieds_in,
                        input [0:`TABLE_SIZE-1]TABLE
);
parameter VC_NUM = 4;

genvar util_genvar;
`MAKE_ARRAY_1BASED(flit_in_array, flit_in, `IN_OUTPORT_CNT, `FLIT_SIZE, GEN_FLIT_IN)

wire [0:`IN_OUTPORT_CNT-1] selected_inputs_out_chain [0:`IN_OUTPORT_CNT];
assign selected_inputs_out_chain[0] = selected_inputs_in;
assign selected_inputs_out = selected_inputs_out_chain[`IN_OUTPORT_CNT];

wire [0:`IN_OUTPORT_CNT-1] selected_outputs_out_chain [0:`IN_OUTPORT_CNT];
assign selected_outputs_out_chain[0] = selected_outputs_in;
assign selected_outputs_out = selected_outputs_out_chain[`IN_OUTPORT_CNT];

wire [1:`FLIT_SIZE * `IN_OUTPORT_CNT] outputs_out_chain [0:`IN_OUTPORT_CNT];
assign outputs_out_chain[0] = outputs_in;
assign outputs_out = outputs_out_chain[`IN_OUTPORT_CNT];

wire [0:`OCCUPIEDS_SIZE*`IN_OUTPORT_CNT-1] occupieds_chain [0:`IN_OUTPORT_CNT];
assign occupieds_chain[0] = occupieds_in;
assign occupieds_out = occupieds_chain[`IN_OUTPORT_CNT];


wire [0:3] nums[0:`IN_OUTPORT_CNT-1];
assign nums[0]=4'd0;
assign nums[1]=4'd1;
assign nums[2]=4'd2;
assign nums[3]=4'd3;
assign nums[4]=4'd4;
assign nums[5]=4'd5;
assign nums[6]=4'd6;

generate
    genvar i;
    for(i=0;i<`IN_OUTPORT_CNT;i=i+1)
    begin : GEN_PRIORITY_VC_INPUTS
        priority_vc_perInput #(.VC_NUM(VC_NUM)) p(
            .selected_inputs_out(selected_inputs_out_chain [i+1]),
            .selected_outputs_out(selected_outputs_out_chain [i+1]),
            .outputs_out(outputs_out_chain[i+1]),
            .credit_for_input(credit_for_inputs[i]),
            .occupieds_out(occupieds_chain[i+1]),
            .is_new_flit(is_new_flit[i]),
            .port_num(nums[i]),
            .selected_inputs_in(selected_inputs_out_chain[i]),
            .selected_outputs_in(selected_outputs_out_chain[i]),
            .nxt_routers_credit(nxt_routers_credit),
            .flit_in(flit_in_array[i]),
            .outputs_in(outputs_out_chain[i]),
            .occupieds_in(occupieds_chain[i]),
            .TABLE(TABLE)
        );
    end
endgenerate

endmodule

