`include "constants.v"
module mux1024to1(output [0:`LOG_PORTS_CNT-1]OUT,
				  input [0:9]select,
				  input [0:2999]TABLE

);

wire [0:`LOG_PORTS_CNT-1]table_port[0:999];
genvar i;
generate
	for(i=0;i<1000;i=i+1)begin : GEN_TABLE_PORT_MUX
		assign table_port[i][0:`LOG_PORTS_CNT-1] = TABLE[i * `LOG_PORTS_CNT : (i+1) * `LOG_PORTS_CNT - 1];
	end
endgenerate

generate
	for(i=0;i<1000;i=i+1)begin : GEN_MUX
		if(i == select)
			 assign OUT = table_port[i];
	end
endgenerate

endmodule
