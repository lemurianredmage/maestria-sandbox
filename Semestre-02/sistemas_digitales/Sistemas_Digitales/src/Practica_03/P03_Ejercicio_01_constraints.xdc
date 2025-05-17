# =========================
# Clock de sistema - 100 MHz
# =========================
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN R2 [ get_ports rst]
    set_property IOSTANDARD LVCMOS33 [ get_ports rst]
set_property PACKAGE_PIN V17 [ get_ports sw]
    set_property IOSTANDARD LVCMOS33 [ get_ports sw]

# =========================
# Pines del XADC
# =========================
# Entrada analógica (canal VP/VN)
set_property PACKAGE_PIN H1 [get_ports {ja[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ja[0]}]

set_property PACKAGE_PIN K2 [get_ports {ja[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ja[1]}]

set_property PACKAGE_PIN H2 [get_ports {ja[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ja[2]}]

set_property PACKAGE_PIN G3 [get_ports {ja[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ja[3]}]

set_property PACKAGE_PIN J1 [get_ports {ja[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ja[4]}]

set_property PACKAGE_PIN L2 [get_ports {ja[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ja[5]}]

set_property PACKAGE_PIN J2 [get_ports {ja[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ja[6]}]

set_property PACKAGE_PIN G2 [get_ports {ja[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ja[7]}]

# =========================
# Displays de 7 segmentos
# =========================

# Segmentos (a, b, c, d, e, f, g)
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
set_property PACKAGE_PIN V7 [get_ports {seg[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports seg[*]]

# Ánodos (an0-an3)
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports an[*]]


# Display LEDs
set_property PACKAGE_PIN L1 [ get_ports {led[15]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[15]}]
set_property PACKAGE_PIN P1 [ get_ports {led[14]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[14]}]
set_property PACKAGE_PIN N3 [ get_ports {led[13]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[13]}]
set_property PACKAGE_PIN P3 [ get_ports {led[12]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[12]}]

set_property PACKAGE_PIN U3 [ get_ports {led[11]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[11]}]
set_property PACKAGE_PIN W3 [ get_ports {led[10]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[10]}]
set_property PACKAGE_PIN V3 [ get_ports {led[9]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[9]}]
set_property PACKAGE_PIN V13 [ get_ports {led[8]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[8]}]

set_property PACKAGE_PIN V14 [ get_ports {led[7]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[7]}]
set_property PACKAGE_PIN U14 [ get_ports {led[6]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[6]}]
set_property PACKAGE_PIN U15 [ get_ports {led[5]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[5]}]
set_property PACKAGE_PIN W18 [ get_ports {led[4]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[4]}]

set_property PACKAGE_PIN V19 [ get_ports {led[3]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[3]}]
set_property PACKAGE_PIN U19 [ get_ports {led[2]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[2]}]
set_property PACKAGE_PIN E19 [ get_ports {led[1]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[1]}]
set_property PACKAGE_PIN V16 [ get_ports {led[0]}]
    set_property IOSTANDARD LVCMOS33 [ get_ports {led[0]}]