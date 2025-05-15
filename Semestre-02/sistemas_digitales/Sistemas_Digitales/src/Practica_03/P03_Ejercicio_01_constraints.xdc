# =========================
# Clock de sistema - 100 MHz
# =========================
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# =========================
# Pines del XADC
# =========================
# Entrada analógica (canal VP/VN)
set_property PACKAGE_PIN N1 [get_ports vp_in]
set_property IOSTANDARD LVCMOS33 [get_ports vp_in]

set_property PACKAGE_PIN A14 [get_ports vn_in]
set_property IOSTANDARD LVCMOS33 [get_ports vn_in]

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
set_property IOSTANDARD LVCMOS33 [get_ports seg[*]]

# Ánodos (an0-an3)
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports an[*]]