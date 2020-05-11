//指令执行单元 —— 算术逻辑单元 Arithmetic and Logic Unit

`include "defines.v"

module ALU(
    input [3:0] ALUCtl,
    input [`QBBus] A,B,
    output reg [`QBBus] C,
    output reg OF
    );

    always@ (*) begin
        case(ALUCtl)
            `ALUSIG_ADD:{OF,C}=A+B;
            `ALUSIG_SUB:{OF,C}=A-B;
            `ALUSIG_OR:C=A|B;
            `ALUSIG_LUI:C={B[15:0],16'd0};
            `ALUSIG_SLT:C=A<B;
            default:{OF,C}=A+B;
        endcase
    end

endmodule
