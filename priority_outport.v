`include "constants.v"
module  priority_outport(output isNew,
                 output[`LOG_PORTS_CNT-1:0] firstPriority,
                 input [`LOG_PORTS_CNT-1:0] outport_id,
                 input [0:`IN_OUTPORT_CNT*`FLIT_SIZE-1]flit_in,
                 input [0:`TABLE_SIZE-1]TABLE,
				 input [0:`IN_OUTPORT_CNT-1] new_flit_is_in_inport,
				 input [0:`VC_SIZE_default-1]VC_ID,
				 input [0:`OCCUPIED_SIZE-1]occupied
);
wire [0:`FLIT_SIZE-1]in_port[0:6];
genvar j;
generate
    for(j=0; j < 7;j = j + 1)begin
        assign in_port[j]=flit_in[j*`FLIT_SIZE:(j+1)*`FLIT_SIZE-1];
    
	end
endgenerate



 wire new_port[0:7];
 wire [2:0] priority_id[0:7];
 assign new_port[0]=1'b0;
 assign priority_id[0]=4'b0000;
/*
 wire isNew[0:6];
 wire [`LOG_PORTS_CNT-1:0] firstPriority[0:6];
 */
 genvar i;
 generate
    for(i = 0; i < 7; i = i + 1)begin
	    priority_port_perVC m( .isNew(new_port[i+1]),
            .firstPriority(priority_id[i+1]),
			.VC_ID(VC_ID),
            .outport_id(outport_id),
            .inport_id(i),
			.prevPriority(priority_id[i]),
            .prevIsNew(new_port[i]),
            .port_isNew(new_flit_is_in_inport[i]),
            .port(in_port[i]),
            .TABLE(TABLE));
   
    end
 endgenerate
 assign isNew = new_port[7];
 assign firstPriority = priority_id[7];

endmodule