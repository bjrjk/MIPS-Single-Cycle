//指令译码单元 —— 控制器 Controller

`include "defines.v"

module Controller(
    input [`QBBus] DecInstBus,
    output reg RegWrEn,RegOFWrEn,MemWrEn, //寄存器写使能，寄存器溢出写使能，内存写使能
    output reg [3:0] ALUCtl, //ALU控制信号
    output reg [1:0] RegWrDstCtl, //寄存器写目标控制信号
    output reg WrBackCtl, ALUSrcCtl, ExtCtl //回写控制信号，ALU数据源控制信号，位拓展器控制信号
    
    );

    always@ (*) begin
        
    end

endmodule
