/**************************************
* File: constants
* Date:2016-01-27  
* Author: armin     
*
* Description: all of constants
***************************************/

`define FLIT_SIZE 30
`define OUTPORT_CNT  7
`define SOURCE_SIZE 10
/*****************
* head -> 1bit
* tail -> 1bit
* srcX -> 4bit
* srcY -> 4bit
* srcZ -> 4bit
* dstX -> 4bit
* dstY -> 4bit
* dstZ -> 4bit
* parity -> 1bit
* vc -> 1bit
******************/

`define FLIT_HEAD [1]
`define FLIT_TAIL [2]
`define FLIT_SRCX [3:6]
`define FLIT_SRCY [7:10]
`define FLIT_SRCZ [11:14]
`define FLIT_DSTX [15:18]
`define FLIT_DSTY [19:22]
`define FLIT_DSTZ [23:26]
`define FLIT_PAR  [27]
`define FLIT_VC   [28:30]