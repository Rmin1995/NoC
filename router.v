/**************************************
* Module: router
* Date:2016-01-29  
* Author: saber     
*
* Description: 
***************************************/
`include "constants.v"
module  router(output [1:`IN_OUTPORT_CNT*`FLIT_SIZE] OUT,
                input [1:`IN_OUTPORT_CNT*`FLIT_SIZE] IN,
                input [1:`IN_OUTPORT_CNT_BIN] DATA,
                input [1:`ROUTERS_CNT_BIN] LOAD,
                input WRITE,
                input INIT,
                input CLK,
                input RESET
);
reg [1:`TABLE_SIZE] TABLE;
wire [1:`TABLE_SIZE] NEXT_TABLE;

always @(posedge CLK or posedge RESET)
begin
    if (RESET==1)begin 
        TABLE={`TABLE_SIZE{1'b0}};
    end
    else begin
        TABLE=NEXT_TABLE;
    end
end

generate
    genvar i;
    NEXT_TABLE[i] = ((INIT == 0) ? TABLE[i] : (WRITE == 1 && LOAD == i) ? DATA : TABLE[i]);
    

endgenerate

endmodule


