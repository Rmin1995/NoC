/**************************************
* Module: priority_port
* Date:2016-01-28  
* Author: Armin     
*
* Description: 
***************************************/
module  priority_port(output isNew,
                 output [2:0] firstPriority,
                 input [2:0] num,
                 input [2:0] prevPriority,
                 input prevIsNew,
                 input port_isNew,
                 input [1:`FLIT_SIZE]port,
                 input [0:9999]TABLE
);
wire [0 : `SOURCE_SIZE-1]routing_table[0:999];
genvar i;
generate
    for(i=0;i<1000;i=i+1)begin
        assign routing_table[i] = TABLE[(i-1)*`SOURCE_SIZE : i* `SOURCE_SIZE-1];
    end
endgenerate



assign isNew = prevIsNew | port_isNew;
assign firstPriority = (prevIsNew==1'b1 ? prevPriority : (port_isNew==1'b1 ? num : 3'd0));   

endmodule

