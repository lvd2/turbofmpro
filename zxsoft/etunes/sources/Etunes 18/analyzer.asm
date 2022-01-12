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

		ld	a,(Analyzer_ch0_vol)
		ld	e,a				;амплитуда
		ld	a,(Analyzer_ch1_vol)
		cp	e
		jr	c,Analyzer_max_level_0		;вычисляем максимальное значение амплитуды
		ld	e,a				

Analyzer_max_level_0:
		ld	d,0
		ld	c,d
		
		ld	a,(Analyzer_ch0_vol)
		and	a
		jr	z, Analyzer_skip_0
		ld	a,(EFrequency_ch0)
		ld	d,a                             ;тон
		ld	a,(EOctave_ch0)
		and	3
		ld	c,a
Analyzer_skip_0:

		ld	a,(Analyzer_ch1_vol)
		and	a
		jr	z, Analyzer_skip_1
		ld	a,(EFrequency_ch0 + 1)
		add	d
		ld	d,a                             ;тон
		ld	a,(EOctave_ch0)
		and	30h
		rlca
		rlca
		rlca
		rlca
		add	c
		ld	c,a

Analyzer_skip_1:

		ld	a,c 				;итоговое значение октавы
		add	0Fh
		ld	(loc_0_8D38+1),a

		ld	l,d 				;итоговое значение тона
		ld	h,90h
		ld	a,e
		add	a,h                             
		ld	h,a                             ;вычислим ее таблице 8000...8FFFh

		ld	de,5007h
		call	Analyzer_draw

		ld	a,(Analyzer_ch2_vol)
		ld	e,a				;амплитуда
		ld	a,(Analyzer_ch3_vol)
		cp	e
		jr	c,Analyzer_max_level_1		;вычисляем максимальное значение амплитуды
		ld	e,a				

Analyzer_max_level_1:
		ld	d,0
		ld	c,d
		
		ld	a,(Analyzer_ch2_vol)
		and	a
		jr	z, Analyzer_skip_2
		ld	a,(EFrequency_ch2)
		ld	d,a                             ;тон
		ld	a,(EOctave_ch2)
		and	3
		ld	c,a
Analyzer_skip_2:

		ld	a,(Analyzer_ch3_vol)
		and	a
		jr	z, Analyzer_skip_3
		ld	a,(EFrequency_ch2 + 1)
		add	d
		ld	d,a                             ;тон
		ld	a,(EOctave_ch2)
		and	30h
		rlca
		rlca
		rlca
		rlca
		add	c
		ld	c,a

Analyzer_skip_3:
		ld	a,c 				;итоговое значение октавы
		add	0Fh
		ld	(loc_0_8D38+1),a

		ld	l,d 				;итоговое значение тона
		ld	h,90h
		ld	a,e
		add	a,h                             
		ld	h,a                             ;вычислим ее таблице 8000...8FFFh

		ld	de,48ACh
		call	Analyzer_draw

		ld	a,(Analyzer_ch4_vol)
		ld	e,a				;амплитуда
		ld	a,(Analyzer_ch5_vol)
		cp	e
		jr	c,Analyzer_max_level_2		;вычисляем максимальное значение амплитуды
		ld	e,a				

Analyzer_max_level_2:
		ld	d,0
		ld	c,d
		
		ld	a,(Analyzer_ch4_vol)
		and	a
		jr	z, Analyzer_skip_5
		ld	a,(EFrequency_ch4)
		ld	d,a                             ;тон
		ld	a,(EOctave_ch4)
		and	3
		ld	c,a
Analyzer_skip_5:

		ld	a,(Analyzer_ch5_vol)
		and	a
		jr	z, Analyzer_skip_6
		ld	a,(EFrequency_ch4 + 1)
		add	d
		ld	d,a                             ;тон
		ld	a,(EOctave_ch4)
		and	30h
		rlca
		rlca
		rlca
		rlca
		add	c
		ld	c,a

Analyzer_skip_6:

		ld	a,c 				;итоговое значение октавы
		add	0Fh
		ld	(loc_0_8D38+1),a

		ld	l,d 				;итоговое значение тона
		ld	h,90h
		ld	a,e
		add	a,h                             
		ld	h,a                             ;вычислим ее таблице 8000...8FFFh

		ld	de,4851h
	
Analyzer_draw:
		ld	b,31

loc_0_8D27:
		xor	a
		ld	ix,Analyzer_buffer
		ld	(ix + 0),a
		ld	(ix + 1),a
		ld	(ix + 2),a
		ld	(ix + 3),a

		push	de
		push	hl
		ld	l,(hl)                          ;получим смещение 
		ld	h,0A0h                          ;для таблицы FC00h
		ld	e,(hl)                          ;смещение
		ld	d,0
		add	ix,de
		inc	h                               
		ld	a,(hl)                          ;байт
		ld	(ix + 0),a
		pop	hl
		pop	de

		ld	ix,Analyzer_buffer
		ld	a,(de)
		and	0F0h
		or	(ix + 0)
		ld	(de),a
		inc	de

		ld	a,(ix + 1)
		ld	(de),a
		inc	de

		ld	a,(ix + 2)
		ld	(de),a
		inc	de

		ld	a,(de)
		and	0Fh
		or	(ix + 3)
		ld	(de),a
		dec	de
		dec	de
		dec	de

		inc	d
		ld	a,d
		and 	7
		jr	nz,Analyzer_next_line
		ld	a,e
		add	20h
		ld	e,a
		jr	c,Analyzer_next_line
		ld	a,d
		sub	8
		ld	d,a

Analyzer_next_line:

		ld	a,l
loc_0_8D38:
		add	a,0				;амплитуду увеличиваем
		ld	l,a
		djnz	loc_0_8D27
		ret
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_table:
		db	47h,47h,47h,46h,46h,46h,45h,45h,45h,44h,44h,44h,43h,43h,42h,42h	
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

Analyzer_buffer:	
		db	0,0,0,0
