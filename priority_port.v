/**************************************
* Module: priority_port
* Date:2016-01-28  
* Author: Armin     
*
* Description: 
***************************************/
`include "constants.v"

module  priority_port(output isNew,
                 output [2:0] firstPriority,
                 input [0:3]occupied,
                 input [2:0] ouport_id,
                 input [2:0] inport_id,
                 input [2:0] prevPriority,
                 input prevIsNew,
                 input port_isNew,
                 input [1:`FLIT_SIZE]port,
                 input [0:2999]TABLE
);
/****************
*out_port is ocupied? => 1bit
*out_port is occupied by which in_port? => 3bit
****************/

wire [0:`LOG_PORTS_CNT-1]flit_valid_portout;
wire tmp1,tmp2;
//===========================>note:D
//man tooye mux am in taqsim bandie table o anjam dadam na inja
/*
wire [0 :`LOG_PORTS_CNT - 1]routing_table[0:999];
genvar i;
generate
    for(i=0;i<1000;i=i+1)begin
        assign routing_table[i] = TABLE[(i-1) * `LOG_PORTS_CNT : i* `LOG_PORTS_CNT-1];
    end
endgenerate
*/

mux1024to1 m(flit_valid_portout , port `FLIT_DST , TABLE);
assign tmp1 = | (~(flit_valid_portout ^ ouport_id));
assign tmp2 = | ( ( ( |(~(occupied[1:3]^inport_id)) & occupied[0]) || ~(occupied[0])) && tmp1);

assign isNew = (prevIsNew | port_isNew) && tmp2;
assign firstPriority = (prevIsNew==1'b1 ? prevPriority : (port_isNew==1'b1 ? inport_id : 3'd0));   

endmodule
