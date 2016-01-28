/**************************************
* Module: priority
* Date:2016-01-27  
* Author: armin     
*
* Description: 
***************************************/
module  priority_vc(output isNew,
                 output [2:0] firstPriority,
                 input [2:0] num,
                 input [2:0] prevPriority,
                 input prevIsNew,
                 input vc_isNew
);

assign isNew = prevIsNew | vc_isNew;
assign firstPriority = (prevIsNew==1'b1 ? prevPriority : (vc_isNew==1'b1 ? num : 3'd0));   

endmodule
