onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fp_divide_opt

do {wave.do}

view wave
view structure
view signals

do {fp_divide.udo}

run -all

quit -force
