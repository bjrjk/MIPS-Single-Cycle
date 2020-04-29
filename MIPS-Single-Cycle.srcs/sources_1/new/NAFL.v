//指令形成单元 —— 下地址形成逻辑 Next Address Formulation Logic

`include "defines.v"

module NAFL(
    input [`QBBus] addr,
    output reg [`QBBus] nextAddr,
    input beq,j,jal,jr,
    input [`DBBus] beqShift, // beq指令，16比特左移两位后变18比特加到PC
    input [25:0] jPadding, // j和jal指令，26比特左移两位后变28比特置PC低位
    input [`QBBus] jrAddr // jr指令从$ra直接读入的32位地址
    );

    

endmodule
