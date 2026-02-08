// -----------------------------------------------------------------------------
// Project: AXI-Stream Moving Average Filter
// Description: 4-Tap FIR Filter with Valid/Ready Handshake
// -----------------------------------------------------------------------------

module moving_avg (
    input  logic        clk, rst_n,
    // AXI Stream Slave (Input)
    input  logic [7:0]  s_data,   
    input  logic        s_valid,
    output logic        s_ready,
    // AXI Stream Master (Output)
    output logic [7:0]  m_data,
    output logic        m_valid,
    input  logic        m_ready
);
    logic [7:0] x0, x1, x2, x3;
    logic [9:0] sum; 

    assign s_ready = m_ready; // Simple backpressure

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x0<=0; x1<=0; x2<=0; x3<=0; m_valid<=0; m_data<=0;
        end else begin
            if (s_valid && s_ready) begin
                // Shift Pipeline
                x0 <= s_data; x1 <= x0; x2 <= x1; x3 <= x2;
                
                // Average Calculation (Sum / 4)
                sum = x0 + x1 + x2 + x3;
                m_data <= sum[9:2]; // Bit shift right by 2
                
                m_valid <= 1;
            end else if (m_ready) begin
                m_valid <= 0;
            end
        end
    end
endmodule