
`include "constants.v" 
module  priority_vc_check_outport(output isNew,
                 output [`VC_SIZE_default-1:0] firstPriority,
                 input  [`VC_SIZE_default-1:0] vc_id,
                 input [`VC_SIZE_default-1:0] prevPriority,
                 input prevIsNew,
                 input vc_isNew,
				 input credit

);

assign isNew = prevIsNew | (vc_isNew && credit);
assign firstPriority = (prevIsNew==1'b1 ? prevPriority : ((vc_isNew==1'b1 && credit==1'b1) ?  vc_id : 3'd0));   
endmodule

module ALL_priority_vc_check_outport(output [1:`FLIT_SIZE]flit_out,
									 input [1:`FLIT_SIZE * `INOUT_PORT_CNT] flit_in,
									input [0:`LOG_PORTS_CNT * `VC_NUM -1] ports
									input [0:`VC_NUM-1] credit,
									input [0:`VC_NUM-1] vc_isNew
);
parameter VC_NUM = 4;

wire [0:`LOG_PORTS_CNT - 1] ports_id [0:`VC_NUM-1];

genvar i;
generate
	for(i=0;i<`VC_NUM;i=i+1)
	begin
		ports_id[i] = ports[i*`LOG_PORTS_CNT : (i+1) * `LOG_PORTS_CNT -1];
	end
endgenerate

wire isNew [0:`VC_NUM];
wire [`VC_SIZE_default-1:0] firstPriority [0:`VC_NUM];

generate
	for(i=0;i<`VC_NUM;i=i+1)
	begin
		priority_vc_check_outport p(.isNew(isNew[i+1])
									.firstPriority(firstPriority[i+1]),
									.vc_id(i),
									.prevPriority(firstPriority[i]),
									.prevIsNew(isNew[i]),
									.vc_isNew(vc_isNew[i]),
									.credit(credit[i])
		);
	end
endgenerate

generate
    for(i=0; i < 7;i = i + 1)begin
        assign in_port[i]=flit_in[i*`FLIT_SIZE:(i+1)*`FLIT_SIZE-1];
	end
endgenerate

assign flit_out = in_port[firstPriority[`VC_NUM]];

endmodule