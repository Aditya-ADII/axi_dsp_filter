`timescale 1ns/1ps

module tb;
    logic clk, rst_n, s_valid, s_ready, m_valid, m_ready;
    logic [7:0] s_data, m_data;

    moving_avg dut (clk, rst_n, s_data, s_valid, s_ready, m_data, m_valid, m_ready);

    always #5 clk = ~clk;

    initial begin
        clk=0; rst_n=0; s_valid=0; m_ready=1;
        #10 rst_n=1;

        $display("--- Starting AXI Stream DSP Test ---");
        
        // Send a noisy signal that stabilizes at 100
        repeat(10) begin
            @(posedge clk);
            s_data <= 100;
            s_valid <= 1;
        end
        
        @(posedge clk) s_valid <= 0;
        #50;
        
        $display("Final Output: %d", m_data);
        if (m_data == 100) $display("PASS: Filter Converged");
        else               $display("FAIL: Filter Failed");
        
        $finish;
    end
endmodule