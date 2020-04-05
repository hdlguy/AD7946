// This module controls the TI AD7946 ADC with multiplexed analog input.
// It is designed to run on the 100MHz axi clock of the Xilinx Zynq. 
// Conversions run at the fasted reasonable rate using that clock, about 700Ksps on each analog input.
// Since control pattern just repeats a simple modulo counter was implemented then control signals were 
// decoded from that counter.

// The pins connecting to the AD9746 should have IOB constraints in the xdc file like this.
// set_property IOB TRUE            [get_ports {sclk[*]}]


module ad7946_controller (
    input   logic       clk,    // 100MHz axi clock.
    output  logic       pden,
    output  logic       chsel,
    output  logic       cs_n=1,
    output  logic       sclk=0,
    input   logic       sdi,     // sdo from ad7946.
    //
    output  logic       ch0_dv=0, ch1_dv=0,
    output  logic[13:0] dout=0
);

    assign pden = 0;    
    
    // state counter
    localparam state_period = 19*4;
    logic[6:0] state_count = 0;
    always_ff @(posedge clk) begin
        if ((state_period-1) == state_count) begin
            state_count <= 0;
        end else begin
            state_count <= state_count + 1;
        end
    end
    
    logic pre_sclk;
    assign pre_sclk = ~state_count[1];
    
    logic pre_cs_n;
    assign pre_cs_n = ((state_count>=0)&&(state_count<10)) ? 1'b1 : 1'b0;        
    
    logic pre_chsel=0, pre_ch1_dv=0, pre_ch0_dv=0;
    always_ff @(posedge clk) begin
        if (13==state_count) pre_chsel <= ~pre_chsel;
        if ((65==state_count)&&(1==pre_chsel)) pre_ch1_dv=1; else pre_ch1_dv=0;
        if ((65==state_count)&&(0==pre_chsel)) pre_ch0_dv=1; else pre_ch0_dv=0;
        ch0_dv <= pre_ch0_dv;
        ch1_dv <= pre_ch1_dv;
    end    
        

    logic sdi_reg;
    always_ff @(posedge clk) begin    
        // registers to go in the IO Logic
        chsel <= pre_chsel;
        cs_n  <= pre_cs_n;
        sclk  <= pre_sclk;
        sdi_reg <= sdi;
    end

    // shift and latch data
    logic[15:0] shift_reg=0, pre_sclk_reg=0;
    always_ff @(posedge clk) begin
        pre_sclk_reg <= pre_sclk;
        if ((1==pre_sclk) && (0==pre_sclk_reg)) begin
            shift_reg[0] <= sdi_reg;
            shift_reg[15:1] <= shift_reg[14:0];
        end
        if (65==state_count) begin
            dout <= shift_reg;
        end 
    end

endmodule


