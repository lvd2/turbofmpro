;--------------------------------------------------------------------
; Описание: Модуль отображения анализатора
; Автор порта: Тарасов М.Н.(Mick),2010
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
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view:
		ld	a,(Analyzer_ch0_vol)
		push	af
		ld	c,a
		ld	a,(Analyzer_ch0_oldvol)
		ld	de,4002h
		call	Analyzer_draw
		pop	af
		ld	(Analyzer_ch0_oldvol),a

		ld	a,(Analyzer_ch1_vol)
		push	af
		ld	c,a
		ld	a,(Analyzer_ch1_oldvol)
		ld	de,4002h + 5
		call	Analyzer_draw
		pop	af
		ld	(Analyzer_ch1_oldvol),a

		ld	a,(Analyzer_ch2_vol)
		push	af
		ld	c,a
		ld	a,(Analyzer_ch2_oldvol)
		ld	de,4002h + 10
		call	Analyzer_draw
		pop	af
		ld	(Analyzer_ch2_oldvol),a

		ld	a,(Analyzer_ch3_vol)
		push	af
		ld	c,a
		ld	a,(Analyzer_ch3_oldvol)
		ld	de,4002h + 16
		call	Analyzer_draw
		pop	af
		ld	(Analyzer_ch3_oldvol),a

		ld	a,(Analyzer_ch4_vol)
		push	af
		ld	c,a
		ld	a,(Analyzer_ch4_oldvol)
		ld	de,4002h + 21
		call	Analyzer_draw
		pop	af
		ld	(Analyzer_ch4_oldvol),a

		ld	a,(Analyzer_ch5_vol)
		push	af
		ld	c,a
		ld	a,(Analyzer_ch5_oldvol)
		ld	de,4002h + 26
		call	Analyzer_draw
		pop	af
		ld	(Analyzer_ch5_oldvol),a
		ret
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw:
		push	de
		cp	c
		jr	nz,Analyzer_draw_next
		ld	a,r
		and	0Fh	
Analyzer_draw_next:
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	de,Analyzer_table_phase
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ld	a,c
		ld	l,a
		ld	h,0
		add	hl,hl
		add	hl,de
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		pop	de
		ex	de,hl

		ld	b,23				;размерность по Y
Analyzer_loop_Y:
		ld	c,10
		push	hl
		ex	hl,de
		ldi
		ldi
		ex	hl,de
		pop	hl
		inc	h
		ld	a,h
		and 	7
		jr	nz,Analyzer_next_line
		ld	a,l
		add	20h
		ld	l,a
		jr	c,Analyzer_next_line
		ld	a,h
		sub	8
		ld	h,a
Analyzer_next_line:
    		djnz    Analyzer_loop_Y
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
		ld	hl,5AFEh
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
		ld	hl,5AE4h
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
		ld	hl,5ACAh
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
		ld	l,0EAh
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
              	ld	b, 12
		ld	hl,Analyzer_ch0_vol

Analyzer_init_loop:
                ld	(hl),0
		inc	hl
		djnz	Analyzer_init_loop
		ret
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_table:
		db	47h,47h,47h,47h,46h,46h,45h,45h,44h,44h,43h,43h,42h,42h,41h,41h	
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase:
		dw	Analyzer_table_phase_00		      ;0
		dw	Analyzer_table_phase_01		      ;1
		dw	Analyzer_table_phase_02               ;2
		dw	Analyzer_table_phase_03               ;3
		dw	Analyzer_table_phase_04               ;4
		dw	Analyzer_table_phase_05               ;5
		dw	Analyzer_table_phase_06               ;6
		dw	Analyzer_table_phase_07               ;7
		dw	Analyzer_table_phase_08               ;8
		dw	Analyzer_table_phase_09               ;9
		dw	Analyzer_table_phase_10               ;10
		dw	Analyzer_table_phase_11               ;11
		dw	Analyzer_table_phase_12               ;12
		dw	Analyzer_table_phase_13               ;13
		dw	Analyzer_table_phase_14               ;14
		dw	Analyzer_table_phase_15               ;15
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_00:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_001
		dw	Analyzer_phase_002
		dw	Analyzer_phase_003
		dw	Analyzer_phase_004
		dw	Analyzer_phase_005
		dw	Analyzer_phase_006
		dw	Analyzer_phase_007
		dw	Analyzer_phase_008
		dw	Analyzer_phase_009
		dw	Analyzer_phase_010
		dw	Analyzer_phase_011
		dw	Analyzer_phase_012
		dw	Analyzer_phase_013
		dw	Analyzer_phase_014
		dw	Analyzer_phase_015

Analyzer_phase_000:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h

Analyzer_phase_001:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_002:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_003:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	10h,00h
		db	0A0h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_004:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,00h
		db	10h,00h
		db	0A8h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_005:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	08h,00h
		db	96h,00h
		db	0A0h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_006:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,00h
		db	04h,00h
		db	49h,00h
		db	96h,00h
		db	0A0h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_007:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	49h,00h
		db	96h,00h
		db	0A0h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_008:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,80h
		db	01h,00h
		db	02h,00h
		db	24h,80h
		db	4Bh,00h
		db	90h,00h
		db	0A0h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_009:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,40h
		db	02h,80h
		db	01h,00h
		db	42h,00h
		db	24h,80h
		db	4Bh,40h
		db	90h,00h
		db	0A0h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_010:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,10h
		db	00h,20h
		db	01h,40h
		db	02h,40h
		db	02h,80h
		db	01h,00h
		db	42h,00h
		db	24h,80h
		db	4Bh,40h
		db	90h,00h
		db	0A0h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_011:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,10h
		db	00h,10h
		db	02h,20h
		db	01h,40h
		db	02h,40h
		db	02h,80h
		db	81h,00h
		db	42h,00h
		db	24h,80h
		db	4Bh,40h
		db	90h,20h
		db	0A0h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_012:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,28h
		db	00h,10h
		db	01h,10h
		db	02h,20h
		db	01h,40h
		db	02h,40h
		db	02h,80h
		db	81h,00h
		db	42h,00h
		db	24h,80h
		db	4Bh,40h
		db	90h,20h
		db	0A0h,40h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_013:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,04h
		db	00h,08h
		db	00h,28h
		db	00h,10h
		db	01h,19h
		db	02h,26h
		db	01h,40h
		db	02h,40h
		db	02h,80h
		db	81h,00h
		db	42h,00h
		db	24h,80h
		db	4Bh,40h
		db	90h,20h
		db	0A0h,40h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_014:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,02h
		db	00h,04h
		db	00h,08h
		db	00h,48h
		db	00h,28h
		db	00h,10h
		db	01h,19h
		db	02h,26h
		db	01h,40h
		db	02h,40h
		db	02h,80h
		db	81h,00h
		db	42h,00h
		db	24h,80h
		db	4Bh,40h
		db	90h,20h
		db	0A0h,40h
		db	40h,00h
		db	80h,00h
		db	80h,00h

Analyzer_phase_015:
		db	00h,01h
		db	00h,02h
		db	00h,04h
		db	00h,02h
		db	00h,24h
		db	00h,28h
		db	00h,48h
		db	00h,28h
		db	00h,10h
		db	01h,19h
		db	02h,26h
		db	01h,40h
		db	02h,40h
		db	02h,80h
		db	81h,00h
		db	42h,00h
		db	24h,80h
		db	4Bh,40h
		db	90h,20h
		db	0A0h,40h
		db	40h,00h
		db	80h,00h
		db	80h,00h
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_01:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_101
		dw	Analyzer_phase_102
		dw	Analyzer_phase_103
		dw	Analyzer_phase_104
		dw	Analyzer_phase_105
		dw	Analyzer_phase_106
		dw	Analyzer_phase_107
		dw	Analyzer_phase_108
		dw	Analyzer_phase_109
		dw	Analyzer_phase_110
		dw	Analyzer_phase_111
		dw	Analyzer_phase_112
		dw	Analyzer_phase_113
		dw	Analyzer_phase_114
		dw	Analyzer_phase_115
Analyzer_phase_101:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	40h,00h
		db	80h,00h
		db	40h,00h

Analyzer_phase_102:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,00h
		db	40h,00h
		db	80h,00h
		db	40h,00h

Analyzer_phase_103:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	58h,00h
		db	20h,00h
		db	40h,00h
		db	80h,00h
		db	40h,00h

Analyzer_phase_104:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	84h,00h
		db	58h,00h
		db	20h,00h
		db	40h,00h
		db	80h,00h
		db	40h,00h

Analyzer_phase_105:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	86h,00h
		db	58h,00h
		db	20h,00h
		db	40h,00h
		db	80h,00h
		db	40h,00h

Analyzer_phase_106:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,00h
		db	44h,00h
		db	86h,00h
		db	59h,00h
		db	20h,00h
		db	40h,00h
		db	80h,00h
		db	40h,00h

Analyzer_phase_107:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	82h,00h
		db	44h,00h
		db	86h,00h
		db	59h,80h
		db	20h,00h
		db	40h,00h
		db	80h,00h
		db	40h,00h

Analyzer_phase_108:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	00h,80h
		db	01h,00h
		db	82h,00h
		db	44h,00h
		db	86h,40h
		db	59h,80h
		db	20h,00h
		db	40h,00h
		db	80h,00h
		db	40h,00h

Analyzer_phase_109:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,00h
		db	01h,40h
		db	00h,80h
		db	01h,00h
		db	82h,00h
		db	44h,00h
		db	86h,40h
		db	59h,80h
		db	20h,00h
		db	40h,00h
		db	80h,00h
		db	40h,00h

Analyzer_phase_110:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	02h,20h
		db	01h,40h
		db	00h,80h
		db	01h,00h
		db	82h,00h
		db	44h,00h
		db	86h,40h
		db	59h,80h
		db	20h,00h
		db	40h,00h
		db	80h,00h
		db	40h,00h

Analyzer_phase_111:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,10h
		db	02h,20h
		db	01h,40h
		db	00h,80h
		db	41h,00h
		db	82h,00h
		db	44h,00h
		db	86h,40h
		db	59h,80h
		db	20h,40h
		db	40h,00h
		db	80h,00h
		db	40h,00h

Analyzer_phase_112:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,88h
		db	01h,10h
		db	02h,20h
		db	01h,40h
		db	00h,80h
		db	41h,00h
		db	82h,00h
		db	44h,00h
		db	86h,40h
		db	59h,80h
		db	20h,40h
		db	40h,80h
		db	80h,00h
		db	40h,00h

Analyzer_phase_113:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,04h
		db	00h,88h
		db	01h,10h
		db	02h,20h
		db	01h,40h
		db	20h,80h
		db	41h,00h
		db	82h,00h
		db	44h,00h
		db	86h,40h
		db	59h,80h
		db	20h,40h
		db	40h,80h
		db	80h,00h
		db	40h,00h
Analyzer_phase_114:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,04h
		db	00h,02h
		db	01h,44h
		db	00h,88h
		db	01h,14h
		db	02h,20h
		db	01h,40h
		db	20h,80h
		db	41h,00h
		db	82h,00h
		db	44h,00h
		db	86h,40h
		db	59h,80h
		db	20h,40h
		db	40h,80h
		db	80h,00h
		db	40h,00h

Analyzer_phase_115:
		db	00h,01h
		db	00h,02h
		db	00h,04h
		db	00h,02h
		db	00h,01h
		db	02h,02h
		db	04h,05h
		db	02h,02h
		db	01h,44h
		db	00h,88h
		db	01h,14h
		db	02h,22h
		db	01h,42h
		db	20h,85h
		db	41h,00h
		db	82h,00h
		db	44h,00h
		db	86h,40h
		db	59h,80h
		db	20h,40h
		db	40h,80h
		db	80h,00h
		db	40h,00h
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_02:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_201
		dw	Analyzer_phase_202
		dw	Analyzer_phase_203
		dw	Analyzer_phase_204
		dw	Analyzer_phase_205
		dw	Analyzer_phase_206
		dw	Analyzer_phase_207
		dw	Analyzer_phase_208
		dw	Analyzer_phase_209
		dw	Analyzer_phase_210
		dw	Analyzer_phase_211
		dw	Analyzer_phase_212
		dw	Analyzer_phase_213
		dw	Analyzer_phase_214
		dw	Analyzer_phase_215

Analyzer_phase_201:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_202:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	10h,00h
		db	20h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_203:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,00h
		db	10h,00h
		db	28h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_204:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	06h,00h
		db	08h,00h
		db	10h,00h
		db	28h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_205:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	03h,00h
		db	06h,00h
		db	08h,00h
		db	10h,00h
		db	28h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_206:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,00h
		db	04h,80h
		db	03h,00h
		db	06h,00h
		db	08h,00h
		db	10h,00h
		db	28h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_207:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,80h
		db	04h,80h
		db	03h,00h
		db	06h,00h
		db	08h,00h
		db	10h,00h
		db	28h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_208:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,40h
		db	08h,0A0h
		db	04h,0A0h
		db	03h,00h
		db	06h,00h
		db	08h,00h
		db	10h,00h
		db	28h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_209:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	10h,40h
		db	08h,0A0h
		db	04h,0A0h
		db	03h,10h
		db	06h,00h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_210:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,10h
		db	00h,20h
		db	10h,40h
		db	08h,0A0h
		db	04h,0A0h
		db	03h,10h
		db	06h,10h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_211:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,10h
		db	00h,08h
		db	00h,10h
		db	00h,20h
		db	10h,40h
		db	08h,0A0h
		db	04h,0A0h
		db	03h,10h
		db	06h,10h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_212:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,0A0h
		db	00h,40h
		db	00h,20h
		db	00h,14h
		db	00h,08h
		db	00h,10h
		db	40h,20h
		db	30h,40h
		db	08h,0A0h
		db	04h,0A0h
		db	03h,10h
		db	06h,10h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_213:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,10h
		db	00h,0A0h
		db	00h,40h
		db	00h,22h
		db	00h,14h
		db	00h,08h
		db	00h,10h
		db	40h,20h
		db	30h,40h
		db	08h,0A0h
		db	04h,0A0h
		db	03h,10h
		db	06h,18h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_214:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,10h
		db	00h,0A2h
		db	00h,44h
		db	00h,22h
		db	00h,14h
		db	00h,08h
		db	00h,10h
		db	40h,20h
		db	30h,40h
		db	08h,0A0h
		db	04h,0A0h
		db	03h,10h
		db	06h,18h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	40h,00h
		db	20h,00h

Analyzer_phase_215:
		db	00h,00h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h
		db	00h,11h
		db	00h,0A2h
		db	00h,44h
		db	00h,22h
		db	00h,14h
		db	00h,08h
		db	00h,10h
		db	40h,20h
		db	30h,40h
		db	08h,0A0h
		db	04h,0A0h
		db	03h,10h
		db	06h,18h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	40h,00h
		db	20h,00h

;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_03:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_301
		dw	Analyzer_phase_302
		dw	Analyzer_phase_303
		dw	Analyzer_phase_304
		dw	Analyzer_phase_305
		dw	Analyzer_phase_306
		dw	Analyzer_phase_307
		dw	Analyzer_phase_308
		dw	Analyzer_phase_309
		dw	Analyzer_phase_310
		dw	Analyzer_phase_311
		dw	Analyzer_phase_312
		dw	Analyzer_phase_313
		dw	Analyzer_phase_314
		dw	Analyzer_phase_315

Analyzer_phase_301:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_302:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_303:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	14h,00h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_304:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,00h
		db	22h,00h
		db	14h,00h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_305:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	12h,00h
		db	22h,00h
		db	14h,00h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_306:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	00h,80h
		db	09h,40h
		db	12h,00h
		db	22h,00h
		db	14h,00h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_307:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	10h,80h
		db	09h,40h
		db	12h,20h
		db	22h,00h
		db	14h,00h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_308:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,40h
		db	20h,80h
		db	10h,80h
		db	09h,40h
		db	12h,20h
		db	22h,40h
		db	14h,00h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_309:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	10h,20h
		db	20h,40h
		db	20h,80h
		db	10h,80h
		db	09h,40h
		db	12h,20h
		db	22h,40h
		db	14h,20h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_310:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,10h
		db	00h,50h
		db	10h,20h
		db	20h,40h
		db	20h,80h
		db	10h,80h
		db	09h,40h
		db	12h,20h
		db	22h,40h
		db	14h,20h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_311:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,48h
		db	00h,90h
		db	00h,50h
		db	10h,20h
		db	28h,40h
		db	20h,80h
		db	10h,80h
		db	09h,40h
		db	12h,20h
		db	22h,40h
		db	14h,20h
		db	08h,00h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_312:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,04h
		db	00h,84h
		db	00h,48h
		db	00h,90h
		db	00h,50h
		db	10h,20h
		db	28h,40h
		db	20h,80h
		db	10h,80h
		db	09h,40h
		db	12h,20h
		db	22h,40h
		db	14h,20h
		db	08h,40h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_313:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,02h
		db	01h,04h
		db	02h,84h
		db	00h,48h
		db	00h,90h
		db	00h,50h
		db	14h,20h
		db	28h,40h
		db	20h,80h
		db	10h,80h
		db	09h,40h
		db	12h,20h
		db	22h,40h
		db	14h,20h
		db	08h,40h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_314:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,81h
		db	01h,01h
		db	00h,82h
		db	01h,04h
		db	02h,84h
		db	00h,48h
		db	00h,90h
		db	00h,50h
		db	14h,20h
		db	28h,40h
		db	20h,80h
		db	10h,80h
		db	09h,40h
		db	12h,20h
		db	22h,40h
		db	14h,20h
		db	08h,40h
		db	10h,00h
		db	20h,00h
		db	10h,00h

Analyzer_phase_315:
		db	00h,8Ah
		db	00h,84h
		db	00h,42h
		db	00h,81h
		db	01h,01h
		db	00h,82h
		db	01h,04h
		db	02h,84h
		db	00h,48h
		db	00h,90h
		db	00h,50h
		db	14h,20h
		db	28h,40h
		db	20h,80h
		db	10h,80h
		db	09h,40h
		db	12h,20h
		db	22h,40h
		db	14h,20h
		db	08h,50h
		db	10h,00h
		db	20h,00h
		db	10h,00h

;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_04:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_401
		dw	Analyzer_phase_402
		dw	Analyzer_phase_403
		dw	Analyzer_phase_404
		dw	Analyzer_phase_405
		dw	Analyzer_phase_406
		dw	Analyzer_phase_407
		dw	Analyzer_phase_408
		dw	Analyzer_phase_409
		dw	Analyzer_phase_410
		dw	Analyzer_phase_411
		dw	Analyzer_phase_412
		dw	Analyzer_phase_413
		dw	Analyzer_phase_414
		dw	Analyzer_phase_415

Analyzer_phase_401:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_402:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	08h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_403:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_404:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	02h,00h
		db	02h,00h
		db	04h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_405:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	00h,80h
		db	01h,00h
		db	02h,00h
		db	02h,00h
		db	44h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_406:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,40h
		db	00h,80h
		db	00h,80h
		db	01h,00h
		db	02h,00h
		db	22h,00h
		db	44h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_407:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,20h
		db	00h,40h
		db	00h,80h
		db	00h,80h
		db	01h,00h
		db	22h,00h
		db	22h,00h
		db	44h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_408:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,10h
		db	00h,20h
		db	00h,20h
		db	00h,20h
		db	00h,40h
		db	00h,80h
		db	00h,80h
		db	01h,40h
		db	12h,20h
		db	22h,00h
		db	44h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_409:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,04h
		db	00h,08h
		db	00h,10h
		db	00h,20h
		db	00h,20h
		db	00h,20h
		db	00h,40h
		db	00h,80h
		db	00h,80h
		db	21h,40h
		db	12h,30h
		db	22h,00h
		db	44h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_410:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,04h
		db	00h,04h
		db	00h,08h
		db	00h,10h
		db	00h,20h
		db	00h,20h
		db	00h,20h
		db	00h,40h
		db	00h,80h
		db	10h,80h
		db	21h,40h
		db	12h,38h
		db	22h,00h
		db	44h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_411:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,01h
		db	00h,02h
		db	00h,04h
		db	00h,04h
		db	00h,08h
		db	00h,10h
		db	00h,20h
		db	00h,20h
		db	00h,20h
		db	00h,40h
		db	00h,80h
		db	10h,80h
		db	21h,44h
		db	12h,38h
		db	22h,00h
		db	44h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_412:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,08h
		db	00h,05h
		db	00h,02h
		db	00h,04h
		db	00h,04h
		db	00h,08h
		db	00h,10h
		db	00h,20h
		db	00h,20h
		db	00h,20h
		db	00h,40h
		db	28h,80h
		db	10h,80h
		db	21h,44h
		db	12h,38h
		db	22h,04h
		db	44h,02h
		db	28h,00h
		db	10h,00h
		db	08h,00h

Analyzer_phase_413:
		db	00h,00h
		db	00h,00h
		db	00h,14h
		db	00h,08h
		db	00h,05h
		db	00h,02h
		db	00h,04h
		db	00h,04h
		db	00h,08h
		db	00h,10h
		db	00h,20h
		db	00h,20h
		db	00h,20h
		db	00h,40h
		db	28h,80h
		db	10h,80h
		db	21h,44h
		db	12h,38h
		db	22h,04h
		db	44h,02h
		db	28h,01h
		db	10h,00h
		db	08h,00h

Analyzer_phase_414:
		db	00h,00h
		db	00h,0E2h
		db	00h,14h
		db	00h,08h
		db	00h,05h
		db	00h,02h
		db	00h,04h
		db	00h,04h
		db	00h,08h
		db	00h,10h
		db	00h,20h
		db	00h,20h
		db	00h,20h
		db	00h,40h
		db	28h,80h
		db	10h,80h
		db	21h,44h
		db	12h,38h
		db	22h,04h
		db	44h,02h
		db	28h,01h
		db	10h,00h
		db	08h,00h

Analyzer_phase_415:
		db	01h,01h
		db	00h,0E2h
		db	00h,14h
		db	00h,08h
		db	00h,05h
		db	00h,02h
		db	00h,04h
		db	00h,04h
		db	00h,08h
		db	00h,10h
		db	00h,20h
		db	00h,20h
		db	00h,20h
		db	00h,40h
		db	28h,80h
		db	10h,80h
		db	21h,44h
		db	12h,38h
		db	22h,04h
		db	44h,02h
		db	28h,01h
		db	10h,00h
		db	08h,00h

;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_05:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_501
		dw	Analyzer_phase_502
		dw	Analyzer_phase_503
		dw	Analyzer_phase_504
		dw	Analyzer_phase_505
		dw	Analyzer_phase_506
		dw	Analyzer_phase_507
		dw	Analyzer_phase_508
		dw	Analyzer_phase_509
		dw	Analyzer_phase_510
		dw	Analyzer_phase_511
		dw	Analyzer_phase_512
		dw	Analyzer_phase_513
		dw	Analyzer_phase_514
		dw	Analyzer_phase_515

Analyzer_phase_501:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_502:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_503:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	05h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_504:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	10h,80h
		db	09h,00h
		db	05h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_505:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,40h
		db	10h,80h
		db	09h,00h
		db	05h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_506:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	50h,20h
		db	20h,40h
		db	10h,80h
		db	09h,00h
		db	05h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_507:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,10h
		db	08h,10h
		db	50h,20h
		db	20h,40h
		db	10h,80h
		db	09h,00h
		db	05h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_508:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,08h
		db	04h,10h
		db	08h,10h
		db	50h,20h
		db	20h,40h
		db	10h,80h
		db	09h,00h
		db	05h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_509:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,04h
		db	02h,04h
		db	0Ah,08h
		db	04h,10h
		db	08h,10h
		db	50h,20h
		db	20h,40h
		db	10h,80h
		db	09h,00h
		db	05h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_510:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,01h
		db	01h,02h
		db	01h,04h
		db	02h,04h
		db	0Ah,08h
		db	04h,10h
		db	08h,10h
		db	50h,20h
		db	20h,40h
		db	10h,80h
		db	09h,00h
		db	05h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_511:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,01h
		db	00h,01h
		db	02h,01h
		db	01h,02h
		db	01h,04h
		db	12h,04h
		db	0Ah,08h
		db	04h,10h
		db	08h,10h
		db	50h,20h
		db	20h,40h
		db	10h,80h
		db	09h,00h
		db	05h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_512:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,02h
		db	02h,01h
		db	04h,01h
		db	02h,01h
		db	01h,02h
		db	29h,04h
		db	12h,04h
		db	0Ah,08h
		db	04h,10h
		db	08h,10h
		db	50h,20h
		db	20h,40h
		db	10h,80h
		db	09h,00h
		db	05h,40h
		db	02h,80h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_513:
		db	00h,00h
		db	00h,00h
		db	00h,0Ah
		db	00h,04h
		db	00h,02h
		db	02h,01h
		db	04h,01h
		db	02h,01h
		db	01h,02h
		db	29h,04h
		db	12h,04h
		db	0Ah,08h
		db	04h,10h
		db	08h,10h
		db	50h,20h
		db	20h,40h
		db	10h,80h
		db	09h,20h
		db	05h,50h
		db	02h,80h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_514:
		db	00h,00h
		db	00h,01h
		db	00h,0Ah
		db	00h,04h
		db	00h,02h
		db	02h,01h
		db	04h,01h
		db	02h,01h
		db	01h,02h
		db	29h,04h
		db	12h,04h
		db	0Ah,08h
		db	04h,10h
		db	08h,10h
		db	50h,20h
		db	20h,40h
		db	10h,80h
		db	09h,20h
		db	05h,58h
		db	02h,80h
		db	04h,00h
		db	08h,00h
		db	04h,00h

Analyzer_phase_515:
		db	00h,82h
		db	00h,61h
		db	00h,1Ah
		db	00h,04h
		db	00h,02h
		db	02h,01h
		db	04h,01h
		db	02h,81h
		db	01h,02h
		db	29h,04h
		db	12h,04h
		db	0Ah,08h
		db	04h,10h
		db	08h,10h
		db	50h,20h
		db	20h,40h
		db	10h,80h
		db	09h,24h
		db	05h,58h
		db	02h,80h
		db	04h,00h
		db	08h,00h
		db	04h,00h
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_06:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_601
		dw	Analyzer_phase_602
		dw	Analyzer_phase_603
		dw	Analyzer_phase_604
		dw	Analyzer_phase_605
		dw	Analyzer_phase_606
		dw	Analyzer_phase_607
		dw	Analyzer_phase_608
		dw	Analyzer_phase_609
		dw	Analyzer_phase_610
		dw	Analyzer_phase_611
		dw	Analyzer_phase_612
		dw	Analyzer_phase_613
		dw	Analyzer_phase_614
		dw	Analyzer_phase_615

Analyzer_phase_601:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_602:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_603:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_604:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,40h
		db	01h,40h
		db	00h,80h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_605:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,40h
		db	01h,40h
		db	00h,80h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_606:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,30h
		db	02h,40h
		db	01h,40h
		db	00h,80h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_607:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,08h
		db	00h,10h
		db	00h,20h
		db	01h,30h
		db	02h,48h
		db	01h,40h
		db	00h,80h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_608:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,04h
		db	00h,04h
		db	00h,04h
		db	00h,08h
		db	00h,10h
		db	00h,20h
		db	01h,30h
		db	02h,48h
		db	01h,44h
		db	00h,80h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_609:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,11h
		db	00h,0Ah
		db	00h,04h
		db	00h,04h
		db	00h,04h
		db	00h,08h
		db	00h,90h
		db	00h,0A0h
		db	01h,30h
		db	02h,48h
		db	01h,44h
		db	00h,80h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_610:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,12h
		db	00h,22h
		db	00h,11h
		db	00h,0Ah
		db	00h,04h
		db	00h,04h
		db	00h,04h
		db	01h,08h
		db	00h,90h
		db	00h,0A0h
		db	01h,30h
		db	02h,48h
		db	01h,44h
		db	00h,80h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_611:
		db	00h,00h
		db	00h,00h
		db	00h,04h
		db	00h,28h
		db	00h,12h
		db	00h,0Ah
		db	00h,11h
		db	00h,0Ah
		db	00h,04h
		db	00h,04h
		db	00h,04h
		db	01h,08h
		db	00h,90h
		db	00h,0A0h
		db	05h,30h
		db	02h,48h
		db	01h,44h
		db	00h,84h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_612:
		db	00h,00h
		db	00h,22h
		db	00h,14h
		db	00h,28h
		db	00h,12h
		db	00h,0Ah
		db	00h,11h
		db	00h,0Ah
		db	00h,04h
		db	00h,04h
		db	00h,04h
		db	01h,08h
		db	00h,90h
		db	08h,0A0h
		db	15h,30h
		db	02h,4Ah
		db	01h,44h
		db	00h,84h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_613:
		db	00h,01h
		db	00h,22h
		db	00h,0D4h
		db	00h,08h
		db	00h,12h
		db	00h,0Ah
		db	00h,11h
		db	00h,0Ah
		db	00h,04h
		db	00h,04h
		db	00h,04h
		db	01h,08h
		db	00h,90h
		db	08h,0A0h
		db	15h,30h
		db	22h,4Ah
		db	01h,44h
		db	00h,84h
		db	01h,00h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_614:
		db	00h,11h
		db	00h,22h
		db	02h,0D4h
		db	01h,08h
		db	00h,12h
		db	00h,0Ah
		db	00h,11h
		db	00h,0Ah
		db	00h,04h
		db	00h,04h
		db	02h,04h
		db	01h,08h
		db	00h,90h
		db	08h,0A0h
		db	15h,30h
		db	22h,4Ah
		db	01h,44h
		db	00h,84h
		db	01h,02h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_615:
		db	08h,11h
		db	04h,22h
		db	02h,0D4h
		db	01h,08h
		db	00h,12h
		db	00h,0Ah
		db	00h,11h
		db	00h,0Ah
		db	00h,04h
		db	00h,04h
		db	02h,04h
		db	05h,08h
		db	00h,90h
		db	08h,0A0h
		db	15h,30h
		db	22h,4Ah
		db	11h,45h
		db	00h,84h
		db	01h,02h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_07:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_701
		dw	Analyzer_phase_702
		dw	Analyzer_phase_703
		dw	Analyzer_phase_704
		dw	Analyzer_phase_705
		dw	Analyzer_phase_706
		dw	Analyzer_phase_707
		dw	Analyzer_phase_708
		dw	Analyzer_phase_709
		dw	Analyzer_phase_710
		dw	Analyzer_phase_711
		dw	Analyzer_phase_712
		dw	Analyzer_phase_713
		dw	Analyzer_phase_714
		dw	Analyzer_phase_715

Analyzer_phase_701:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_702:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	01h,00h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_703:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,40h
		db	00h,80h
		db	01h,00h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_704:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,60h
		db	00h,40h
		db	00h,80h
		db	01h,00h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_705:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,40h
		db	00h,60h
		db	00h,50h
		db	00h,80h
		db	01h,00h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_706:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,90h
		db	00h,50h
		db	00h,20h
		db	00h,40h
		db	00h,60h
		db	00h,50h
		db	00h,80h
		db	01h,00h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_707:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,08h
		db	00h,90h
		db	03h,50h
		db	00h,20h
		db	00h,40h
		db	00h,60h
		db	00h,50h
		db	00h,88h
		db	01h,00h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_708:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,08h
		db	00h,10h
		db	00h,08h
		db	00h,90h
		db	03h,50h
		db	04h,20h
		db	00h,40h
		db	00h,60h
		db	00h,50h
		db	00h,88h
		db	01h,00h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_709:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,04h
		db	00h,04h
		db	00h,08h
		db	00h,10h
		db	00h,08h
		db	00h,90h
		db	03h,50h
		db	04h,20h
		db	08h,40h
		db	00h,60h
		db	00h,50h
		db	00h,88h
		db	01h,04h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_710:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,02h
		db	00h,02h
		db	00h,04h
		db	00h,04h
		db	00h,08h
		db	00h,10h
		db	00h,08h
		db	00h,90h
		db	03h,50h
		db	04h,20h
		db	18h,40h
		db	00h,68h
		db	00h,50h
		db	00h,88h
		db	01h,04h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_711:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,01h
		db	00h,01h
		db	00h,02h
		db	00h,02h
		db	00h,04h
		db	00h,04h
		db	00h,08h
		db	00h,10h
		db	00h,08h
		db	04h,90h
		db	03h,50h
		db	04h,20h
		db	18h,40h
		db	20h,68h
		db	00h,50h
		db	00h,88h
		db	01h,04h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_712:
		db	00h,00h
		db	00h,02h
		db	00h,02h
		db	00h,01h
		db	00h,01h
		db	00h,02h
		db	00h,12h
		db	00h,0Ch
		db	00h,04h
		db	00h,08h
		db	14h,10h
		db	08h,08h
		db	04h,90h
		db	03h,50h
		db	04h,20h
		db	18h,44h
		db	20h,68h
		db	00h,50h
		db	00h,88h
		db	01h,04h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_713:
		db	00h,01h
		db	00h,02h
		db	00h,02h
		db	00h,21h
		db	00h,41h
		db	00h,22h
		db	00h,12h
		db	00h,0Ch
		db	10h,04h
		db	20h,08h
		db	14h,10h
		db	08h,08h
		db	04h,90h
		db	03h,50h
		db	04h,20h
		db	18h,46h
		db	20h,68h
		db	00h,50h
		db	00h,88h
		db	01h,04h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_714:
		db	00h,01h
		db	00h,0Ah
		db	02h,52h
		db	01h,21h
		db	00h,0C1h
		db	00h,22h
		db	00h,12h
		db	00h,0Ch
		db	10h,04h
		db	20h,08h
		db	14h,10h
		db	28h,08h
		db	04h,90h
		db	03h,50h
		db	04h,20h
		db	18h,46h
		db	20h,68h
		db	00h,50h
		db	00h,8Ah
		db	01h,04h
		db	03h,00h
		db	02h,00h
		db	01h,00h

Analyzer_phase_715:
		db	14h,01h
		db	08h,0Ah
		db	06h,52h
		db	01h,21h
		db	00h,0C1h
		db	00h,22h
		db	00h,12h
		db	00h,0Ch
		db	10h,04h
		db	20h,08h
		db	14h,10h
		db	0A8h,08h
		db	44h,90h
		db	03h,50h
		db	04h,21h
		db	18h,46h
		db	20h,68h
		db	00h,50h
		db	00h,8Ah
		db	01h,04h
		db	03h,00h
		db	02h,00h
		db	01h,00h
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_08:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_801
		dw	Analyzer_phase_802
		dw	Analyzer_phase_803
		dw	Analyzer_phase_804
		dw	Analyzer_phase_805
		dw	Analyzer_phase_806
		dw	Analyzer_phase_807
		dw	Analyzer_phase_808
		dw	Analyzer_phase_809
		dw	Analyzer_phase_810
		dw	Analyzer_phase_811
		dw	Analyzer_phase_812
		dw	Analyzer_phase_813
		dw	Analyzer_phase_814
		dw	Analyzer_phase_815

Analyzer_phase_801:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_802:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,04h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_803:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,08h
		db	00h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_804:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,10h
		db	00h,08h
		db	00h,15h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_805:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,10h
		db	00h,69h
		db	00h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_806:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,40h
		db	00h,20h
		db	00h,92h
		db	00h,69h
		db	00h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_807:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,92h
		db	00h,69h
		db	00h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_808:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,40h
		db	00h,80h
		db	00h,40h
		db	01h,24h
		db	00h,0D2h
		db	00h,09h
		db	00h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_809:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,40h
		db	01h,40h
		db	00h,80h
		db	00h,42h
		db	01h,24h
		db	02h,0D2h
		db	00h,09h
		db	00h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_810:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,00h
		db	04h,00h
		db	02h,80h
		db	02h,40h
		db	01h,40h
		db	00h,80h
		db	00h,42h
		db	01h,24h
		db	02h,0D2h
		db	00h,09h
		db	00h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_811:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,00h
		db	08h,00h
		db	04h,40h
		db	02h,80h
		db	02h,40h
		db	01h,40h
		db	00h,81h
		db	00h,42h
		db	01h,24h
		db	02h,0D2h
		db	04h,09h
		db	00h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_812:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	14h,00h
		db	08h,00h
		db	08h,80h
		db	04h,40h
		db	02h,80h
		db	02h,40h
		db	01h,40h
		db	00h,81h
		db	00h,42h
		db	01h,24h
		db	02h,0D2h
		db	04h,09h
		db	02h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_813:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,00h
		db	10h,00h
		db	14h,00h
		db	08h,00h
		db	98h,80h
		db	64h,40h
		db	02h,80h
		db	02h,40h
		db	01h,40h
		db	00h,81h
		db	00h,42h
		db	01h,24h
		db	02h,0D2h
		db	04h,09h
		db	02h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_814:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	40h,00h
		db	20h,00h
		db	10h,00h
		db	12h,00h
		db	14h,00h
		db	08h,00h
		db	98h,80h
		db	64h,40h
		db	02h,80h
		db	02h,40h
		db	01h,40h
		db	00h,81h
		db	00h,42h
		db	01h,24h
		db	02h,0D2h
		db	04h,09h
		db	02h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h

Analyzer_phase_815:
		db	80h,00h
		db	40h,00h
		db	20h,00h
		db	40h,00h
		db	24h,00h
		db	14h,00h
		db	12h,00h
		db	14h,00h
		db	08h,00h
		db	98h,80h
		db	64h,40h
		db	02h,80h
		db	02h,40h
		db	01h,40h
		db	00h,81h
		db	00h,42h
		db	01h,24h
		db	02h,0D2h
		db	04h,09h
		db	02h,05h
		db	00h,02h
		db	00h,01h
		db	00h,01h
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_09:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_901
		dw	Analyzer_phase_902
		dw	Analyzer_phase_903
		dw	Analyzer_phase_904
		dw	Analyzer_phase_905
		dw	Analyzer_phase_906
		dw	Analyzer_phase_907
		dw	Analyzer_phase_908
		dw	Analyzer_phase_909
		dw	Analyzer_phase_910
		dw	Analyzer_phase_911
		dw	Analyzer_phase_912
		dw	Analyzer_phase_913
		dw	Analyzer_phase_914
		dw	Analyzer_phase_915

Analyzer_phase_901:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_902:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,04h
		db	00h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_903:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,1Ah
		db	00h,04h
		db	00h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_904:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,21h
		db	00h,1Ah
		db	00h,04h
		db	00h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_905:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,61h
		db	00h,1Ah
		db	00h,04h
		db	00h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_906:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,40h
		db	00h,22h
		db	00h,61h
		db	00h,9Ah
		db	00h,04h
		db	00h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_907:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	00h,41h
		db	00h,22h
		db	00h,61h
		db	01h,9Ah
		db	00h,04h
		db	00h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_908:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	01h,00h
		db	00h,80h
		db	00h,41h
		db	00h,22h
		db	02h,61h
		db	01h,9Ah
		db	00h,04h
		db	00h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_909:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,40h
		db	02h,80h
		db	01h,00h
		db	00h,80h
		db	00h,41h
		db	00h,22h
		db	02h,61h
		db	01h,9Ah
		db	00h,04h
		db	00h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_910:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	04h,40h
		db	02h,80h
		db	01h,00h
		db	00h,80h
		db	00h,41h
		db	00h,22h
		db	02h,61h
		db	01h,9Ah
		db	00h,04h
		db	00h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_911:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,80h
		db	04h,40h
		db	02h,80h
		db	01h,00h
		db	00h,82h
		db	00h,41h
		db	00h,22h
		db	02h,61h
		db	01h,9Ah
		db	02h,04h
		db	00h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_912:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	11h,00h
		db	08h,80h
		db	04h,40h
		db	02h,80h
		db	01h,00h
		db	00h,82h
		db	00h,41h
		db	00h,22h
		db	02h,61h
		db	01h,9Ah
		db	02h,04h
		db	01h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_913:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,80h
		db	11h,00h
		db	08h,80h
		db	04h,40h
		db	02h,80h
		db	01h,04h
		db	00h,82h
		db	00h,41h
		db	00h,22h
		db	02h,61h
		db	01h,9Ah
		db	02h,04h
		db	01h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_914:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,00h
		db	40h,00h
		db	22h,80h
		db	11h,00h
		db	28h,80h
		db	04h,40h
		db	02h,80h
		db	01h,04h
		db	00h,82h
		db	00h,41h
		db	00h,22h
		db	02h,61h
		db	01h,9Ah
		db	02h,04h
		db	01h,02h
		db	00h,01h
		db	00h,02h

Analyzer_phase_915:
		db	80h,00h
		db	40h,00h
		db	20h,00h
		db	40h,00h
		db	80h,00h
		db	40h,40h
		db	0A0h,20h
		db	40h,40h
		db	22h,80h
		db	11h,00h
		db	28h,80h
		db	44h,40h
		db	42h,80h
		db	0A1h,04h
		db	00h,82h
		db	00h,41h
		db	00h,22h
		db	02h,61h
		db	01h,9Ah
		db	02h,04h
		db	01h,02h
		db	00h,01h
		db	00h,02h

;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_10:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_A01
		dw	Analyzer_phase_A02
		dw	Analyzer_phase_A03
		dw	Analyzer_phase_A04
		dw	Analyzer_phase_A05
		dw	Analyzer_phase_A06
		dw	Analyzer_phase_A07
		dw	Analyzer_phase_A08
		dw	Analyzer_phase_A09
		dw	Analyzer_phase_A10
		dw	Analyzer_phase_A11
		dw	Analyzer_phase_A12
		dw	Analyzer_phase_A13
		dw	Analyzer_phase_A14
		dw	Analyzer_phase_A15

Analyzer_phase_A01:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,04h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A02:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,08h
		db	00h,04h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A03:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,10h
		db	00h,08h
		db	00h,14h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A04:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,60h
		db	00h,10h
		db	00h,08h
		db	00h,14h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A05:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,0C0h
		db	00h,60h
		db	00h,10h
		db	00h,08h
		db	00h,14h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A06:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,10h
		db	01h,20h
		db	00h,0C0h
		db	00h,60h
		db	00h,10h
		db	00h,08h
		db	00h,14h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A07:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,10h
		db	01h,20h
		db	00h,0C0h
		db	00h,60h
		db	00h,10h
		db	00h,08h
		db	00h,14h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A08:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,00h
		db	05h,10h
		db	05h,20h
		db	00h,0C0h
		db	00h,60h
		db	00h,10h
		db	00h,08h
		db	00h,14h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A09:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	02h,08h
		db	05h,10h
		db	05h,20h
		db	08h,0C0h
		db	00h,60h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A10:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,00h
		db	04h,00h
		db	02h,08h
		db	05h,10h
		db	05h,20h
		db	08h,0C0h
		db	08h,60h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A11:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	08h,00h
		db	10h,00h
		db	08h,00h
		db	04h,00h
		db	02h,08h
		db	05h,10h
		db	05h,20h
		db	08h,0C0h
		db	08h,60h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A12:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	05h,00h
		db	02h,00h
		db	04h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h
		db	04h,02h
		db	02h,0Ch
		db	05h,10h
		db	05h,20h
		db	08h,0C0h
		db	08h,60h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A13:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	08h,00h
		db	05h,00h
		db	02h,00h
		db	44h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h
		db	04h,02h
		db	02h,0Ch
		db	05h,10h
		db	05h,20h
		db	08h,0C0h
		db	18h,60h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A14:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	08h,00h
		db	45h,00h
		db	22h,00h
		db	44h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h
		db	04h,02h
		db	02h,0Ch
		db	05h,10h
		db	05h,20h
		db	08h,0C0h
		db	18h,60h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,02h
		db	00h,04h

Analyzer_phase_A15:
		db	00h,00h
		db	02h,00h
		db	04h,00h
		db	08h,00h
		db	04h,00h
		db	88h,00h
		db	45h,00h
		db	22h,00h
		db	44h,00h
		db	28h,00h
		db	10h,00h
		db	08h,00h
		db	04h,02h
		db	02h,0Ch
		db	05h,10h
		db	05h,20h
		db	08h,0C0h
		db	18h,60h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,02h
		db	00h,04h

;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_11:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_B01
		dw	Analyzer_phase_B02
		dw	Analyzer_phase_B03
		dw	Analyzer_phase_B04
		dw	Analyzer_phase_B05
		dw	Analyzer_phase_B06
		dw	Analyzer_phase_B07
		dw	Analyzer_phase_B08
		dw	Analyzer_phase_B09
		dw	Analyzer_phase_B10
		dw	Analyzer_phase_B11
		dw	Analyzer_phase_B12
		dw	Analyzer_phase_B13
		dw	Analyzer_phase_B14
		dw	Analyzer_phase_B15

Analyzer_phase_B01:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B02:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B03:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,28h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B04:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,40h
		db	00h,44h
		db	00h,28h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B05:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	00h,48h
		db	00h,44h
		db	00h,28h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B06:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	01h,00h
		db	02h,90h
		db	00h,48h
		db	00h,44h
		db	00h,28h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B07:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	01h,08h
		db	02h,90h
		db	04h,48h
		db	00h,44h
		db	00h,28h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B08:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,04h
		db	01h,04h
		db	01h,08h
		db	02h,90h
		db	04h,48h
		db	02h,44h
		db	00h,28h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B09:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,08h
		db	02h,04h
		db	01h,04h
		db	01h,08h
		db	02h,90h
		db	04h,48h
		db	02h,44h
		db	04h,28h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B10:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,00h
		db	0Ah,00h
		db	04h,08h
		db	02h,04h
		db	01h,04h
		db	01h,08h
		db	02h,90h
		db	04h,48h
		db	02h,44h
		db	04h,28h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B11:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	12h,00h
		db	09h,00h
		db	0Ah,00h
		db	04h,08h
		db	02h,14h
		db	01h,04h
		db	01h,08h
		db	02h,90h
		db	04h,48h
		db	02h,44h
		db	04h,28h
		db	00h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B12:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,80h
		db	21h,00h
		db	12h,00h
		db	09h,00h
		db	0Ah,00h
		db	04h,08h
		db	02h,14h
		db	01h,04h
		db	01h,08h
		db	02h,90h
		db	04h,48h
		db	02h,44h
		db	04h,28h
		db	02h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B13:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	40h,00h
		db	20h,80h
		db	21h,40h
		db	12h,00h
		db	09h,00h
		db	0Ah,00h
		db	04h,28h
		db	02h,14h
		db	01h,04h
		db	01h,08h
		db	02h,90h
		db	04h,48h
		db	02h,44h
		db	04h,28h
		db	02h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B14:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	81h,00h
		db	80h,80h
		db	41h,00h
		db	20h,80h
		db	21h,40h
		db	12h,00h
		db	09h,00h
		db	0Ah,00h
		db	04h,28h
		db	02h,14h
		db	01h,04h
		db	01h,08h
		db	02h,90h
		db	04h,48h
		db	02h,44h
		db	04h,28h
		db	02h,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h

Analyzer_phase_B15:
		db	51h,00h
		db	21h,00h
		db	42h,00h
		db	81h,00h
		db	80h,80h
		db	41h,00h
		db	20h,80h
		db	21h,40h
		db	12h,00h
		db	09h,00h
		db	0Ah,00h
		db	04h,28h
		db	02h,14h
		db	01h,04h
		db	01h,08h
		db	02h,90h
		db	04h,48h
		db	02h,44h
		db	04h,28h
		db	0Ah,10h
		db	00h,08h
		db	00h,04h
		db	00h,08h
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_12:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_C01
		dw	Analyzer_phase_C02
		dw	Analyzer_phase_C03
		dw	Analyzer_phase_C04
		dw	Analyzer_phase_C05
		dw	Analyzer_phase_C06
		dw	Analyzer_phase_C07
		dw	Analyzer_phase_C08
		dw	Analyzer_phase_C09
		dw	Analyzer_phase_C10
		dw	Analyzer_phase_C11
		dw	Analyzer_phase_C12
		dw	Analyzer_phase_C13
		dw	Analyzer_phase_C14
		dw	Analyzer_phase_C15

Analyzer_phase_C01:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,10h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C02:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,10h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C03:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,40h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C04:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	00h,40h
		db	00h,40h
		db	00h,20h
		db	00h,14h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C05:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	01h,00h
		db	00h,80h
		db	00h,40h
		db	00h,40h
		db	00h,22h
		db	00h,14h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C06:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	02h,00h
		db	01h,00h
		db	01h,00h
		db	00h,80h
		db	00h,40h
		db	00h,44h
		db	00h,22h
		db	00h,14h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C07:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	04h,00h
		db	02h,00h
		db	01h,00h
		db	01h,00h
		db	00h,80h
		db	00h,44h
		db	00h,44h
		db	00h,22h
		db	00h,14h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C08:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,00h
		db	04h,00h
		db	04h,00h
		db	04h,00h
		db	02h,00h
		db	01h,00h
		db	01h,00h
		db	02h,80h
		db	04h,48h
		db	00h,44h
		db	00h,22h
		db	00h,14h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C09:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,00h
		db	10h,00h
		db	08h,00h
		db	04h,00h
		db	04h,00h
		db	04h,00h
		db	02h,00h
		db	01h,00h
		db	01h,00h
		db	02h,84h
		db	0Ch,48h
		db	00h,44h
		db	00h,22h
		db	00h,14h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C10:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,00h
		db	20h,00h
		db	10h,00h
		db	08h,00h
		db	04h,00h
		db	04h,00h
		db	04h,00h
		db	02h,00h
		db	01h,00h
		db	01h,08h
		db	02h,84h
		db	1Ch,48h
		db	00h,44h
		db	00h,22h
		db	00h,14h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C11:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	80h,00h
		db	40h,00h
		db	20h,00h
		db	20h,00h
		db	10h,00h
		db	08h,00h
		db	04h,00h
		db	04h,00h
		db	04h,00h
		db	02h,00h
		db	01h,00h
		db	01h,08h
		db	22h,84h
		db	1Ch,48h
		db	00h,44h
		db	00h,22h
		db	00h,14h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C12:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	10h,00h
		db	0A0h,00h
		db	40h,00h
		db	20h,00h
		db	20h,00h
		db	10h,00h
		db	08h,00h
		db	04h,00h
		db	04h,00h
		db	04h,00h
		db	02h,00h
		db	01h,14h
		db	01h,08h
		db	22h,84h
		db	1Ch,48h
		db	20h,44h
		db	40h,22h
		db	00h,14h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C13:
		db	00h,00h
		db	00h,00h
		db	28h,00h
		db	10h,00h
		db	0A0h,00h
		db	40h,00h
		db	20h,00h
		db	20h,00h
		db	10h,00h
		db	08h,00h
		db	04h,00h
		db	04h,00h
		db	04h,00h
		db	02h,00h
		db	01h,14h
		db	01h,08h
		db	22h,84h
		db	1Ch,48h
		db	20h,44h
		db	40h,22h
		db	80h,14h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C14:
		db	00h,00h
		db	47h,00h
		db	28h,00h
		db	10h,00h
		db	0A0h,00h
		db	40h,00h
		db	20h,00h
		db	20h,00h
		db	10h,00h
		db	08h,00h
		db	04h,00h
		db	04h,00h
		db	04h,00h
		db	02h,00h
		db	01h,14h
		db	01h,08h
		db	22h,84h
		db	1Ch,48h
		db	20h,44h
		db	40h,22h
		db	80h,14h
		db	00h,08h
		db	00h,10h

Analyzer_phase_C15:
		db	80h,80h
		db	47h,00h
		db	28h,00h
		db	10h,00h
		db	0A0h,00h
		db	40h,00h
		db	20h,00h
		db	20h,00h
		db	10h,00h
		db	08h,00h
		db	04h,00h
		db	04h,00h
		db	04h,00h
		db	02h,00h
		db	01h,14h
		db	01h,08h
		db	22h,84h
		db	1Ch,48h
		db	20h,44h
		db	40h,22h
		db	80h,14h
		db	00h,08h
		db	00h,10h
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_13:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_D01
		dw	Analyzer_phase_D02
		dw	Analyzer_phase_D03
		dw	Analyzer_phase_D04
		dw	Analyzer_phase_D05
		dw	Analyzer_phase_D06
		dw	Analyzer_phase_D07
		dw	Analyzer_phase_D08
		dw	Analyzer_phase_D09
		dw	Analyzer_phase_D10
		dw	Analyzer_phase_D11
		dw	Analyzer_phase_D12
		dw	Analyzer_phase_D13
		dw	Analyzer_phase_D14
		dw	Analyzer_phase_D15

Analyzer_phase_D01:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D02:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D03:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	00h,0A0h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D04:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,08h
		db	00h,90h
		db	00h,0A0h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D05:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,04h
		db	01h,08h
		db	00h,90h
		db	00h,0A0h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D06:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,0Ah
		db	02h,04h
		db	01h,08h
		db	00h,90h
		db	00h,0A0h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D07:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	08h,20h
		db	08h,10h
		db	04h,0Ah
		db	02h,04h
		db	01h,08h
		db	00h,90h
		db	00h,0A0h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D08:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	10h,20h
		db	08h,20h
		db	08h,10h
		db	04h,0Ah
		db	02h,04h
		db	01h,08h
		db	00h,90h
		db	00h,0A0h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D09:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,80h
		db	20h,40h
		db	10h,50h
		db	08h,20h
		db	08h,10h
		db	04h,0Ah
		db	02h,04h
		db	01h,08h
		db	00h,90h
		db	00h,0A0h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D10:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	80h,40h
		db	40h,80h
		db	20h,80h
		db	20h,40h
		db	10h,50h
		db	08h,20h
		db	08h,10h
		db	04h,0Ah
		db	02h,04h
		db	01h,08h
		db	00h,90h
		db	00h,0A0h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D11:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	80h,00h
		db	80h,00h
		db	80h,40h
		db	40h,80h
		db	20h,80h
		db	20h,48h
		db	10h,50h
		db	08h,20h
		db	08h,10h
		db	04h,0Ah
		db	02h,04h
		db	01h,08h
		db	00h,90h
		db	00h,0A0h
		db	00h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D12:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	40h,00h
		db	80h,40h
		db	80h,20h
		db	80h,40h
		db	40h,80h
		db	20h,94h
		db	20h,48h
		db	10h,50h
		db	08h,20h
		db	08h,10h
		db	04h,0Ah
		db	02h,04h
		db	01h,08h
		db	00h,90h
		db	02h,0A0h
		db	01h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D13:
		db	00h,00h
		db	00h,00h
		db	50h,00h
		db	20h,00h
		db	40h,00h
		db	80h,40h
		db	80h,20h
		db	80h,40h
		db	40h,80h
		db	20h,94h
		db	20h,48h
		db	10h,50h
		db	08h,20h
		db	08h,10h
		db	04h,0Ah
		db	02h,04h
		db	01h,08h
		db	04h,90h
		db	0Ah,0A0h
		db	01h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D14:
		db	00h,00h
		db	80h,00h
		db	50h,00h
		db	20h,00h
		db	40h,00h
		db	80h,40h
		db	80h,20h
		db	80h,40h
		db	40h,80h
		db	20h,94h
		db	20h,48h
		db	10h,50h
		db	08h,20h
		db	08h,10h
		db	04h,0Ah
		db	02h,04h
		db	01h,08h
		db	04h,90h
		db	1Ah,0A0h
		db	01h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h

Analyzer_phase_D15:
		db	41h,00h
		db	86h,00h
		db	58h,00h
		db	20h,00h
		db	40h,00h
		db	80h,40h
		db	80h,20h
		db	81h,40h
		db	40h,80h
		db	20h,94h
		db	20h,48h
		db	10h,50h
		db	08h,20h
		db	08h,10h
		db	04h,0Ah
		db	02h,04h
		db	01h,08h
		db	24h,90h
		db	1Ah,0A0h
		db	01h,40h
		db	00h,20h
		db	00h,10h
		db	00h,20h
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_14:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_E01
		dw	Analyzer_phase_E02
		dw	Analyzer_phase_E03
		dw	Analyzer_phase_E04
		dw	Analyzer_phase_E05
		dw	Analyzer_phase_E06
		dw	Analyzer_phase_E07
		dw	Analyzer_phase_E08
		dw	Analyzer_phase_E09
		dw	Analyzer_phase_E10
		dw	Analyzer_phase_E11
		dw	Analyzer_phase_E12
		dw	Analyzer_phase_E13
		dw	Analyzer_phase_E14
		dw	Analyzer_phase_E15

Analyzer_phase_E01:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E02:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E03:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	00h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E04:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,00h
		db	02h,80h
		db	01h,00h
		db	00h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E05:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	02h,00h
		db	02h,80h
		db	01h,00h
		db	00h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E06:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	0Ch,00h
		db	02h,40h
		db	02h,80h
		db	01h,00h
		db	00h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E07:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,00h
		db	20h,00h
		db	20h,00h
		db	10h,00h
		db	08h,00h
		db	04h,00h
		db	0Ch,80h
		db	12h,40h
		db	22h,80h
		db	01h,00h
		db	00h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E08:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	88h,00h
		db	50h,00h
		db	20h,00h
		db	20h,00h
		db	20h,00h
		db	10h,00h
		db	09h,00h
		db	05h,00h
		db	0Ch,80h
		db	12h,40h
		db	22h,80h
		db	01h,00h
		db	00h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E09:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	48h,00h
		db	44h,00h
		db	88h,00h
		db	50h,00h
		db	20h,00h
		db	20h,00h
		db	20h,00h
		db	10h,80h
		db	09h,00h
		db	05h,00h
		db	0Ch,80h
		db	12h,40h
		db	22h,80h
		db	01h,00h
		db	00h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E10:
		db	00h,00h
		db	00h,00h
		db	20h,00h
		db	14h,00h
		db	48h,00h
		db	50h,00h
		db	88h,00h
		db	50h,00h
		db	20h,00h
		db	20h,00h
		db	20h,00h
		db	10h,80h
		db	09h,00h
		db	05h,00h
		db	0Ch,0A0h
		db	12h,40h
		db	22h,80h
		db	21h,00h
		db	00h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E11:
		db	00h,00h
		db	44h,00h
		db	28h,00h
		db	14h,00h
		db	48h,00h
		db	50h,00h
		db	88h,00h
		db	50h,00h
		db	20h,00h
		db	20h,00h
		db	20h,00h
		db	10h,80h
		db	09h,00h
		db	05h,10h
		db	0Ch,0A8h
		db	52h,40h
		db	22h,80h
		db	21h,00h
		db	00h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E12:
		db	80h,00h
		db	44h,00h
		db	2Bh,00h
		db	10h,00h
		db	48h,00h
		db	50h,00h
		db	88h,00h
		db	50h,00h
		db	20h,00h
		db	20h,00h
		db	20h,00h
		db	10h,80h
		db	09h,00h
		db	05h,10h
		db	0Ch,0A8h
		db	52h,44h
		db	22h,80h
		db	21h,00h
		db	00h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E13:
		db	00h,11h
		db	00h,22h
		db	02h,0D4h
		db	01h,08h
		db	00h,12h
		db	00h,0Ah
		db	00h,11h
		db	00h,0Ah
		db	00h,04h
		db	00h,04h
		db	02h,04h
		db	01h,08h
		db	00h,90h
		db	08h,0A0h
		db	15h,30h
		db	22h,4Ah
		db	01h,44h
		db	00h,84h
		db	01h,02h
		db	01h,00h
		db	02h,00h
		db	04h,00h
		db	02h,00h

Analyzer_phase_E14:
		db	88h,00h
		db	44h,00h
		db	2Bh,40h
		db	10h,80h
		db	48h,00h
		db	50h,00h
		db	88h,00h
		db	50h,00h
		db	20h,00h
		db	20h,00h
		db	20h,40h
		db	10h,80h
		db	09h,00h
		db	05h,10h
		db	0Ch,0A8h
		db	52h,44h
		db	22h,80h
		db	21h,00h
		db	40h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h

Analyzer_phase_E15:
		db	88h,10h
		db	44h,20h
		db	2Bh,40h
		db	10h,80h
		db	48h,00h
		db	50h,00h
		db	88h,00h
		db	50h,00h
		db	20h,00h
		db	20h,00h
		db	20h,40h
		db	10h,0A0h
		db	09h,00h
		db	05h,10h
		db	0Ch,0A8h
		db	52h,44h
		db	0A2h,88h
		db	21h,00h
		db	40h,80h
		db	00h,80h
		db	00h,40h
		db	00h,20h
		db	00h,40h
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase_15:
		dw	Analyzer_phase_000
		dw	Analyzer_phase_F01
		dw	Analyzer_phase_F02
		dw	Analyzer_phase_F03
		dw	Analyzer_phase_F04
		dw	Analyzer_phase_F05
		dw	Analyzer_phase_F06
		dw	Analyzer_phase_F07
		dw	Analyzer_phase_F08
		dw	Analyzer_phase_F09
		dw	Analyzer_phase_F10
		dw	Analyzer_phase_F11
		dw	Analyzer_phase_F12
		dw	Analyzer_phase_F13
		dw	Analyzer_phase_F14
		dw	Analyzer_phase_F15

Analyzer_phase_F01:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F02:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	01h,00h
		db	00h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F03:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	02h,00h
		db	01h,00h
		db	00h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F04:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	06h,00h
		db	02h,00h
		db	01h,00h
		db	00h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F05:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	04h,00h
		db	02h,00h
		db	06h,00h
		db	0Ah,00h
		db	01h,00h
		db	00h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F06:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	09h,00h
		db	0Ah,00h
		db	04h,00h
		db	02h,00h
		db	06h,00h
		db	0Ah,00h
		db	01h,00h
		db	00h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F07:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	10h,00h
		db	09h,00h
		db	0Ah,0C0h
		db	04h,00h
		db	02h,00h
		db	06h,00h
		db	0Ah,00h
		db	11h,00h
		db	00h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F08:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	10h,00h
		db	08h,00h
		db	10h,00h
		db	09h,00h
		db	0Ah,0C0h
		db	04h,20h
		db	02h,00h
		db	06h,00h
		db	0Ah,00h
		db	11h,00h
		db	00h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F09:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	20h,00h
		db	20h,00h
		db	10h,00h
		db	08h,00h
		db	10h,00h
		db	09h,00h
		db	0Ah,0C0h
		db	04h,20h
		db	02h,10h
		db	06h,00h
		db	0Ah,00h
		db	11h,00h
		db	20h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F10:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	40h,00h
		db	40h,00h
		db	20h,00h
		db	20h,00h
		db	10h,00h
		db	08h,00h
		db	10h,00h
		db	09h,00h
		db	0Ah,0C0h
		db	04h,20h
		db	02h,18h
		db	16h,00h
		db	0Ah,00h
		db	11h,00h
		db	20h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F11:
		db	00h,00h
		db	00h,00h
		db	00h,00h
		db	80h,00h
		db	80h,00h
		db	40h,00h
		db	40h,00h
		db	20h,00h
		db	20h,00h
		db	10h,00h
		db	08h,00h
		db	10h,00h
		db	09h,20h
		db	0Ah,0C0h
		db	04h,20h
		db	02h,18h
		db	16h,04h
		db	0Ah,00h
		db	11h,00h
		db	20h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F12:
		db	00h,00h
		db	40h,00h
		db	40h,00h
		db	80h,00h
		db	80h,00h
		db	40h,00h
		db	48h,00h
		db	30h,00h
		db	20h,00h
		db	10h,00h
		db	08h,28h
		db	10h,10h
		db	09h,20h
		db	0Ah,0C0h
		db	04h,20h
		db	22h,18h
		db	16h,04h
		db	0Ah,00h
		db	11h,00h
		db	20h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F13:
		db	80h,00h
		db	40h,00h
		db	40h,00h
		db	84h,00h
		db	82h,00h
		db	44h,00h
		db	48h,00h
		db	30h,00h
		db	20h,08h
		db	10h,04h
		db	08h,28h
		db	10h,10h
		db	09h,20h
		db	0Ah,0C0h
		db	04h,20h
		db	62h,18h
		db	16h,04h
		db	0Ah,00h
		db	11h,00h
		db	20h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F14:
		db	80h,00h
		db	50h,00h
		db	4Ah,40h
		db	84h,80h
		db	83h,00h
		db	44h,00h
		db	48h,00h
		db	30h,00h
		db	20h,08h
		db	10h,04h
		db	08h,28h
		db	10h,14h
		db	09h,20h
		db	0Ah,0C0h
		db	04h,20h
		db	62h,18h
		db	16h,04h
		db	0Ah,00h
		db	51h,00h
		db	20h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h

Analyzer_phase_F15:
		db	80h,28h
		db	50h,10h
		db	4Ah,60h
		db	84h,80h
		db	83h,00h
		db	44h,00h
		db	48h,00h
		db	30h,00h
		db	20h,08h
		db	10h,04h
		db	08h,28h
		db	10h,15h
		db	09h,22h
		db	0Ah,0C0h
		db	84h,20h
		db	62h,18h
		db	16h,04h
		db	0Ah,00h
		db	51h,00h
		db	20h,80h
		db	00h,0C0h
		db	00h,40h
		db	00h,80h
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
Analyzer_ch0_oldvol:
		db	0
Analyzer_ch1_oldvol:
		db	0
Analyzer_ch2_oldvol:
		db	0
Analyzer_ch3_oldvol:
		db	0
Analyzer_ch4_oldvol:
		db	0
Analyzer_ch5_oldvol:
		db	0
