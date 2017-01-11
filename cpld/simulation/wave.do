onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb/DUT/aya8
add wave -noupdate /tb/DUT/aya9_n
add wave -noupdate /tb/DUT/aybc1
add wave -noupdate /tb/DUT/aybc2
add wave -noupdate /tb/DUT/aybdir
add wave -noupdate -radix hexadecimal /tb/DUT/ayd
add wave -noupdate /tb/DUT/ayres_n
add wave -noupdate /tb/DUT/conf
add wave -noupdate /tb/DUT/confwr_n
add wave -noupdate -radix hexadecimal /tb/DUT/d
add wave -noupdate /tb/DUT/enable
add wave -noupdate /tb/DUT/fclk
add wave -noupdate /tb/DUT/mode_enable_saa
add wave -noupdate /tb/DUT/mode_enable_ymfm
add wave -noupdate -radix hexadecimal /tb/DUT/negsaacounter
add wave -noupdate -radix hexadecimal /tb/DUT/possaacounter
add wave -noupdate /tb/DUT/saaa0
add wave -noupdate /tb/DUT/saaclk
add wave -noupdate /tb/DUT/saacs_n
add wave -noupdate /tb/DUT/saawr_n
add wave -noupdate /tb/DUT/yma0
add wave -noupdate /tb/DUT/ymclk
add wave -noupdate -radix hexadecimal /tb/DUT/ymcounter
add wave -noupdate /tb/DUT/ymcs1_n
add wave -noupdate /tb/DUT/ymcs2_n
add wave -noupdate /tb/DUT/ymop1
add wave -noupdate /tb/DUT/ymop1d
add wave -noupdate /tb/DUT/ymop2
add wave -noupdate /tb/DUT/ymop2d
add wave -noupdate /tb/DUT/ymrd_n
add wave -noupdate /tb/DUT/ymwr_n
add wave -noupdate -divider {{New Divider}}
add wave -noupdate /tb/rst_n
add wave -noupdate /tb/fclk
add wave -noupdate /tb/aya8
add wave -noupdate /tb/aya9_n
add wave -noupdate /tb/aybc2
add wave -noupdate -radix hexadecimal /tb/d
add wave -noupdate /tb/mode_enable_saa
add wave -noupdate /tb/mode_enable_ymfm
add wave -noupdate /tb/zclk
add wave -noupdate -radix hexadecimal /tb/zaddr
add wave -noupdate /tb/mreq_n
add wave -noupdate /tb/iorq_n
add wave -noupdate /tb/rd_n
add wave -noupdate /tb/wr_n
add wave -noupdate -radix hexadecimal /tb/zdata
add wave -noupdate -radix hexadecimal /tb/zdout
add wave -noupdate /tb/zdena
add wave -noupdate /tb/aybc1
add wave -noupdate /tb/aybdir
add wave -noupdate /tb/saaa0
add wave -noupdate /tb/saaclk
add wave -noupdate /tb/saacs_n
add wave -noupdate /tb/saawr_n
add wave -noupdate /tb/seed
add wave -noupdate /tb/yma0
add wave -noupdate /tb/ymclk
add wave -noupdate /tb/ymcs1_n
add wave -noupdate /tb/ymcs2_n
add wave -noupdate /tb/ymop1
add wave -noupdate /tb/ymop1d
add wave -noupdate /tb/ymop2
add wave -noupdate /tb/ymop2d
add wave -noupdate /tb/ymrd_n
add wave -noupdate /tb/ymwr_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9660637 ps} 0} {{Cursor 2} {9732065 ps} 0}
configure wave -namecolwidth 242
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 70
configure wave -griddelta 10
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1312500 ps}
