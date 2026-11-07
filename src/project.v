`default_nettype none

// Change the module name!
module tt_um_uwasic_onboarding_houtao_liu(
   
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,

    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
)

  // Add this inside the module block
  assign uio_oe = 8'hFF; // Set all IOs to output
  
  // Create wires to refer to the values of the registers
  wire [7:0] en_reg_out_7_0;
  wire [7:0] en_reg_out_15_8;
  wire [7:0] en_reg_pwm_7_0;
  wire [7:0] en_reg_pwm_15_8;
  wire [7:0] pwm_duty_cycle;

  //wire for spi
  wire sclk = ui_in[0];
  wire copi = ui_in[1];
  wire cs_n = ui_in[2];

  // Instantiate the PWM module
  pwm_peripheral pwm_peripheral_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en_reg_out_7_0(en_reg_out_7_0),
    .en_reg_out_15_8(en_reg_out_15_8),
    .en_reg_pwm_7_0(en_reg_pwm_7_0),
    .en_reg_pwm_15_8(en_reg_pwm_15_8),
    .pwm_duty_cycle(pwm_duty_cycle),
    .out({uio_out, uo_out})
  );

  // Instantiate the SPI module
  spi_peripheral spi_peripheral_inst (
    .clk(clk),
    .rst_n(rst_n),
    .sclk(sclk),
    .cs_n(cs_n),
    .copi(copi),
    .en_reg_out_7_0(en_reg_out_7_0),
    .en_reg_out_15_8(en_reg_out_15_8),
    .en_reg_pwm_7_0(en_reg_pwm_7_0),
    .en_reg_pwm_15_8(en_reg_pwm_15_8),
    .pwm_duty_cycle(pwm_duty_cycle)
  );
  // Add uio_in and ui_in[7:3] to the list of unused signals:
  wire _unused = &{ena, ui_in[7:3], uio_in, 1'b0};

endmodule

`default_nettype wire

