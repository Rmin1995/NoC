/**************************************
* Module: priority_port
* Date:2016-01-28  
* Author: Armin     
*
* Description: 
***************************************/
`include "constants.v"
module  priority_port_perVC  (output isNew,
                 output [`LOG_PORTS_CNT-1:0] firstPriority,
				 input [0:`VC_SIZE_default-1]VC_ID,
                 input [`LOG_PORTS_CNT-1:0] outport_id,
                 input [`LOG_PORTS_CNT-1:0] inport_id,
				 input [`LOG_PORTS_CNT-1:0] prevPriority,
                 input prevIsNew,
                 input port_isNew,
                 input [1:`FLIT_SIZE]port,
                 input [0:`OCCUPIED_SIZE-1]occupied_i,
				 input [0:`TABLE_SIZE-1]TABLE
);

/****************
*out_port is ocupied? => 1bit(msb)
*out_port is occupied by which in_port? => 4bit
****************/

wire [0:`LOG_PORTS_CNT-1]flit_valid_portout;
wire tmp1,tmp2,tmp3;
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
assign tmp1 = ~(flit_valid_portout ^ outport_id);
assign tmp2 = ~(port `FLIT_VC ^ VC_ID); 
assign tmp3 = tmp1 && tmp2 && (!occupied_i[0]) && (occupied_i[0] && (occupied_i[1:4] ^ inport_id));
assign isNew = (prevIsNew | (port_isNew & tmp3));
assign firstPriority = (prevIsNew==1'b1 ? prevPriority : ((port_isNew==1'b1 && tmp3 == 1'b1) ? inport_id : 4'd0));   
endmodule
