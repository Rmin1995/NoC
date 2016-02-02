/**************************************
* Module: router
* Date:2016-01-29  
* Author: saber     
*
* Description: 
***************************************/
`include "constants.v"
module  router(flit_out, credit, flit_in, data, next_router_credit, load, write,
                init, clk, reset);
parameter CREDIT_DELAY = 16;
parameter VC_NUM = 4;
                output [1:`IN_OUTPORT_CNT*`FLIT_SIZE] flit_out;
				output credit;
                input [1:`IN_OUTPORT_CNT*`FLIT_SIZE] flit_in;
                input [1:`IN_OUTPORT_CNT_BIN] data;
                input [0:VC_NUM*`IN_OUTPORT_CNT-1] next_router_credit;
				input [1:`ROUTERS_CNT_BIN] load;
                input write;
                input init;
                input clk;
                input reset;

/************************
INITIAL phase:initial values for router's table
************************/
reg [0:`IN_OUTPORT_CNT_BIN-1] TABLE [0:`TABLE_ROWS-1];
wire[0:`IN_OUTPORT_CNT_BIN-1] NEXT_TABLE [0:`TABLE_ROWS-1];

integer tmp;
always @(posedge clk or posedge reset)
begin
    for(tmp=0; tmp<`TABLE_ROWS; tmp=tmp+1)
    begin
        if ( reset ) 
            TABLE[tmp] <= {`IN_OUTPORT_CNT_BIN{1'b0}};
        else
            TABLE[tmp] <= NEXT_TABLE[tmp];
    end
end

genvar i;
generate
	for(i = 0; i <`TABLE_ROWS; i = i + 1)begin
		assign NEXT_TABLE[i] = ((init == 1'b0) ? TABLE[i] : (write == 1'b1 && load == i) ? data : TABLE[i]);
	end
endgenerate

//important!!!!!!!!next_router_credit_for_inport bayad ba next_router_credit ke az vooroodi migitrm besazimesh

`MAKE_ARRAY_1BASED(flit_in_array, flit_in, `IN_OUTPORT_CNT, `FLIT_SIZE, GEN_FLIT_IN1)

wire [1:`FLIT_SIZE] flit_out_each_in_port [1:`IN_OUTPORT_CNT];

wire [0:VC_NUM-1] credit_each_in_port [1:`IN_OUTPORT_CNT];

wire [0:VC_NUM-1] isnew_each_in_port [1:`IN_OUTPORT_CNT];

generate
	for(i = 0; i < `IN_OUTPORT_CNT; i = i + 1)begin:GEN_IN_PORT
	    in_port #(.CREDIT_DELAY(CREDIT_DELAY),.VC_NUM(VC_NUM)) m(.credit(credit_each_in_port[i]),
					.flit_out(flit_out_each_in_port[i]),
					.is_new(isnew_each_in_port),
					.flit_in(flit_in_array[i]),
					.credit_next_router(next_router_credit_for_inport[i]),
					.clock(clock),
					.reset(reset),
//					input [3:0]port_num
		);

	end
endgenerate

`MAKE_VECTOR(flit_in_priority,flit_out_each_in_port,`IN_OUTPORT_CNT,`FLIT_SIZE,GEN_FLIT_IN2)



endmodule


