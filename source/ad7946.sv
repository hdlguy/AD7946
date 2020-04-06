// This module emulates the TI AD7946 ADC for the purposes of digital simulation of the controller.
// based on: "SBAS539B – JUNE 2011 – REVISED SEPTEMBER 2011"
module ad7946 (
    input   logic       pden,
    input   logic       chsel,
    input   logic       cs_n,
    input   logic       sclk,
    output  logic       sdo
);

    // emulate a data conversion on the falling edge of cs_n
    logic[11:0] data0=0, data1=0;
    logic[13:0] data;
    always_ff @(negedge cs_n) begin
        if (0==chsel) begin
            data0 <= data0 + 1;
        end else begin
            data1 <= data1 + 1;
        end
        if (1==chsel) begin       
            data <= {2'b01, data0};
        end else begin
            data <= {2'b00, data1};
        end
    end
    
    // shift register
    logic[15:0] sh_reg=0;
    always @(posedge sclk, posedge cs_n) begin
        if (1==cs_n) begin
            sh_reg <= {data, 2'b00};
        end else begin
            sh_reg[15:1] <= sh_reg[14:0]; // shift
            sh_reg[0] <= 0;
        end
    end
    
    always_ff @(negedge sclk) sdo <= sh_reg[15];

endmodule


