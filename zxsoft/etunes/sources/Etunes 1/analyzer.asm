;--------------------------------------------------------------------
; Описание: Модуль отображения анализатора
; портирован  с компьютера Sam Coupe - Fred magazine 34
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
		and	07h
		inc	a
		ld	(Analyzer_ch0_left),a           ;Amplitude 0 left 
		ld	a,(hl)				;+00h - Amplitude 0 right/left				
		and	070h
		rrca	
		rrca	
		rrca
		rrca	
		inc	a
		ld	(Analyzer_ch0_right),a          ;Amplitude 0 right 

		inc	hl
		ld	a,(hl)				;+01h - Amplitude 1 right/left
		and	07h
		inc	a
		ld	(Analyzer_ch1_left),a           ;Amplitude 1 left 
		ld	a, (hl)				;+01h - Amplitude 1 right/left
		and	070h
		rrca	
		rrca	
		rrca	
		rrca	
		inc	a
		ld	(Analyzer_ch1_right),a          ;Amplitude 1 right 

		inc	hl
		ld	a,(hl) 				;+02h - Amplitude 2 right/left
		and	07h
		inc	a
		ld	(Analyzer_ch2_left),a           ;Amplitude 2 left 
		ld	a,(hl)				;+02h - Amplitude 2 right/left
		and	070h
		rrca	
		rrca	
		rrca	
		rrca	
		inc	a
		ld	(Analyzer_ch2_right),a         	;Amplitude 2 right 

		inc	hl
		ld	a, (hl) 			;+03h - Amplitude 3 right/left
		and	07h
		inc	a
		ld	(Analyzer_ch3_left),a          	;Amplitude 3 left 
		ld	a, (hl)                         ;+03h - Amplitude 3 right/left
		and	070h
		rrca	
		rrca	
		rrca	
		rrca	
		inc	a
		ld	(Analyzer_ch3_right),a         	;Amplitude 3 right 

		inc	hl
		ld	a, (hl)				;+04h - Amplitude 4 right/left
		and	07h
		inc	a
		ld	(Analyzer_ch4_left),a           ;Amplitude 4 left 
		ld	a, (hl)
		and	070h
		rrca	
		rrca	
		rrca	
		rrca	
		inc	a
		ld	(Analyzer_ch4_right),a          ;Amplitude 4 right 

		inc	hl
		ld	a, (hl)				;+05h - Amplitude 5 right/left
		and	07h
		inc	a
		ld	(Analyzer_ch5_left),a           ;Amplitude 5 left 
		ld	a, (hl)
		and	070h
		rrca	
		rrca	
		rrca	
		rrca	
		inc	a
		ld	(Analyzer_ch5_right),a		;Amplitude 5 right 
		ret

;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view:
		ld	a,(Analyzer_ch0_left)		;Amplitude 0 left 
		ld	hl,520Fh
		call	Analyzer_left_draw

		ld	a, (Analyzer_ch1_left)		;Amplitude 1 left 
		ld	hl,540Fh
		call	Analyzer_left_draw

		ld	a,(Analyzer_ch2_left)		;Amplitude 2 left 
		ld	hl,560Fh
		call	Analyzer_left_draw

		ld	a,(Analyzer_ch3_left)          ;Amplitude 3 left 
		ld	hl,502Fh
		call	Analyzer_left_draw
                                                        
		ld	a,(Analyzer_ch4_left)          ;Amplitude 4 left 
		ld	hl,522Fh
		call	Analyzer_left_draw

		ld	a,(Analyzer_ch5_left)          ;Amplitude 5 left 
		ld	hl,542Fh
		call	Analyzer_left_draw
                                                        
		ld	a,(Analyzer_ch0_right)         ;Amplitude 0 right 
		ld	hl,5210h
		call	Analyzer_right_draw

		ld	a,(Analyzer_ch1_right)		;Amplitude 1 right 
		ld	hl,5410h
		call	Analyzer_right_draw

		ld	a,(Analyzer_ch2_right)		;Amplitude 2 right 
		ld	hl,5610h
		call	Analyzer_right_draw

		ld	a,(Analyzer_ch3_right)		;Amplitude 3 right 
		ld	hl,5030h
		call	Analyzer_right_draw

		ld	a,(Analyzer_ch4_right)		;Amplitude 4 right 
		ld	hl,5230h
		call	Analyzer_right_draw

		ld	a,(Analyzer_ch5_right) 		;Amplitude 5 right 
		ld	hl,5430h
		call	Analyzer_right_draw
		ret
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;	     A - размерность анализатора
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_left_draw:
		ld	b,a
		ld	a,0FFh

Analyzer_left_loop:
		ld	(hl),a
		dec	l
		djnz	Analyzer_left_loop
		ret	
;-------------------------------------------------------------------
; описание: Отрисовка правого канала анализатора
; параметры: HL - адрес экрана
;	     A - размерность анализатора
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_right_draw:
		ld	b,a
		ld	a,0FFh

Analyzer_right_loop:
		ld	(hl),a
		inc	l
		djnz	Analyzer_right_loop
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
		call	Analyzer_clear
		ret

;-------------------------------------------------------------------
; описание: Очистка экрана анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_clear:
		ld	hl,5208h
		call	Analyzer_filling 		;Amplitude 0 
		ld	hl,5408h
		call	Analyzer_filling                ;Amplitude 1
		ld	hl,5608h
		call	Analyzer_filling                ;Amplitude 2
		ld	hl,5028h
		call	Analyzer_filling                ;Amplitude 3
		ld	hl,5228h
		call	Analyzer_filling                ;Amplitude 4
		ld	hl,5428h
		call	Analyzer_filling                ;Amplitude 5
		ret
;-------------------------------------------------------------------
; описание: Очистка одной строки анализатора
; параметры: HL - адрес экрана
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_filling:
		ld	(hl),0 				;позиция -8
		ld	e,l
		ld	d,h
		inc	de
		ldi					;позиция -7	
		ldi	                                ;позиция -6
		ldi	                                ;позиция -5
		ldi	                                ;позиция -4
		ldi	                                ;позиция -3
		ldi	                                ;позиция -2
		ldi	                                ;позиция -1
		ldi	                                ;позиция +1
		ldi	                                ;позиция +2
		ldi	                                ;позиция +3
		ldi	                                ;позиция +4
		ldi	                                ;позиция +5
		ldi	                                ;позиция +6
		ldi	                                ;позиция +7
		ldi	                                ;позиция +8
		ret	
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_ch0_left:
		db	0	
Analyzer_ch1_left:
		db	0	
Analyzer_ch2_left:
		db	0	
Analyzer_ch3_left:
		db	0	
Analyzer_ch4_left:
		db	0	
Analyzer_ch5_left:
		db	0	
Analyzer_ch0_right:
		db	0	
Analyzer_ch1_right:
		db	0	
Analyzer_ch2_right:
		db	0	
Analyzer_ch3_right:
		db	0	
Analyzer_ch4_right:
		db	0	
Analyzer_ch5_right:
		db	0	
;		.end