/**************************************
* Module: router
* Date:2016-01-29  
* Author: saber     
*
* Description: 
***************************************/
`include "constants.v"
module  router(output [1:`IN_OUTPORT_CNT*`FLIT_SIZE] OUT,
                input [1:`IN_OUTPORT_CNT*`FLIT_SIZE] IN
);


endmodule
module initiator ();
wire [1:`FLIT_SIZE] output_wire [1:`ROUTERS_CNT][1:`IN_OUTPORT_CNT];
wire [1:`FLIT_SIZE] input_wire  [1:`ROUTERS_CNT][1:`IN_OUTPORT_CNT];
generate
genvar i;
    for (i=1;i<=`ROUTERS_CNT;i=i+1)begin : GEN_ROUTERS
        router rtr(.OUT(output_wire[i]),
                   .IN(input_wire[i]));
    end
    for (i=1;i<=`ROUTERS_CNT;i=i+1)begin : GEN_WIRES_OF_ROUTERS
        assign input_wire[i][1]=output_wire[(i-1+10)%10][9];
        assign input_wire[i][2]=output_wire[(i+1+10)%10][8];
        assign input_wire[i][3]=output_wire[(i-10+100)%100][11];
        assign input_wire[i][4]=output_wire[(i+10+100)%100][10];
        assign input_wire[i][5]=output_wire[(i-100+1000)%1000][13];
        assign input_wire[i][6]=output_wire[(i+100+1000)%1000][12];
    end
endgenerate




endmodule

