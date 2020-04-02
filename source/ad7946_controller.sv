//
module ad7946_controller (
    input   logic       clk,    // 100MHz axi clock.
    output  logic       pden,
    output  logic       chsel,
    output  logic       cs_n=1,
    output  logic       sclk=0,
    input   logic       sdi     // sdo from ad7946.
);

    assign pden = 0;
    
    // registers to go in the IO Logic
    logic pre_chsel=0, pre_cs_n=0, pre_sclk=0, sdi_reg;
    always_ff @(posedge clk) begin
        chsel <= pre_chsel;
        cs_n  <= pre_cs_n;
        sclk  <= pre_sclk;
        sdi_reg <= sdi;
    end
    
    // state machine
    logic[2:0] state=0;
    logic bit_count_reset=1, bit_count_ena=0;
    logic shift_ena=0, shift_latch=0;
    always_ff @(posedge clk) begin
        // defaults
        bit_count_reset <= 0;
        bit_count_ena <= 0;
        shift_ena <= 0;
        shift_latch <= 0;
        case (state)
        
            0: begin
                state <= 1;
                pre_cs_n <= 1;
                bit_count_reset <= 1;
                pre_chsel <= 0;
            end
            
            1: begin
                state <= 2;
                bit_count_ena <= 1;
            end
            
            2: begin
                state <= 3;
            end
            
            3: begin
                state <= 0;
            end
            
            default: begin
                state <= 0;
            end
            
        endcase
    
    end
    
   
    // bit counter
    logic[3:0] bit_count=15;
    always_ff @(posedge clk) begin
        if (1==bit_count_reset) begin
            bit_count <= 15;
        end else begin
            if (1==bit_count_ena) begin
                bit_count <= bit_count - 1;
            end
        end
    end
    
    
    // shift and latch data
    logic[15:0] shift_reg=0, data_reg=0;
    always_ff @(posedge clk) begin
        if (1==shift_ena) begin
            shift_reg[0] <= sdi_reg;
            shift_reg[15:1] <= shift_reg[14:0];
            if (0==bit_count) begin
                data_reg <= shift_reg;
            end 
        end
    end
    
      

endmodule