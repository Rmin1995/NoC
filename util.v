/**************************************
* Module: util
* Date:2016-01-31  
* Author: armin     
*
* Description: 
***************************************/

`define CONCAT(A,B) A``B

`define MAKE_ARRAY(out,in,size1,size2,name) \
wire [0:size2-1] out [0:size1-1]; \
generate \
    for(util_genvar=0; util_genvar<size1; util_genvar = util_genvar+1) begin : name \
        assign out[util_genvar] = in[util_genvar*size2 : (util_genvar+1)*size2-1]; \
    end \
endgenerate

`define MAKE_VECTOR(out,in,size1,size2,name) \
wire [0:size1*size2-1] out; \
generate \
    for(util_genvar=0; util_genvar<size1; util_genvar = util_genvar+1) begin : name \
        assign out[util_genvar*size2 : (util_genvar+1)*size2-1] = in[util_genvar]; \
    end \
endgenerate

`define MAKE_VECTOR_1BASED(out,in,size1,size2,name) \
wire [0:size1*size2-1] out; \
generate \
    for(util_genvar=1; util_genvar<=size1; util_genvar = util_genvar+1) begin : name \
        assign out[(util_genvar-1)*size2 : util_genvar*size2-1] = in[util_genvar]; \
    end \
endgenerate


`define MAKE_ARRAY_1BASED(out,in,size1,size2,name) \
wire [1:size2] out [0:size1-1]; \
generate \
    for(util_genvar=0; util_genvar<size1; util_genvar = util_genvar+1) begin : name \
        assign out[util_genvar] = in[util_genvar*size2+1 : (util_genvar+1)*size2]; \
    end \
endgenerate	