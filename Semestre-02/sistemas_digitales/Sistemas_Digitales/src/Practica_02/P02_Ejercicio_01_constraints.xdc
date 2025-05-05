## Clock Signal (100MHz Clock)
set_property PACKAGE_PIN W5 [ get_ports clk]
    set_property IOSTANDARD LVCMOS33 [ get_ports clk]
set_property PACKAGE_PIN R2 [ get_ports reset]
    set_property IOSTANDARD LVCMOS33 [ get_ports reset]

## Traffic Light Outputs mapped to JA connector (Pmod)
## JA9 -> Green Light
set_property PACKAGE_PIN H2 [get_ports green_light]
set_property IOSTANDARD LVCMOS33 [get_ports green_light]

## JA8 -> Yellow Light
set_property PACKAGE_PIN K2 [get_ports yellow_light]
set_property IOSTANDARD LVCMOS33 [get_ports yellow_light]

## JA7 -> Red Light
set_property PACKAGE_PIN H1 [get_ports red_light]
set_property IOSTANDARD LVCMOS33 [get_ports red_light]

## (Optional) - Force output drive strength if needed
#set_property DRIVE 12 [get_ports {green_light yellow_light red_light}]
#set_property SLEW FAST [get_ports {green_light yellow_light red_light}]