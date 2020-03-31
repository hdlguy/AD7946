module ad7946_tb ();

    logic       pden;
    logic       chsel;
    logic       cs_n;
    logic       sclk;
    logic       sdo;
    logic       reset;


    localparam clk_period = 10; logic clk = 0; always #(clk_period/2) clk = ~clk;

    ad7946 ad7946_inst (.pden(pden), .chsel(chsel), .cs_n(cs_n), .sclk(sclk), .sdo(sdo));
    
    ad7946_controller ad7946_controller_inst (.clk(clk), .pden(pden), .chsel(chsel), .cs_n(cs_n), .sclk(sclk), .sdi(sdo));

    initial begin
        reset = 1;
        #(clk_period*10);
        reset = 0;
    end

endmodule

