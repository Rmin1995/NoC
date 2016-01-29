/**************************************
* File: constants
* Date:2016-01-27  
* Author: armin     
*
* Description: all of constants
***************************************/

`define FLIT_SIZE 26
`define IN_OUTPORT_CNT  7
`define LOG_PORTS_CNT 3
/*****************
* head -> 1bit
* tail -> 1bit
* src -> 10bit
* dst -> 10bit
* parity -> 1bit
* vc -> 3bit
******************/

`define FLIT_HEAD [1]
`define FLIT_TAIL [2]
`define FLIT_SRC [3:12]
`define FLIT_DST [13:22]
`define FLIT_PAR  [23]
`define FLIT_VC   [24:26]