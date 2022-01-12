;--------------------------------------------------------------------
; Описание: Модуль отображения анализатора
; Автор порта: Тарасов М.Н.(Mick),2011
;--------------------------------------------------------------------

;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_update:
		ld	hl,EAmplitude_ch0

		ld	a,(hl)				;+00h - Amplitude 0 right/left
		and	0Fh
		ld	c,a
		ld	a,(hl)				;+00h - Amplitude 0 right/left				
		and	0F0h
		rrca	
		rrca	
		rrca
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch0
		ld	a,c	
Analyzer_up_ch0:
		ld	(Analyzer_ch0_vol),a          	;Amplitude 0

		inc	hl
		ld	a,(hl)				;+01h - Amplitude 1 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)				;+01h - Amplitude 1 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch1
		ld	a,c	
Analyzer_up_ch1:
		ld	(Analyzer_ch1_vol),a          	;Amplitude 1 

		inc	hl
		ld	a,(hl) 				;+02h - Amplitude 2 right/left
		and	0Fh
		ld	c,a
		ld	a,(hl)				;+02h - Amplitude 2 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch2
		ld	a,c	
Analyzer_up_ch2:
		ld	(Analyzer_ch2_vol),a         	;Amplitude 2  

		inc	hl
		ld	a, (hl) 			;+03h - Amplitude 3 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)                         ;+03h - Amplitude 3 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch3
		ld	a,c	
Analyzer_up_ch3:
		ld	(Analyzer_ch3_vol),a         	;Amplitude 3  

		inc	hl
		ld	a, (hl)				;+04h - Amplitude 4 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch4
		ld	a,c	
Analyzer_up_ch4:
		ld	(Analyzer_ch4_vol),a          ;Amplitude 4  

		inc	hl
		ld	a, (hl)				;+05h - Amplitude 5 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch5
		ld	a,c	
Analyzer_up_ch5:
		ld	(Analyzer_ch5_vol),a		;Amplitude 5  
		ret
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_flash:
		ld	a,(Analyzer_ch0_vol)
		ld	e,a
		ld	a,(Analyzer_ch3_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,58C6h
		ld	(hl),a
		inc	l
		ld	(hl),a

		ld	a,(Analyzer_ch1_vol)
		ld	e,a
		ld	a,(Analyzer_ch4_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,58DCh
		ld	(hl),a
		inc	l
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a

		ld	a,(Analyzer_ch2_vol)
		ld	e,a
		ld	a,(Analyzer_ch5_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5AEAh
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a

		ret

;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_init:
              	ld	b, 6
		ld	hl,Analyzer_ch0_vol

Analyzer_init_loop:
                ld	(hl),0
		inc	hl
		djnz	Analyzer_init_loop
		ret
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view:
		ld	a,(Analyzer_ch5_vol)
		ld	de,Analyzer_phase_mask
		ld	h,0
		ld	l,a
		add	hl,de
		ld	l,(hl)
		ld	h,0
		add	hl,hl
		ld	de,Analyzer_addr_ch6
		add	hl,de
		ld	c,(hl)			;адрес блока данных
		inc	hl
		ld	b,(hl)

		ld	a,(Analyzer_ch4_vol)
		ld	de,Analyzer_phase_mask
		ld	h,0
		ld	l,a
		add	hl,de
		ld	l,(hl)
		ld	h,0
		ld	de,Analyzer_addr_ch5
		add	hl,de
		ld	l,(hl)
		ld	h,0
		add	hl,bc			; добавим смещение среднего
		ld	b,h
		ld	c,l

		ld	a,(Analyzer_ch3_vol)
		ld	de,Analyzer_phase_mask
		ld	h,0
		ld	l,a
		add	hl,de
		ld	a,(hl)
		ld	l,a
		add	a,a
		add	a,l
		ld	l,a
		ld	h,0
		add	hl,bc			;добавим смещение младшего
		ex	hl,de
		ld	hl,48f9h
		ld	(Analyzer_draw_0 +1),hl
		ld	hl,5019h
		ld	(Analyzer_draw_1 +1),hl
		ld	l,38h
		ld	(Analyzer_draw_2 +1),hl
		ld	l,58h
		ld	(Analyzer_draw_3 +1),hl
		ld	l,77h
		ld	(Analyzer_draw_4 +1),hl
		ld	l,97h
		ld	(Analyzer_draw_5 +1),hl
		ld	l,0B6h
		ld	(Analyzer_draw_6 +1),hl
		ex	hl,de
		call	Analyzer_draw

		ld	a,(Analyzer_ch0_vol)
		ld	de,Analyzer_phase_mask
		ld	h,0
		ld	l,a
		add	hl,de
		ld	l,(hl)
		ld	h,0
		add	hl,hl
		ld	de,Analyzer_addr_ch1
		add	hl,de
		ld	c,(hl)			;адрес блока данных
		inc	hl
		ld	b,(hl)

		ld	a,(Analyzer_ch1_vol)
		ld	de,Analyzer_phase_mask
		ld	h,0
		ld	l,a
		add	hl,de
		ld	l,(hl)
		ld	h,0
		ld	de,Analyzer_addr_ch5
		add	hl,de
		ld	l,(hl)
		ld	h,0
		add	hl,bc			; добавим смещение среднего
		ld	b,h
		ld	c,l

		ld	a,(Analyzer_ch2_vol)
		ld	de,Analyzer_phase_mask
		ld	h,0
		ld	l,a
		add	hl,de
		ld	a,(hl)
		ld	l,a
		add	a,a
		add	a,l
		ld	l,a
		ld	h,0
		add	hl,bc			;добавим смещение младшего
		ex	hl,de
		ld	hl,48E5h
		ld	(Analyzer_draw_0 +1),hl
		ld	hl,5005h
		ld	(Analyzer_draw_1 +1),hl
		ld	l,25h
		ld	(Analyzer_draw_2 +1),hl
		ld	l,45h
		ld	(Analyzer_draw_3 +1),hl
		ld	l,65h
		ld	(Analyzer_draw_4 +1),hl
		ld	l,85h
		ld	(Analyzer_draw_5 +1),hl
		ld	l,0A5h
		ld	(Analyzer_draw_6 +1),hl
		ex	hl,de
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw:
		ld	a,(hl)
		ld	bc,7FFDh
		out	(c),a
		inc	hl
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
	
Analyzer_draw_0:
		ld	de,48f9h
		ldi                            	;48f9
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;49f9
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;4Af9
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;4bf9
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;4cf9
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;4df9
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;4ef9
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;4ff9
		ldi	

Analyzer_draw_1:
		ld	de,5019h
		ldi                            	;5019
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;5119
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;5219
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;5319
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;5419
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;5519
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;5619
		ldi	
		dec	e
		dec	e
		inc	d
		ldi                             ;5719
		ldi	

Analyzer_draw_2:
		ld	de,5038h
		ldi                            	;5038
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5138
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5238
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5338
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5438
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5538
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5638
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5738
		ldi	
		ldi	

Analyzer_draw_3:
		ld	de,5058h
		ldi                            	;5058
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5158
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5258
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5358
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5458
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5558
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5658
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5758
		ldi	
		ldi	

Analyzer_draw_4:
		ld	de,5077h
		ldi                            	;5078
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5178
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5278
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5378
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5478
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5578
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5678
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5778
		ldi	
		ldi	
		ldi	

Analyzer_draw_5:
		ld	de,5097h
		ldi                            	;5098
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5198
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5298
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5398
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5498
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5598
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5698
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;5798
		ldi	
		ldi	
		ldi	

Analyzer_draw_6:
		ld	de,50B6h
		ldi                            	;50b8
		ldi	
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;51b8
		ldi	
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;52b8
		ldi	
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;53b8
		ldi	
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;54b8
		ldi	
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;55b8
		ldi	
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;56b8
		ldi	
		ldi	
		ldi	
		ldi	
		dec	e
		dec	e
		dec	e
		dec	e
		dec	e
		inc	d
		ldi                             ;57b8
		ldi	
		ldi	
		ldi	
		ldi	
		ret	    
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_table:
		db	47h,47h,47h,46h,46h,46h,45h,45h,45h,44h,44h,44h,43h,43h,42h,42h	
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_phase_mask:
		db	0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7	

;-------------------------------------------------------------------
; описание:  Таблица смещений для 5 канала
;---------------------------------------------------------------------
Analyzer_addr_ch5:
		db	0 	;0
		db	27 	;1
		db      27     	;2
		db	54     	;3
		db	78     	;4
		db	102    	;5
		db	126    	;6
		db	150    	;7
;-------------------------------------------------------------------
; описание:  Таблица адресов данных для 6 канала
;---------------------------------------------------------------------
Analyzer_addr_ch6:
		dw	Analyzer_table_01 	;0
		dw      Analyzer_table_01       ;1
		dw      Analyzer_table_02       ;2
		dw	Analyzer_table_03       ;3
		dw	Analyzer_table_04       ;4
		dw	Analyzer_table_05       ;5
		dw	Analyzer_table_06       ;6
		dw	Analyzer_table_07       ;7
;-------------------------------------------------------------------
; описание:  Таблица адресов данных для 1 канала
;---------------------------------------------------------------------
Analyzer_addr_ch1:
		dw	Analyzer_table_11 	;0
		dw      Analyzer_table_11       ;1
		dw      Analyzer_table_12       ;2
		dw	Analyzer_table_13       ;3
		dw	Analyzer_table_14       ;4
		dw	Analyzer_table_15       ;5
		dw	Analyzer_table_16       ;6
		dw	Analyzer_table_17       ;7
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------

Analyzer_table_01:
		db	90h
		dw	Analyzer_phase_0000	;000
		db	90h
		dw	Analyzer_phase_0001     ;001
		db	90h
		dw	Analyzer_phase_0002     ;002
		db	90h
		dw	Analyzer_phase_0003     ;003
		db	90h
		dw	Analyzer_phase_0004     ;004
		db	90h
		dw	Analyzer_phase_0005     ;005
		db	90h
		dw	Analyzer_phase_0006     ;006
		db	90h
		dw	Analyzer_phase_0007     ;007
		db	90h
		dw	Analyzer_phase_0000	;008 - для выравнивания

		db	90h
		dw	Analyzer_phase_0001     ;010
		db	90h
		dw	Analyzer_phase_0001     ;011
		db	90h
		dw	Analyzer_phase_0101     ;012
		db	90h
		dw	Analyzer_phase_0102     ;013
		db	90h
		dw	Analyzer_phase_0103     ;014
		db	90h
		dw	Analyzer_phase_0104     ;015
		db	90h
		dw	Analyzer_phase_0105     ;016
		db	90h
		dw	Analyzer_phase_0106     ;017
		db	90h
		dw	Analyzer_phase_0107     ;018

		db	90h
		dw	Analyzer_phase_0201     ;020
		db	90h
		dw	Analyzer_phase_0201     ;021
		db	90h
		dw	Analyzer_phase_0202     ;022
		db	90h
		dw	Analyzer_phase_0203     ;023
		db	90h
		dw	Analyzer_phase_0204     ;024
		db	90h
		dw	Analyzer_phase_0205     ;025
		db	90h
		dw	Analyzer_phase_0206     ;026
		db	90h
		dw	Analyzer_phase_0207     ;027

		db	90h
		dw	Analyzer_phase_0301     ;030
		db	90h
		dw	Analyzer_phase_0301     ;031
		db	90h
		dw	Analyzer_phase_0302     ;032
		db	90h
		dw	Analyzer_phase_0303     ;033
		db	90h
		dw	Analyzer_phase_0304     ;034
		db	90h
		dw	Analyzer_phase_0305     ;035
		db	90h
		dw	Analyzer_phase_0306     ;036
		db	90h
		dw	Analyzer_phase_0307     ;037

		db	90h
		dw	Analyzer_phase_0401     ;040
		db	90h
		dw	Analyzer_phase_0401     ;041
		db	90h
		dw	Analyzer_phase_0402     ;042
		db	90h
		dw	Analyzer_phase_0403     ;043
		db	90h
		dw	Analyzer_phase_0404     ;044
		db	90h
		dw	Analyzer_phase_0405     ;045
		db	90h
		dw	Analyzer_phase_0406     ;046
		db	90h
		dw	Analyzer_phase_0407     ;047

		db	90h
		dw	Analyzer_phase_0501     ;050
		db	90h
		dw	Analyzer_phase_0501     ;051
		db	90h
		dw	Analyzer_phase_0502     ;052
		db	90h
		dw	Analyzer_phase_0503     ;053
		db	90h
		dw	Analyzer_phase_0504     ;054
		db	90h
		dw	Analyzer_phase_0505     ;055
		db	90h
		dw	Analyzer_phase_0506     ;056
		db	90h
		dw	Analyzer_phase_0507     ;057

		db	90h
		dw	Analyzer_phase_0601     ;060
		db	90h
		dw	Analyzer_phase_0601     ;061
		db	90h
		dw	Analyzer_phase_0602     ;062
		db	90h
		dw	Analyzer_phase_0603     ;063
		db	90h
		dw	Analyzer_phase_0604     ;064
		db	90h
		dw	Analyzer_phase_0605     ;065
		db	90h
		dw	Analyzer_phase_0606     ;066
		db	90h
		dw	Analyzer_phase_0607     ;067

Analyzer_table_02:
		db	90h
		dw	Analyzer_phase_0001     ;100
		db	90h
		dw	Analyzer_phase_0001     ;101
		db	90h
		dw	Analyzer_phase_1001     ;102
		db	90h
		dw	Analyzer_phase_1002     ;103
		db	90h
		dw	Analyzer_phase_1003     ;104
		db	90h
		dw	Analyzer_phase_1004     ;105
		db	90h
		dw	Analyzer_phase_1005     ;106
		db	90h
		dw	Analyzer_phase_1006     ;107
		db	90h
		dw	Analyzer_phase_1007     ;108

		db	90h
		dw	Analyzer_phase_0001     ;110
		db	90h
		dw	Analyzer_phase_0001     ;111
		db	90h
		dw	Analyzer_phase_1101     ;112
		db	90h
		dw	Analyzer_phase_1102     ;113
		db	90h
		dw	Analyzer_phase_1103     ;114
		db	90h
		dw	Analyzer_phase_1104     ;115
		db	90h
		dw	Analyzer_phase_1105     ;116
		db	90h
		dw	Analyzer_phase_1106     ;117
		db	90h
		dw	Analyzer_phase_1107     ;118

		db	90h
		dw	Analyzer_phase_1201     ;120
		db	90h
		dw	Analyzer_phase_1201     ;121
		db	90h
		dw	Analyzer_phase_1202     ;122
		db	90h
		dw	Analyzer_phase_1203     ;123
		db	90h
		dw	Analyzer_phase_1204     ;124
		db	90h
		dw	Analyzer_phase_1205     ;125
		db	90h
		dw	Analyzer_phase_1206     ;126
		db	90h
		dw	Analyzer_phase_1207     ;127

		db	90h
		dw	Analyzer_phase_1301     ;130
		db	90h
		dw	Analyzer_phase_1301     ;131
		db	90h
		dw	Analyzer_phase_1302     ;132
		db	90h
		dw	Analyzer_phase_1303     ;133
		db	90h
		dw	Analyzer_phase_1304     ;134
		db	90h
		dw	Analyzer_phase_1305     ;135
		db	90h
		dw	Analyzer_phase_1306     ;136
		db	90h
		dw	Analyzer_phase_1307     ;137

		db	90h
		dw	Analyzer_phase_1401     ;140
		db	90h
		dw	Analyzer_phase_1401     ;141
		db	90h
		dw	Analyzer_phase_1402     ;142
		db	90h
		dw	Analyzer_phase_1403     ;143
		db	90h
		dw	Analyzer_phase_1404     ;144
		db	90h
		dw	Analyzer_phase_1405     ;145
		db	90h
		dw	Analyzer_phase_1406     ;146
		db	90h
		dw	Analyzer_phase_1407     ;147

		db	91h
		dw	Analyzer_phase_1501     ;150
		db	91h
		dw	Analyzer_phase_1501     ;151
		db	91h
		dw	Analyzer_phase_1502     ;152
		db	91h
		dw	Analyzer_phase_1503     ;153
		db	91h
		dw	Analyzer_phase_1504     ;154
		db	91h
		dw	Analyzer_phase_1505     ;155
		db	91h
		dw	Analyzer_phase_1506     ;156
		db	91h
		dw	Analyzer_phase_1507     ;157

		db	91h
		dw	Analyzer_phase_1601     ;160
		db	91h
		dw	Analyzer_phase_1601     ;161
		db	91h
		dw	Analyzer_phase_1602     ;162
		db	91h
		dw	Analyzer_phase_1603     ;163
		db	91h
		dw	Analyzer_phase_1604     ;164
		db	91h
		dw	Analyzer_phase_1605     ;165
		db	91h
		dw	Analyzer_phase_1606     ;166
		db	91h
		dw	Analyzer_phase_1607     ;167

Analyzer_table_03:
		db	91h
		dw	Analyzer_phase_2001     ;200
		db	91h
		dw	Analyzer_phase_2001     ;201
		db	91h
		dw	Analyzer_phase_2002     ;202
		db	91h
		dw	Analyzer_phase_2003     ;203
		db	91h
		dw	Analyzer_phase_2004     ;204
		db	91h
		dw	Analyzer_phase_2005     ;205
		db	91h
		dw	Analyzer_phase_2006     ;206
		db	91h
		dw	Analyzer_phase_2007     ;207
		db	90h
		dw	Analyzer_phase_0000	;208 - для выравнивания

		db	91h
		dw	Analyzer_phase_2001     ;210
		db	91h
		dw	Analyzer_phase_2001     ;211
		db	91h
		dw	Analyzer_phase_2101     ;212
		db	91h
		dw	Analyzer_phase_2102     ;213
		db	91h
		dw	Analyzer_phase_2103     ;214
		db	91h
		dw	Analyzer_phase_2104     ;215
		db	91h
		dw	Analyzer_phase_2105     ;216
		db	91h
		dw	Analyzer_phase_2106     ;217
		db	91h
		dw	Analyzer_phase_2107     ;218

		db	91h
		dw	Analyzer_phase_2201     ;220
		db	91h
		dw	Analyzer_phase_2201     ;221
		db	91h
		dw	Analyzer_phase_2202     ;222
		db	91h
		dw	Analyzer_phase_2203     ;223
		db	91h
		dw	Analyzer_phase_2204     ;224
		db	91h
		dw	Analyzer_phase_2205     ;225
		db	91h
		dw	Analyzer_phase_2206     ;226
		db	91h
		dw	Analyzer_phase_2207     ;227

		db	91h
		dw	Analyzer_phase_2301     ;230
		db	91h
		dw	Analyzer_phase_2301     ;231
		db	91h
		dw	Analyzer_phase_2302     ;232
		db	91h
		dw	Analyzer_phase_2303     ;233
		db	91h
		dw	Analyzer_phase_2304     ;234
		db	91h
		dw	Analyzer_phase_2305     ;235
		db	91h
		dw	Analyzer_phase_2306     ;236
		db	91h
		dw	Analyzer_phase_2307     ;237

		db	91h
		dw	Analyzer_phase_2401     ;240
		db	91h
		dw	Analyzer_phase_2401     ;241
		db	91h
		dw	Analyzer_phase_2402     ;242
		db	91h
		dw	Analyzer_phase_2403     ;243
		db	91h
		dw	Analyzer_phase_2404     ;244
		db	91h
		dw	Analyzer_phase_2405     ;245
		db	91h
		dw	Analyzer_phase_2406     ;246
		db	91h
		dw	Analyzer_phase_2407     ;247

		db	91h
		dw	Analyzer_phase_2501     ;250
		db	91h
		dw	Analyzer_phase_2501     ;251
		db	91h
		dw	Analyzer_phase_2502     ;252
		db	91h
		dw	Analyzer_phase_2503     ;253
		db	91h
		dw	Analyzer_phase_2504     ;254
		db	91h
		dw	Analyzer_phase_2505     ;255
		db	91h
		dw	Analyzer_phase_2506     ;256
		db	91h
		dw	Analyzer_phase_2507     ;257

		db	91h
		dw	Analyzer_phase_2601     ;260
		db	91h
		dw	Analyzer_phase_2601     ;261
		db	91h
		dw	Analyzer_phase_2602     ;262
		db	91h
		dw	Analyzer_phase_2603     ;263
		db	91h
		dw	Analyzer_phase_2604     ;264
		db	91h
		dw	Analyzer_phase_2605     ;265
		db	91h
		dw	Analyzer_phase_2606     ;266
		db	91h
		dw	Analyzer_phase_2607     ;267

Analyzer_table_04:
		db	91h
		dw	Analyzer_phase_3001     ;300
		db	91h
		dw	Analyzer_phase_3001     ;301
		db	91h
		dw	Analyzer_phase_3002     ;302
		db	91h
		dw	Analyzer_phase_3003     ;303
		db	91h
		dw	Analyzer_phase_3004     ;304
		db	91h
		dw	Analyzer_phase_3005     ;305
		db	91h
		dw	Analyzer_phase_3006     ;306
		db	91h
		dw	Analyzer_phase_3007     ;307
		db	90h
		dw	Analyzer_phase_0000	;308 - для выравнивания

		db	91h
		dw	Analyzer_phase_3001     ;310
		db	91h
		dw	Analyzer_phase_3001     ;311
		db	91h
		dw	Analyzer_phase_3101     ;312
		db	91h
		dw	Analyzer_phase_3102     ;313
		db	91h
		dw	Analyzer_phase_3103     ;314
		db	91h
		dw	Analyzer_phase_3104     ;315
		db	91h
		dw	Analyzer_phase_3105     ;316
		db	91h
		dw	Analyzer_phase_3106     ;317
		db	91h
		dw	Analyzer_phase_3107     ;318

		db	91h
		dw	Analyzer_phase_3201     ;320
		db	91h
		dw	Analyzer_phase_3201     ;321
		db	91h
		dw	Analyzer_phase_3202     ;322
		db	91h
		dw	Analyzer_phase_3203     ;323
		db	91h
		dw	Analyzer_phase_3204     ;324
		db	91h
		dw	Analyzer_phase_3205     ;325
		db	91h
		dw	Analyzer_phase_3206     ;326
		db	91h
		dw	Analyzer_phase_3207     ;327

		db	92h
		dw	Analyzer_phase_3301     ;330
		db	92h
		dw	Analyzer_phase_3301     ;331
		db	92h
		dw	Analyzer_phase_3302     ;332
		db	92h
		dw	Analyzer_phase_3303     ;333
		db	92h
		dw	Analyzer_phase_3304     ;334
		db	92h
		dw	Analyzer_phase_3305     ;335
		db	92h
		dw	Analyzer_phase_3306     ;336
		db	92h
		dw	Analyzer_phase_3307     ;337

		db	92h
		dw	Analyzer_phase_3401     ;340
		db	92h
		dw	Analyzer_phase_3401     ;341
		db	92h
		dw	Analyzer_phase_3402     ;342
		db	92h
		dw	Analyzer_phase_3403     ;343
		db	92h
		dw	Analyzer_phase_3404     ;344
		db	92h
		dw	Analyzer_phase_3405     ;345
		db	92h
		dw	Analyzer_phase_3406     ;346
		db	92h
		dw	Analyzer_phase_3407     ;347

		db	92h
		dw	Analyzer_phase_3501     ;350
		db	92h
		dw	Analyzer_phase_3501     ;351
		db	92h
		dw	Analyzer_phase_3502     ;352
		db	92h
		dw	Analyzer_phase_3503     ;353
		db	92h
		dw	Analyzer_phase_3504     ;354
		db	92h
		dw	Analyzer_phase_3505     ;355
		db	92h
		dw	Analyzer_phase_3506     ;356
		db	92h
		dw	Analyzer_phase_3507     ;357

		db	92h
		dw	Analyzer_phase_3601     ;360
		db	92h
		dw	Analyzer_phase_3601     ;361
		db	92h
		dw	Analyzer_phase_3602     ;362
		db	92h
		dw	Analyzer_phase_3603     ;363
		db	92h
		dw	Analyzer_phase_3604     ;364
		db	92h
		dw	Analyzer_phase_3605     ;365
		db	92h
		dw	Analyzer_phase_3606     ;366
		db	92h
		dw	Analyzer_phase_3607     ;367

Analyzer_table_05:
		db	92h
		dw	Analyzer_phase_4001     ;400
		db	92h
		dw	Analyzer_phase_4001     ;401
		db	92h
		dw	Analyzer_phase_4002     ;402
		db	92h
		dw	Analyzer_phase_4003     ;403
		db	92h
		dw	Analyzer_phase_4004     ;404
		db	92h
		dw	Analyzer_phase_4005     ;405
		db	92h
		dw	Analyzer_phase_4006     ;406
		db	92h
		dw	Analyzer_phase_4007     ;407
		db	90h
		dw	Analyzer_phase_0000	;408 - для выравнивания

		db	92h
		dw	Analyzer_phase_4001     ;410
		db	92h
		dw	Analyzer_phase_4001     ;411
		db	92h
		dw	Analyzer_phase_4101     ;412
		db	92h
		dw	Analyzer_phase_4102     ;413
		db	92h
		dw	Analyzer_phase_4103     ;414
		db	92h
		dw	Analyzer_phase_4104     ;415
		db	92h
		dw	Analyzer_phase_4105     ;416
		db	92h
		dw	Analyzer_phase_4106     ;417
		db	92h
		dw	Analyzer_phase_4107     ;418

		db	92h
		dw	Analyzer_phase_4201     ;420
		db	92h
		dw	Analyzer_phase_4201     ;421
		db	92h
		dw	Analyzer_phase_4202     ;422
		db	92h
		dw	Analyzer_phase_4203     ;423
		db	92h
		dw	Analyzer_phase_4204     ;424
		db	92h
		dw	Analyzer_phase_4205     ;425
		db	92h
		dw	Analyzer_phase_4206     ;426
		db	92h
		dw	Analyzer_phase_4207     ;427

		db	92h
		dw	Analyzer_phase_4301     ;430
		db	92h
		dw	Analyzer_phase_4301     ;431
		db	92h
		dw	Analyzer_phase_4302     ;432
		db	92h
		dw	Analyzer_phase_4303     ;433
		db	92h
		dw	Analyzer_phase_4304     ;434
		db	92h
		dw	Analyzer_phase_4305     ;435
		db	92h
		dw	Analyzer_phase_4306     ;436
		db	92h
		dw	Analyzer_phase_4307     ;437

		db	92h
		dw	Analyzer_phase_4401     ;440
		db	92h
		dw	Analyzer_phase_4401     ;441
		db	92h
		dw	Analyzer_phase_4402     ;442
		db	92h
		dw	Analyzer_phase_4403     ;443
		db	92h
		dw	Analyzer_phase_4404     ;444
		db	92h
		dw	Analyzer_phase_4405     ;445
		db	92h
		dw	Analyzer_phase_4406     ;446
		db	92h
		dw	Analyzer_phase_4407     ;447

		db	92h
		dw	Analyzer_phase_4501     ;450
		db	92h
		dw	Analyzer_phase_4501     ;451
		db	92h
		dw	Analyzer_phase_4502     ;452
		db	92h
		dw	Analyzer_phase_4503     ;453
		db	92h
		dw	Analyzer_phase_4504     ;454
		db	92h
		dw	Analyzer_phase_4505     ;455
		db	92h
		dw	Analyzer_phase_4506     ;456
		db	92h
		dw	Analyzer_phase_4507     ;457

		db	92h
		dw	Analyzer_phase_4601     ;460
		db	92h
		dw	Analyzer_phase_4601     ;461
		db	92h
		dw	Analyzer_phase_4602     ;462
		db	92h
		dw	Analyzer_phase_4603     ;463
		db	92h
		dw	Analyzer_phase_4604     ;464
		db	92h
		dw	Analyzer_phase_4605     ;465
		db	92h
		dw	Analyzer_phase_4606     ;466
		db	92h
		dw	Analyzer_phase_4607     ;467

Analyzer_table_06:
		db	92h
		dw	Analyzer_phase_5001     ;500
		db	92h
		dw	Analyzer_phase_5001     ;501
		db	92h
		dw	Analyzer_phase_5002     ;502
		db	92h
		dw	Analyzer_phase_5003     ;503
		db	92h
		dw	Analyzer_phase_5004     ;504
		db	92h
		dw	Analyzer_phase_5005     ;505
		db	92h
		dw	Analyzer_phase_5006     ;506
		db	92h
		dw	Analyzer_phase_5007     ;507
		db	90h
		dw	Analyzer_phase_0000	;508 - для выравнивания

		db	92h
		dw	Analyzer_phase_5001     ;510
		db	92h
		dw	Analyzer_phase_5001     ;511
		db	93h
		dw	Analyzer_phase_5101     ;512
		db	93h
		dw	Analyzer_phase_5102     ;513
		db	93h
		dw	Analyzer_phase_5103     ;514
		db	93h
		dw	Analyzer_phase_5104     ;515
		db	93h
		dw	Analyzer_phase_5105     ;516
		db	93h
		dw	Analyzer_phase_5106     ;517
		db	93h
		dw	Analyzer_phase_5107     ;518

		db	93h
		dw	Analyzer_phase_5201     ;520
		db	93h
		dw	Analyzer_phase_5201     ;521
		db	93h
		dw	Analyzer_phase_5202     ;522
		db	93h
		dw	Analyzer_phase_5203     ;523
		db	93h
		dw	Analyzer_phase_5204     ;524
		db	93h
		dw	Analyzer_phase_5205     ;525
		db	93h
		dw	Analyzer_phase_5206     ;526
		db	93h
		dw	Analyzer_phase_5207     ;527

		db	93h
		dw	Analyzer_phase_5301     ;530
		db	93h
		dw	Analyzer_phase_5301     ;531
		db	93h
		dw	Analyzer_phase_5302     ;532
		db	93h
		dw	Analyzer_phase_5303     ;533
		db	93h
		dw	Analyzer_phase_5304     ;534
		db	93h
		dw	Analyzer_phase_5305     ;535
		db	93h
		dw	Analyzer_phase_5306     ;536
		db	93h
		dw	Analyzer_phase_5307     ;537

		db	93h
		dw	Analyzer_phase_5401     ;540
		db	93h
		dw	Analyzer_phase_5401     ;541
		db	93h
		dw	Analyzer_phase_5402     ;542
		db	93h
		dw	Analyzer_phase_5403     ;543
		db	93h
		dw	Analyzer_phase_5404     ;544
		db	93h
		dw	Analyzer_phase_5405     ;545
		db	93h
		dw	Analyzer_phase_5406     ;546
		db	93h
		dw	Analyzer_phase_5407     ;547

		db	93h
		dw	Analyzer_phase_5501     ;550
		db	93h
		dw	Analyzer_phase_5501     ;551
		db	93h
		dw	Analyzer_phase_5502     ;552
		db	93h
		dw	Analyzer_phase_5503     ;553
		db	93h
		dw	Analyzer_phase_5504     ;554
		db	93h
		dw	Analyzer_phase_5505     ;555
		db	93h
		dw	Analyzer_phase_5506     ;556
		db	93h
		dw	Analyzer_phase_5507     ;557

		db	93h
		dw	Analyzer_phase_5601     ;560
		db	93h
		dw	Analyzer_phase_5601     ;561
		db	93h
		dw	Analyzer_phase_5602     ;562
		db	93h
		dw	Analyzer_phase_5603     ;563
		db	93h
		dw	Analyzer_phase_5604     ;564
		db	93h
		dw	Analyzer_phase_5605     ;565
		db	93h
		dw	Analyzer_phase_5606     ;566
		db	93h
		dw	Analyzer_phase_5607     ;567

Analyzer_table_07:
		db	93h
		dw	Analyzer_phase_6001     ;600
		db	93h
		dw	Analyzer_phase_6001     ;601
		db	93h
		dw	Analyzer_phase_6002     ;602
		db	93h
		dw	Analyzer_phase_6003     ;603
		db	93h
		dw	Analyzer_phase_6004     ;604
		db	93h
		dw	Analyzer_phase_6005     ;605
		db	93h
		dw	Analyzer_phase_6006     ;606
		db	93h
		dw	Analyzer_phase_6007     ;607
		db	90h
		dw	Analyzer_phase_0000	;608 - для выравнивания

		db	93h
		dw	Analyzer_phase_6001     ;610
		db	93h
		dw	Analyzer_phase_6001     ;611
		db	93h
		dw	Analyzer_phase_6101     ;612
		db	93h
		dw	Analyzer_phase_6102     ;613
		db	93h
		dw	Analyzer_phase_6103     ;614
		db	93h
		dw	Analyzer_phase_6104     ;615
		db	93h
		dw	Analyzer_phase_6105     ;616
		db	93h
		dw	Analyzer_phase_6106     ;617
		db	93h
		dw	Analyzer_phase_6107     ;618

		db	93h
		dw	Analyzer_phase_6201     ;620
		db	93h
		dw	Analyzer_phase_6201     ;621
		db	93h
		dw	Analyzer_phase_6202     ;622
		db	93h
		dw	Analyzer_phase_6203     ;623
		db	93h
		dw	Analyzer_phase_6204     ;624
		db	93h
		dw	Analyzer_phase_6205     ;625
		db	93h
		dw	Analyzer_phase_6206     ;626
		db	93h
		dw	Analyzer_phase_6207     ;627

		db	93h
		dw	Analyzer_phase_6301     ;630
		db	93h
		dw	Analyzer_phase_6301     ;631
		db	93h
		dw	Analyzer_phase_6302     ;632
		db	93h
		dw	Analyzer_phase_6303     ;633
		db	93h
		dw	Analyzer_phase_6304     ;634
		db	93h
		dw	Analyzer_phase_6305     ;635
		db	93h
		dw	Analyzer_phase_6306     ;636
		db	93h
		dw	Analyzer_phase_6307     ;637

		db	93h
		dw	Analyzer_phase_6401     ;640
		db	93h
		dw	Analyzer_phase_6401     ;641
		db	93h
		dw	Analyzer_phase_6402     ;642
		db	93h
		dw	Analyzer_phase_6403     ;643
		db	93h
		dw	Analyzer_phase_6404     ;644
		db	93h
		dw	Analyzer_phase_6405     ;645
		db	93h
		dw	Analyzer_phase_6406     ;646
		db	93h
		dw	Analyzer_phase_6407     ;647

		db	93h
		dw	Analyzer_phase_6501     ;650
		db	93h
		dw	Analyzer_phase_6501     ;651
		db	93h
		dw	Analyzer_phase_6502     ;652
		db	93h
		dw	Analyzer_phase_6503     ;653
		db	93h
		dw	Analyzer_phase_6504     ;654
		db	93h
		dw	Analyzer_phase_6505     ;655
		db	93h
		dw	Analyzer_phase_6506     ;656
		db	93h
		dw	Analyzer_phase_6507     ;657

		db	94h
		dw	Analyzer_phase_6601     ;660
		db	94h
		dw	Analyzer_phase_6601     ;661
		db	94h
		dw	Analyzer_phase_6602     ;662
		db	94h
		dw	Analyzer_phase_6603     ;663
		db	94h
		dw	Analyzer_phase_6604     ;664
		db	94h
		dw	Analyzer_phase_6605     ;665
		db	94h
		dw	Analyzer_phase_6606     ;666
		db	94h
		dw	Analyzer_phase_6607     ;667

;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------

Analyzer_table_11:
		db	94h
		dw	Analyzer_phase_7000	;000
		db	94h
		dw	Analyzer_phase_7001     ;001
		db	94h
		dw	Analyzer_phase_7002     ;002
		db	94h
		dw	Analyzer_phase_7003     ;003
		db	94h
		dw	Analyzer_phase_7004     ;004
		db	94h
		dw	Analyzer_phase_7005     ;005
		db	94h
		dw	Analyzer_phase_7006     ;006
		db	94h
		dw	Analyzer_phase_7007     ;007
		db	94h
		dw	Analyzer_phase_7000	;008 - для выравнивания

		db	94h
		dw	Analyzer_phase_7001     ;010
		db	94h
		dw	Analyzer_phase_7001     ;011
		db	94h
		dw	Analyzer_phase_7101     ;012
		db	94h
		dw	Analyzer_phase_7102     ;013
		db	94h
		dw	Analyzer_phase_7103     ;014
		db	94h
		dw	Analyzer_phase_7104     ;015
		db	94h
		dw	Analyzer_phase_7105     ;016
		db	94h
		dw	Analyzer_phase_7106     ;017
		db	94h
		dw	Analyzer_phase_7107     ;018
		         
		db	94h
		dw	Analyzer_phase_7201     ;020
		db	94h
		dw	Analyzer_phase_7201     ;021
		db	94h
		dw	Analyzer_phase_7202     ;022
		db	94h
		dw	Analyzer_phase_7203     ;023
		db	94h
		dw	Analyzer_phase_7204     ;024
		db	94h
		dw	Analyzer_phase_7205     ;025
		db	94h
		dw	Analyzer_phase_7206     ;026
		db	94h
		dw	Analyzer_phase_7207     ;027
		         
		db	94h
		dw	Analyzer_phase_7301     ;030
		db	94h
		dw	Analyzer_phase_7301     ;031
		db	94h
		dw	Analyzer_phase_7302     ;032
		db	94h
		dw	Analyzer_phase_7303     ;033
		db	94h
		dw	Analyzer_phase_7304     ;034
		db	94h
		dw	Analyzer_phase_7305     ;035
		db	94h
		dw	Analyzer_phase_7306     ;036
		db	94h
		dw	Analyzer_phase_7307     ;037

		db	94h
		dw	Analyzer_phase_7401     ;040
		db	94h
		dw	Analyzer_phase_7401     ;041
		db	94h
		dw	Analyzer_phase_7402     ;042
		db	94h
		dw	Analyzer_phase_7403     ;043
		db	94h
		dw	Analyzer_phase_7404     ;044
		db	94h
		dw	Analyzer_phase_7405     ;045
		db	94h
		dw	Analyzer_phase_7406     ;046
		db	94h
		dw	Analyzer_phase_7407     ;047

		db	94h
		dw	Analyzer_phase_7501     ;050
		db	94h
		dw	Analyzer_phase_7501     ;051
		db	94h
		dw	Analyzer_phase_7502     ;052
		db	94h
		dw	Analyzer_phase_7503     ;053
		db	94h
		dw	Analyzer_phase_7504     ;054
		db	94h
		dw	Analyzer_phase_7505     ;055
		db	94h
		dw	Analyzer_phase_7506     ;056
		db	94h
		dw	Analyzer_phase_7507     ;057

		db	94h
		dw	Analyzer_phase_7601     ;060
		db	94h
		dw	Analyzer_phase_7601     ;061
		db	94h
		dw	Analyzer_phase_7602     ;062
		db	94h
		dw	Analyzer_phase_7603     ;063
		db	94h
		dw	Analyzer_phase_7604     ;064
		db	94h
		dw	Analyzer_phase_7605     ;065
		db	94h
		dw	Analyzer_phase_7606     ;066
		db	94h
		dw	Analyzer_phase_7607     ;067
		         
Analyzer_table_12:
		db	94h
		dw	Analyzer_phase_7001     ;100
		db	94h
		dw	Analyzer_phase_7001     ;101
		db	94h
		dw	Analyzer_phase_8001     ;102
		db	94h
		dw	Analyzer_phase_8002     ;103
		db	94h
		dw	Analyzer_phase_8003     ;104
		db	94h
		dw	Analyzer_phase_8004     ;105
		db	94h
		dw	Analyzer_phase_8005     ;106
		db	94h
		dw	Analyzer_phase_8006     ;107
		db	94h
		dw	Analyzer_phase_8007     ;108

		db	94h
		dw	Analyzer_phase_7001     ;110
		db	94h
		dw	Analyzer_phase_7001     ;111
		db	94h
		dw	Analyzer_phase_8101     ;112
		db	94h
		dw	Analyzer_phase_8102     ;113
		db	94h
		dw	Analyzer_phase_8103     ;114
		db	94h
		dw	Analyzer_phase_8104     ;115
		db	94h
		dw	Analyzer_phase_8105     ;116
		db	94h
		dw	Analyzer_phase_8106     ;117
		db	94h
		dw	Analyzer_phase_8107     ;118

		db	94h
		dw	Analyzer_phase_8201     ;120
		db	94h
		dw	Analyzer_phase_8201     ;121
		db	94h
		dw	Analyzer_phase_8202     ;122
		db	94h
		dw	Analyzer_phase_8203     ;123
		db	94h
		dw	Analyzer_phase_8204     ;124
		db	94h
		dw	Analyzer_phase_8205     ;125
		db	94h
		dw	Analyzer_phase_8206     ;126
		db	94h
		dw	Analyzer_phase_8207     ;127

		db	94h
		dw	Analyzer_phase_8301     ;130
		db	94h
		dw	Analyzer_phase_8301     ;131
		db	94h
		dw	Analyzer_phase_8302     ;132
		db	94h
		dw	Analyzer_phase_8303     ;133
		db	94h
		dw	Analyzer_phase_8304     ;134
		db	94h
		dw	Analyzer_phase_8305     ;135
		db	94h
		dw	Analyzer_phase_8306     ;136
		db	94h
		dw	Analyzer_phase_8307     ;137

		db	95h
		dw	Analyzer_phase_8401     ;140
		db	95h
		dw	Analyzer_phase_8401     ;141
		db	95h
		dw	Analyzer_phase_8402     ;142
		db	95h
		dw	Analyzer_phase_8403     ;143
		db	95h
		dw	Analyzer_phase_8404     ;144
		db	95h
		dw	Analyzer_phase_8405     ;145
		db	95h
		dw	Analyzer_phase_8406     ;146
		db	95h
		dw	Analyzer_phase_8407     ;147

		db	95h
		dw	Analyzer_phase_8501     ;150
		db	95h
		dw	Analyzer_phase_8501     ;151
		db	95h
		dw	Analyzer_phase_8502     ;152
		db	95h
		dw	Analyzer_phase_8503     ;153
		db	95h
		dw	Analyzer_phase_8504     ;154
		db	95h
		dw	Analyzer_phase_8505     ;155
		db	95h
		dw	Analyzer_phase_8506     ;156
		db	95h
		dw	Analyzer_phase_8507     ;157

		db	95h
		dw	Analyzer_phase_8601     ;160
		db	95h
		dw	Analyzer_phase_8601     ;161
		db	95h
		dw	Analyzer_phase_8602     ;162
		db	95h
		dw	Analyzer_phase_8603     ;163
		db	95h
		dw	Analyzer_phase_8604     ;164
		db	95h
		dw	Analyzer_phase_8605     ;165
		db	95h
		dw	Analyzer_phase_8606     ;166
		db	95h
		dw	Analyzer_phase_8607     ;167

Analyzer_table_13:
		db	95h
		dw	Analyzer_phase_9001     ;200
		db	95h
		dw	Analyzer_phase_9001     ;201
		db	95h
		dw	Analyzer_phase_9002     ;202
		db	95h
		dw	Analyzer_phase_9003     ;203
		db	95h
		dw	Analyzer_phase_9004     ;204
		db	95h
		dw	Analyzer_phase_9005     ;205
		db	95h
		dw	Analyzer_phase_9006     ;206
		db	95h
		dw	Analyzer_phase_9007     ;207
		db	94h
		dw	Analyzer_phase_7000	;208 - для выравнивания

		db	95h
		dw	Analyzer_phase_9001     ;210
		db	95h
		dw	Analyzer_phase_9001     ;211
		db	95h
		dw	Analyzer_phase_9101     ;212
		db	95h
		dw	Analyzer_phase_9102     ;213
		db	95h
		dw	Analyzer_phase_9103     ;214
		db	95h
		dw	Analyzer_phase_9104     ;215
		db	95h
		dw	Analyzer_phase_9105     ;216
		db	95h
		dw	Analyzer_phase_9106     ;217
		db	95h
		dw	Analyzer_phase_9107     ;218

		db	95h
		dw	Analyzer_phase_9201     ;220
		db	95h
		dw	Analyzer_phase_9201     ;221
		db	95h
		dw	Analyzer_phase_9202     ;222
		db	95h
		dw	Analyzer_phase_9203     ;223
		db	95h
		dw	Analyzer_phase_9204     ;224
		db	95h
		dw	Analyzer_phase_9205     ;225
		db	95h
		dw	Analyzer_phase_9206     ;226
		db	95h
		dw	Analyzer_phase_9207     ;227

		db	95h
		dw	Analyzer_phase_9301     ;230
		db	95h
		dw	Analyzer_phase_9301     ;231
		db	95h
		dw	Analyzer_phase_9302     ;232
		db	95h
		dw	Analyzer_phase_9303     ;233
		db	95h
		dw	Analyzer_phase_9304     ;234
		db	95h
		dw	Analyzer_phase_9305     ;235
		db	95h
		dw	Analyzer_phase_9306     ;236
		db	95h
		dw	Analyzer_phase_9307     ;237

		db	95h
		dw	Analyzer_phase_9401     ;240
		db	95h
		dw	Analyzer_phase_9401     ;241
		db	95h
		dw	Analyzer_phase_9402     ;242
		db	95h
		dw	Analyzer_phase_9403     ;243
		db	95h
		dw	Analyzer_phase_9404     ;244
		db	95h
		dw	Analyzer_phase_9405     ;245
		db	95h
		dw	Analyzer_phase_9406     ;246
		db	95h
		dw	Analyzer_phase_9407     ;247

		db	95h
		dw	Analyzer_phase_9501     ;250
		db	95h
		dw	Analyzer_phase_9501     ;251
		db	95h
		dw	Analyzer_phase_9502     ;252
		db	95h
		dw	Analyzer_phase_9503     ;253
		db	95h
		dw	Analyzer_phase_9504     ;254
		db	95h
		dw	Analyzer_phase_9505     ;255
		db	95h
		dw	Analyzer_phase_9506     ;256
		db	95h
		dw	Analyzer_phase_9507     ;257

		db	95h
		dw	Analyzer_phase_9601     ;260
		db	95h
		dw	Analyzer_phase_9601     ;261
		db	95h
		dw	Analyzer_phase_9602     ;262
		db	95h
		dw	Analyzer_phase_9603     ;263
		db	95h
		dw	Analyzer_phase_9604     ;264
		db	95h
		dw	Analyzer_phase_9605     ;265
		db	95h
		dw	Analyzer_phase_9606     ;266
		db	95h
		dw	Analyzer_phase_9607     ;267

Analyzer_table_14:
		db	95h
		dw	Analyzer_phase_A001     ;300
		db	95h
		dw	Analyzer_phase_A001     ;301
		db	95h
		dw	Analyzer_phase_A002     ;302
		db	95h
		dw	Analyzer_phase_A003     ;303
		db	95h
		dw	Analyzer_phase_A004     ;304
		db	95h
		dw	Analyzer_phase_A005     ;305
		db	95h
		dw	Analyzer_phase_A006     ;306
		db	95h
		dw	Analyzer_phase_A007     ;307
		db	94h
		dw	Analyzer_phase_7000	;308 - для выравнивания

		db	95h
		dw	Analyzer_phase_A001     ;310
		db	95h
		dw	Analyzer_phase_A001     ;311
		db	95h
		dw	Analyzer_phase_A101     ;312
		db	95h
		dw	Analyzer_phase_A102     ;313
		db	95h
		dw	Analyzer_phase_A103     ;314
		db	95h
		dw	Analyzer_phase_A104     ;315
		db	95h
		dw	Analyzer_phase_A105     ;316
		db	95h
		dw	Analyzer_phase_A106     ;317
		db	95h
		dw	Analyzer_phase_A107     ;318

		db	96h
		dw	Analyzer_phase_A201     ;320
		db	96h
		dw	Analyzer_phase_A201     ;321
		db	96h
		dw	Analyzer_phase_A202     ;322
		db	96h
		dw	Analyzer_phase_A203     ;323
		db	96h
		dw	Analyzer_phase_A204     ;324
		db	96h
		dw	Analyzer_phase_A205     ;325
		db	96h
		dw	Analyzer_phase_A206     ;326
		db	96h
		dw	Analyzer_phase_A207     ;327

		db	96h
		dw	Analyzer_phase_A301     ;330
		db	96h
		dw	Analyzer_phase_A301     ;331
		db	96h
		dw	Analyzer_phase_A302     ;332
		db	96h
		dw	Analyzer_phase_A303     ;333
		db	96h
		dw	Analyzer_phase_A304     ;334
		db	96h
		dw	Analyzer_phase_A305     ;335
		db	96h
		dw	Analyzer_phase_A306     ;336
		db	96h
		dw	Analyzer_phase_A307     ;337

		db	96h
		dw	Analyzer_phase_A401     ;340
		db	96h
		dw	Analyzer_phase_A401     ;341
		db	96h
		dw	Analyzer_phase_A402     ;342
		db	96h
		dw	Analyzer_phase_A403     ;343
		db	96h
		dw	Analyzer_phase_A404     ;344
		db	96h
		dw	Analyzer_phase_A405     ;345
		db	96h
		dw	Analyzer_phase_A406     ;346
		db	96h
		dw	Analyzer_phase_A407     ;347

		db	96h
		dw	Analyzer_phase_A501     ;350
		db	96h
		dw	Analyzer_phase_A501     ;351
		db	96h
		dw	Analyzer_phase_A502     ;352
		db	96h
		dw	Analyzer_phase_A503     ;353
		db	96h
		dw	Analyzer_phase_A504     ;354
		db	96h
		dw	Analyzer_phase_A505     ;355
		db	96h
		dw	Analyzer_phase_A506     ;356
		db	96h
		dw	Analyzer_phase_A507     ;357

		db	96h
		dw	Analyzer_phase_A601     ;360
		db	96h
		dw	Analyzer_phase_A601     ;361
		db	96h
		dw	Analyzer_phase_A602     ;362
		db	96h
		dw	Analyzer_phase_A603     ;363
		db	96h
		dw	Analyzer_phase_A604     ;364
		db	96h
		dw	Analyzer_phase_A605     ;365
		db	96h
		dw	Analyzer_phase_A606     ;366
		db	96h
		dw	Analyzer_phase_A607     ;367

Analyzer_table_15:
		db	96h
		dw	Analyzer_phase_B001     ;400
		db	96h
		dw	Analyzer_phase_B001     ;401
		db	96h
		dw	Analyzer_phase_B002     ;402
		db	96h
		dw	Analyzer_phase_B003     ;403
		db	96h
		dw	Analyzer_phase_B004     ;404
		db	96h
		dw	Analyzer_phase_B005     ;405
		db	96h
		dw	Analyzer_phase_B006     ;406
		db	96h
		dw	Analyzer_phase_B007     ;407
		db	94h
		dw	Analyzer_phase_7000	;408 - для выравнивания

		db	96h
		dw	Analyzer_phase_B001     ;410
		db	96h
		dw	Analyzer_phase_B001     ;411
		db	96h
		dw	Analyzer_phase_B101     ;412
		db	96h
		dw	Analyzer_phase_B102     ;413
		db	96h
		dw	Analyzer_phase_B103     ;414
		db	96h
		dw	Analyzer_phase_B104     ;415
		db	96h
		dw	Analyzer_phase_B105     ;416
		db	96h
		dw	Analyzer_phase_B106     ;417
		db	96h
		dw	Analyzer_phase_B107     ;418

		db	96h            
		dw	Analyzer_phase_B201     ;420
		db	96h
		dw	Analyzer_phase_B201     ;421
		db	96h
		dw	Analyzer_phase_B202     ;422
		db	96h
		dw	Analyzer_phase_B203     ;423
		db	96h
		dw	Analyzer_phase_B204     ;424
		db	96h
		dw	Analyzer_phase_B205     ;425
		db	96h
		dw	Analyzer_phase_B206     ;426
		db	96h
		dw	Analyzer_phase_B207     ;427

		db	96h
		dw	Analyzer_phase_B301     ;430
		db	96h
		dw	Analyzer_phase_B301     ;431
		db	96h
		dw	Analyzer_phase_B302     ;432
		db	96h
		dw	Analyzer_phase_B303     ;433
		db	96h
		dw	Analyzer_phase_B304     ;434
		db	96h
		dw	Analyzer_phase_B305     ;435
		db	96h
		dw	Analyzer_phase_B306     ;436
		db	96h
		dw	Analyzer_phase_B307     ;437

		db	96h
		dw	Analyzer_phase_B401     ;440
		db	96h
		dw	Analyzer_phase_B401     ;441
		db	96h
		dw	Analyzer_phase_B402     ;442
		db	96h
		dw	Analyzer_phase_B403     ;443
		db	96h
		dw	Analyzer_phase_B404     ;444
		db	96h
		dw	Analyzer_phase_B405     ;445
		db	96h
		dw	Analyzer_phase_B406     ;446
		db	96h
		dw	Analyzer_phase_B407     ;447

		db	96h
		dw	Analyzer_phase_B501     ;450
		db	96h
		dw	Analyzer_phase_B501     ;451
		db	96h
		dw	Analyzer_phase_B502     ;452
		db	96h
		dw	Analyzer_phase_B503     ;453
		db	96h
		dw	Analyzer_phase_B504     ;454
		db	96h
		dw	Analyzer_phase_B505     ;455
		db	96h
		dw	Analyzer_phase_B506     ;456
		db	96h
		dw	Analyzer_phase_B507     ;457

		db	96h
		dw	Analyzer_phase_B601     ;460
		db	96h
		dw	Analyzer_phase_B601     ;461
		db	96h
		dw	Analyzer_phase_B602     ;462
		db	96h
		dw	Analyzer_phase_B603     ;463
		db	96h
		dw	Analyzer_phase_B604     ;464
		db	96h
		dw	Analyzer_phase_B605     ;465
		db	96h
		dw	Analyzer_phase_B606     ;466
		db	96h
		dw	Analyzer_phase_B607     ;467

Analyzer_table_16:
		db	97h
		dw	Analyzer_phase_C001     ;500
		db	97h
		dw	Analyzer_phase_C001     ;501
		db	97h
		dw	Analyzer_phase_C002     ;502
		db	97h
		dw	Analyzer_phase_C003     ;503
		db	97h
		dw	Analyzer_phase_C004     ;504
		db	97h
		dw	Analyzer_phase_C005     ;505
		db	97h
		dw	Analyzer_phase_C006     ;506
		db	97h
		dw	Analyzer_phase_C007     ;507
		db	94h
		dw	Analyzer_phase_7000	;508 - для выравнивания

		db	97h
		dw	Analyzer_phase_C001     ;510
		db	97h
		dw	Analyzer_phase_C001     ;511
		db	97h
		dw	Analyzer_phase_C101     ;512
		db	97h
		dw	Analyzer_phase_C102     ;513
		db	97h
		dw	Analyzer_phase_C103     ;514
		db	97h
		dw	Analyzer_phase_C104     ;515
		db	97h
		dw	Analyzer_phase_C105     ;516
		db	97h
		dw	Analyzer_phase_C106     ;517
		db	97h
		dw	Analyzer_phase_C107     ;518

		db	97h
		dw	Analyzer_phase_C201     ;520
		db	97h
		dw	Analyzer_phase_C201     ;521
		db	97h
		dw	Analyzer_phase_C202     ;522
		db	97h
		dw	Analyzer_phase_C203     ;523
		db	97h
		dw	Analyzer_phase_C204     ;524
		db	97h
		dw	Analyzer_phase_C205     ;525
		db	97h
		dw	Analyzer_phase_C206     ;526
		db	97h
		dw	Analyzer_phase_C207     ;527

		db	97h
		dw	Analyzer_phase_C301     ;530
		db	97h
		dw	Analyzer_phase_C301     ;531
		db	97h
		dw	Analyzer_phase_C302     ;532
		db	97h
		dw	Analyzer_phase_C303     ;533
		db	97h
		dw	Analyzer_phase_C304     ;534
		db	97h
		dw	Analyzer_phase_C305     ;535
		db	97h
		dw	Analyzer_phase_C306     ;536
		db	97h
		dw	Analyzer_phase_C307     ;537

		db	97h
		dw	Analyzer_phase_C401     ;540
		db	97h
		dw	Analyzer_phase_C401     ;541
		db	97h
		dw	Analyzer_phase_C402     ;542
		db	97h
		dw	Analyzer_phase_C403     ;543
		db	97h
		dw	Analyzer_phase_C404     ;544
		db	97h
		dw	Analyzer_phase_C405     ;545
		db	97h
		dw	Analyzer_phase_C406     ;546
		db	97h
		dw	Analyzer_phase_C407     ;547

		db	97h
		dw	Analyzer_phase_C501     ;550
		db	97h
		dw	Analyzer_phase_C501     ;551
		db	97h
		dw	Analyzer_phase_C502     ;552
		db	97h
		dw	Analyzer_phase_C503     ;553
		db	97h
		dw	Analyzer_phase_C504     ;554
		db	97h
		dw	Analyzer_phase_C505     ;555
		db	97h
		dw	Analyzer_phase_C506     ;556
		db	97h
		dw	Analyzer_phase_C507     ;557

		db	97h
		dw	Analyzer_phase_C601     ;560
		db	97h
		dw	Analyzer_phase_C601     ;561
		db	97h
		dw	Analyzer_phase_C602     ;562
		db	97h
		dw	Analyzer_phase_C603     ;563
		db	97h
		dw	Analyzer_phase_C604     ;564
		db	97h
		dw	Analyzer_phase_C605     ;565
		db	97h
		dw	Analyzer_phase_C606     ;566
		db	97h
		dw	Analyzer_phase_C607     ;567

Analyzer_table_17:
		db	97h
		dw	Analyzer_phase_D001     ;600
		db	97h
		dw	Analyzer_phase_D001     ;601
		db	97h
		dw	Analyzer_phase_D002     ;602
		db	97h
		dw	Analyzer_phase_D003     ;603
		db	97h
		dw	Analyzer_phase_D004     ;604
		db	97h
		dw	Analyzer_phase_D005     ;605
		db	97h
		dw	Analyzer_phase_D006     ;606
		db	97h
		dw	Analyzer_phase_D007     ;607
		db	94h
		dw	Analyzer_phase_7000	;608 - для выравнивания

		db	97h
		dw	Analyzer_phase_D001     ;610
		db	97h
		dw	Analyzer_phase_D001     ;611
		db	97h
		dw	Analyzer_phase_D101     ;612
		db	97h
		dw	Analyzer_phase_D102     ;613
		db	97h
		dw	Analyzer_phase_D103     ;614
		db	97h
		dw	Analyzer_phase_D104     ;615
		db	97h
		dw	Analyzer_phase_D105     ;616
		db	97h
		dw	Analyzer_phase_D106     ;617
		db	97h
		dw	Analyzer_phase_D107     ;618

		db	97h            
		dw	Analyzer_phase_D201     ;620
		db	97h
		dw	Analyzer_phase_D201     ;621
		db	97h
		dw	Analyzer_phase_D202     ;622
		db	97h
		dw	Analyzer_phase_D203     ;623
		db	97h
		dw	Analyzer_phase_D204     ;624
		db	97h
		dw	Analyzer_phase_D205     ;625
		db	97h
		dw	Analyzer_phase_D206     ;626
		db	97h
		dw	Analyzer_phase_D207     ;627

		db	97h
		dw	Analyzer_phase_D301     ;630
		db	97h
		dw	Analyzer_phase_D301     ;631
		db	97h
		dw	Analyzer_phase_D302     ;632
		db	97h
		dw	Analyzer_phase_D303     ;633
		db	97h
		dw	Analyzer_phase_D304     ;634
		db	97h
		dw	Analyzer_phase_D305     ;635
		db	97h
		dw	Analyzer_phase_D306     ;636
		db	97h
		dw	Analyzer_phase_D307     ;637

		db	97h
		dw	Analyzer_phase_D401     ;640
		db	97h
		dw	Analyzer_phase_D401     ;641
		db	97h
		dw	Analyzer_phase_D402     ;642
		db	97h
		dw	Analyzer_phase_D403     ;643
		db	97h
		dw	Analyzer_phase_D404     ;644
		db	97h
		dw	Analyzer_phase_D405     ;645
		db	97h
		dw	Analyzer_phase_D406     ;646
		db	97h
		dw	Analyzer_phase_D407     ;647

		db	17h
		dw	Analyzer_phase_D501     ;650
		db	17h
		dw	Analyzer_phase_D501     ;651
		db	17h
		dw	Analyzer_phase_D502     ;652
		db	17h
		dw	Analyzer_phase_D503     ;653
		db	17h
		dw	Analyzer_phase_D504     ;654
		db	17h
		dw	Analyzer_phase_D505     ;655
		db	17h
		dw	Analyzer_phase_D506     ;656
		db	17h
		dw	Analyzer_phase_D507     ;657

		db	17h
		dw	Analyzer_phase_D601     ;660
		db	17h
		dw	Analyzer_phase_D601     ;661
		db	17h
		dw	Analyzer_phase_D602     ;662
		db	17h
		dw	Analyzer_phase_D603     ;663
		db	17h
		dw	Analyzer_phase_D604     ;664
		db	17h
		dw	Analyzer_phase_D605     ;665
		db	17h
		dw	Analyzer_phase_D606     ;666
		db	17h
		dw	Analyzer_phase_D607     ;667

;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_ch0_vol:
		db	0
Analyzer_ch1_vol:
		db	0
Analyzer_ch2_vol:
		db	0
Analyzer_ch3_vol:
		db	0
Analyzer_ch4_vol:
		db	0
Analyzer_ch5_vol:
		db	0
