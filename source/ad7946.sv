// This module emulates the TI AD7946 ADC for the purposes of digital simulation of the controller.
// based on: SBAS539B – JUNE 2011 – REVISED SEPTEMBER 2011
module ad7946 (
    input   logic       pden,
    input   logic       chsel,
    input   logic       cs_n,
    input   logic       sclk,
    output  logic       sdo
);

    assign sdo = 1;

endmodule


