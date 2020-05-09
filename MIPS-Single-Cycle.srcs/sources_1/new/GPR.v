//读寄存器单元 —— 通用寄存器组 General Purpose Register

`include "defines.v"

module GPR(
    input clk,WrEn,OFWrEn,OFFlag,
    input [4:0] RdAddr1,RdAddr2,WrAddr,
    input [`QBBus] WrData,
    output reg [`QBBus] RdData1,RdData2
    );

    reg [`QBBus] regArr [`QBBus];

    always @(*) begin
        RdData1=regArr[RdAddr1];
        RdData2=regArr[RdAddr2];
    end

    always @(posedge clk) begin
        if(WrEn)regArr[WrAddr]<=WrData;
        if(OFWrEn)regArr[30][0]<=OFFlag;
    end

endmodule
