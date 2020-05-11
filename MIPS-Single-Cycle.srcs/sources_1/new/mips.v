//主模块

`include "defines.v"

module mips(
    input clk,rst
    );

    //PC
    wire [`QBBus] PC_addr, NAFL_nextAddr;
    PC insPC(
    .clk(clk),
    .rst(rst),
    .nextAddr(NAFL_nextAddr),
    .addr(PC_addr)
    );

    //NAFL
    wire ALU_zero;
    wire [`QBBus] Decoder_DecInstBus;
    wire [`DBBus] Decoder_imm;
    wire [25:0] Decoder_tgtAddr;
    wire [`QBBus] NAFL_nextInstAddr;
    wire [`QBBus] GPR_RdData1;
    NAFL insNAFL(
    .addr(PC_addr),
    .nextAddr(NAFL_nextAddr),
    .beq(Decoder_DecInstBus[`CTLSIG_BEQ]),
    .j(Decoder_DecInstBus[`CTLSIG_J]),
    .jal(Decoder_DecInstBus[`CTLSIG_JAL]),
    .jr(Decoder_DecInstBus[`CTLSIG_JR]),
    .beqZero(ALU_zero),
    .beqShift(Decoder_imm),
    .jPadding(Decoder_tgtAddr),
    .jrAddr(GPR_RdData1),
    .nextInstAddr(NAFL_nextInstAddr)
    );
    
    //IM
    wire [`QBBus] IM_Inst;
    im_1k insIM(
    .addr(PC_addr[11:0]),
    .dout(IM_Inst)
    );

    //Decoder
    wire [4:0] Decoder_rs,Decoder_rt,Decoder_rd,Decoder_shamt;
    Decoder insDecoder(
    .Inst(IM_Inst),
    .DecInstBus(Decoder_DecInstBus),
    .rs(Decoder_rs),
    .rt(Decoder_rt),
    .rd(Decoder_rd),
    .shamt(Decoder_shamt),
    .imm(Decoder_imm),
    .tgtAddr(Decoder_tgtAddr)
    );

    //Controller
    wire Controller_RegWrEn,Controller_RegOFWrEn,Controller_MemWrEn;
    wire [3:0] Controller_ALUCtl;
    wire [1:0] Controller_RegWrDstCtl,Controller_WrBackCtl;
    wire Controller_ALUSrcCtl, Controller_ExtCtl;
    Controller insController(
    .DecInstBus(Decoder_DecInstBus),
    .RegWrEn(Controller_RegWrEn),
    .RegOFWrEn(Controller_RegOFWrEn),
    .MemWrEn(Controller_MemWrEn),
    .ALUCtl(Controller_ALUCtl),
    .RegWrDstCtl(Controller_RegWrDstCtl),
    .WrBackCtl(Controller_WrBackCtl),
    .ALUSrcCtl(Controller_ALUSrcCtl), 
    .ExtCtl(Controller_ExtCtl)
    );

    //GPR_WrAddr_MUX
    wire [4:0] GPR_WrAddr_MUX_out;
    GPR_WrAddr_MUX insGPR_WrAddr_MUX(
    .RegWrDstCtl(Controller_RegWrDstCtl),
    .rt(Decoder_rt),
    .rd(Decoder_rd),
    .out(GPR_WrAddr_MUX_out)
    );

    //GPR_WrData_MUX
    wire [`QBBus] GPR_WrData_MUX_out;
    wire [`QBBus] ALU_C,DM_dout;
    GPR_WrData_MUX insGPR_WrData_MUX(
    .WrBackCtl(Controller_WrBackCtl),
    .ALU(ALU_C),
    .MEM(DM_dout),
    .PC(NAFL_nextInstAddr),
    .out(GPR_WrData_MUX_out)
    );

    //GPR
    wire [`QBBus] GPR_RdData2;
    wire ALU_OF;
    GPR insGPR(
    .clk(clk),
    .WrEn(Controller_RegWrEn),
    .OFWrEn(Controller_RegOFWrEn),
    .OFFlag(ALU_OF),
    .RdAddr1(Decoder_rs),
    .RdAddr2(Decoder_rt),
    .WrAddr(GPR_WrAddr_MUX_out),
    .WrData(GPR_WrData_MUX_out),
    .RdData1(GPR_RdData1),
    .RdData2(GPR_RdData2)
    );

    //Ext
    wire [`QBBus] Ext_ExtImm;
    Ext insExt(
    .ExtCtl(Controller_ExtCtl),
    .imm(Decoder_imm),
    .ExtImm(Ext_ExtImm)
    );

    //ALUSrc_MUX
    wire [`QBBus] ALUSrc_MUX_out;
    ALUSrc_MUX insALUSrc_MUX(
    .ALUSrcCtl(Controller_ALUSrcCtl),
    .GPRData(GPR_RdData2),
    .ExtData(Ext_ExtImm),
    .out(ALUSrc_MUX_out)
    );

    //ALU
    ALU insALU(
    .ALUCtl(Controller_ALUCtl),
    .A(GPR_RdData1),
    .B(ALUSrc_MUX_out),
    .C(ALU_C),
    .OF(ALU_OF),
    .zero(ALU_zero)
    );

    //DM
    dm_1k insDM(
    .addr(ALU_C[11:0]),
    .din(GPR_RdData2),
    .we(Controller_MemWrEn),
    .clk(clk),
    .dout(DM_dout)
    );

endmodule
