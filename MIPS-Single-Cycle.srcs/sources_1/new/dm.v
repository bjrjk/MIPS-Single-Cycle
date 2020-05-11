module dm_1k(
    input [11:0] addr,
    input [`QBBus] din,
    input we,
    input clk,
    output [`QBBus] dout
    );

    reg [`BBus] dm[1023:0];
    wire [9:0] index;

    assign index=addr[9:0];
    //Dout为小端序
    assign dout={dm[index+3],dm[index+2],dm[index+1],dm[index]};

    always@ (posedge clk) begin
        if(we) begin
            dm[index]<=din[7:0];
            dm[index+1]<=din[15:8];
            dm[index+2]<=din[23:16];
            dm[index+3]<=din[31:24];
        end
    end

endmodule
