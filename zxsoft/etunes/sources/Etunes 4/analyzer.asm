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

		ret

;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view:
		ld	a,(Analyzer_ch0_left)
		ld	hl,5243h
		ld	de,5343h
		call	Analyzer_draw

		ld	a,(Analyzer_ch0_right)
		ld	hl,5543h
		ld	de,5643h
		call	Analyzer_draw

		ld	a,(Analyzer_ch1_left)
		ld	hl,5163h
		ld	de,5263h
		call	Analyzer_draw

		ld	a,(Analyzer_ch1_right)
		ld	hl,5463h
		ld	de,5563h
		call	Analyzer_draw
                                                        
		ld	a,(Analyzer_ch2_left)
		ld	hl,5183h
		ld	de,5283h
		call	Analyzer_draw

		ld	a,(Analyzer_ch2_right)
		ld	hl,5483h
		ld	de,5583h
		call	Analyzer_draw

		ld	a,(Analyzer_ch3_left)
		ld	hl,50A3h
		ld	de,51A3h
		call	Analyzer_draw

		ld	a,(Analyzer_ch3_right)
		ld	hl,53A3h
		ld	de,54A3h
		call	Analyzer_draw

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
		ld	hl,5926h
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	hl,5946h
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	hl,5966h
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	hl,5986h
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	hl,59A6h
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		ret
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw:
		ld	c,a
		ld	b,a
		and	a
		jr	z,Analyzer_clear
		ld	a,0FEh
Analyzer_loop:
		ld	(hl),a
		ld	(de),a
		inc	l
		inc	e
		djnz	Analyzer_loop

Analyzer_clear:
		ld	b,c
		ld	a,15
		sub	b
		ret	z
		ld	b,a
		ld	a,0

Analyzer_clear_loop:
		ld	(hl),a
		ld	(de),a
		inc	l
		inc	e
		djnz	Analyzer_clear_loop
		ret	
;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_init:
              	ld	b, 8
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
;		.end