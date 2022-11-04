onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fp_accumulator_opt

do {wave.do}

view wave
view structure
view signals

do {fp_accumulator.udo}

run -all

quit -force
