## Clock Signal (100MHz Clock)
set_property PACKAGE_PIN W5 [get_ports clk]
create_clock -period 10.0 -name sys_clk -waveform {0 5} [get_ports clk]

## Reset Button (por ejemplo BTN0)
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Traffic Light Outputs mapped to JA connector (Pmod)
## JA9 -> Green Light
set_property PACKAGE_PIN D4 [get_ports green_light]
set_property IOSTANDARD LVCMOS33 [get_ports green_light]

## JA8 -> Yellow Light
set_property PACKAGE_PIN C4 [get_ports yellow_light]
set_property IOSTANDARD LVCMOS33 [get_ports yellow_light]

## JA7 -> Red Light
set_property PACKAGE_PIN C5 [get_ports red_light]
set_property IOSTANDARD LVCMOS33 [get_ports red_light]

## (Optional) - Force output drive strength if needed
#set_property DRIVE 12 [get_ports {green_light yellow_light red_light}]
#set_property SLEW FAST [get_ports {green_light yellow_light red_light}]