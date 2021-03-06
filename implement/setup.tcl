# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj 
set_property part xc7a35ticsg324-1L [current_project]
#set_property board_part digilentinc.com:arty-a7-35:part0:1.0 [current_project]
set_property target_language verilog [current_project]
set_property default_lib work [current_project]
load_features ipintegrator
tclapp::install ultrafast -quiet

read_ip ../source/adc_ila/adc_ila.xci
read_ip ../source/artix_clock_wiz/artix_clock_wiz.xci
#upgrade_ip -quiet  [get_ips *]
#generate_target {all} [get_ips *]


read_verilog -sv [glob ../source/arty_top.sv]
read_verilog -sv [glob ../source/ad7946_controller.sv]
read_verilog -sv [glob ../source/ad7946.sv]
read_xdc ../source/arty_top.xdc

#read_xdc ../..//source/arty_top_late.xdc
#set_property used_in_synthesis false [get_files  ../../source/arty_top_late.xdc]

close_project


