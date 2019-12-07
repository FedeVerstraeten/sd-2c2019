# ArtyZ7-10 xdc

# CLK source 125 MHz
set_property -dict { PACKAGE_PIN H16    IOSTANDARD LVCMOS33 } [get_ports { sys_clk_pin }];

# Reset button
set_property -dict { PACKAGE_PIN L19    IOSTANDARD LVCMOS33 } [get_ports { reset }]; 

# UART input
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { rxd_pin }]; #IO_L5P_T0_34 Sch=CK_IO0
# VGA ouput
# Vertical signal
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { vsync }]; 

# Horizontal signal
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { hsync }]; 

# RGB output pin
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { rgb[2] }]; 
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { rgb[2] }]; 
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { rgb[2] }]; 
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { rgb[2] }]; 

set_property -dict { PACKAGE_PIN Y14   IOSTANDARD LVCMOS33 } [get_ports { rgb[1] }]; 
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { rgb[1] }]; 
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { rgb[1] }]; 
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { rgb[1] }]; 

set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { rgb[0] }]; 
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports { rgb[0] }]; 
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { rgb[0] }]; 
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { rgb[0] }];

 