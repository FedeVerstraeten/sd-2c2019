# ==================================================================================================
# block_design.tcl - Create Vivado Project - 1_led_blink
#
# This script should be run from the base redpitaya-guides/ folder inside Vivado tcl console.
#
# This script is modification of Pavel Demin's project.tcl and block_design.tcl files
# by Anton Potocnik, 02.10.2016
#
# # This script is modification of apotocnik/redpitaya_guide project using VHDL source codes
# by Federico Verstraeten, 20.02.2022
# ==================================================================================================


#set project_name 1_led_blink
set part_name xc7z010clg400-1
set bd_path tmp/$project_name/$project_name.srcs/sources_1/bd/system


file delete -force tmp/$project_name

create_project $project_name tmp/$project_name -part $part_name

create_bd_design system
# open_bd_design {$bd_path/system.bd}

# Load RedPitaya ports
source cfg/ports.tcl

# Set Path for the custom IP cores
set_property IP_REPO_PATHS tmp/cores [current_project]
update_ip_catalog

# Load any additional Verilog files in the project folder
set files [glob -nocomplain projects/$project_name/*.v projects/$project_name/*.sv]
if {[llength $files] > 0} {
  add_files -norecurse $files
}

# Load any additional VHDL files in the project folder
set files [glob -nocomplain projects/$project_name/*.vhd]
if {[llength $files] > 0} {
  import_files -norecurse $files
  # add_files -norecurse 
}

# Zynq processing system with RedPitaya specific preset
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7 processing_system7_0
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.PCW_IMPORT_BOARD_PRESET {cfg/red_pitaya.xml}] [get_bd_cells processing_system7_0]
endgroup

# Buffers for differential IOs
startgroup
# create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf util_ds_buf_0
# set_property -dict [list CONFIG.C_SIZE {2}] [get_bd_cells util_ds_buf_0]

create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf util_ds_buf_1
set_property -dict [list CONFIG.C_SIZE {2}] [get_bd_cells util_ds_buf_1]

create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf util_ds_buf_2
set_property -dict [list CONFIG.C_SIZE {2}] [get_bd_cells util_ds_buf_2]
set_property -dict [list CONFIG.C_BUF_TYPE {OBUFDS}] [get_bd_cells util_ds_buf_2]
endgroup

# We will use all LEDs
set_property LEFT 7 [get_bd_ports led_o]

# Add two rtl modules - leds VHDL
startgroup
create_bd_cell -type module -reference led1 led1_0
endgroup

# Set as top led1
update_compile_order -fileset sources_1
set_property top led1 [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
set_property top_arch Behavioral [get_filesets sim_1]
set_property top_file tmp/$project_name/$project_name.srcs/sources_1/new/leds.vhd [get_filesets sim_1]
reset_run synth_1

# ====================================================================================
# Connections 

# connect_bd_net [get_bd_ports adc_clk_p_i] [get_bd_pins util_ds_buf_0/IBUF_DS_P]
# connect_bd_net [get_bd_ports adc_clk_n_i] [get_bd_pins util_ds_buf_0/IBUF_DS_N]
connect_bd_net [get_bd_ports daisy_p_i] [get_bd_pins util_ds_buf_1/IBUF_DS_P]
connect_bd_net [get_bd_ports daisy_n_i] [get_bd_pins util_ds_buf_1/IBUF_DS_N]
connect_bd_net [get_bd_ports daisy_p_o] [get_bd_pins util_ds_buf_2/OBUF_DS_P]
connect_bd_net [get_bd_ports daisy_n_o] [get_bd_pins util_ds_buf_2/OBUF_DS_N]
connect_bd_net [get_bd_pins util_ds_buf_1/IBUF_OUT] [get_bd_pins util_ds_buf_2/OBUF_IN]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]


connect_bd_net [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0]

# input/output RTL module led1_0
connect_bd_net [get_bd_pins led1_0/ent] [get_bd_pins exp_p_tri_io]
connect_bd_net [get_bd_pins led1_0/sal] [get_bd_pins led_o]
connect_bd_net [get_bd_pins led1_0/clk] [get_bd_pins processing_system7_0/FCLK_CLK0]
# ====================================================================================
# Generate output products and wrapper, add constraint any any additional files 

generate_target all [get_files  $bd_path/system.bd]

make_wrapper -files [get_files $bd_path/system.bd] -top
add_files -norecurse $bd_path/hdl/system_wrapper.v

# Load RedPitaya constraint files
set files [glob -nocomplain cfg/*.xdc]
if {[llength $files] > 0} {
  add_files -norecurse -fileset constrs_1 $files
}

set_property VERILOG_DEFINE {TOOL_VIVADO} [current_fileset]
set_property STRATEGY Flow_PerfOptimized_High [get_runs synth_1]
set_property STRATEGY Performance_NetDelay_high [get_runs impl_1]

