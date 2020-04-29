//译码器至控制器指令信号线对应指令下标宏定义

`define CTLSIG_NOP 0
`define CTLSIG_ADDU 1
`define CTLSIG_SUBU 2
`define CTLSIG_ORI 3
`define CTLSIG_LW 4
`define CTLSIG_SW 5
`define CTLSIG_BEQ 6
`define CTLSIG_LUI 7
`define CTLSIG_J 8
`define CTLSIG_ADDI 9
`define CTLSIG_ADDIU 10
`define CTLSIG_SLT 11
`define CTLSIG_JAL 12
`define CTLSIG_JR 13
