/**************************************
* Module: vc
* Date:2016-01-27  
* Author: sara     
*
* Description: virtual channel
***************************************/
`include "constants.v"
module vc(  output reg [1:`FLIT_SIZE] flit_buff,
            output reg credit,
            output reg is_new,
            input [1:`FLIT_SIZE] flit,
            input next_router_credit,
            input load,
            input clock,
            input reset);

//S0:wait for packet's flit
//S1:wait for receiving the credit of next router
//S2:credit delay state
parameter S0= 2'b00, S1= 2'b01, S2= 2'b10;
parameter CREDIT_DELAY=16;

reg [1:0]state, next_state;

reg [4:0]credit_delay_counter;
wire [1:`FLIT_SIZE]n_flit_buff;
wire n_credit;
wire n_is_new;
wire [4:0]n_credit_delay_counter;
//end_packet means tail_p=1  in the flit

//control unit
always @(posedge clock or posedge reset)begin
    if(reset)
     begin
        state<= S0;
          flit_buff <= {`FLIT_SIZE{1'b0}};
          credit <= 1'b1;
          credit_delay_counter <= 5'd0;
          is_new <= 1'd0;
     end
    else
     begin
          state <= next_state;
          flit_buff <= n_flit_buff;
          credit <= n_credit;
          credit_delay_counter <= n_credit_delay_counter;
          is_new <= n_is_new;
     end
end

always @(state or load or next_router_credit or credit_delay_counter)
begin
    next_state<= S0;
    case(state)
        S0: next_state <= ((load) ? S1: S0);
        S1: next_state <= ((next_router_credit == 1) ? S2: S1);       // TODO FIXME maybe credit delay should be decrement
        S2: next_state <= ((credit_delay_counter < CREDIT_DELAY) ? S2: S0);
    endcase
end

assign n_credit = (reset == 1'b0 ? (state == S0 ? 1'd1: 1'd0): 1'd1);
assign n_flit_buff = (reset == 1'b0 ? ((state == S0 && load == 1'b1) ? flit : flit_buff) : {`FLIT_SIZE{1'b0}});
assign n_credit_delay_counter = (reset == 0 ?(state == S2 ? credit_delay_counter + 5'd1 : 5'd0): 5'd0);
assign n_is_new = (reset == 1'b0 ? (state == S1 ? 1'b1 : 1'b0) : 1'b0); 

endmodule
