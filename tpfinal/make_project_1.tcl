# ==================================================================================================
# make_project_1.tcl
#
# Simple script for creating a Vivado project from the project/ folder 
# Based on Pavel Demin's red-pitaya-notes-master/ git project
#
# Make sure the script is executed from redpitaya_guide/ folder
#
# by Anton Potocnik, 02.10.2016 - 14.12.2017
# by Anton Potocnik, 01.01.2021 - 03.03.2021
# ==================================================================================================

set project_name "1_led_blink"

source projects/$project_name/block_design.tcl
