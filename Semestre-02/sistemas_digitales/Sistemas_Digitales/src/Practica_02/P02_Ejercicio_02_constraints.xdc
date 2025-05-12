## Clock Signal (100MHz Clock)
set_property PACKAGE_PIN W5 [ get_ports clk]
    set_property IOSTANDARD LVCMOS33 [ get_ports clk]
set_property PACKAGE_PIN R2 [ get_ports rst]
    set_property IOSTANDARD LVCMOS33 [ get_ports rst]

## Pedestrian button (BTN1)
set_property PACKAGE_PIN B16 [get_ports btn_ped]
set_property IOSTANDARD LVCMOS33 [get_ports btn_ped]

set_property PACKAGE_PIN C16 [get_ports led_ped]
set_property IOSTANDARD LVCMOS33 [get_ports led_ped]

## Traffic Light Outputs mapped to JA connector (Pmod)
## Este-Oeste (EO) traffic light LEDs (using JA PMOD header)
## JA9 -> Green Light
set_property PACKAGE_PIN H2 [get_ports eo_green]
set_property IOSTANDARD LVCMOS33 [get_ports eo_green]

## JA8 -> Yellow Light
set_property PACKAGE_PIN K2 [get_ports eo_yellow]
set_property IOSTANDARD LVCMOS33 [get_ports eo_yellow]

## JA7 -> Red Light
set_property PACKAGE_PIN H1 [get_ports eo_red]
set_property IOSTANDARD LVCMOS33 [get_ports eo_red]

## Norte-Sur (NS) traffic light LEDs (using JB PMOD header)
# Green (JB9)
set_property PACKAGE_PIN A14 [get_ports ns_green]
set_property IOSTANDARD LVCMOS33 [get_ports ns_green]

# Yellow (JB10)
set_property PACKAGE_PIN A16 [get_ports ns_yellow]
set_property IOSTANDARD LVCMOS33 [get_ports ns_yellow]

# Red (JB7)
set_property PACKAGE_PIN B15 [get_ports ns_red]
set_property IOSTANDARD LVCMOS33 [get_ports ns_red]
