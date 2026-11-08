<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a SPI-Controlled PWM (Pulse Width Modulation) peripheral.

The SPI peripheral receives commands from an external controller and updates internal registers to configure the PWM outputs. The controller can enable or disable PWM channels and adjust the duty cycle through SPI write transactions.

The PWM module uses a clock divider of 13 and an 8-bit counter to generate periodic PWM signals. The duty cycle is controlled by an 8-bit register, allowing the output pulse width to be adjusted.

The PWM signals are routed to the output pins according to the output enable registers.

## How to test

The design is verified using Cocotb with the Icarus Verilog simulator.

Three tests are included:

SPI Test: Verifies SPI write transactions, register updates, and handling of invalid commands.

PWM Frequency Test: Measures the PWM period by detecting consecutive rising edges and verifies the expected frequency.

PWM Duty Cycle Test: Configures different duty cycle values through SPI and measures the percentage of clock cycles for which the PWM output is high.

To run the tests, navigate to the test directory and execute:

make

The simulator reports the results of each test as PASS or FAIL.

## External hardware

No external hardware is required for simulation. The design can be tested using Cocotb and Icarus Verilog.
