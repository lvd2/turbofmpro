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
		ld	hl,5264h
		call	Analyzer_draw

		ld	c,13
		ld	hl,5464h
		call	Analyzer_draw

		ld	c,12
		ld	hl,5664h
		call	Analyzer_draw

		ld	c,10
		ld	hl,5084h
		call	Analyzer_draw

		ld	c,9
		ld	hl,5284h
		call	Analyzer_draw

		ld	c,8
		ld	hl,5484h
		call	Analyzer_draw
                                                        
		ld	c,7
		ld	hl,5684h
		call	Analyzer_draw

		ld	c,6
		ld	hl,50A4h
		call	Analyzer_draw
                                                        
		ld	c,5
		ld	hl,52A4h
		call	Analyzer_draw

		ld	c,4
		ld	hl,54A4h
		call	Analyzer_draw

		ld	c,3
		ld	hl,56A4h
		call	Analyzer_draw

		ld	c,2
		ld	hl,50C4h
		call	Analyzer_draw

		ld	c,1
		ld	hl,52C4h
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
		ld	(hl),0FCh
		dec	l
		ld	(hl),3Fh
		inc	l
Analyzer_next:
		inc	l
		inc	de
		djnz	Analyzer_loop
		ret	
Analyzer_skip:
		nop
		add	a,1
		jr	Analyzer_next	
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_flash:
		ld	a,(Analyzer_ch0_left)
		ld	e,a
		ld	a,(Analyzer_ch0_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch1_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch1_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch2_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch2_right)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5A1Dh
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	a,(Analyzer_ch3_left)
		ld	e,a
		ld	a,(Analyzer_ch3_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch4_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch4_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch5_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch5_right)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,586Dh
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
		db	47h,47h,47h,47h,46h,46h,45h,45h,44h,44h,43h,43h,42h,42h,41h,41h	
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