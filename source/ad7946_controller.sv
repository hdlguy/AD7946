//
module ad7946_controller (
    input   logic       clk,    
    input   logic       pden,
    output  logic       chsel,
    output  logic       cs_n,
    output  logic       sclk,
    input   logic       sdi
);

    assign pden = 0;
    
    // registers to go in the IO Logic
    logic pre_chsel, pre_cs_n, pre_sclk, sdi_reg;
    always_ff @(posedge clk) begin
        chsel <= pre_chsel;
        cs_n  <= pre_cs_n;
        sclk  <= pre_sclk;
        sdi_reg <= sdi;
    end

endmodule