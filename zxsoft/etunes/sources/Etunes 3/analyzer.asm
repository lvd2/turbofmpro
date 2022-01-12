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
		ld	(Analyzer_ch0_left),a           ;Amplitude 0 left 
		ld	a,(hl)				;+00h - Amplitude 0 right/left				
		and	0F0h
		rrca	
		rrca	
		rrca
		rrca	
		ld	(Analyzer_ch0_right),a          ;Amplitude 0 right 

		inc	hl
		ld	a,(hl)				;+01h - Amplitude 1 right/left
		and	0Fh
		ld	(Analyzer_ch1_left),a           ;Amplitude 1 left 
		ld	a, (hl)				;+01h - Amplitude 1 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch1_right),a          ;Amplitude 1 right 

		inc	hl
		ld	a,(hl) 				;+02h - Amplitude 2 right/left
		and	0Fh
		ld	(Analyzer_ch2_left),a           ;Amplitude 2 left 
		ld	a,(hl)				;+02h - Amplitude 2 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch2_right),a         	;Amplitude 2 right 

		inc	hl
		ld	a, (hl) 			;+03h - Amplitude 3 right/left
		and	0Fh
		ld	(Analyzer_ch3_left),a          	;Amplitude 3 left 
		ld	a, (hl)                         ;+03h - Amplitude 3 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch3_right),a         	;Amplitude 3 right 

		inc	hl
		ld	a, (hl)				;+04h - Amplitude 4 right/left
		and	0Fh
		ld	(Analyzer_ch4_left),a           ;Amplitude 4 left 
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch4_right),a          ;Amplitude 4 right 

		inc	hl
		ld	a, (hl)				;+05h - Amplitude 5 right/left
		and	0Fh
		ld	(Analyzer_ch5_left),a           ;Amplitude 5 left 
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch5_right),a		;Amplitude 5 right 
		ret

;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view:
		ld	c,15
		ld	hl,58E1h
		call	Analyzer_draw

		ld	c,13
		ld	hl,5901h
		call	Analyzer_draw

		ld	c,11
		ld	hl,5921h
		call	Analyzer_draw

		ld	c,9
		ld	hl,5941h
		call	Analyzer_draw
                                                        
		ld	c,7
		ld	hl,5961h
		call	Analyzer_draw

		ld	c,6
		ld	hl,5981h
		call	Analyzer_draw
                                                        
		ld	c,5
		ld	hl,59A1h
		call	Analyzer_draw

		ld	c,4
		ld	hl,59C1h
		call	Analyzer_draw

		ld	c,3
		ld	hl,59E1h
		call	Analyzer_draw

		ld	c,2
		ld	hl,5A01h
		call	Analyzer_draw

		ld	c,1
		ld	hl,5A21h
		call	Analyzer_draw

		ret
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw:
		ld	b,12
		ld	de,Analyzer_ch0_left
Analyzer_loop:
		ld	(hl),0
		inc	l
		ld	(hl),0
		ld	a,(de)
		cp	c
		jr	c,Analyzer_skip
		ld	a,12
		sub	b
		push	hl
		push	de
		ld	d,0
		ld	e,a
		ld	hl,Analyzer_table
		add	hl,de
		ld	a,(hl)
		pop	de
		pop	hl
		ld	(hl),a
		dec	l
		ld	(hl),a
		inc	l
Analyzer_skip:
		inc	l
		inc	de
		djnz	Analyzer_loop
		ret	
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_fill:
		ld	b,12
		ld	a,0Fh
Analyzer_fill_loop:
		ld	(hl),a
		inc	l
		djnz	Analyzer_fill_loop
		ret	
;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_init:
              	ld	b, 12
		ld	hl,Analyzer_ch0_left

Analyzer_init_loop:
                ld	(hl),0
		inc	hl
		djnz	Analyzer_init_loop
		ret

;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_table:
		db	01,41h,02,42h,03,43h,04,44h,05,45h,06,46h	
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_ch0_left:
		db	0	
Analyzer_ch0_right:
		db	0	
Analyzer_ch1_left:
		db	0	
Analyzer_ch1_right:
		db	0	
Analyzer_ch2_left:
		db	0	
Analyzer_ch2_right:
		db	0	
Analyzer_ch3_left:
		db	0	
Analyzer_ch3_right:
		db	0	
Analyzer_ch4_left:
		db	0	
Analyzer_ch4_right:
		db	0	
Analyzer_ch5_left:
		db	0	
Analyzer_ch5_right:
		db	0	
;		.end