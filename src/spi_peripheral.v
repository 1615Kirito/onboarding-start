`default_nettype none

module spi_peripheral (
    input  wire       clk,      // clock
    input  wire       rst_n,     // reset_n - low to reset

    input wire sclk,  // SPI clock
    input wire cs_n,  // SPI chip select (active low)
    input wire copi,  // SPI data in (controller to peripheral)
    
    output reg [7:0] en_reg_out_7_0,
    output reg [7:0] en_reg_out_15_8,
    output reg [7:0] en_reg_pwm_7_0,
    output reg [7:0] en_reg_pwm_15_8,
    output reg [7:0] pwm_duty_cycle

);
    // Synchronize the SPI signals to the clk domain
    reg [2:0] sclk_sync;
    reg [1:0] cs_n_sync;
    reg [1:0] copi_sync;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sclk_sync <= 3'b000;
            cs_n_sync <= 2'b11;
            copi_sync <= 2'b00;
        end else begin
            sclk_sync <= {sclk_sync[1:0], sclk};
            cs_n_sync <= {cs_n_sync[0], cs_n};
            copi_sync <= {copi_sync[0], copi};
        end
    end

    // SPI logics

    wire sclk_rising_edge = (sclk_sync[2:1] == 2'b01);

    // Shift register to capture incoming SPI data
    reg [14:0] spi_shift_reg;
    reg [4:0] bit_count;

    // SPI address split
    wire write_enable = spi_shift_reg[14]; // Assuming bit 14 is the write enable bit
    wire [6:0] spi_address = spi_shift_reg[13:7]; // Assuming bits 13:7 are the address bits
    wire [7:0] spi_data = {spi_shift_reg[6:0], copi_sync[1]};


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            spi_shift_reg <= 16'b0;
            bit_count <= 5'b0;

            en_reg_out_7_0 <= 8'b0;
            en_reg_out_15_8 <= 8'b0;
            en_reg_pwm_7_0 <= 8'b0;
            en_reg_pwm_15_8 <= 8'b0;
            pwm_duty_cycle <= 8'b0;

        end else if (cs_n_sync[1]) begin // Active when chip select is low
            
            spi_shift_reg <= 16'b0;
            bit_count <= 5'b0;
            
        end else if (sclk_rising_edge && bit_count < 5'd16) begin
            spi_shift_reg <= {spi_shift_reg[14:0], copi_sync[1]};
            bit_count <= bit_count + 1;

            // If we have received 16 bits, process the command
            if (bit_count == 5'd15) begin
                if (write_enable) begin
                    case (spi_address)
                        7'h00: en_reg_out_7_0 <= spi_data;
                        7'h01: en_reg_out_15_8 <= spi_data;
                        7'h02: en_reg_pwm_7_0 <= spi_data;
                        7'h03: en_reg_pwm_15_8 <= spi_data;
                        7'h04: pwm_duty_cycle <= spi_data;
                        default: ; // Do nothing for undefined addresses
                    endcase
                end
            end
        end
    end


endmodule

`default_nettype wire