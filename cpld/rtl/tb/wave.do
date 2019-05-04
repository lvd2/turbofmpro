onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/zclk
add wave -noupdate -radix hexadecimal /tb/DUT/ayd
add wave -noupdate -radix hexadecimal /tb/DUT/d
add wave -noupdate /tb/iorq_n
add wave -noupdate /tb/rd_n
add wave -noupdate /tb/wr_n
add wave -noupdate /tb/DUT/ayres_n
add wave -noupdate /tb/DUT/aybc1
add wave -noupdate /tb/DUT/aybdir
add wave -noupdate /tb/DUT/aybc2
add wave -noupdate /tb/DUT/aya8
add wave -noupdate /tb/DUT/aya9_n
add wave -noupdate /tb/DUT/fclk
add wave -noupdate /tb/DUT/ymcs1_n
add wave -noupdate /tb/DUT/ymcs2_n
add wave -noupdate /tb/DUT/ymrd_n
add wave -noupdate /tb/DUT/ymwr_n
add wave -noupdate /tb/DUT/yma0
add wave -noupdate /tb/DUT/saacs_n
add wave -noupdate /tb/DUT/saawr_n
add wave -noupdate /tb/DUT/saaa0
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb/DUT/cfg/ym_sel
add wave -noupdate /tb/DUT/cfg/ym_stat
add wave -noupdate /tb/DUT/cfg/saa_sel
add wave -noupdate /tb/DUT/cfg/fm_dac_ena
add wave -noupdate /tb/DUT/cfg/cfg_port
add wave -noupdate -divider {{New Divider}}
add wave -noupdate /tb/DUT/bus/clk
add wave -noupdate /tb/DUT/bus/rst_n
add wave -noupdate /tb/DUT/bus/aybc1
add wave -noupdate /tb/DUT/bus/aybc2
add wave -noupdate /tb/DUT/bus/aybdir
add wave -noupdate /tb/DUT/bus/aya8
add wave -noupdate /tb/DUT/bus/aya9_n
add wave -noupdate -radix hexadecimal /tb/DUT/bus/ayd
add wave -noupdate -radix hexadecimal /tb/DUT/bus/d
add wave -noupdate /tb/DUT/bus/wr_port
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix unsigned /tb/DUT/bus/ym_ctr
add wave -noupdate /tb/DUT/bus/yma0
add wave -noupdate /tb/DUT/bus/ymcs0_n
add wave -noupdate /tb/DUT/bus/ymcs1_n
add wave -noupdate /tb/DUT/bus/ymrd_n
add wave -noupdate /tb/DUT/bus/ymwr_n
add wave -noupdate -divider {{{{New Divider}}}}
add wave -noupdate -radix unsigned /tb/DUT/bus/saa_ctr
add wave -noupdate /tb/DUT/bus/saaa0
add wave -noupdate /tb/DUT/bus/saacs_n
add wave -noupdate /tb/DUT/bus/saawr_n
add wave -noupdate -divider {{{New Divider}}}
add wave -noupdate /tb/DUT/bus/ym_sel
add wave -noupdate /tb/DUT/bus/ym_stat
add wave -noupdate /tb/DUT/bus/saa_sel
add wave -noupdate -divider {{New Divider}}
add wave -noupdate /tb/DUT/bus/decode_wraddr
add wave -noupdate /tb/DUT/bus/async_wrport
add wave -noupdate /tb/DUT/bus/async_wraddr
add wave -noupdate /tb/DUT/bus/async_wrdata
add wave -noupdate /tb/DUT/bus/async_rddata
add wave -noupdate /tb/DUT/bus/wrport
add wave -noupdate /tb/DUT/bus/wraddr
add wave -noupdate /tb/DUT/bus/wrdata
add wave -noupdate /tb/DUT/bus/rddata
add wave -noupdate /tb/DUT/bus/wrport_on
add wave -noupdate /tb/DUT/bus/wraddr_on
add wave -noupdate /tb/DUT/bus/wrdata_on
add wave -noupdate /tb/DUT/bus/rddata_on
add wave -noupdate /tb/DUT/bus/wraddr_beg
add wave -noupdate /tb/DUT/bus/wrdata_beg
add wave -noupdate /tb/DUT/bus/rddata_beg
add wave -noupdate /tb/DUT/bus/wrport_beg
add wave -noupdate -radix hexadecimal /tb/DUT/bus/write_latch
add wave -noupdate -radix hexadecimal /tb/DUT/bus/read_latch
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb/portcfg
add wave -noupdate /tb/mode_enable_saa
add wave -noupdate /tb/mode_enable_ymfm
add wave -noupdate -divider {{New Divider}}
add wave -noupdate /tb/ym2/cs_n
add wave -noupdate /tb/ym2/rd_n
add wave -noupdate /tb/ym2/wr_n
add wave -noupdate /tb/ym2/a0
add wave -noupdate -radix hexadecimal /tb/ym2/d
add wave -noupdate -radix hexadecimal /tb/ym2/rddat
add wave -noupdate -radix hexadecimal /tb/ym2/rdstat
add wave -noupdate -radix hexadecimal /tb/ym2/adr
add wave -noupdate -radix hexadecimal /tb/ym2/wrdat
add wave -noupdate /tb/ym2/int_a0
add wave -noupdate /tb/ym2/wr_stb_n
add wave -noupdate -divider {{{New Divider}}}
add wave -noupdate /tb/DUT/saaclk
add wave -noupdate /tb/DUT/ymclk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {67515000 ps} 0}
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 200
configure wave -griddelta 10
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {115500 us}
