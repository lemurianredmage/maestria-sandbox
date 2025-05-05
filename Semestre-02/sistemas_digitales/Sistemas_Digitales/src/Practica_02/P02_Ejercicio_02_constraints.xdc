## Clock signal (100MHz clock on Basys 3)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## Reset button (BTN0)
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Pedestrian button (BTN1)
set_property PACKAGE_PIN T18 [get_ports btn_ped]
set_property IOSTANDARD LVCMOS33 [get_ports btn_ped]

## Este-Oeste (EO) traffic light LEDs (using JA PMOD header)
# Green (JA9)
set_property PACKAGE_PIN J4 [get_ports eo_green]
set_property IOSTANDARD LVCMOS33 [get_ports eo_green]

# Yellow (JA10)
set_property PACKAGE_PIN G3 [get_ports eo_yellow]
set_property IOSTANDARD LVCMOS33 [get_ports eo_yellow]

# Red (JA7)
set_property PACKAGE_PIN H4 [get_ports eo_red]
set_property IOSTANDARD LVCMOS33 [get_ports eo_red]

## Norte-Sur (NS) traffic light LEDs (using JB PMOD header)
# Green (JB9)
set_property PACKAGE_PIN D4 [get_ports ns_green]
set_property IOSTANDARD LVCMOS33 [get_ports ns_green]

# Yellow (JB10)
set_property PACKAGE_PIN D3 [get_ports ns_yellow]
set_property IOSTANDARD LVCMOS33 [get_ports ns_yellow]

# Red (JB7)
set_property PACKAGE_PIN E2 [get_ports ns_red]
set_property IOSTANDARD LVCMOS33 [get_ports ns_red]
