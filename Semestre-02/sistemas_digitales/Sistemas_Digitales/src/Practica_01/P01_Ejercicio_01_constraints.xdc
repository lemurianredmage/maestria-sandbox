# Switches
set_property PACKAGE_PIN W5 [ get_ports clk]
    set_property IOSTANDARD LVCMOS33 [ get_ports clk]
set_property PACKAGE_PIN R2 [ get_ports reset]
    set_property IOSTANDARD LVCMOS33 [ get_ports reset]
    
# Display LEDs
set_property PACKAGE_PIN U7 [ get_ports {seg[6]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {seg[6]}]    
set_property PACKAGE_PIN V5 [ get_ports {seg[5]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {seg[5]}]
set_property PACKAGE_PIN U5 [ get_ports {seg[4]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {seg[4]}]
set_property PACKAGE_PIN V8 [ get_ports {seg[3]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {seg[3]}]
set_property PACKAGE_PIN U8 [ get_ports {seg[2]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {seg[2]}]
set_property PACKAGE_PIN W6 [ get_ports {seg[1]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {seg[1]}]
set_property PACKAGE_PIN W7 [ get_ports {seg[0]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {seg[0]}]
    
# Display Anodos
set_property PACKAGE_PIN W4 [ get_ports {an[3]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {an[3]}]
set_property PACKAGE_PIN V4 [ get_ports {an[2]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {an[2]}]
set_property PACKAGE_PIN U4 [ get_ports {an[1]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {an[1]}]
set_property PACKAGE_PIN U2 [ get_ports {an[0]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {an[0]}]

set_property PACKAGE_PIN W3 [ get_ports {count_out[3]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {count_out[3]}]
set_property PACKAGE_PIN V3 [ get_ports {count_out[2]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {count_out[2]}]
set_property PACKAGE_PIN V13 [ get_ports {count_out[1]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {count_out[1]}]
set_property PACKAGE_PIN V14 [ get_ports {count_out[0]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {count_out[0]}]