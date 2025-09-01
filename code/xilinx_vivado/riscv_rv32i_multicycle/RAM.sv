`timescale 1ns / 1ps

module RAM (
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] addr,
    input  logic [31:0] wData,
    output logic [31:0] rData,
    input  logic [ 1:0] LSControl,
    input  logic        SignControl
);                              // 16 word = 64 byte
    logic [31:0] mem[0:2**8-1]; // 0x00 ~ 0x0f => 0x10 * 4 => 0x40
    logic [31:0] non_rData;

/*
    always_ff @( posedge clk ) begin
        if (we) mem[addr[31:2]] <= wData;
    end

    assign rData = mem[addr[31:2]];
    */

    
    // Store-Type 에서 func에 따른 데이터 비트 수
    always_ff @(posedge clk) begin
        if(we) begin
            case(LSControl)
                //Byte
                2'b00 : begin
                    mem[addr[31:2]] <= {{24{1'b0}},wData[7:0]};
                end
                //Half
                2'b01 : begin
                    mem[addr[31:2]] <= {{16{1'b0}},wData[15:0]};
                end
                //Word
                2'b10 : begin
                    mem[addr[31:2]] <= wData;
                end
            endcase
        end
    end

    assign non_rData = mem[addr[31:2]];

    // Load Type에서 func에 따른 데이터의 비트 수 및 부호 여부
    always_comb begin  
        case ({SignControl, LSControl})
            // Signed Byte
            3'b000 : begin
                rData = {{24{non_rData[7]}}, non_rData[7:0]};
            end

            // Signed Half
            3'b001 : begin
                rData = {{16{non_rData[15]}}, non_rData[15:0]};
            end

            // Signed Word
            3'b010 : begin
                rData = non_rData;
            end

            // Unsigned Byte
            3'b100 : begin
                rData = {{24{1'b0}}, non_rData[7:0]};
            end

            // Unsigned Half
            3'b101 : begin
                rData = {{16{1'b0}}, non_rData[15:0]};
            end

            default : rData = 32'd0;
        endcase

    end


endmodule
