`timescale 1ns / 1ps

module tb_rv32i_s();

    logic clk;
    logic reset;

    MCU dut(.*);

    always #5 clk = ~clk;

    localparam RAM_max_addr = 63;

    int i, j;
    logic [32:0] result_addr_array [0:4];

    initial begin
        #0;
        j = 0;

        for(int k = 0; k < 5; k++) begin
            result_addr_array[k] = 32'd0; 
        end

        clk = 0; reset = 1;
        #10;
        reset = 0;

        #1000000;

        for(i = 0; i < RAM_max_addr; i ++) begin
            if(dut.U_RAM.mem[i]==j+1) begin
                if(j == 5) begin
                    break;      // 반복문 탈출
                end
                result_addr_array[j] = i;
                j = j + 1;
            end else begin
                j = 0;
            end
        end

        if(dut.U_RAM.mem[result_addr_array[0]] == 32'd1 &&
           dut.U_RAM.mem[result_addr_array[1]] == 32'd2 &&
           dut.U_RAM.mem[result_addr_array[2]] == 32'd3 &&
           dut.U_RAM.mem[result_addr_array[3]] == 32'd4 &&
           dut.U_RAM.mem[result_addr_array[4]] == 32'd5)
        begin
            $display("Sort Success! : RAM[%d:%d] = [%d, %d, %d, %d, %d]",
                        result_addr_array[0], result_addr_array[4], dut.U_RAM.mem[result_addr_array[0]], dut.U_RAM.mem[result_addr_array[1]], dut.U_RAM.mem[result_addr_array[2]], dut.U_RAM.mem[result_addr_array[3]], dut.U_RAM.mem[result_addr_array[4]]);
        end else begin
            $display("Sort Failed!");
        end
        
        $finish;
    end
endmodule