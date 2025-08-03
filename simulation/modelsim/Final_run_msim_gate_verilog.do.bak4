transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {Final.vo}

vlog -vlog01compat -work work +incdir+D:/ThietkeHDL/FinalLab {D:/ThietkeHDL/FinalLab/cpu_pl_tb.v}

vsim -t 1ps -L cycloneii_ver -L gate_work -L work -voptargs="+acc"  cpu_pl_tb

add wave *
view structure
view signals
run -all
