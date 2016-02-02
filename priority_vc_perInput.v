/**************************************
* Module: priority_vc_perInput
* Date:2016-01-31  
* Author: armin     
*
* Description: 
***************************************/
`include "util.v"
`include "constants.v"
`include "mux1024to1.v"
// for one vc, and one input
module  priority_vc_perInput(
        output [0:`IN_OUTPORT_CNT-1] selected_inputs_out,
        output [0:`IN_OUTPORT_CNT-1] selected_outputs_out,
        output [1:`FLIT_SIZE * `IN_OUTPORT_CNT] outputs_out,
        output credit_for_input,
        output [0:`OCCUPIEDS_SIZE*`IN_OUTPORT_CNT-1] occupieds_out,
        input is_new_flit,
        input [0:`LOG_PORTS_CNT-1] port_num,
        input [0:`IN_OUTPORT_CNT-1] selected_inputs_in,
        input [0:`IN_OUTPORT_CNT-1] selected_outputs_in,
        input [0:`IN_OUTPORT_CNT-1] nxt_routers_credit,
        input [1:`FLIT_SIZE] flit_in,
        input [1:`FLIT_SIZE * `IN_OUTPORT_CNT] outputs_in,
        input [0:`OCCUPIEDS_SIZE*`IN_OUTPORT_CNT-1] occupieds_in,
        input [0:`TABLE_SIZE-1]TABLE
);

parameter VC_NUM = 4;

genvar util_genvar;
`MAKE_ARRAY(occupieds_in_array, occupieds_in, `IN_OUTPORT_CNT, `OCCUPIEDS_SIZE, GEN_OCCUPIEDS_IN)
`MAKE_ARRAY(occupieds_out_array, occupieds_out, `IN_OUTPORT_CNT, `OCCUPIEDS_SIZE, GEN_OCCUPIEDS_OUT)

wire [0:`LOG_PORTS_CNT-1] dst_port_num;
mux1024to1 m(.OUT(dst_port_num),
             .select(flit_in `FLIT_DST),
             .TABLE(TABLE)
);

genvar i;
generate
    for(i=0;i<`IN_OUTPORT_CNT;i=i+1)
    begin : GEN_PRIORITY_VC_PERINPUT
        assign selected_inputs_out[i] = (i == port_num && is_new_flit ? ((selected_inputs_in[i]==1'b0 && selected_outputs_in[dst_port_num]==1'b0 &&
                                                nxt_routers_credit[dst_port_num]==1'b1 &&
                                                (occupieds_in_array[dst_port_num] `OCCUPIED_IS_FULL==1'b0 || 
                                                (occupieds_in_array[dst_port_num] `OCCUPIED_IS_FULL==1'b1 && occupieds_in_array[dst_port_num] `OCCUPIED_PORT_NO == i)) ) ? 1'b1
                                         : selected_inputs_in[i])
                                         : selected_inputs_in[i]);
        assign outputs_out[i*`FLIT_SIZE+1 : (i+1)*`FLIT_SIZE] = (i == port_num && is_new_flit ? ((selected_inputs_in[i]==1'b0 && selected_outputs_in[dst_port_num]==1'b0 &&
                                                nxt_routers_credit[dst_port_num]==1'b1 &&
                                                (occupieds_in_array[dst_port_num] `OCCUPIED_IS_FULL==1'b0 || 
                                                (occupieds_in_array[dst_port_num] `OCCUPIED_IS_FULL && occupieds_in_array[dst_port_num] `OCCUPIED_PORT_NO == i)) ) ? flit_in
                                         : outputs_in[i*`FLIT_SIZE+1 : (i+1)*`FLIT_SIZE])
                                         : outputs_in[i*`FLIT_SIZE+1 : (i+1)*`FLIT_SIZE]);
        assign selected_outputs_out[i] = (i == dst_port_num && is_new_flit ? ((selected_inputs_in[port_num]==1'b0 && selected_outputs_in[dst_port_num]==1'b0 &&
                                            nxt_routers_credit[dst_port_num]==1'b1 && 
                                            (occupieds_in_array[dst_port_num] `OCCUPIED_IS_FULL==1'b0 ||
                                            (occupieds_in_array[dst_port_num] `OCCUPIED_IS_FULL==1'b1 && occupieds_in_array[dst_port_num] `OCCUPIED_PORT_NO == port_num)) ) ? 1'b1
                                            :selected_outputs_in[i])
                                            :selected_outputs_in[i]);
        assign occupieds_out_array[i] = (i == dst_port_num && is_new_flit ? ((selected_inputs_in[port_num]==1'b0 && selected_outputs_in[dst_port_num]==1'b0 &&
                                            nxt_routers_credit[dst_port_num]==1'b1 && 
                                            (occupieds_in_array[dst_port_num] `OCCUPIED_IS_FULL==1'b0 ||
                                            (occupieds_in_array[dst_port_num] `OCCUPIED_IS_FULL==1'b1 && occupieds_in_array[dst_port_num] `OCCUPIED_PORT_NO == port_num)) ) ? (flit_in `FLIT_TAIL ? {`OCCUPIEDS_SIZE{1'b0}} : {1'b1,port_num[0:`LOG_PORTS_CNT-1]})
                                            :occupieds_in_array[i])
                                            :occupieds_in_array[i]);
                                            
    end
    assign credit_for_input = ((selected_inputs_in[port_num]==1'b0 && selected_outputs_in[dst_port_num]==1'b0 &&
                               nxt_routers_credit[dst_port_num]==1'b1 &&
                               (occupieds_in_array[dst_port_num] `OCCUPIED_IS_FULL==1'b0 || 
                               (occupieds_in_array[dst_port_num] `OCCUPIED_IS_FULL && occupieds_in_array[dst_port_num] `OCCUPIED_PORT_NO == port_num)) ) ? 1'b1 : 1'b0);
endgenerate

endmodule


