//指令形成单元 —— 程序计数器 Program Counter

`include "defines.v"

module PC(
    input clk,
    input [`QBBus] nextAddr,
    output reg [`QBBus] addr
    );

    always@ (posedge clk) begin
        addr<=nextAddr;
    end

endmodule
