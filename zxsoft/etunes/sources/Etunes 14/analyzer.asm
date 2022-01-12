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
		ld	de,4982h
		call	Analyzer_draw

		ld	a,(Analyzer_ch1_vol)
		ld	de,4982h + 5
		call	Analyzer_draw

		ld	a,(Analyzer_ch2_vol)
		ld	de,4982h + 10
		call	Analyzer_draw

		ld	a,(Analyzer_ch3_vol)
		ld	de,4982h + 15
		call	Analyzer_draw

		ld	a,(Analyzer_ch4_vol)
		ld	de,4982h + 20
		call	Analyzer_draw

		ld	a,(Analyzer_ch5_vol)
		ld	de,4982h + 25
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw:

		ld	l,a
		ld	h,0
		add	hl,hl
		ld	bc,Analyzer_table_phase
		add	hl,bc
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ex	de,hl

		ld	b,36				;размерность по Y
Analyzer_loop_Y:
		ld	c,10
		push	hl
		ex	hl,de
		ldi
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
		ld	hl,5807h
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
		ld	hl,581Bh
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
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_table:
		db	47h,47h,47h,47h,46h,46h,45h,45h,44h,44h,43h,43h,42h,42h,41h,41h	
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_phase:
		dw	Analyzer_phase_00		;0
		dw	Analyzer_phase_01               ;1
		dw	Analyzer_phase_02               ;2
		dw	Analyzer_phase_03               ;3
		dw	Analyzer_phase_04               ;4
		dw	Analyzer_phase_05               ;5
		dw	Analyzer_phase_06               ;6
		dw	Analyzer_phase_07               ;7
		dw	Analyzer_phase_00               ;8
		dw	Analyzer_phase_09               ;9
		dw	Analyzer_phase_10               ;10
		dw	Analyzer_phase_10               ;11
		dw	Analyzer_phase_11               ;12
		dw	Analyzer_phase_11               ;13
		dw	Analyzer_phase_12               ;14
		dw	Analyzer_phase_12               ;15

Analyzer_phase_00:
		db	80h,10h,03h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_01:
		db	80h,10h,03h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_02:
		db	80h,10h,03h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_03:
		db	80h,10h,03h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_04:
		db	80h,10h,03h
		db	00h,10h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_05:
		db	80h,10h,03h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,38h,01h
		db	00h,10h,01h
		db	00h,10h,01h
Analyzer_phase_06:
		db	80h,38h,03h
		db	00h,7Ch,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	01h,0FFh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,38h,01h
		db	00h,38h,01h
Analyzer_phase_07:
		db	80h,7Ch,03h
		db	00h,0FEh,01h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	01h,0FFh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,38h,01h
Analyzer_phase_08:
		db	80h,7Ch,03h
		db	01h,0FFh,01h
		db	03h,0FFh,81h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	1Fh,0FFh,0E1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	07h,0FFh,0C1h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,38h,01h
Analyzer_phase_09:
		db	80h,7Ch,03h
		db	01h,0FFh,01h
		db	03h,0FFh,81h
		db	07h,0FFh,0C1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	07h,0FFh,0C1h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	01h,0FFh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,38h,01h
Analyzer_phase_10:
		db	80h,7Ch,03h
		db	01h,0FFh,01h
		db	07h,0FFh,0C1h
		db	0Fh,0FFh,0E1h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	0Fh,0FFh,0E1h
		db	0Fh,0FFh,0E1h
		db	07h,0FFh,0C1h
		db	07h,0FFh,0C1h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	01h,0FFh,01h
		db	01h,0FFh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,38h,01h
Analyzer_phase_11:
		db	80h,7Ch,03h
		db	01h,0FFh,01h
		db	07h,0FFh,0C1h
		db	0Fh,0FFh,0E1h
		db	1Fh,0FFh,0F1h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	1Fh,0FFh,0F1h
		db	0Fh,0FFh,0E1h
		db	07h,0FFh,0C1h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	01h,0FFh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,7Eh,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,38h,01h
Analyzer_phase_12:
		db	80h,7Ch,03h
		db	01h,0FFh,01h
		db	07h,0FFh,0C1h
		db	1Fh,0FFh,0F1h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	7Fh,0FFh,0FDh
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	3Fh,0FFh,0F9h
		db	1Fh,0FFh,0F1h
		db	1Fh,0FFh,0F1h
		db	0Fh,0FFh,0E1h
		db	07h,0FFh,0C1h
		db	03h,0FFh,81h
		db	03h,0FFh,81h
		db	01h,0FFh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,0FEh,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,7Ch,01h
		db	00h,38h,01h


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
