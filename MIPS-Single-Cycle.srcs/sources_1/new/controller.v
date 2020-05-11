//指令译码单元 —— 控制器 Controller

`include "defines.v"

module Controller(
    input [`QBBus] DecInstBus,
    output reg RegWrEn,RegOFWrEn,MemWrEn, //寄存器写使能，寄存器溢出写使能，内存写使能
    output reg [3:0] ALUCtl, //ALU控制信号
    output reg [1:0] RegWrDstCtl,WrBackCtl, //寄存器写目标控制信号，回写控制信号
    output reg ALUSrcCtl, ExtCtl //ALU数据源控制信号，位拓展器控制信号
    );

    always@ (*) begin
        RegWrEn=`t;
        RegOFWrEn=`f;
        MemWrEn=`f;
        ALUCtl=`ALUSIG_ADD;
        RegWrDstCtl=`REGWRDSTSIG_RT;
        WrBackCtl=`WRBACKSIG_ALU;
        ALUSrcCtl=`ALUSRCSIG_EXT;
        ExtCtl=`EXTSIG_SIGN;
        if(DecInstBus[`CTLSIG_ADDU]) begin
            RegWrDstCtl=`REGWRDSTSIG_RD;
            ALUSrcCtl=`ALUSRCSIG_GPR;
        end else if(DecInstBus[`CTLSIG_SUBU]) begin
            ALUCtl=`ALUSIG_SUB;
            RegWrDstCtl=`REGWRDSTSIG_RD;
            ALUSrcCtl=`ALUSRCSIG_GPR;
        end else if(DecInstBus[`CTLSIG_ORI]) begin
            ALUCtl=`ALUSIG_OR;
            ExtCtl=`EXTSIG_ZERO;
        end else if(DecInstBus[`CTLSIG_LW]) begin
            WrBackCtl=`WRBACKSIG_MEM;
        end else if(DecInstBus[`CTLSIG_SW]) begin
            RegWrEn=`f;
            MemWrEn=`t;
        end else if(DecInstBus[`CTLSIG_BEQ]) begin
            RegWrEn=`f;
            ALUCtl=`ALUSIG_SUB;
            ALUSrcCtl=`ALUSRCSIG_GPR;
        end else if(DecInstBus[`CTLSIG_LUI]) begin
            ALUCtl=`ALUSIG_LUI;
        end else if(DecInstBus[`CTLSIG_J]) begin
            RegWrEn=`f;
        end else if(DecInstBus[`CTLSIG_ADDI]) begin
            RegOFWrEn=`t;
        end else if(DecInstBus[`CTLSIG_ADDIU]) begin

        end else if(DecInstBus[`CTLSIG_SLT]) begin
            ALUCtl=`ALUSIG_SLT;
            RegWrDstCtl=`REGWRDSTSIG_RD;
            ALUSrcCtl=`ALUSRCSIG_GPR;
        end else if(DecInstBus[`CTLSIG_JAL]) begin
            RegWrDstCtl=`REGWRDSTSIG_GPR_RA;
            WrBackCtl=`WRBACKSIG_PC;
        end else if(DecInstBus[`CTLSIG_JR]) begin
            RegWrEn=`f;
        end else begin // DecInstBus[`CTLSIG_NOP] or Unexcepted Situations
            RegWrEn=`f;
        end
    end

endmodule
