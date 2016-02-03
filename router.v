/**************************************
* Module: router
* Date:2016-01-29  
* Author: saber     
*
* Description: 
***************************************/
`include "constants.v"
`include "util.v"
module  router(flit_out, credit, flit_in, data, next_router_credit, load, write,
                init, clock, reset);
parameter CREDIT_DELAY = 16;
parameter VC_NUM = 4;
                output [1:`IN_OUTPORT_CNT*`FLIT_SIZE] flit_out;
                output [0:VC_NUM*`IN_OUTPORT_CNT-1] credit;
                input [1:`IN_OUTPORT_CNT*`FLIT_SIZE] flit_in;
                input [1:`IN_OUTPORT_CNT_BIN] data;
                input [0:VC_NUM*`IN_OUTPORT_CNT-1] next_router_credit;
                input [1:`ROUTERS_CNT_BIN] load;
                input write;
                input init;
                input clock;
                input reset;

/************************
INITIAL phase:initial values for router's table
************************/
reg [0:`IN_OUTPORT_CNT_BIN-1] TABLE_ARRAY [0:`TABLE_ROWS-1];
wire[0:`IN_OUTPORT_CNT_BIN-1] NEXT_TABLE_ARRAY [0:`TABLE_ROWS-1];

reg [0:`OCCUPIEDS_SIZE*`IN_OUTPORT_CNT*VC_NUM-1] occupieds;
wire [0:`OCCUPIEDS_SIZE*`IN_OUTPORT_CNT*VC_NUM-1] nxt_occupieds;

genvar tmp;
generate
    for(tmp=0; tmp<`TABLE_ROWS; tmp=tmp+1)
    begin
		always @(posedge clock or posedge reset)
		begin
        if ( reset ) 
            TABLE_ARRAY[tmp] <= {`IN_OUTPORT_CNT_BIN{1'b0}};
        else
            TABLE_ARRAY[tmp] <= NEXT_TABLE_ARRAY[tmp];
		end
    end
endgenerate

always @(posedge clock or posedge reset)
begin
    if(reset)
      occupieds <= {`OCCUPIEDS_SIZE*`IN_OUTPORT_CNT*VC_NUM{1'b0}};
    else
      occupieds <= nxt_occupieds;
end

genvar i;
generate
    for(i = 0; i <`TABLE_ROWS; i = i + 1)begin : GEN_NEXT_TABLE_ARRAY
        assign NEXT_TABLE_ARRAY[i] = ((init == 1'b0) ? TABLE_ARRAY[i] : (write == 1'b1 && load == i) ? data : TABLE_ARRAY[i]);
    end
endgenerate

genvar util_genvar;

`MAKE_ARRAY(credit_array, credit, `IN_OUTPORT_CNT, VC_NUM, GEN_CREDIT)

`MAKE_VECTOR(TABLE_VECTOR, TABLE_ARRAY, `TABLE_ROWS, `IN_OUTPORT_CNT_BIN, GEN_TABLE_VECTOR)

`MAKE_ARRAY_1BASED(flit_in_array, flit_in, `IN_OUTPORT_CNT, `FLIT_SIZE, GEN_FLIT_IN1)

wire [1:`FLIT_SIZE*VC_NUM] flit_out_each_in_port [0:`IN_OUTPORT_CNT-1];

wire [0:VC_NUM-1] isnew_each_in_port [0:`IN_OUTPORT_CNT-1];
`MAKE_VECTOR(isnew_vector, isnew_each_in_port, `IN_OUTPORT_CNT, VC_NUM, GEN_ISNEW_VECTOR)

wire [0:`IN_OUTPORT_CNT * VC_NUM -1] credit_for_inputs;
wire [0:`IN_OUTPORT_CNT * VC_NUM -1] nxt_routers_credits;
wire [0:VC_NUM-1] credit_next_router [0:`IN_OUTPORT_CNT];

generate
    for(i = 0; i < `IN_OUTPORT_CNT; i = i + 1)begin:GEN_IN_PORT
        in_port #(.CREDIT_DELAY(CREDIT_DELAY),.VC_NUM(VC_NUM)) m(
            .credit(credit_array[i]),
                    .flit_out(flit_out_each_in_port[i]),
                    .is_new(isnew_each_in_port[i]),
                    .flit_in(flit_in_array[i]),
                    .credit_next_router(credit_next_router[i]),
                    .clock(clock),
                    .reset(reset)
        );

    end
endgenerate

genvar j;
generate
    for(i=0;i<VC_NUM;i=i+1) begin : GEN_VC_CREDIT
      for(j=0;j<`IN_OUTPORT_CNT;j=j+1) begin : GEN_IN_OUTPORT_CREDIT
        assign credit_next_router[j][i] = credit_for_inputs[i*`IN_OUTPORT_CNT + j];
        assign nxt_routers_credits[i*`IN_OUTPORT_CNT + j] = next_router_credit[j*VC_NUM + i];
      end
    end
endgenerate

priority_all_vc P(.outputs_out(flit_out),
               .occupieds_out(nxt_occupieds),
               .credit_for_inputs(credit_for_inputs),
               .nxt_routers_credits(nxt_routers_credits),
               .flit_in(flit_in),
               .occupieds_in(occupieds),
               .is_new_flit(isnew_vector),
               .TABLE(TABLE_VECTOR)
);

endmodule