vmap unisim /opt/Xilinx/iselib/unisim
vmap xilinxcorelib /opt/Xilinx/iselib/XilinxCoreLib
vmap xilinxcorelib_ver /opt/Xilinx/iselib/XilinxCoreLib_ver

vlib ddr2_controller
vmap ddr2_controller ddr2_controller

vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/parameter.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/unisim.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/r_w_dly.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/mybufg.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/iobs_72bit.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/infrastructure_top.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/infrastructure_iobs_72bit.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/infrastructure.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/dqs_delay.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/ddr_dqs_iob.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/ddr_dq_iob.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/ddr2_transfer_done.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/ddr2_dqs_div.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/ddr2_dqbit.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/ddr2_dm_72bit.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/ddr2_controller.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/ddr2_cntrl_72bit_rl.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/dcmx3y0_2vp70_sim.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/data_write_72bit.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/data_read_controller_72bit_rl.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/data_read_72bit_rl.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/data_path_rst.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/data_path_iobs_72bit.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/data_path_72bit_rl.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/controller_iobs.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/controller.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/clk_dcm.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/cal_top.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/cal_reg.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/cal_div2f.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/cal_div2.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/cal_ctl.vhd
vcom -93 -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/vhdl/RAM_8D.vhd
vlog +incdir+../../pcores/ddr2_controller_v1_00_a/hdl/verilog -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/verilog/ddr2.v
vlog +incdir+../../pcores/ddr2_controller_v1_00_a/hdl/verilog/sim -work ddr2_controller ../../pcores/ddr2_controller_v1_00_a/hdl/verilog/ddr2dimm.v
