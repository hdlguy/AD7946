module artix_top (
    input  logic       clk_in,
    output logic [7:0] led
);

    assign led = 8'hfa;

    logic clk;
    artix_clock_wiz clock_wiz_inst(.clk100(clk), .locked(), .clk_in1(clk_in));

    logic       clk;
    logic       pden;
    logic       chsel;
    logic       cs_n;
    logic       sclk;
    logic       sdo;
    logic       ch0_dv, ch1_dv;
    logic[13:0] dout;

    ad7946 ad7946_inst (.pden(pden), .chsel(chsel), .cs_n(cs_n), .sclk(sclk), .sdo(sdo));
    ad7946_controller ad7946_controller_inst (.clk(clk), .pden(pden), .chsel(chsel), .cs_n(cs_n), .sclk(sclk), .sdi(sdo), .ch0_dv(ch0_dv), .ch1_dv(ch1_dv), .dout(dout) );
    adc_ila adc_ila_inst (.clk(clk), .probe0({pden, chsel, cs_n, sclk, sdo, ch0_dv, ch1_dv, dout})); // 21

endmodule

